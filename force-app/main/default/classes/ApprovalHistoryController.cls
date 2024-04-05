public with sharing class ApprovalHistoryController {
    
    @AuraEnabled(cacheable=true)
    public static List<Approval_Detail__c> pullApprovalDetails(Id opportunityId){
        return [Select Id, Name, LastModifiedDate, Approval_Status__c, Date__c, Approver_Name__c, LinkedEntityId__c, Comments__c from Approval_Detail__c where LinkedEntityId__c = :opportunityId AND Approval_Process_Name__c = 'Bid Approval' WITH SECURITY_ENFORCED ORDER BY Date__c DESC];
    }
    
    @AuraEnabled
    public static void updateApprovalDetails(List<Approval_Detail__c> approverCommentList ){
        update approverCommentList;
    }
}