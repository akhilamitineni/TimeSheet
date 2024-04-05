public with sharing class OppController {

    @AuraEnabled(cacheable = true)
    public static List<Opportunity> fetchOpp() {
        List<Opportunity> oppList = [Select Name, StageName, CloseDate, Amount from Opportunity LIMIT 10];
        if(oppList == null || oppList.isEmpty()){
            return null;
        }
        else {
            return oppList;
        }
    }
}