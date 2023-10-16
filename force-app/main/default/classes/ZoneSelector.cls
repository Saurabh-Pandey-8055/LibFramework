/**
 * @description       : This class provides methods to select and query Zone records.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class ZoneSelector extends LibSObjectSelector {

    /**
     *  @Description - Constructor for ZoneSelector class.
     */
    public ZoneSelector() {
        super(true, false, false, false);
    }

    /**
      * @Description - Gets the SObjectType for Zone records.
     * @return Schema.SObjectType : Zone object type.
     */
    public Schema.SObjectType getSObjectType() {
        return Zone__c.SObjectType;
    }

    /**
     * @Description - Gets a list of SObject fields for Zone records.
     * @return List<Schema.SObjectField> : List of SObject fields.
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Zone__c.Id,
            Zone__c.Name,
            Zone__c.User__r.Id,
            Zone__c.User__r.Name,
            Zone__c.User__c
        };
    }

    /**
     *  @Description - Retrieves a list of Zone records associated with the current user.
     * @return List<Zone__c> : List of Zone records.
     */
    public List<Zone__c> getZone() {
        String userId = UserInfo.getUserId();
        return Database.query(
            newQueryFactory()
                .setCondition('User__r.Id = :userId AND Id != null')
                .toSOQL()
        );
    }

    /**
     *  @Description - Retrieves the Zone record associated with the current BDM (Business Development Manager) user.
     * @return Zone__c : Zone record for the BDM user.
     */
    public Zone__c getBDMZone() {
        String userId = UserInfo.getUserId();
        // String profileName = 'Standard Platform User'; // Replace with the actual profile name for BDM users
        return Database.query(
            newQueryFactory()
                .setCondition('User__r.Id = :userId AND Id != null')
                .toSOQL()
        );
    }
}
