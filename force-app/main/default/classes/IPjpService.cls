/**
 * @description       : Interface for PJPServiceImpl
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-10-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public interface IPjpService {
    List<Account> getAccountList(string filter1,String filter2,String subclass);
    List<Area__c> getArea(String city_id);
    List<User> getUser();
    List<User> getUserforGM();
    string getCurrentUser();
    List<City__c> getCity();
    List<Area__c> getAreaAll();
    String saveAsDraft(List<String> eventToCreate, String usr_id);
    String submitForApproval(String pjpId);
    String getFilterList1(String currentMonth, String startDate, String endDate, String usr_id, String profilename);
    String getProfile();
    String getUserId();
    String getUsername();
    String getSubzone();
    Area__c getCityOnArea(String areaId);
    List<PJP__c> getMonth();
    List<PJP__c> getMOnthbyId(String mon_id);
    String getMonthOnUser(String usr_id, String mon_name);
    Map<String, PJP_Detail__c> getMonthdetails(String month_value, String usr_id);
    Map<String, String> getMonthmap();
    void getdeleteDetails(List<String> lst);
    List<Sub_Zone__c> getBdmuser();
    List<User> getRkamUser();
    List<User> getNkamUser();
    List<Zone__c> getZone();
    List<City__c> rkmCity(String zone);
    List<Area__c> rkmArea(String zone);
    List<PJP__c> getpjp(String usr_id);
    List<Account> getAccountsubclass(String str);
    String getUserbyId(String usr_id);
    Boolean approvePjp(String pjpId, String comment);
    Boolean rejectPjp(String pjp_id, String comment);
    List<String> getSubclassFromApex();
    String getpjpUserId(String pjp_id);
    List<City__c> getCityforGM();
    List<Area__c> getAreaforGM();
}