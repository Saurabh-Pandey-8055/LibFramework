/**
 * @description       : Selector class for PJP__c object.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class PJPSelector extends LibSObjectSelector 
{
    /**
     * @Description - Constructor for the PJPSelector class.
     */
    public PJPSelector()
    {
        super(true, false, false, false);
    }

    /**
     * @Description - Get the SObjectType for the PJP__c object.
     * @return  - Schema.SObjectType.
     */
    public Schema.SObjectType getSObjectType() 
    {
        return PJP__c.SObjectType;
    }

    /**
     * @Description - Get a list of SObjectFields for the PJP__c object.
     * @return  - List<Schema.SObjectField>.
     */
    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            PJP__c.Id,  
            PJP__c.Name,
            PJP__c.Status__c,
            PJP__c.User__r.Name,
            PJP__c.User__r.Id,
            PJP__c.User__c,
            PJP__c.Start_Datetime__c,
            PJP__c.PJP_Prepared_By__c,
            PJP__c.CreatedById,
            PJP__c.Approved_By__c
        };
    }

    /**
     * @Description - Get the order by clause for query results.
     * @return  - String.
     */
    public override String getOrderBy() {
        return 'Start_Datetime__c asc';
    }

    /**
     * @Description - Get a list of PJP__c records for a specific user.
     * @param List : usr_id (String).
     * @return  - List<PJP__c>.
     */
    public List<PJP__c> getpjp(String usrId) {
        return Database.query(
            newQueryFactory()
                .setCondition('User__r.Id = :usrId') 
                .toSOQL()
        );
    }

    /**
     * @Description - Get a list of PJP__c records for a specific user and month.
     * @param List : mon_name (String), usr_id (String).
     * @return  - List<PJP__c>.
     */
    public List<PJP__c> getpjpc(String monname, String usrid) {
        return Database.query(
            newQueryFactory()
                .setCondition('Name = :monname AND User__r.Id = :usrid') 
                .setLimit(1)
                .toSOQL()
        );
    }

    /**
     * @Description - Get a list of PJP__c records for a specific month and user.
     * @param List : currentMonth (String), usr_id (String).
     * @return  - List<PJP__c>.
     */
    public List<PJP__c> getPJPBymonth(String currentMonth, String usrid) {
        return Database.query(
            newQueryFactory()
                .setCondition('Name = :currentMonth AND User__r.Id = :usrid') 
                .toSOQL()
        );
    }

    /**
     * @Description - Get a list of PJP__c records for a specific user.
     * @param List : usr_id (String).
     * @return  - List<PJP__c>.
     */
    public List<PJP__c> getMonth(String usrid) {
       System.debug('Get Month'+usrid);
        return Database.query(
            newQueryFactory()
                .selectField('User__r.Id')
                .setCondition('User__r.Id = :usrid') 
                .toSOQL()
        );
    }

    /**
     * @Description - Get a list of PJP__c records for a specific month.
     * @param List : mon_id (String).
     * @return  - List<PJP__c>.
     */
    public List<PJP__c> getMOnthbyId(String monId) {
        return Database.query(
            newQueryFactory()
                .setCondition('Id = :monId AND Name != null') 
                .toSOQL()
        );
    }

    /**
     * @Description - Get a PJP__c record for a specific user and month.
     * @param List : usr_id (String), mon_name (String).
     * @return  - PJP__c.
     */
    public List<PJP__c> getMonthOnUser(String usrId, String monName) {
        return Database.query(
            newQueryFactory()
                .setCondition('User__r.Id = :usrId AND Name = :monName') 
                .setLimit(1)
                .toSOQL()
        );
    }

    /**
     * @Description - Get a PJP__c record by its Id.
     * @param List : pjp_id (String).
     * @return  - PJP__c.
     */
    public PJP__c getpjpUserId(String pjpId) {
        return Database.query(
            newQueryFactory()
                .setCondition('Id = :pjpId') 
                .toSOQL()
        );
    }

    /**
     * @Description - Get a PJP__c record by its Id.
     * @param List : pjpId (String).
     * @return  - PJP__c.
     */
    public PJP__c getPJPById(String pjpId) {
        return Database.query(
            newQueryFactory()
                .setCondition('Id = :pjpId')
                .setLimit(1)
                .toSOQL()
        );
    }

    /**
     * @Description - Get a list of approved PJP__c records for the current month and year.
     * @return  - List<PJP__c>.
     */
   
     public List<PJP__c> getPJPforEvent() {
       Integer currentMonth = Date.today().month();
       Integer currentYear = Date.today().year();
        return Database.query(
            newQueryFactory()
                .setCondition('Status__c = \'Approved\' AND CALENDAR_MONTH(CreatedDate) = :currentMonth AND CALENDAR_YEAR(CreatedDate) = :currentYear')
                .toSOQL()
        );
    
    }
    
}