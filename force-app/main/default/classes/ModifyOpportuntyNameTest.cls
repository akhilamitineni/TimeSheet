@isTest
public class ModifyOpportuntyNameTest {
    @isTest public static void ModifyOpportuntyNameTest() {
        Account acct = new Account(Name='Test Account');
        insert acct;
        Opportunity opp = new Opportunity(Name='FiniteTech',
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id);
        insert opp;
        Opportunity opp1 = [Select Name, Id from Opportunity where Id =: opp.Id];
        Test.startTest();
        System.assertEquals('FiniteTech/Modified', opp1.Name);
        Test.stopTest();
    }
}