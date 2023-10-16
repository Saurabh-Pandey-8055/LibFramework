/**
 * @description       : Schedulable class for event scheduling.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public class EventSchedular implements Schedulable {
    
    /**
     * @Description - Method executed when the scheduler runs.
     * @param List : ctx (SchedulableContext).
     */
    global void execute(SchedulableContext ctx) {
        PJPSelector pjpSelector = (PJPSelector)Pjp_Application.selector.newInstance(PJP__c.SObjectType);
        List<PJP__c> records = pjpSelector.getPJPforEvent();
        system.debug('Records' + records);
        
        List<String> pjp_ids = new List<String>();
        if (records.size() > 0) {
            for(PJP__c p : records) {
                pjp_ids.add(p.id);   
            }
        }
        
        if (pjp_ids.size() > 0) {
            pjpServiceImpl.createEvent(pjp_ids);
        }
    }
}
