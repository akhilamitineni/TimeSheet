@IsTest
public class CompetitorAccountOppControllerTest {
    static String compAccountId;
    static List<Opportunity> oppList = new List<Opportunity>();
   
    static void setupMethod() {
        Account acc = new Account();
        acc.Name ='TestAccount';
        insert acc;
       
        Id Competitor_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account accCompt = new Account();
        accCompt.Name = 'TestCompAccount';
        accCompt.RecordTypeId = Competitor_RecordTypeId;
        insert accCompt;
       
        Account accCompt1 = new Account();
        accCompt1.Name = 'TestCompAccount1';
        accCompt1.RecordTypeId = Competitor_RecordTypeId;
        insert accCompt1;
       
        compAccountId = accCompt1.Id;
        Opportunity opt = new Opportunity();
        opt.Name = 'Testopt';
        opt.CloseDate = System.today();
        opt.StageName = 'Negotiation/Review';
        opt.Quantity__c = 5;
        opt.AccountId = acc.Id;
        opt.Competitor_1__c  = accCompt.id;
        opt.Competitor_2__c = accCompt1.id;
        oppList.add(opt);
    }
 
    @isTest static void whenNoOpportunitiesFound() {
        setupMethod();
        Test.startTest();
        List<Opportunity> compOpportunities = CompetitorAccountOppController.retrieveOpportunities(compAccountId);
        Test.stopTest();
        System.assertEquals(0, compOpportunities.size());
    }
   
    @isTest static void whenOpportunitiesFound() {
        setupMethod();
        insert oppList;
        Test.startTest();
        List<Opportunity> compOpportunities =  CompetitorAccountOppController.retrieveOpportunities(compAccountId);
        Test.stopTest();
        System.assertEquals(1, compOpportunities.size());
    }
}