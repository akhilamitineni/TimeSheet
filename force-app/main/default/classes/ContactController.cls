public with sharing class ContactController {
    @AuraEnabled
    public static List<Contact> getContacts() {
        return [SELECT Id, Name, Phone, Email, Title FROM Contact];
    }
    @AuraEnabled
    public static Contact saveContact(Contact cont) {
        upsert cont;
        return cont;
    }
}