/**
 * @description       : Selector class for Area__c object.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class AreaSelector extends LibSObjectSelector 
{

    /**
     * @Description - Constructor for the AreaSelector class.
     * @return  - None.
     */
    public AreaSelector()
    {
        super(true, false, false, false);
    }
    
    /**
     * @Description - Get the SObjectType for the Area__c object.
     * @return  - Schema.SObjectType.
     */
    public Schema.SObjectType getSObjectType() 
    {
        return Area__c.SObjectType;
    }

    /**
     * @Description - Get a list of SObjectFields for the Area__c object.
     * @return  - List<Schema.SObjectField>.
     */
    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            Area__c.Id,
            Area__c.Name,
            Area__c.City__c,
            Area__c.City__r.Id,
            Area__c.City__r.Name,
            Area__c.Zone__c,  
            Area__c.Zone__r.Id 
        };
    }
    
    /**
     * @Description - Get a list of Area__c records based on specified City Ids.
     * @param List : cityIds (Set<Id>).
     * @return  - List<Area__c>.
     */
    public List<Area__c> getArea(Set<Id> cityIds) {
        return Database.query(
            newQueryFactory()
                .setCondition('City__r.Id IN :cityIds')
                .toSOQL()
        );
    }
    
    /**
     * @Description - Get an Area__c record based on its Id.
     * @param List : area_id (String).
     * @return  - Area__c.
     */
     public Area__c getCityOnArea(String area_id) {
        return Database.query(
            newQueryFactory()
                .setCondition('Id =:area_id')
                .toSOQL()
        );
    }

    /**
     * @Description - Get a list of Area__c records based on specified Zone Ids.
     * @param List : zoneIds (Set<Id>).
     * @return  - List<Area__c>.
     */
    public List<Area__c> getAreaAll(Set<Id> zoneIds) {
        return Database.query(
            newQueryFactory()
                .setCondition('Zone__c IN :zoneIds')
                .toSOQL()
        );
    }
    
    /**
     * @Description - Get a list of all Area__c records.
     * @return  - List<Area__c>.
     */
    public List<Area__c> getAreaforGM(){
         return Database.query(
            newQueryFactory()
                .toSOQL()
        );
    }

    /**
     * @Description - Get a list of Area__c records for a specific zone.
     * @param List : zone (String).
     * @return  - List<Area__c>.
     */
    public List<Area__c> rkmArea(String zone){
        return Database.query(
            newQueryFactory()
              .setCondition(' Zone__r.Id=:zone')
                .toSOQL()
        );
    }
}
