public class ProcessInstanceController {
    
    @AuraEnabled
    public static List<ProcessInstanceItems> fetchRequiredItems() {
        List<ProcessInstanceItems> piItemsList =new List<ProcessInstanceItems>();
        
        List<ProcessInstanceWorkitem> piWiList = [Select Id, ProcessInstanceId from ProcessInstanceWorkitem ];
        
        System.debug('ONE'+piWiList);
        
        if (piWiList == null || piWiList.isEmpty()){
            return piItemsList;  
        }
        Set<Id> piIds = new Set<Id>();
        for (ProcessInstanceWorkitem piWi : piWiList){
            piIds.add(piwi.ProcessInstanceId);
        }
        
        System.debug('TWO'+piIds);
        
        Map<Id,ProcessInstance> piMap = new Map<Id, ProcessInstance>([SELECT Id, ProcessDefinitionId, (SELECT ID, CreatedDate, StepStatus, CreatedById, ActorId, ProcessNodeId, ProcessInstanceId, TargetObjectId FROM StepsAndWorkitems where StepStatus = 'Pending' ORDER BY createdDate DESC, Id DESC) FROM ProcessInstance WHERE Id IN : piIds]);
        List<ProcessInstanceHistory> pihList = new List<ProcessInstanceHistory>();
        Set<Id> pdIds = new Set<Id>();
        for (ProcessInstance pi : piMap.values()){
            pihList.addAll(pi.StepsAndWorkitems);
            pdIds.add(pi.ProcessDefinitionId);
        }
        
        System.debug('THREE'+pihList);
        System.debug('FOUR'+pdIds);
        
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
        
        System.debug('FIVE'+targetObjectIds);
        System.debug('SIX'+userIds);
        System.debug('SEVEN'+processNodeIds);
        System.debug('EIGHT'+processInstanceIds);
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([Select Id, Name, StageName from Opportunity where Id IN : targetObjectIds]);
        Map<Id, User> userMap = new Map<Id, User>([Select Id, Name from User where Id IN : userIds]);
        Map<Id, ProcessNode> pnMap = new Map<Id, ProcessNode>([Select Id, Name from ProcessNode where Id IN : processNodeIds]);
        Map<Id, ProcessDefinition> pdMap = new Map<Id, ProcessDefinition>([Select Id, DeveloperName from ProcessDefinition where Id IN : pdIds]);
        
        System.debug('NINE'+oppMap);
        System.debug('TEN'+userMap);
        System.debug('ELEVEN'+pnMap);
        System.debug('TWELVE'+pdMap);
        
        ProcessInstanceItems piItems;
        String oppName;
        for (ProcessInstanceHistory pih : pihList){
            piItems = new ProcessInstanceItems();
            if (oppMap.get(pih.TargetObjectId).Name != oppName){
                piItems.setOpportunityName(oppMap.get(pih.TargetObjectId).Name);
            }
            piItems.setOpportunityStage(oppMap.get(pih.TargetObjectId).StageName);
            String str = piMap.get(pih.ProcessInstanceId).ProcessDefinitionId;
            piItems.setApprovalProcessName(pdMap.get(str).Developername);
            piItems.setOpportunityId(oppMap.get(pih.TargetObjectId).Id);
            piItems.setStepName(pnMap.get(pih.ProcessNodeId).Name);
            piItems.setApproverName(userMap.get(pih.ActorId).Name) ;
            piItemsList.add(piItems);
            oppName = oppMap.get(pih.TargetObjectId).Name;
        }
        return piItemsList;
    }
}