public class GetResourceSkillController {
    
    @AuraEnabled(cacheable=true)
    public static List<ATSWrapper> fetchResources(Id jobId){
        List<ATSWrapper> wrapperList = new List<ATSWrapper>();
        Job_Posting__c jobPosting;
        try{
            if(Job_Posting__c.SObjectType.getDescribe().isAccessible() &&
          		Schema.SObjectType.Job_Posting__c.fields.Skills__c.isAccessible()){
                    jobPosting = [SELECT 
                                    Skills__c 
                                    FROM Job_Posting__c 
                                    WHERE Id=:jobId 
                                    WITH SECURITY_ENFORCED];
            }
        }catch(Exception e){
            System.debug('An error occurred: ' + e.getMessage());
        }
        List<Skill_Resource__c> skillResources = getSkillResources(jobPosting);
        Map<Id, List<Skill_Resource__c>> resourceToSkillsMap = new Map<Id, List<Skill_Resource__c>>();
        if (!skillResources.isEmpty()) {
            for (Skill_Resource__c skillResource : skillResources) {
				if (!resourceToSkillsMap.containsKey(skillResource.Resource__c)) {
					resourceToSkillsMap.put(skillResource.Resource__c, new List<Skill_Resource__c>());
				}
				resourceToSkillsMap.get(skillResource.Resource__c).add(skillResource);
			}
            ATSWrapper wrapper;
            for (Id resourceId : resourceToSkillsMap.keySet()) {
                wrapper = new ATSWrapper();
                List<String> skillNames = new List<String>();
                List<Skill_Resource__c> skillsForResource = resourceToSkillsMap.get(resourceId);
                if (skillsForResource != null) {
                    for (Skill_Resource__c skill : skillsForResource) {
                        if(wrapper.getResourceName() == null &&
                           wrapper.getEmail() == null &&
                           wrapper.getPhoneNumber() == null){
                            wrapper.setResourceName(skill.Resource__r.Name);
                            wrapper.setEmail(skill.Resource__r.Primary_Email__c);
                            wrapper.setPhoneNumber(skill.Resource__r.Phone_Number__c);
                            wrapper.setResourceId(skill.Resource__c);
                            wrapper.setResourceURL('/lightning/r/Resource__c/' + skill.Resource__c + '/view');
                        }
                        skillNames.add(skill.Skill__r.Name);
                    }
                    wrapper.setSkillList(skillNames);
                }
                wrapperList.add(wrapper);
            }
        }
        if(wrapperList.size()>0){
            return wrapperList;
        }
        return null;
    }

    private static List<Skill_Resource__c> getSkillResources(Job_Posting__c jobPosting){ 
        List<String> skills = jobPosting.Skills__c.split(';');
        List<Skill_Resource__c> skillResources;
        List<Skill_Resource__c> finalSkillResources;
        try{
            if(Skill_Resource__c.SObjectType.getDescribe().isAccessible() &&
          		Schema.SObjectType.Skill_Resource__c.fields.Resource__c.isAccessible() &&
              	Resource__c.SObjectType.getDescribe().isAccessible() &&
              	Schema.SObjectType.Resource__c.fields.Name.isAccessible() &&
              	Schema.SObjectType.Resource__c.fields.Primary_Email__c.isAccessible() &&
              	Schema.SObjectType.Resource__c.fields.Phone_Number__c.isAccessible() &&
              	Skill__c.SObjectType.getDescribe().isAccessible() &&
              	Schema.SObjectType.Skill__c.fields.Name.isAccessible()){
       			skillResources = [
                    SELECT
                    Resource__c
                    FROM Skill_Resource__c 
                    WHERE Skill_Name__c IN :skills 
                    WITH SECURITY_ENFORCED];
                Set<Id> resourceIds = new Set<Id>();
                for(Skill_Resource__c skillResource : skillResources){
                    resourceIds.add(skillResource.Resource__c);
                }
                if(skillResources != null){
                    finalSkillResources = [
                    SELECT 
                    Resource__c,
                    Resource__r.Name,
                    Resource__r.Primary_Email__c,
                    Resource__r.Phone_Number__c,
                    Skill__r.Name
                    FROM Skill_Resource__c 
                    WHERE Resource__c =:resourceIds 
                    WITH SECURITY_ENFORCED];
                }
         	}
        }catch(Exception e){
            System.debug('An error occurred: ' + e.getMessage());
        }
        return finalSkillResources;
    }
}