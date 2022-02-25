public with sharing class BC_editLeadsController {
    @AuraEnabled(cacheable=true)
    public static List<Lead> webLeads(){
        return [
            SELECT Name, Last_Name__c, Email, Company, State__c, Owner.Name
            FROM Lead WHERE LeadSource = 'Web'
        ];
    }
}
