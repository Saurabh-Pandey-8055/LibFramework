/**
 * @description       : This class provides methods to query and filter Account records.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class AccountSelector extends LibSObjectSelector {

/**
 * @Description - Constructor for the AccountSelector class.
 * @return  - None.
 */
public AccountSelector() {
    super(true, false, false, false);
}

/**
 * @Description - Get the SObjectType for the Account object.
 * @return  - Schema.SObjectType.
 */
public Schema.SObjectType getSObjectType() {
    return Account.SObjectType;
}

/**
 * @Description - Get a list of SObjectFields for the Account object.
 * @return  - List<Schema.SObjectField>.
 */
public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField> {
        Account.Id,
        Account.Name,
        Account.Sub_Classification__c,
        Account.Key_Customer__c,
        Account.Status__c,
        Account.City__r.id,
        Account.Area__r.id
    };
}

/**
 * @Description - Get the order by clause for query results.
 * @return  - String.
 */
public override String getOrderBy() {
    return 'Name';
}

/**
 * @Description - Get a list of Account records based on specified filters.
 * @param List : filter1 (String), filter2 (String), subclass (String).
 * @return  - List<Account>.
 */
public List<Account> getAccountList(String filter1, String filter2, String subclass) {
    return Database.query(
        newQueryFactory()
            .setCondition('Key_Customer__c != null AND (Status__c = \'Active\' OR Status__c = \'Approved\' OR Status__c = \'Auto Approved\')')  
            .toSOQL()
    );
}

/**
 * @Description - Get a list of Account records filtered by City.
 * @param List : cityId (String).
 * @return  - List<Account>.
 */
public List<Account> getAccountListByCity(String cityId) {
    // Implement logic for filtering by city
    return Database.query(
        newQueryFactory()
            .setCondition('City__r.Id=:cityId AND Key_Customer__c != null AND (Status__c = \'Active\' OR Status__c = \'Approved\' OR Status__c = \'Auto Approved\')')  
            .toSOQL()
    );
}

/**
 * @Description - Get a list of Account records filtered by Area.
 * @param List : areaId (String).
 * @return  - List<Account>.
 */
public List<Account> getAccountListByArea(String areaId) {
    // Implement logic for filtering by area
    return Database.query(
        newQueryFactory()
            .setCondition('Area__r.Id=:areaId AND Key_Customer__c != null AND (Status__c = \'Active\' OR Status__c = \'Approved\' OR Status__c = \'Auto Approved\')')  
            .toSOQL()
    ); 
}

/**
 * @Description - Get a list of Account records filtered by City and Area.
 * @param List : cityId (String), areaId (String).
 * @return  - List<Account>.
 */
public List<Account> getAccountListByCityAndArea(String cityId, String areaId) {
    // Implement logic for filtering by both city and area
    return Database.query(
        newQueryFactory()
            .setCondition('City__r.Id=:cityId AND Area__r.Id=:areaId  AND Key_Customer__c != null AND (Status__c = \'Active\' OR Status__c = \'Approved\' OR Status__c = \'Auto Approved\')')  
            .toSOQL()
    );
}

/**
 * @Description - Get a list of Account records filtered by Subclass.
 * @param List : subclass (String).
 * @return  - List<Account>.
 */
public List<Account> getAccountListBySubclass(String subclass) {
    // Implement logic for filtering by subclass
    return Database.query(
        newQueryFactory()
            .setCondition('Sub_Classification__c=:subclass AND Key_Customer__c != null AND (Status__c = \'Active\' OR Status__c = \'Approved\' OR Status__c = \'Auto Approved\')')  
            .toSOQL()
    );
}

/**
 * @Description - Get a list of Account records filtered by City, Area, and Subclass.
 * @param List : cityId (String), areaId (String), subclass (String).
 * @return  - List<Account>.
 */
public List<Account> getAccountListByCityAndAreaAndSubclass(String cityId, String areaId, String subclass) {
    // Implement logic for filtering by city, area, and subclass
    return Database.query(
        newQueryFactory()
            .setCondition('City__r.Id=:cityId AND Area__r.Id=:areaId AND Sub_Classification__c=:subclass AND Key_Customer__c != null AND (Status__c = \'Active\' OR Status__c = \'Approved\' OR Status__c = \'Auto Approved\')')  
            .toSOQL()
    );
}

/**
 * @Description - Get a list of Account records filtered by City and Subclass.
 * @param List : cityId (String), subclass (String).
 * @return  - List<Account>.
 */
public List<Account> getAccountListByCityAndSubclass(String cityId, String subclass) {
    // Implement logic for filtering by city and subclass
    return Database.query(
        newQueryFactory()
            .setCondition('City__r.Id=:cityId AND Sub_Classification__c=:subclass AND Key_Customer__c != null AND (Status__c = \'Active\' OR Status__c = \'Approved\' OR Status__c = \'Auto Approved\')')  
            .toSOQL()
    );
}

/**
 * @Description - Get a list of Account records filtered by Area and Subclass.
 * @param List : areaId (String), subclass (String).
 * @return  - List<Account>.
 */
public List<Account> getAccountListByAreaAndSubclass(String areaId, String subclass) {
    // Implement logic for filtering by area and subclass
    return Database.query(
        newQueryFactory()
            .setCondition('Area__r.Id=:areaId AND Sub_Classification__c=:subclass AND Key_Customer__c != null AND (Status__c = \'Active\' OR Status__c = \'Approved\' OR Status__c = \'Auto Approved\')')  
            .toSOQL()
    );
}

/**
 * @Description - Get a list of Account records filtered by Key Customer and Status.
 * @param List : None.
 * @return  - List<Account>.
 */
public List<Account> getSubclassFromApex() {
    return Database.query(
        newQueryFactory()
            .setCondition('Key_Customer__c != null AND (Status__c = \'Active\' OR Status__c = \'Approved\' OR Status__c = \'Auto Approved\')')
            .toSOQL()
    );
}
}
