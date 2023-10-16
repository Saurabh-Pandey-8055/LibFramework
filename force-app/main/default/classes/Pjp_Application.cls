/**
 * @description       : Application class for PJP functionality
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class Pjp_Application
{
    //  Configure and create the UnitOfWorkFactory for this Application
    public static final LibApplication.UnitOfWorkFactory UOW = new LibApplication.UnitOfWorkFactory(
    new List<SObjectType>{
        PJP__c.SObjectType,
        Event.SObjectType,
        PJP_Detail__c.SObjectType
    
    }
    );
    
    
    // Configure and create the ServiceFactory for this Application
    public static final LibApplication.ServiceFactory SERVICE = new LibApplication.ServiceFactory(
    new Map<Type, Type>{
        IPjpService.class => PJPServiceImpl.class
    }
    );
    
    
    
    // Configure and create the SelectorFactory for this Application
    public static final LibApplication.SelectorFactory SELECTOR =  new LibApplication.SelectorFactory(
    new Map<SObjectType, Type>{  
        User.SObjectType => UserSelector.class,
        Profile.SObjectType => ProfileSelector.class,
        Account.SObjectType => AccountSelector.class,
        ProcessInstanceWorkitem.SObjectType => ProcessInstanceWorkitemSelector.class,
        Zone__c.SObjectType => ZoneSelector.class,
        Sub_Zone__c.SObjectType => SubZoneSelector.class,
        City__c.SObjectType => CitySelector.class,
        Area__c.SObjectType => AreaSelector.class,
        PJP__c.SObjectType => PJPSelector.class,
        PJP_Detail__c.SObjectType => PjpDetailsSelector.class
    });
    
    // Configure and create the DomainFactory for this Application
    public static final LibApplication.DomainFactory DOMAIN = null;
    
}