public with sharing class OpportunityAutoApproval {

    @InvocableMethod
    public static void submitAndApprove(List<Id> opportunityIds){
        System.debug('Entered submit and approve method');
        Id opportunityId = opportunityIds.get(0);
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setComments('Submitted for Approval');
        request.setObjectId(opportunityId);
        Approval.ProcessResult result = Approval.process(request);
        approveRecord(opportunityId);
        createApprovalHistoryRecords(opportunityId);
    }
    
    public static List<ProcessInstanceWorkitem> getWorkitems(Id targetObjectId){
        List<ProcessInstanceWorkitem> workitems = new List<ProcessInstanceWorkitem>();
        for (ProcessInstanceWorkitem pIwi : [Select p.Id, p.OriginalActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId WITH SECURITY_ENFORCED]){
            workitems.add(pIwi);
        }
        return workitems;
    }
    
    public static void approveRecord(Id opportunityId){
        Opportunity opp = [Select Id, Name, OwnerId from Opportunity where Id = :opportunityId WITH SECURITY_ENFORCED];
        List<ProcessInstanceWorkitem> workitems = getWorkitems(opportunityId);
        Boolean pullOut = false;
        While (workitems.size() > 0 && pullOut == false){
            List<Approval.ProcessWorkitemRequest> requestList = new List<Approval.ProcessWorkitemRequest>();
            for (ProcessInstanceWorkitem piwi : workitems){
                if (piwi.OriginalActorId != opp.OwnerId){
                    Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
                    request.setWorkitemId(piwi.Id);
                    request.setComments('Approved the Record');
                    request.setAction('Approve');
                    requestList.add(request);     
                }else if (piwi.OriginalActorId == opp.OwnerId){
                    pullOut = true;
                    break;
                }
        	}
            if (requestList.size() > 0){
               Approval.ProcessResult[] results = Approval.process(requestList); 
            }
            if (pullOut == false) {
                workitems = getWorkitems(opportunityId);
            }
        }
    }

    public static void createApprovalHistoryRecords(Id opportunityId){
        List<ProcessInstance> piList = [Select Id, ProcessDefinitionId, CompletedDate from ProcessInstance where TargetObjectId = :opportunityId WITH SECURITY_ENFORCED ORDER BY CompletedDate DESC];
        ProcessInstance pi = piList.get(0);
        ProcessDefinition pd = [Select Id, Name from ProcessDefinition where Id = :pi.ProcessDefinitionId WITH SECURITY_ENFORCED];
        List<ProcessInstanceStep> pisList = [Select OriginalActorId, StepStatus, StepNodeId, CreatedDate from ProcessInstanceStep where ProcessInstanceId = :pi.Id AND StepStatus = 'Approved' WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC];
        List<Approval_Detail__c> approvalDetailList = new List<Approval_Detail__c>();
        List<Id> processNodeIds = new List<Id>();
        List<Id> userIdList = new List<Id>();
        for (ProcessInstanceStep pis : pisList){
            userIdList.add(pis.OriginalActorId);
            processNodeIds.add(pis.StepNodeId);
        }
        Map<Id, ProcessNode> processNodeMap = new Map<Id, ProcessNode>([Select Id, Name from ProcessNode where Id = :processNodeIds]);
        Map<Id, User> userMap = new Map<Id, User>([Select Id, Name from User where Id = :userIdList]);
        for (ProcessInstanceStep piStep : pisList) {
            Approval_Detail__c approvalDetail = new Approval_Detail__c();
            approvalDetail.Date__c = piStep.CreatedDate;
            approvalDetail.Name = processNodeMap.get(piStep.StepNodeId).Name;
            if(approvalDetail.Name.contains('Bid Assessment')){
                approvalDetail.Approval_Process_Name__c = 'Bid Approval';
            }
            approvalDetail.ApproverId__c = piStep.OriginalActorId;
            approvalDetail.LinkedEntityId__c = opportunityId;
            approvalDetailList.add(approvalDetail);
        }
        if (Schema.sObjectType.Approval_Detail__c.fields.Date__c.isCreateable() && Schema.sObjectType.Approval_Detail__c.fields.Name.isCreateable() && Schema.sObjectType.Approval_Detail__c.fields.ApproverId__c.isCreateable() && Schema.sObjectType.Approval_Detail__c.fields.LinkedEntityId__c.isCreateable() && Schema.sObjectType.Approval_Detail__c.fields.Approval_Process_Name__c.isCreateable()){
            insert approvalDetailList;
        }
    }
}