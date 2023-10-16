/**
 * @description       : This class provides methods to select and query SubZone records.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class SubZoneSelector extends LibSObjectSelector {

    /**
     * @Description - Constructor for SubZoneSelector class.
     */
    public SubZoneSelector() {
        super(true, false, false, false);
    }

    /**
     * @Description - Gets the SObjectType for SubZone records.
     * @return Schema.SObjectType : SubZone object type.
     */
    public Schema.SObjectType getSObjectType() {
        return Sub_Zone__c.SObjectType;
    }

    /**
     * @Description - Gets a list of SObject fields for SubZone records.
     * @return List<Schema.SObjectField> : List of SObject fields.
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Sub_Zone__c.Id,
            Sub_Zone__c.Name,
            Sub_Zone__c.Zone__c,
            Sub_Zone__c.User__c,
            Sub_Zone__c.Sub_Zone_Manager_Bevrages2__r.id,
            Sub_Zone__c.Sub_Zone_Manager_Bevrages2__r.Name,
            Sub_Zone__c.Sub_Zone_Manager_Bevrages2__c,
            Sub_Zone__c.Zone__r.Id
        };
    }

    /**
     * @Description - Retrieves a list of SubZone records based on the user's ID.
     * @return List<Sub_Zone__c> : List of SubZone records.
     */
    public List<Sub_Zone__c> getSubzone() {
        String userId = UserInfo.getUserId();
        return (List<Sub_Zone__c>) Database.query(
            newQueryFactory()
                .setCondition('User__r.Id = :userId AND Id != null')
                .toSOQL()
        );
    }

    /**
     * @Description - Retrieves a list of SubZone records for a given list of zones.
     * @param zonelist : List of zone IDs to filter SubZone records.
     * @return List<Sub_Zone__c> : List of SubZone records.
     */
    public List<Sub_Zone__c> getBdmUsers(String zonelist) {
        return Database.query(
            newQueryFactory()
                .selectField('User__r.Id')
                .selectField('User__r.Name')
                .setCondition('Zone__r.Id = :zonelist AND (User__r.Id != null OR Sub_Zone_Manager_Bevrages2__c != null)')
                .toSOQL()
        );
    }
}
