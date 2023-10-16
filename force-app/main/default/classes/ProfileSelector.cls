/**
 * @description       : This class provides methods to select and query Profile records.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class ProfileSelector extends LibSObjectSelector {

    /**
     * @Description - Constructor for ProfileSelector class.
     */
    public ProfileSelector() {
        super(true, false, false, false);
    }

    /**
     * @Description - Gets the SObjectType for Profile records.
     * @return Schema.SObjectType : Profile object type.
     */
    public Schema.SObjectType getSObjectType() {
        return Profile.SObjectType;
    }

    /**
     * @Description - Gets a list of SObject fields for Profile records.
     * @return List<Schema.SObjectField> : List of SObject fields.
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Profile.Id,
            Profile.Name,
            Profile.User__r.id
        };
    }

    /**
     * @Description - Retrieves the user's Profile record.
     * @return Profile : User's Profile record.
     */
    public Profile getProfile() {
        String userId = UserInfo.getProfileId();
        return (Profile) Database.query(
            newQueryFactory()
                .setCondition('Id = :userId')
                .toSOQL()
        );
    }
}
