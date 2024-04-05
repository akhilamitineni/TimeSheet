@IsTest
public class OpportunityAutoApprovalTest {

	public static TestMethod void doTestAutoApprove(){
        Opportunity opp = Test_library.createOpportunityForBidApproval();
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('1. NEW, FFP').getRecordTypeId();
        opp.OwnerId = UserInfo.getUserId();
        opp.US_Government__c = 'Yes';
        opp.Total_Tooling_K__c = 9000;
        opp.Total_NRE_K__c = 15000;
        opp.Recurring_Total_M__c = 6000;
        opp.Tooling_Award_K__c = 15000;
        opp.NRE_Award_K__c = 12000;
        opp.Recurring_Award_K__c = 7000;
        insert opp;
        Account acc = [Select Id, Region__c from Account where Id = : opp.AccountId];
        acc.Region__c ='Americas';
        update acc;
        List<Id> oppIds = new List<Id>();
        oppIds.add(opp.Id);
        System.debug('After inserting Opp, the list is : '+ oppIds);
        OpportunityAutoApproval.submitAndApprove(oppIds);
        List<ProcessInstance> piList = [Select Id, Status, CreatedDate from ProcessInstance where TargetObjectId = :opp.Id ORDER BY CreatedDate DESC];
        System.debug('The process Instance list is : '+piList);
        ProcessInstance pi = piList.get(0);
        System.debug('The Process Instance pi is : '+pi);
        System.debug('The Oppoortunity Approval Status is : '+pi.Status);
        System.assertEquals('Pending', pi.Status);
        List<ProcessInstanceWorkitem> pIwiItems = OpportunityAutoApproval.getWorkitems(opp.Id);
        ProcessInstanceWorkitem pIwi = pIwiItems.get(0);
        System.assertEquals(opp.OwnerId, pIwi.OriginalActorId);
        List<Approval_Detail__c> approvalDetailList = [Select Id, Name from Approval_Detail__c where LinkedEntityId__c = : opp.Id];
        System.assert(approvalDetailList.size() > 0);
    }
}