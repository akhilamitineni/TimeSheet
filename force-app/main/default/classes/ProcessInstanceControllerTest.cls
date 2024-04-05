@isTest
public with sharing class ProcessInstanceControllerTest {

    @isTest static void processMethod() {
        
        List<ProcessInstanceItems> emptyPiItemsList = ProcessInstanceController.fetchRequiredItems();
        System.assertEquals(emptyPiItemsList.size(), 0);

        Id New_RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpportunity';
        opp.RecordTypeId = New_RecordTypeId;
        opp.CloseDate = System.today();
        opp.StageName = 'Negotiation/Review';
        opp.Quantity__c = 7;
        insert opp;
        System.debug(opp);

        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(opp.Id);
        Approval.ProcessResult result = Approval.process(app);
        
        List<ProcessInstanceItems> piItemsList = ProcessInstanceController.fetchRequiredItems();
        System.debug(piItemsList);
		System.assert(piItemsList.size() > 0);
        ProcessInstanceItems piItems1 = piItemsList.get(0);

        List<ProcessInstanceWorkitem> piWiList = [Select Id, ProcessInstanceId from ProcessInstanceWorkitem];
        System.debug(piWiList);
        
        Set<Id> piIds = new Set<Id>();
        for (ProcessInstanceWorkitem piWi : piWiList){
            piIds.add(piwi.ProcessInstanceId);
        }
        
        Map<Id,ProcessInstance> piMap = new Map<Id, ProcessInstance>([SELECT Id, ProcessDefinitionId, (SELECT ID, ActorId, ProcessNodeId, ProcessInstanceId, TargetObjectId FROM StepsAndWorkitems where StepStatus = 'Pending' ORDER BY createdDate DESC, Id DESC) FROM ProcessInstance WHERE Id IN : piIds]);
        List<ProcessInstanceHistory> pihList = new List<ProcessInstanceHistory>();
        Set<Id> pdIds = new Set<Id>();
        for (ProcessInstance pi : piMap.values()){
            pihList.addAll(pi.StepsAndWorkitems);
            pdIds.add(pi.ProcessDefinitionId);
        }
        Set<Id> processInstanceIds = new Set<Id>();
        Set<Id> processNodeIds = new Set<Id>();
        Set<Id> targetObjectIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        for (ProcessInstanceHistory pih :pihList){
            targetObjectIds.add(pih.TargetObjectId);
            userIds.add(pih.ActorId);
        	processNodeIds.add(pih.ProcessNodeId);
            processInstanceIds.add(pih.ProcessInstanceId);
        }
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([Select Id, Name, StageName from Opportunity where Id IN : targetObjectIds]);
        Map<Id, User> userMap = new Map<Id, User>([Select Id, Name from User where Id IN : userIds]);
        Map<Id, ProcessNode> pnMap = new Map<Id, ProcessNode>([Select Id, Name from ProcessNode where Id IN : processNodeIds]);
        Map<Id, ProcessDefinition> pdMap = new Map<Id, ProcessDefinition>([Select Id, DeveloperName from ProcessDefinition where Id IN : pdIds]);

        List<ProcessInstanceItems> piItemsList1 = new List<ProcessInstanceItems>();

        ProcessInstanceItems piItems;
        for (ProcessInstanceHistory pih : pihList){
            piItems = new ProcessInstanceItems();
            piItems.setOpportunityName(oppMap.get(pih.TargetObjectId).Name);
            piItems.setOpportunityStage(oppMap.get(pih.TargetObjectId).StageName);
            String str = piMap.get(pih.ProcessInstanceId).ProcessDefinitionId;
            piItems.setApprovalProcessName(pdMap.get(str).Developername);
            piItems.setOpportunityId(oppMap.get(pih.TargetObjectId).Id);
            piItems.setStepName(pnMap.get(pih.ProcessNodeId).Name);
            piItems.setApproverName(userMap.get(pih.ActorId).Name);
            piItemsList1.add(piItems);
        }
        
        ProcessInstanceItems piItems2 = new ProcessInstanceItems();
        piItems2 = piItemsList1.get(0); 
        System.assertEquals(piItems2.getOpportunityName(), piItems1.getOpportunityName());
        System.assertEquals(piItems2.getOpportunityStage(), piItems1.getOpportunityStage());
        System.assertEquals(piItems2.getOpportunityId(), piItems1.getOpportunityId());
        System.assertEquals(piItems2.getApprovalProcessName(), piItems1.getApprovalProcessName());
        System.assertEquals(piItems2.getApproverName(), piItems1.getApproverName());
        System.assertEquals(piItems2.getStepName(), piItems1.getStepName());
    }    
}