public class SubmittalResourceController {

    @AuraEnabled(cacheable=true)
    public static List<ATSWrapper> fetchResources(Id jobId){
        List<ATSWrapper> wrapperList = new List<ATSWrapper>();
		List<Submittal__c> submittals = getSumittals(jobId);
        Map<Id, Submittal__c> submittalResourceMap = createMap(submittals);
        ATSWrapper wrapper;
        for(Id resourceId : submittalResourceMap.keySet()){
            wrapper=new ATSWrapper();
            Submittal__c submittal = submittalResourceMap.get(resourceId);
            wrapper.setResourceName(submittal.Resource__r.Name);
            wrapper.setEmail(submittal.Resource__r.Primary_Email__c);
            wrapper.setPhoneNumber(submittal.Resource__r.Phone_Number__c);
            wrapper.setSource(submittal.Resource__r.Source__c);
            wrapper.setStageName(submittal.Stage__c);
            wrapper.setStatus(submittal.Status__c); 
            wrapper.setSubmittalName(submittal.Name); 
            wrapper.setResourceId(submittal.Resource__c);
            wrapper.setSubmittalURL('/lightning/r/Submittal__c/' + submittal.Id + '/view');
            wrapper.setResourceURL('/lightning/r/Resource__c/' + submittal.Resource__c + '/view');
            wrapperList.add(wrapper);
        }
        return wrapperList;
    }

    private static List<Submittal__c> getSumittals(Id jobPostingId){
        List<Submittal__c> submittals;
        try{
            if(Submittal__c.SObjectType.getDescribe().isAccessible() &&
                Schema.SObjectType.Submittal__c.fields.Resource__c.isAccessible() &&
                Resource__c.SObjectType.getDescribe().isAccessible() &&
                Schema.SObjectType.Resource__c.fields.Id.isAccessible() &&
                Schema.SObjectType.Resource__c.fields.Name.isAccessible() &&
                Schema.SObjectType.Resource__c.fields.Phone_Number__c.isAccessible() &&
                Schema.SObjectType.Resource__c.fields.Source__c.isAccessible() &&
                Schema.SObjectType.Resource__c.fields.Primary_Email__c.isAccessible() &&
                Schema.SObjectType.Submittal__c.fields.Stage__c.isAccessible() &&
                Schema.SObjectType.Submittal__c.fields.Status__c.isAccessible()){
                    submittals = [
                        SELECT 
                        Resource__c,
                        Name,
                        Id,
                        Resource__r.Name,
                        Resource__r.Phone_Number__c,
                        Resource__r.Source__c,
                        Resource__r.Primary_Email__c,
                        Stage__c,
                        Status__c
                        FROM Submittal__c
                        WHERE Job_Posting__c =:jobPostingId
                        WITH SECURITY_ENFORCED];
            }
        }catch(Exception e){
            System.debug('An error occurred: ' + e.getMessage());
        }
        return submittals;
    }

    private static Map<Id, Submittal__c> createMap(List<Submittal__c> submittals){
        Map<Id, Submittal__c> submittalResourceMap = new  Map<Id, Submittal__c>();
        if(submittals != null){
            for(Submittal__c submittal : submittals){
                if(!submittalResourceMap.containsKey(submittal.Resource__c)){
                    submittalResourceMap.put(submittal.Resource__c, submittal);
                }
            }
        }
        return submittalResourceMap;
    }
}