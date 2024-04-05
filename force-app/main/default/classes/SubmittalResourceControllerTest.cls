@isTest
public class SubmittalResourceControllerTest {
    
	@isTest
    public static void oneJobPostingWithMultipleResourcesAndSubmittals(){
        Resource__c resource1 = createResource();
        Resource__c resource2 = createResource();
        Resource__c resource3 = createResource();
        insert new List<Resource__C>{resource1,resource2,resource3};
            
        Client__c client1 = createClient();
        insert client1;

        Job_Posting__c jobPost = createJobPosting(client1.Id);
        insert jobPost;
		
        List<Submittal__c> testSubmittal = new List<Submittal__c>();
        for(Resource__c res : new List<Resource__c>{resource1,resource2,resource3}){
            Submittal__c submittal1 = new Submittal__c();
            submittal1.Resource__c = res.Id;
            submittal1.Job_Posting__c = jobPost.Id;
            testSubmittal.add(submittal1);
        }
		insert testSubmittal;
        
        Test.startTest();
        List<ATSWrapper> myResult =SubmittalResourceController.fetchResources(jobPost.Id);
        Test.stopTest();
        
        Assert.areEqual(3, myResult.size(), 'Length of the Array is not same');
    }

	@isTest
    public static void oneJobPostingWithOneResourceWithoutSubmittal(){
        Resource__c resource = createResource();
        insert resource;

        Client__c client = createClient();
        insert client;

        Job_Posting__c jobPost = createJobPosting(client.Id);
        insert jobPost;
        
        Test.startTest();
        List<ATSWrapper> myResult = SubmittalResourceController.fetchResources(jobPost.Id);
        Test.stopTest();
        
        Assert.areEqual(0, myResult.size(), 'Length of the Array is not same');
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
        jobpost.Skills__c = 'SAP MM';
        jobpost.Client_Job_Id__c = '1234';
        return jobpost;
    }
}