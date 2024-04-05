public with sharing class contactClass {
    @AuraEnabled(cacheable=true)
    public static List<Contact>getContact(Id accId) {
        return [SELECT Id, Account.Name, LastName, FirstName FROM Contact WHERE AccountId = :accId WITH SECURITY_ENFORCED
        ];
    }
}