@isTest
public class Test_library {
    public static String defaultUserProfile = 'System Administrator';
    private static integer i = 1;
    
    public static User createSysAdminUser() {
        return createUser(0, defaultUserProfile);     
    }
    
    public static User createUser (Integer userNumber, String userProfileName) {
        return createUser(userNumber, userProfileName, 'tuser@nestaway.com' + string.valueOf(++i));
    }
   
    public static User createUser( Integer userNumber, String userProfileName, string userName) { 
        String nickName = 'cspu' + DateTime.now().getTime();
        return createUser(userNumber, userProfileName, userName, nickName);
    }
    
    public static User createUser( Integer userNumber, String userProfileName, string userName, String nickName) {   
        Profile profile = profileNameToObjectMap.get( userProfileName );
        List<User> eUsers = [Select Id,email,ProfileId,UserName,Alias,CommunityNickName,TimeZoneSidKey,LocaleSidKey,LanguageLocaleKey,FirstName,LastName From User where UserName = 'tuser@aimia.com'];
        if(eUsers.size() > 0) {
            return eUsers[0];            
        }
        User newUser = new User(email='firstlast@nestaway.com'
                                , ProfileId = profile.Id
                                , UserName = userName
                                , Alias = 'cspu' + String.valueOf(userNumber)
                                , CommunityNickName = nickName + String.valueOf(userNumber) 
                                , TimeZoneSidKey = 'America/Los_Angeles'
                                , LocaleSidKey = 'en_US', EmailEncodingKey='ISO-8859-1' 
                                , LanguageLocaleKey='en_US'
                                , FirstName = 'Test_'+ userProfileName
                                , LastName = 'Test' + String.valueOf(userNumber) 
                                , Phone = '9620600507');
        return newUser;
    }
    
    // Profiles
    public static Map<String, Profile> profileNameToObjectMap {
        get {
            if (profileNameToObjectMap == null) {
                initializeProfileMap();
            }
            return profileNameToObjectMap;
        }
        private set {
            profileNameToObjectMap = value;
        }
    }    
    
    private static void initializeProfileMap() {
        Map<Id,Profile> profileIdToObjectMap = new Map<Id,Profile> ([select Id, Name
                                                                     from Profile 
                                                                     order by Name]);
        profileNameToObjectMap = new Map<String, Profile>();

        for (Profile pr : profileIdToObjectMap.values()) {
            profileNameToObjectMap.put(pr.Name, pr);
        }
    }    
    
/*
    public static User createStandardUserWithRole (Integer userNumber) {
        return createStandardUserWithRole( userNumber, defaultUserProfile);
    }
    
    public static User createStandardUserWithRole( Integer userNumber, String userProfileName) {   
        Profile prof = profileNameToObjectMap.get( userProfileName );
        // System.assertNotEquals(null, prof, 'createStandardUser: profile not found: ' + userProfileName);
        List<User> eUsers = [Select Id,email,ProfileId,UserName,Alias,CommunityNickName,TimeZoneSidKey,LocaleSidKey,LanguageLocaleKey,FirstName,LastName From User where UserName = 'tuser@aimia.com'];
        if(eUsers.size() > 0) {
            return eUsers[0];        
        }
        UserRole ur = new UserRole(Name = 'CEO');
        insert ur;
        
        User newUser = new User( email='firstlast@aimia.com'
                                , ProfileId = prof.Id
                                , UserName= 'tuser@aimia.com'
                                , Alias='cspu' + String.valueOf(userNumber)
                                , CommunityNickName='cspu'+ String.valueOf(userNumber) 
                                , TimeZoneSidKey='America/Los_Angeles'
                                , LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1' 
                                , LanguageLocaleKey='en_US'
                                , FirstName = 'Test_'+ userProfileName
                                , LastName = 'Test' + String.valueOf(userNumber) 
                                , UserRoleId = ur.Id);
        return newUser;
    }
*/
    public static Account createAccount() {
        Account accObj = new Account();
        accObj.Name = 'TestAcc' + Datetime.now().format('yyyy-MM-dd-hh.mm.ss.SSS');
        accObj.AEC_Relationship_Overview__c = 'Test';
        accObj.Open_Issues__c ='Test';
        accObj.AEC_Relationship_Plan__c = 'Test';
        accObj.Criteria_1__c  ='Test';
        accObj.Criteria_2__c ='Test';
        accObj.Criteria_3__c ='Test';
        accObj.Criteria_5__c ='Test';
        accObj.Criteria_5__c ='Test';
        accObj.Value_1__c ='Test';
        accObj.Value_2__c ='Test';
        accObj.Value_3__c ='Test';
        accObj.Value_4__c ='Test';
        accObj.Value_5__c = 95;
        accObj.Cusotmer_ID__c ='ABC' + Datetime.now().format('hh.mm.ss.SSS');
        accObj.Abbreviated_Name__c ='Test';
        // accObj.CurrencyIsoCode = 'USD';
        
        return accObj;
    }
    
    public static Contact CreateContact() {   
        Account acc = createAccount();
        acc.name = 'testname Contact';
        System.debug('Account: ' + acc);
        insert acc;
        
        Contact cn = new Contact();
        cn.AccountId = acc.Id;
        cn.firstname ='test 122';
        cn.lastname ='ktesjhgsyudsst' + Datetime.now().format('yyyy-MM-dd-hh.mm.ss.SSS');
        cn.Email = 'tes22@test.com';
        cn.Relevant_for_CSOT__c = 'Yes';
        
        return cn;
    }
    
    public static Opportunity createOpportunity() { 
        Account acc = createAccount();
        insert acc;
        
        Id Competitor_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account accCompt = createAccount();
        accCompt.name = 'Testing';
        accCompt.RecordTypeId = Competitor_RecordTypeId;
        insert accCompt;
        
        return createOpportunityFor(acc, accCompt);
    }
    
    public static Opportunity createOpportunityFor(Account acc, Account accCompt) {
        Contact con = CreateContact();
        insert con;
        
        Opportunity opty = new Opportunity();
        opty.Name = 'Test Opportunity';
        opty.StageName = 'Prospecting';
        opty.CloseDate = System.now().addDays(30).date();
        opty.Customer_RFQ__c = 'Test';
        opty.Customer_PoC__c = con.Id;
        opty.Mfg_Process_Description__c  ='Hand Layup, Oven Cure';
        opty.Site_Recommendation__c ='KSN';
        opty.RFQ_Receipt_Date__c = System.today();
        opty.US_Government__c = 'Yes';
        opty.Competitor1__c  = accCompt.id;
        opty.Competitor2__c = accCompt.id;
        opty.Opportunity_Highlight__c = 'Test';
        opty.Proposal_Revision__c  ='Test';
        opty.Product__c = 'Test';
        opty.Platform__c = 'Test';
        opty.AccountId = acc.Id;
        opty.Period_of_Performance__c ='Test';
        opty.Growth_Probability_Box__c ='Box 1';
        opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('1. NEW, FFP').getRecordTypeId();
        opty.Status__c = 'New Opportunity Identified';
        return opty;
    } 
    
    public static Opportunity createOpportunityForProposalGeneration() { 
        Opportunity opty = createOpportunity();
        opty.Tooling_Year__c  = '2020';
        opty.Total_Tooling_K__c = 122;
        opty.Total_NRE_K__c = 22;
        opty.Additional_Add_on_K__c = 10;
        opty.NRE_Year__c  = '2020';
        opty.Total_Revenue_K__c  = 237636;
        opty.Average_Annual_Revenue_K__c = 286361;
        opty.Total_CapEx_M__c  = 233981;
        opty.CAPEX_Year__c   = '2020';
        opty.Other_Investments_K__c  =2738;
        opty.Other_Investments_Year__c  = '2020';
        opty.Recurring_Total_M__c  = 1221;
        opty.Headcount_Transformational__c  = 2121;
        opty.Headcount_Non_Transformational__c  = 1221;
        opty.EBITDA__c  = 34;
        opty.EBITDA_K__c  = 22;
        opty.Gross_Margin__c  = 22;
        opty.Gross_Margin_K__c  = 22;
        opty.Net_Present_Value_K_NPV__c  = 21221;
        opty.Internal_Rate_Return_IRR__c = 50;
        opty.Build_to_Print__c = 'yes';
        opty.Demonstrated_Mfg_Process__c = 'yes';
        opty.IRR_of_12_or_greater__c = 'yes';
        opty.GM_10_or_greater__c = 'yes';
        opty.PoP_less_than_10_Years__c = 'yes';
        opty.Limited_Liability__c = 'yes';
        opty.Capital_less_than_5M__c = 'yes';
        opty.Opportunity_Highlight__c = 'yes';
        opty.Strategic_Relevance__c = 'yes';
        opty.Win_Strategy__c = 'yes';
        opty.Program_Potential_Platform__c = 'yes';
        opty.Customer_Feedback__c = 'yes';
        opty.Bid_Approval__c = TRUE;
        return opty;
    }
    
    public static Opportunity createOpportunityForBidApproval() {
        User sysAdminUser = createSysAdminUser();
        insert sysAdminUser;
        Opportunity opp = createOpportunityForProposalGeneration();
        opp.StageName = 'Bid Assessment';
        opp.Status__c = 'RFQ Being Assessed for Business Fit'; 
        opp.Program_Account_Manager__c = sysAdminUser.Id;
        opp.Contract_Manager__c = sysAdminUser.Id;  
        opp.Site_Recommendation__c ='BOE';
        opp.US_Government__c = 'No';

        return opp;
    }
    
    public static ContentVersion contentVersion(String fileName) {
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.ContentLocation = 'S'; 
        contentVersion.PathOnClient = 'ionicLogo.png';
        contentVersion.Title = fileName;
        contentVersion.VersionData = EncodingUtil.base64Decode('Test Document');
        return contentVersion;
    }
    
}