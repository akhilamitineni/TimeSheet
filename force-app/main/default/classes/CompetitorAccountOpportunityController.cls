public class CompetitorAccountOpportunityController {
    
    @AuraEnabled
    public static List<Opportunity> retrieveOpportunities(String recordId){
        return [SELECT Name, Id, Account.Name, Amount, StageName, CloseDate  FROM Opportunity WHERE  Competitor_1__r.Id = :recordId OR Competitor_2__r.Id = :recordId ];
    }  
}