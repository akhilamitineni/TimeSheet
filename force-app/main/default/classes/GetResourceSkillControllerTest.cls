@isTest
public class GetResourceSkillControllerTest {
    
    @isTest
    public static void oneJobPostingWithTwoResources(){
        Client__c client = createClient();
        insert client;
        
        Job_Posting__c jobPost = createJobPosting(client.Id);
        insert jobPost;
        
        Skill__c skill1 = createSkill('SAP MM');
        Skill__c skill2 = createSkill('Windchill SAP');
        Skill__c skill3 = createSkill('.Net Developer');
        insert new List<Skill__c>{skill1, skill2, skill3};
            
        Resource__c resource1 = createResource();
        Resource__c resource2 = createResource();
        Resource__c resource3 = createResource();
        insert new List<Resource__c>{resource1, resource2, resource3};
            
        Skill_Resource__c skillRes1 = createSkillResource(resource1.Id,skill1.Id);
        Skill_Resource__c skillRes2 = createSkillResource(resource2.Id,skill2.Id);
        Skill_Resource__c skillRes3 = createSkillResource(resource3.Id,skill3.Id);
        insert new List<Skill_Resource__c>{skillRes1, skillRes2, skillRes3};

        Test.startTest();
        List<ATSWrapper> myResult = GetResourceSkillController.fetchResources(jobPost.Id);
        Test.stopTest();
        
        Assert.areEqual(2, myResult.size(), 'Size is not Matching');
    }

    @isTest
    public static void oneJobPostingWithNoResource(){
        Client__c clientS2 = createClient();
        insert clientS2;
        
        Job_Posting__c jobPostS2 = createJobPosting(clientS2.Id);
        insert jobPostS2;
        
        Skill__c skill1S2 = createSkill('SAP MM');
        Skill__c skill2S2 = createSkill('Windchill SAP');
        Skill__c skill3S2 = createSkill('.Net Developer');
        insert new List<Skill__c>{skill1S2, skill2S2, skill3S2};
            
        Test.startTest();
        List<ATSWrapper> myResult = GetResourceSkillController.fetchResources(jobPostS2.Id);
        Test.stopTest();
        
        Assert.areEqual(null, myResult, 'myResult should be null');
    }
    
    private static Client__c createClient(){
        Client__c company = new Client__c();
        company.Name= 'Test Company'+DateTime.now().format('hh.mm.ss.SSS');
        company.Email__c= 'Companyemail@'+DateTime.now().format('hh.mm.ss.SSS')+ '.com';
        company.Phone_Number__c='1234567895';
        company.Website__c = 'www.TestCompany.com';
        company.City__c = 'Oh, Columbus';
        company.Country__c = 'USA';
        return company;
    }
    
    private static Resource__c createResource(){
        Resource__c resource = new Resource__c();
        resource.Name= 'Test Resource';
        resource.Phone_Number__c = '1234567898';
        resource.Primary_Email__c='testresourceemail@'+DateTime.now().format('hh.mm.ss.SSS');
        resource.Source__c = 'Dice';
        resource.City__c = 'San Antonio, TX';
        resource.Country__c = 'USA';
        return resource;
    }
    
    private static Job_Posting__c createJobPosting(Id clientId){
        Job_Posting__c jobpost = new Job_Posting__c();
        jobpost.Job_Title__c = 'Test Job Title';
        jobpost.Client__c = clientId;
        jobpost.Job_Status__c = 'Open';
        jobpost.Min_Experience__c = 2;
        jobpost.Max_Experience__c=4;
        jobpost.Job_Description__c = 'Test Job Description';
        jobpost.Salary_Range__c= '200K to 300K';
        jobpost.Work_Hours__c = '8 hours';
        jobpost.Skills__c = 'SAP MM; Windchill SAP';
        jobpost.Client_Job_Id__c = '1234';
        return jobpost;
    }
    
    private static Skill__c createSkill(String name){
        Skill__c skillCreation = new Skill__c();
        skillCreation.Name=name;
        return skillCreation;
    }
    
    private static Skill_Resource__c createSkillResource(Id resourceId, Id skillId){
        Skill_Resource__c skillRecord = new Skill_Resource__c();
        skillRecord.Resource__c = resourceId;
        skillRecord.Skill__c = skillId;
        skillRecord.Level_of_Experience__c = 'Beginner';
        skillRecord.Experience__c = '1 year 2 months';
        return skillRecord;
    }
}