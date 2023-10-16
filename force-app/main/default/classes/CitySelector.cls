/**
 * @description       : Selector class for City__c object.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class CitySelector extends LibSObjectSelector {

    /**
     * @Description - Constructor for the CitySelector class.
     * @return  - None.
     */
    public CitySelector() {
        super(true, false, false, false);
    }

    /**
     * @Description - Get the SObjectType for the City__c object.
     * @return  - Schema.SObjectType.
     */
    public Schema.SObjectType getSObjectType() {
        return City__c.SObjectType;
    }

    /**
     * @Description - Get a list of SObjectFields for the City__c object.
     * @return  - List<Schema.SObjectField>.
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            City__c.Id,
            City__c.Name,
            City__c.Account__c,
            City__c.Zone__c,
            City__c.Zone__r.Id 
        };
    }

    /**
     * @Description - Get a list of City__c records based on specified Zone Ids.
     * @param List : zoneIds (Set<Id>).
     * @return  - List<City__c>.
     */
    public List<City__c> getCity(Set<Id> zoneIds) {
        return Database.query(
            newQueryFactory()
                .setCondition('Zone__c IN :zoneIds')
                .toSOQL()
        );
    }
    
    /**
     * @Description - Get a list of all City__c records.
     * @return  - List<City__c>.
     */
     public List<City__c> getCityforGM(){
         return Database.query(
            newQueryFactory()
                .setCondition('')
                .toSOQL()
        );
    }
    
    /**
     * @Description - Get a list of City__c records for a specific zone.
     * @param List : zone (String).
     * @return  - List<City__c>.
     */
    public List<City__c> rkmCity(String zone){
        return Database.query(
            newQueryFactory()
              .setCondition(' Zone__r.Id=:zone')
                .toSOQL()
        );
    }
}
