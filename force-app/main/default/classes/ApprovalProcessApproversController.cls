public class ApprovalProcessApproversController {
	@AuraEnabled
	public static List<ProcessInstanceHistory> getOpportunityApprovers(String recordId){
    	List<ProcessInstanceWorkitem> piwiList = [Select Id, ProcessInstanceId from ProcessInstanceWorkitem where Id = :recordId];
    	System.debug('piwiList: ' + piwiList);
    	if(piwiList != null && !piwiList.isEmpty()) {
        	ProcessInstance pi = [SELECT Id, (SELECT ID, CreatedDate, TargetObjectId, ProcessNodeId, StepStatus, Comments,Actor.Name,OriginalActor.Name FROM StepsAndWorkitems ORDER BY createdDate DESC, Id DESC) FROM ProcessInstance WHERE Id = :piwiList.get(0).ProcessInstanceId];
    		System.debug('ProcessInstance pi: ' + pi);
        	System.debug('ProcessInstance pi.StepsAndWorkitems: ' + pi.StepsAndWorkitems);
        	return pi.StepsAndWorkitems;
    	}
    	return null;
	}
}