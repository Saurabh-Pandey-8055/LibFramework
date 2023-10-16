/**
 * @description       : Selector class for PJP_Detail__c object.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class PjpDetailsSelector extends LibSObjectSelector 
{
    /**
     * @Description - Constructor for the PjpDetailsSelector class.
     */
    public PjpDetailsSelector()
    {
        super(true, false, false, false);
    }

    /**
     * @Description - Get the SObjectType for the PJP_Detail__c object.
     * @return  - Schema.SObjectType.
     */
    public Schema.SObjectType getSObjectType() 
    {
        return PJP_Detail__c.SObjectType;
    }

    /**
     * @Description - Get a list of SObjectFields for the PJP_Detail__c object.
     * @return  - List<Schema.SObjectField>.
     */
    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            PJP_Detail__c.Id,  
            PJP_Detail__c.Name,
            PJP_Detail__c.PJP__c,
            PJP_Detail__c.Account__c,
            PJP_Detail__c.Start_Datetime__c,
            PJP_Detail__c.End_Datetime__c,
            PJP_Detail__c.Plan_Date__c,
            PJP_Detail__c.Account__r.Id,
            PJP_Detail__c.User__r.Id,
            PJP_Detail__c.User__c,
            PJP_Detail__c.PJP__r.Id,
            PJP_Detail__c.EventCreated__c
        };
    }

    /**
     * @Description - Get a list of PJP_Detail__c records for a specific month.
     * @param List : month_id (String).
     * @return  - List<PJP_Detail__c>.
     */
    public List<PJP_Detail__c> getpjpDetails(String month_id) {
        return Database.query(
            newQueryFactory()
                .setCondition('PJP__c = :month_id')
                .toSOQL()
        );
    }

    /**
     * @Description - Get a list of PJP_Detail__c records based on a list of Ids.
     * @param List : lst (List<String>).
     * @return  - List<PJP_Detail__c>.
     */
    public List<PJP_Detail__c> getdeleteDetails(List<String> lst) {
        return Database.query(
            newQueryFactory()
                .setCondition('Id IN :lst')
                .toSOQL()
        );
    }

    /**
     * @Description - Get a list of approved PJP_Detail__c records based on a list of PJP Ids.
     * @param List : pjp_id (List<String>).
     * @return  - List<PJP_Detail__c>.
     */
    public List<PJP_Detail__c> getpjpApprovedDetails(List<String> pjp_id) {
        return Database.query(
            newQueryFactory()
                .setCondition('PJP__r.Id IN :pjp_id')
                .toSOQL()
        );
    }
}
