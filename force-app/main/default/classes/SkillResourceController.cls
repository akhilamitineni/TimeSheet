public class SkillResourceController {
	
     @AuraEnabled
     public static void updateSkillResourceRecords(String jsonOfSkillResourcesUpsert, String[] idsToDelete){
         if(idsToDelete != null && idsToDelete.size() > 0){
             List<Skill_Resource__c> skillReourceRecordDelete = new List<Skill_Resource__c>();
             if(Skill_Resource__c.SObjectType.getDescribe().isAccessible() &&
          		Schema.SObjectType.Skill_Resource__c.fields.Id.isAccessible()){
                 skillReourceRecordDelete = [SELECT 
                                             Id 
                                             FROM Skill_Resource__c 
                                             WHERE Id =:idsToDelete WITH SECURITY_ENFORCED];
             }
             try{
                 delete skillReourceRecordDelete;
             }catch(DmlException e){
                 System.debug('An error occurred: ' + e.getMessage());
              }
         }
         if(jsonOfSkillResourcesUpsert != null && jsonOfSkillResourcesUpsert.length() !=0){
             List<Skill_Resource__c> skillResourceListUpsert=(List<Skill_Resource__c>) JSON.deserialize(jsonOfSkillResourcesUpsert, List<Skill_Resource__c>.class);
             try{
                 upsert skillResourceListUpsert;
             } catch(DmlException e){
                 System.debug('An error occurred: ' + e.getMessage());
              }
        }
     }

    @AuraEnabled(cacheable=true)
    public static List<Skill_Resource__c> getSkillResources(Id resourceId){
        List<Skill_Resource__c> skillResources = new List<Skill_Resource__c>();
        if(Skill_Resource__c.SObjectType.getDescribe().isAccessible() &&
          Schema.SObjectType.Skill_Resource__c.fields.Id.isAccessible() &&
          Schema.SObjectType.Skill_Resource__c.fields.Skill__c.isAccessible() &&
          Schema.SObjectType.Skill_Resource__c.fields.Start_date__c.isAccessible() &&
          Schema.SObjectType.Skill_Resource__c.fields.Resource__c.isAccessible() &&
          Schema.SObjectType.Skill_Resource__c.fields.End_date__c.isAccessible() &&
          Schema.SObjectType.Skill_Resource__c.fields.Version_Release__c.isAccessible() &&
          Schema.SObjectType.Skill_Resource__c.fields.Experience__c.isAccessible() &&
          Schema.SObjectType.Skill_Resource__c.fields.Experience_Formula__c.isAccessible() &&
          Schema.SObjectType.Skill_Resource__c.fields.Level_of_Experience__c.isAccessible()){
              skillResources = [SELECT
                                Id,
                                Skill__c,
                                Start_date__c,
                                Resource__c,
                                End_date__c,
                                Version_Release__c,
                                Experience__c,
                                Experience_Formula__c,
                                Level_of_Experience__c
                                FROM Skill_Resource__c
                                WHERE Resource__c = : resourceId
                                ORDER BY CreatedDate ASC];
           }
        return skillResources; 
    }
}