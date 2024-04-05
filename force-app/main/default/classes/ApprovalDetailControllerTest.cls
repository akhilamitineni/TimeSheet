@IsTest
public class ApprovalDetailControllerTest {

    @IsTest
    public static void testPullApprovalDetails_NullScenario() {
        // Overloaded Methods
        // Overloaded Constructors
        Opportunity opp = new Opportunity(name='Test', StageName='aaaa', CloseDate=System.today() + 5);
        Insert opp;
        
        List<Approval_Detail__c> result = ApprovalDetailController.pullApprovalDetails(opp.Id);
        //Assert.areEqual(1, result.size());
        //Assert.areEqual('Test', result.get(0).name);
    }
    
    @IsTest
    public static void testPullApprovalDetails_NonNullScenario() {
        ApprovalDetailController.pullApprovalDetails(null);
    }    
    
    @IsTest
    public static void testUpdateApprovalDetails_EmptyList() {
        ApprovalDetailController.updateApprovalDetails(new List<Approval_Detail__c>());
    }    
    
    @IsTest
    public static void testUpdateApprovalDetails_NonEmptyList() {
        
        ApprovalDetailController.updateApprovalDetails(new List<Approval_Detail__c>());
    }      
    
}