/**
 * @Description       : Implementation of the IPjpService interface.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PJPServiceImpl implements IPjpService {
    
    @AuraEnabled
    public map<String,String> monthIntMap =new map<String,String>();
    public Map<String,String> monthvaluemap = new Map<String,String>();
    static List<String> subClassList = new List<String>();
    public map<String,String> profileMetaMap =new map<String,String>();
    
     /**
     * Constructor for PJPServiceImpl class.
     * Initializes monthIntMap and profileMetaMap.
     */
    public PJPServiceImpl() {
        monthIntMap.put('Jan','01');
        monthIntMap.put('Feb','02');
        monthIntMap.put('Mar','03');
        monthIntMap.put('Apr','04');
        monthIntMap.put('May','05');
        monthIntMap.put('Jun','06');
        monthIntMap.put('Jul','07');
        monthIntMap.put('Aug','08');
        monthIntMap.put('Sep','09');
        monthIntMap.put('Oct','10');
        monthIntMap.put('Nov','11');
        monthIntMap.put('Dec','12');

        List<JourneyPlanProfiles__mdt> mcs = JourneyPlanProfiles__mdt.getAll().values();
        //Map<String,JourneyPlanProfiles__mdt> journeyProfileByLevel = new Map<String,JourneyPlanProfiles__mdt>();
        for(JourneyPlanProfiles__mdt profile:mcs){
        profileMetaMap.put(profile.level__c,profile.Label);

}
          system.debug('111111'+profileMetaMap);
    }
    
    /**
     * @Description - This method is used to gets a list of Account records based on the provided filters.
     * @param filter1 : String : Filter 1.
     * @param filter2 : String : Filter 2.
     * @param subclass : String : Subclass filter.
     * @return List<Account> : List of Account records.
     */

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList(string filter1,String filter2,String subclass){
        system.debug('filter1--->'+filter1);
        system.debug('filter2--->'+filter2);
        system.debug('subclass--->'+subclass);
        
        
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(Account.SObjectType);
        AccountSelector selectorObj = (AccountSelector)selector; 
        if(!String.isBlank(filter1) && String.isBlank(filter2) && String.isBlank(subclass)){//for city
            return selectorObj.getAccountListByCity(filter1);
        }else if(String.isBlank(filter1) && !String.isBlank(filter2) && String.isBlank(subclass)){//for Area
            return selectorObj.getAccountListByArea(filter2);
        }else if(!String.isBlank(filter1)&& !String.isBlank(filter2) && String.isBlank(subclass)){//for city and Area
            return selectorObj.getAccountListByCityAndArea(filter1,filter2);
        }else if(String.isBlank(filter1) && String.isBlank(filter2) && !String.isBlank(subclass)){ // for class
            return selectorObj.getAccountListBySubclass(subclass);
        }else if(!String.isBlank(filter1) && !String.isBlank(filter2) && !String.isBlank(subclass)){ // for city area class
            return selectorObj.getAccountListByCityAndAreaAndSubclass(filter1,filter2,subclass); 
        }else if(!String.isBlank(filter1) && String.isBlank(filter2) && !String.isBlank(subclass)){ // for city class
            return selectorObj.getAccountListByCityAndSubclass(filter1,subclass);
        }else if(String.isBlank(filter1) && !String.isBlank(filter2) && !String.isBlank(subclass)){ // for area class
            return selectorObj.getAccountListByAreaAndSubclass(filter2,subclass); 
        }else{ // no codition
            List<Account> tempAcc = selectorObj.getAccountList(filter1,filter2,subclass); 
            return tempAcc;
        }
    }
   
    /**
     * @Description - This method is used to gets a list of Area__c records based on the provided cityId.
     * @param cityId : String : City Id.
     * @return List<Area__c> : List of Area__c records.
     */
    @AuraEnabled(cacheable=true)
    public static List<Area__c> getArea(String cityId) {
        LibISObjectSelector selector = Pjp_Application.selector.newInstance(Area__c.SObjectType);
        AreaSelector selectorObj = (AreaSelector) selector;
        Set<Id> cityIds = new Set<Id>{cityId};
        return selectorObj.getArea(cityIds);
    }
    
    /**
     * @Description - This method is used to gets a list of User records.
     * @return List<User> : List of User records.
     */
    @AuraEnabled(cacheable=true)
    public static List<User> getUser() {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(User.SObjectType);
        UserSelector selectorObj = (UserSelector)selector;
        List<User> userlst = selectorObj.getAllUsers();
        if(userlst.size()>0){
            return userlst;
        }
        else{
            return new List<User>();
        }  
    }
    
    /**
     * @Description - This method is used to gets a list of User records for GM (General Manager).
     * @return List<User> : List of User records for GM.
     */

    @AuraEnabled(cacheable=true)
    public static List<User> getUserforGM() {
        LibISObjectSelector selector = Pjp_Application.selector.newInstance(User.SObjectType);
        UserSelector selectorObj = (UserSelector)selector;
        List<User> userlst = selectorObj.getUsersForGM(); 
        if (userlst.size() > 0) {
            return userlst;
        } else {
            return new List<User>();
        }
    }
    
    /**
     * @Description - This method is used to gets the current user's Id.
     * @return String : Current user's Id.
     */

    @AuraEnabled(cacheable=true)
    public static string getCurrentUser(){
        return UserInfo.getUserId();
    }
    
    /**
     * @Description - This method is used to gets a list of City__c records.
     * @return List<City__c> : List of City__c records.
     */
    @AuraEnabled(cacheable=true)
    public static List<City__c> getCity() 
    {
        CitySelector cityselector = (CitySelector) Pjp_Application.selector.newInstance(City__c.SObjectType);
        SubZoneSelector subZoneSelector = (SubZoneSelector)Pjp_Application.selector.newInstance(Sub_Zone__c.SObjectType);
        // CitySelector selectorObj = selector;
        List<Sub_Zone__c> subZones = subZoneSelector.getSubzone();
        
        if (!subZones.isEmpty()) {
            Set<Id> zoneIds = new Set<Id>();
            for (Sub_Zone__c subZone : subZones) {
                zoneIds.add(subZone.Zone__c);
            }
            return cityselector.getCity(zoneIds);
        } else {
            return new List<City__c>();
        }
        
    }
    
    /**
     * @Description - This method is used to gets a list of all Area__c records.
     * @return List<Area__c> : List of all Area__c records.
     */

    @AuraEnabled(cacheable=true)
    public static List<Area__c> getAreaAll() {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(Area__c.SObjectType);
        LibISObjectSelector selector1 =  Pjp_Application.selector.newInstance(Sub_Zone__c.SObjectType);
        AreaSelector selectorObj = (AreaSelector)selector; 
        SubZoneSelector subZoneSelector = (SubZoneSelector)selector1;
        List<Sub_Zone__c> subZones = subZoneSelector.getSubzone();
        
        if (!subZones.isEmpty()) {
            Set<Id> zoneIds = new Set<Id>();
            for (Sub_Zone__c subZone : subZones) {
                zoneIds.add(subZone.Zone__c);
            }
            return selectorObj.getAreaAll(zoneIds);
        } else {
            return new List<Area__c>();
        }
        
        
    }
    
    /**
     * @Description - This method is used to saves a list of pjp_details(events) as drafts.
     * @param eventToCreate : List<String> : List of events to create.
     * @param usr_id : String : User Id.
     * @return String : Result message ('updated' or 'failed').
     */
    @AuraEnabled 
    public static String saveAsDraft(List<String> eventToCreate, String usr_id) {
        system.debug('Event created=='+eventToCreate);
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PJPSelector selectorobj = (PJPSelector)selector; 
        PJPServiceImpl pjpServiceObj = new PJPServiceImpl();
        List<PJP_Detail__c> pjp_detailList = new List<PJP_Detail__c>();
        
        for (String s : eventToCreate) {
            Integer day = Integer.valueOf(s.split('_')[0]);
            String accountid = s.split('_')[1];
            String mon_name = s.split('_')[2];
            String mon = s.split('_')[2].split('-')[0];
            Integer year1 = Integer.valueOf(s.split('_')[2].split('-')[1]);
            Integer mon1 = Integer.valueOf(pjpServiceObj.monthIntMap.get(mon));
            Date myDate = Date.newInstance(year1,mon1,day);
            Time sTime = Time.newInstance(10, 0, 0, 0);
            Time eTime = Time.newInstance(11, 0, 0, 0);
            DateTime sdt = DateTime.newInstance(myDate, sTime);
            DateTime edt = DateTime.newInstance(myDate, eTime);
            List<PJP__C> pjpc = selectorobj.getpjpc(mon_name,usr_id);
            PJP_Detail__c  pd = new PJP_Detail__c(Name='pjp_'+String.valueOf(day)+'-'+mon_name,Start_Datetime__c=sdt,End_Datetime__c=edt,Account__c=accountid,PJP__c=pjpc[0].Id,Plan_Date__c=myDate,User__c=UserInfo.getUserId());
            pjp_detailList.add(pd);
        }
        
            LibISobjectUnitOfWork unitofwork = Pjp_Application.uow.newInstance();
            unitofwork.registerUpsert(pjp_detailList);
            unitofwork.commitWork();

        if (pjp_detailList.size() > 0) {
            return 'updated';
        } else {
            return 'failed';
        }
    }

    /**
     * @Description  : Submits a PJP record for approval.
     * @param pjp_id : String : Id of the PJP record.
     * @return String : Status message ('Pending' or 'Something went wrong').
     */
    @AuraEnabled 
    public static String submitForApproval(String pjp_id) {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        LibISobjectUnitOfWork unitofwork = Pjp_Application.uow.newInstance();
        PJPSelector selectorobj = (PJPSelector)selector; 
        PJP__c pjpRecord = selectorobj.getPJPById(pjp_id);
        
        if (pjpRecord != null) {
            pjpRecord.Status__c = 'Pending';
            unitofwork.registerDirty(pjpRecord);
            unitofwork.commitWork();
            return pjpRecord.Status__c;
        } else {
            return 'Something went wrong';
        }
    }
    

    /**
     * @Description : Gets a list of filters based on provided parameters.
     * @param currentMonth : String : Current month.
     * @param startDate : String : Start date.
     * @param endDate : String : End date.
     * @param usr_id : String : User Id.
     * @param profilename : String : Profile name.
     * @return String : Current month name or an empty string.
     */ 
    @AuraEnabled 
    public static String getFilterList1(String currentMonth, String startDate, String endDate, String usr_id, String profilename) {
        system.debug(' currentMonth-> '+currentMonth+' startDate-> '+startDate+' endDate '+endDate);
        Boolean isMasterCreated;
        String nextMonth;
        system.debug('currentMonth-----> '+startDate.split(' ')[0]+' ===== '+startDate.remove(startDate.split(' ')[0]));
        system.debug('startDate 1 -->'+startDate.split(' ')[1]);
        system.debug('startDate 2 -->'+startDate.split(' ')[2]);
        system.debug('startDate 3 -->'+startDate.split(' ')[3]);
        system.debug('endDate 1 -->'+endDate.split(' ')[1]);
        system.debug('endDate 2 -->'+endDate.split(' ')[2]);
        system.debug('endDate 3 -->'+endDate.split(' ')[3]);
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PJPSelector selectobj = (PJPSelector)selector;
        List<PJP__c> pjpMasterList =  selectobj.getPJPBymonth(currentMonth,usr_id);
        if(pjpMasterList.size()>0){
            //create Master for next month i.e.
            isMasterCreated = true;  
        }else{
            //load master for next month
            isMasterCreated = false;
        }       
        if(!isMasterCreated){
            //create master data
            PJPServiceImpl pjpServiceObj = new PJPServiceImpl();
            
            PJP__c pjp = new PJP__c();
            system.debug('@@@month Map '+pjpServiceObj.monthIntMap);
            system.debug('@@@month Map '+pjpServiceObj.monthIntMap.get(startDate.split(' ')[1]));
            pjp.Name = currentMonth;
            
            
            String newSDate = startDate.split(' ')[3]+'-'+startDate.split(' ')[2]+'-'+pjpServiceObj.monthIntMap.get(startDate.split(' ')[1])+' 14:00 00';
            String newEDate = pjpServiceObj.monthIntMap.get(endDate.split(' ')[1])+'-'+endDate.split(' ')[2]+'-'+endDate.split(' ')[3]+' 14:00 00';
            
            
            DateTime dt = DateTime.newInstance(Integer.valueOf(startDate.split(' ')[3]), Integer.valueOf(pjpServiceObj.monthIntMap.get(startDate.split(' ')[1])), Integer.valueOf(startDate.split(' ')[2]), 12, 0, 0);
            DateTime dt2 = DateTime.newInstance(Integer.valueOf(endDate.split(' ')[3]), Integer.valueOf(pjpServiceObj.monthIntMap.get(endDate.split(' ')[1])), Integer.valueOf(endDate.split(' ')[2]), 12, 0, 0);
            system.debug('@@ newSDate '+dt);
            system.debug('@@ newEDate2 '+dt2);
            pjp.Start_Datetime__c = dt;
            pjp.End_Datetime__c = dt2;
            pjp.Status__c = 'Draft';
            pjp.User__c = UserInfo.getUserId();
            pjp.PJP_Prepared_By__c = profilename;

            LibISobjectUnitOfWork unitofwork = Pjp_Application.uow.newInstance();
            unitofwork.registerNew(pjp);
            unitofwork.commitWork();
            System.debug('PJP inserted --------->'+pjp.Name);
            return pjp.Name;
        }else{
            system.debug('isMasterCreated------------> '+isMasterCreated);
            return '';
        }  
    }
        
    /**
     * @Description   : Gets the profile name of the current user.
     * @return String : Profile name or null.
     */
    
    @AuraEnabled(cacheable=true)
    public static String getProfile() {
        LibISObjectSelector selector = Pjp_Application.selector.newInstance(Profile.SObjectType);
        ProfileSelector selectorObj = (ProfileSelector) selector;
        Profile profile = selectorObj.getProfile();
        
        if (profile != null) {
            return profile.Name;
        } else {
            return null;
        }
        
    }
    
    /**
     * @Description   : Gets the Id of the current user.
     * @return String : User Id.
     */
    @AuraEnabled(cacheable=true)
    public static String getUserId() {
        return UserInfo.getUserId(); 
    }

    /**
     * @Description   : Gets the name of the current user.
     * @return String : User name.
     */
    @AuraEnabled 
    public static String getUsername() {  
        return UserInfo.getName();
    }

    /**
     * @Description   : Gets the name of the Subzone.
     * @return String : Subzone name or null.
     */
    @AuraEnabled 
    public static String getSubzone() {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(Sub_Zone__c.SObjectType);
        SubZoneSelector selectorObj = (SubZoneSelector)selector; 
        return selectorObj.getSubzone()[0]?.Name; 
        
    }

    /**
     * @Description  : Gets the City__c record based on the provided Area Id.
     * @param areaId : String : Area Id.
     * @return Area__c : City__c record.
     */
    @AuraEnabled 
    public static Area__c getcityOnArea(String areaId) {
        System.debug('Area Id '+areaid);
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(Area__c.SObjectType);
        AreaSelector selectorObj = (AreaSelector)selector; 
        return selectorObj.getCityOnArea(areaId); 
        
    }
    
    /**
     * @Description  : Gets a list of PJP__c records for the current user.
     * @return List<PJP__c> : List of PJP__c records.
     */
    @AuraEnabled 
    public static List<PJP__c> getMonth() {
      String userid = UserInfo.getUserId();
      System.debug('USerID 123'+userid);
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PJPSelector selectorObj = (PJPSelector)selector; 
        List<PJP__c> month = selectorObj.getMonth(userid);
        System.debug('month 123'+month);
        if(month.size()>0){
            return month;
        }
        else{
            return new List<PJP__c>();  
        }
        
    }
    
    /**
     * @Description  : Gets a list of PJP__c records by Id.
     * @param mon_id : String : Id of the PJP record.
     * @return List<PJP__c> : List of PJP__c records.
     */
    @AuraEnabled 
    public static List<PJP__c> getMOnthbyId(String mon_id) {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PJPSelector selectorObj = (PJPSelector)selector; 
        List<PJP__c> month = selectorObj.getMOnthbyId(mon_id);
        if(month.size()>0){
            return month;
        }
        else{
            return  new List<PJP__c>();  
        } 
        
    }
    
    /**
     * @Description  : Gets the Id of the PJP record for the given month and user.
     * @param usr_id : String : User Id.
     * @param mon_name : String : Month name.
     * @return String : PJP record Id or 'data'.
     */
    @AuraEnabled 
    public static String getMonthOnUser(String usr_id, String mon_name) {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PJPSelector selectorObj = (PJPSelector)selector; 
        List<PJP__c> pjplst = selectorObj.getMonthOnUser(usr_id,mon_name);
        if(pjplst.size()>0)
        {
            return pjplst[0].Id;
        }else{
            return 'data';
        }
    }       
    
    /**
     * @Description  : Gets a map of PJP_Detail__c records for a given month and user.
     * @param month_value : String : Month value.
     * @param usr_id : String : User Id.
     * @return Map<String, PJP_Detail__c> : Map of PJP_Detail__c records.
     */
    @AuraEnabled 
    public static Map<String, PJP_Detail__c> getMonthdetails(String month_value, String usr_id) {
        System.debug('Month details '+month_value);
        PJPSelector selectorObj = (PJPSelector) Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PJPDetailsSelector pjpDetailSelector = (PJPDetailsSelector)Pjp_Application.selector.newInstance(PJP_Detail__c.SObjectType);
        PJPServiceImpl pjpServiceObj = new PJPServiceImpl();
        List<PJP__c> pjplst = selectorObj.getpjp(usr_id);
        System.debug('current user '+UserInfo.getUserId()+' Name'+UserInfo.getFirstName());
        for(PJP__c pjp:pjplst)
        {
            pjpServiceObj.monthvaluemap.put(pjp.Name,pjp.Id);
            
        }
        System.debug(pjpServiceObj.monthvaluemap.get(month_value)); 
        System.debug('Monthvalue map '+pjpServiceObj.monthvaluemap); 
        String month_id = pjpServiceObj.monthvaluemap.get(month_value);
        System.debug('Month id '+month_id); 
        Map<String,PJP_Detail__c> mapcheckbox = new Map<String,PJP_Detail__c>();

        List<PJP_Detail__c> pjp_detailList = pjpDetailSelector.getPjpDetails(month_id);
        System.debug('pjp details '+pjp_detailList);
        for(PJP_Detail__c  pjpd: pjp_detailList){
            Datetime dt = (DateTime)pjpd.Start_Datetime__c;
            System.debug(dt.day());
            mapcheckbox.put(dt.day()+'_'+pjpd.Account__c,pjpd);
        }
        System.debug('Month details '+mapcheckbox);
        return mapcheckbox;   
        
    }
    
    /**
 * @description       : Gets a map of month names to PJP Ids for the current user.
 * @return Map<String, String> : Map of month names to PJP Ids.
 */
    @AuraEnabled 
    public static Map<String, String> getMonthmap() {
        String userid = UserInfo.getUserId();
        Map<String,String> monthmap = new Map<String,String>();
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PJPSelector selectorObj = (PJPSelector)selector;
        List<PJP__c> pjplst = selectorObj.getpjp(userid);
        for(PJP__c pjp:pjplst)
        {
            monthmap.put(pjp.Name,pjp.Id);
        }
        System.debug('month map '+monthmap);
        return monthmap;    
    }
    /**
 * @description       : Deletes PJP_Detail__c records based on the provided list of Ids.
 * @param lst : List<String> : List of PJP_Detail__c Ids to be deleted.
 */
    @AuraEnabled
    public static void getdeleteDetails(List<String>  lst) {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PjpDetailsSelector selectorobj = (PjpDetailsSelector)selector;
        List<PJP_Detail__c> pjp_detailList = selectorobj.getdeleteDetails(lst);
        
        if (!pjp_detailList.isEmpty()) {
            LibISObjectUnitOfWork uow = Pjp_Application.uow.newInstance();
            uow.registerDeleted(pjp_detailList);
            uow.commitWork();
        }
    }
    
  /**
 * @description       : Gets a list of Sub_Zone__c records for BDM users in the user's Zone.
 * @return List<Sub_Zone__c> : List of Sub_Zone__c records.
 */

    @AuraEnabled
    public static List<Sub_Zone__c> getBdmuser() {
        ZoneSelector selectZoneObj = (ZoneSelector)Pjp_Application.selector.newInstance(Zone__c.SObjectType);
        SubZoneSelector selectorSubZoneObj = (SubZoneSelector)Pjp_Application.selector.newInstance(Sub_Zone__c.SObjectType);
        
        // Get the filtered Zone__c records based on the user's profile
        Zone__c zonelist = selectZoneObj.getBDMZone();
        String zoneid = zonelist.Id;
        // Call the modified getBdmUsers method with the filtering criteria
        List<Sub_Zone__c> subzonelist = selectorSubZoneObj.getBdmUsers(zoneid);
        
        if (subzonelist.size() > 0) {
            return subzonelist;
        } else {
            return new List<Sub_Zone__c>();
        }
    }
    
/**
 * @description       : Gets a list of User records for RKAM users based on their profile.
 * @return List<User> : List of User records.
 */


    @AuraEnabled  
    public static List<User> getRkamUser() {
        PJPServiceImpl pjpServiceObj = new PJPServiceImpl();
       // ProfileSelector profileselector = (ProfileSelector)Pjp_Application.selector.newInstance(Profile.SObjectType);
        UserSelector userselector = (UserSelector)Pjp_Application.selector.newInstance(User.SObjectType);
        system.debug('131231213'+pjpServiceObj.profileMetaMap.get('2'));
        List<User> rkamuser = userselector.getRkamUser( pjpServiceObj.profileMetaMap.get('2'));
        system.debug('rkam'+rkamuser);
        if (!rkamuser.isEmpty()) {
            return userselector.getUserbyId(rkamuser[0].Id); 
        } else {
            return new List<User>();
        }
        
    }
    
    /**
 * @description       : Gets a list of User records for NKAM users based on their profile.
 * @return List<User> : List of User records or null.
 */
    @AuraEnabled  
    public static List<User> getNkamUser() {
        PJPServiceImpl pjpServiceObj = new PJPServiceImpl();
        UserSelector userselector = (UserSelector)Pjp_Application.selector.newInstance(User.SObjectType);
        List<User> nkamuser = userselector.getNkamUser( pjpServiceObj.profileMetaMap.get('3'));
        
        if (!nkamuser.isEmpty()) {
            return userselector.getUserbyId(nkamuser[0].Id);
        } else {
            return null;
        }
        
    }
    
    /**
 * @description       : Gets a list of Zone__c records.
 * @return List<Zone__c> : List of Zone__c records.
 */
    @AuraEnabled 
    public static List<Zone__c> getZone() {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(Zone__c.SObjectType);
        ZoneSelector selectorObj = (ZoneSelector)selector; 
        return selectorObj.getZone(); 
    }
    
    /**
 * @description       : Gets a list of City__c records filtered by a Zone.
 * @param zone : String : Zone name.
 * @return List<City__c> : List of City__c records.
 */
    @AuraEnabled 
    public static List<City__c> rkmCity(String zone) {
        LibISObjectSelector selector = Pjp_Application.selector.newInstance(City__c.SObjectType);
        CitySelector selectorObj = (CitySelector) selector;
        return selectorObj.rkmCity(zone);
    }
    
    /**
 * @description       : Gets a list of Area__c records filtered by a Zone.
 * @param zone : String : Zone name.
 * @return List<Area__c> : List of Area__c records.
 */
    @AuraEnabled 
    public static List<Area__c> rkmArea(String zone) {
        LibISObjectSelector selector = Pjp_Application.selector.newInstance(Area__c.SObjectType);
        AreaSelector selectorObj = (AreaSelector) selector;
        return selectorObj.rkmArea(zone);
    }
    
   /**
 * @description       : Gets a list of PJP__c records for a given user.
 * @param usr_id : String : User Id.
 * @return List<PJP__c> : List of PJP__c records.
 */ 
    @AuraEnabled 
    public static List<PJP__c> getpjp(String usr_id) {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PJPSelector selectorObj = (PJPSelector)selector; 
        return selectorObj.getpjp(usr_id); 
    }
    

    @AuraEnabled 
    public static List<Account> getAccountsubclass(String str) {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(Account.SObjectType);
        AccountSelector selectorObj = (AccountSelector)selector;
        List<Account> acclist = selectorObj.getSubclassFromApex();
        return acclist;
        
    }
    /**
 * @description       : Gets the name of a User record based on the provided Id.
 * @param usr_id : String : User Id.
 * @return String : User name or an empty string.
 */
    @AuraEnabled  
    public static String getUserbyId(String usr_id) {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(User.SObjectType);
        UserSelector selectorObj = (UserSelector)selector; 
        List<User> user = selectorObj.getUserbyId(usr_id);
        if (user.size()>0) {
            return user[0].Name;
        } else {
            return '';
        }
        
    }
    /**
 * @description       : Approves a PJP record.
 * @param pjp_id : String : PJP Id.
 * @param comment : String : Approval comment.
 * @return Boolean : True if successful, False otherwise.
 */

    @AuraEnabled  
    public static Boolean approvePjp(String pjp_id, String comment) {
        System.debug('pjp to approve id '+pjp_id); 
        System.debug('Comment value '+comment);
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(ProcessInstanceWorkitem.SObjectType);
        ProcessInstanceWorkitemSelector selectobj = (ProcessInstanceWorkitemSelector)selector;
        List<ProcessInstanceWorkitem> workItems = selectobj.approve(pjp_id);
        System.debug('Workitem id '+workItems[0].Id);
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for(ProcessInstanceWorkitem workItem : workItems){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest(); 
            req.setWorkitemId(workItem.Id);
            //Valid values are: Approve, Reject, or Removed. 
            //Only system administrators can specify Removed.
            req.setAction('Approve');
            req.setComments(comment);
            requests.add(req);
            System.debug('req '+req);
        }
        Approval.ProcessResult[] processResults;
        try{
            processResults = Approval.process(requests);
        }catch(DmlException dml){
            System.debug('Exp '+dml.getCause()+'-----'+dml.getMessage()+'----->'+dml.getStackTraceString());
        }
        System.debug('Results '+processResults);
        if(processResults.size() > 0)
        {
            System.debug('Success');
            createEvent(new List<String>{pjp_id});
            return true;
        }   else{
            System.debug('Failed to Approve Record');
            return false;
        }
        
    }
/**
 * @description       : Creates Event records based on the provided PJP_Detail__c Ids.
 * @param pjp_id : List<String> : List of PJP_Detail__c Ids for which Event records will be created.
 * @return - None
 */

        public static void createEvent(List<String> pjp_id){
        System.debug('create event');
        PJPDetailsSelector pjpDetailSelector = (PJPDetailsSelector)Pjp_Application.selector.newInstance(PJP_Detail__c.SObjectType);
        List<PJP_Detail__c> pjpdetails = pjpDetailSelector.getpjpApprovedDetails(pjp_id);
        System.debug('create eventabc'+pjpdetails.size());
        List<Event> evntlst = new List<Event>();
       // List<PJP_Detail__c> updatedPjpDetails = new List<PJP_Detail__c>();
         System.debug('create event xyz'+pjpdetails);
        for(PJP_Detail__c pd :pjpdetails ){
            if(pd.EventCreated__c == false){
            System.debug('inside if');
            Event evnt = new Event();
            evnt.StartDateTime = pd.Start_Datetime__c;
            evnt.EndDateTime = pd.End_Datetime__c;
            evnt.ownerId = pd.User__c;
            evnt.WhatId = pd.Account__c;
            evnt.Subject = 'Call';
            evntlst.add(evnt);
    
            pd.EventCreated__c = true;
            // updatedPjpDetails.add(pd);
        }
    }
    
        LibISobjectUnitOfWork unitofwork = Pjp_Application.uow.newInstance();
        unitofwork.registerNew(evntlst);
        unitofwork.registerDirty(pjpdetails);
        unitofwork.commitWork();
    
        System.debug('create event1111');
    }
    

/**
 * @description       : Rejects a PJP record.
 * @param pjp_id : String : PJP Id.
 * @param comment : String : Rejection comment.
 * @return Boolean : True if successful, False otherwise.
 */
    @AuraEnabled 
    public static Boolean rejectPjp(String pjp_id, String comment) {
        System.debug('Comment value '+comment); 
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(ProcessInstanceWorkitem.SObjectType);
        ProcessInstanceWorkitemSelector selectobj = (ProcessInstanceWorkitemSelector)selector;
        List<ProcessInstanceWorkitem> workItems = selectobj.reject(pjp_id);
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for(ProcessInstanceWorkitem workItem : workItems){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(workItem.Id);
            //Valid values are: Approve, Reject, or Removed. 
            //Only system administrators can specify Removed.
            req.setAction('Reject');
            req.setComments(comment);
            requests.add(req);
        }
        Approval.ProcessResult[] processResults = Approval.process(requests);
        System.debug('Results '+processResults);
        if(processResults.size() >0)
        {
            System.debug('Success');
            return true;
        }else{
            System.debug('Failed to Approve Record');
            return false;
        } 
    }
    
/**
 * @description       : Gets a list of subclass values from Account records.
 * @param str : String : Unused parameter.
 * @return List<String> : List of subclass values.
 */
    
    @AuraEnabled  
    public static List<String> getSubclassFromApex() {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(Account.SObjectType);
        AccountSelector selectorObj = (AccountSelector)selector;
        List<Account> acclist = selectorObj.getSubclassFromApex();
        
        Set<String> subclassSet = new Set<String>();
        List<String> subclassList = new List<String>();
        
        for (Account acc : acclist) {
            if (subclassSet.add(acc.Sub_Classification__c)) {
                subclassList.add(acc.Sub_Classification__c);
            }
        }
        
        return subclassList;
        
    }
    
 /**
 * @description       : Gets the User Id of a PJP record based on the provided PJP Id.
 * @param pjp_id : String : PJP Id.
 * @return String : User Id or an empty string.
 */
    @AuraEnabled  
    public static String getpjpUserId(String pjp_id) {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        PJPSelector selectorObj = (PJPSelector)selector; 
        PJP__c pjp = selectorObj.getpjpUserId(pjp_id);
        if (pjp != null) {
            return pjp.CreatedById;
        } else {
            return '';
        }
        
    }
    

    /**
 * @description       : Gets a list of City__c records for GM users.
 * @return List<City__c> : List of City__c records.
 */
    @AuraEnabled 
    public static List<City__c> getCityforGM() {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(City__c.SObjectType);
        CitySelector selectorObj = (CitySelector)selector; 
        return selectorObj.getCityforGM(); 
    }
    

    /**
 * @description       : Gets a list of Area__c records for GM users.
 * @return List<Area__c> : List of Area__c records.
 */
    @AuraEnabled  
    public static List<Area__c> getAreaforGM() {
        LibISObjectSelector selector =  Pjp_Application.selector.newInstance(Area__c.SObjectType);
        AreaSelector selectorObj = (AreaSelector)selector; 
        return selectorObj.getAreaforGM();   
    }
    
    /**
     * @description       : Gets a list of JourneyPlanProfiles__mdt metadata records.
     * @return List<JourneyPlanProfiles__mdt> : List of JourneyPlanProfiles__mdt records.
     */
        @AuraEnabled(cacheable=true)
        public static List<JourneyPlanProfiles__mdt> getProfileMetadata(){
        List<JourneyPlanProfiles__mdt> mcs = JourneyPlanProfiles__mdt.getAll().values();
        return mcs;
            }

   
    
}