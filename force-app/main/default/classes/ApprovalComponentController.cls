/**
 * @description       : This class serves as the controller for managing approval processes and retrieving approval data.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ApprovalComponentController {
   
    /**
     * Default constructor for the ApprovalComponentController class.
     */
    // public ApprovalComponentController() {
    //      // Constructor left intentionally empty.
    // }


   /**
    * @description : Retrieves approval data for a specific record identified by the provided ID.
    * @param recId: The ID of the record for which approval data is retrieved.
    * @return ApprovalList: A list containing the retrieved approval data.
    */
  
   @AuraEnabled  
   public static ApprovalList getApprovalData(Id recId)  
   {  
    system.debug('pjp id =>'+recId);
     Id recordId = recId;  
     ApprovalList approvalResultForObject = new ApprovalList();  
     List<ApprovalStepWrapper> aSW = new List<ApprovalStepWrapper>();  
     String recallApprovalProcessLink;  
     Boolean isSubmitForApproval = true; 
     system.debug('getProcessHistory =>'+getProcessHistory(recordId).values());
     for(ProcessInstance pI: getProcessHistory(recordId).values())  
     {  
      system.debug('pI =>'+pI);
       Map<Id,List<ProcessInstanceHistory>> mapOfProcessNodeIdAndProcessInstanceHistory = new Map<Id,List<ProcessInstanceHistory>>();  
       Set<Id> processNodeId= new Set<Id>();  
       for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems)  
       { 
        system.debug('swI =>'+sWI); 
         if(processNodeId.size() ==0){  
           processNodeId.add(sWI.ProcessNodeId);  
         }
         else if{(processNodeId.size()>0 && processNodeId.contains(sWI.ProcessNodeId)!= NULL)  
           processNodeId.add(sWI.ProcessNodeId);
         }
       }  
       system.debug('processNodeId =>'+processNodeId);
       for(Id pNId: processNodeId)  
       {  
         ApprovalStepWrapper aSWr = new ApprovalStepWrapper();  
         for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems)  
         {  
           if(sWI.processNodeId == pNID)  
           {  
               System.debug(sWI.Id);
               if(sWI.StepStatus == 'Approved')
               {
                    aSWr.listOfSteps.add(new ApprovalHistoryWrap(sWI.CreatedDate,sWI.CreatedDate, sWI.OriginalActor.Name, sWI.StepStatus,sWI.Actor.Name,sWI.Comments,sWI.Id,true,false,false,false)); 
                    System.debug('list of steps1 '+aSWr.listOfSteps);
               }
               if(sWI.StepStatus == 'Pending')
               {
                    aSWr.listOfSteps.add(new ApprovalHistoryWrap(sWI.CreatedDate,sWI.CreatedDate, sWI.OriginalActor.Name, sWI.StepStatus,sWI.Actor.Name,sWI.Comments,sWI.Id,false,true,false,false)); 
                    System.debug('list of steps2 '+aSWr.listOfSteps);
               }
               if(sWI.StepStatus == 'Rejected')
               {
                    aSWr.listOfSteps.add(new ApprovalHistoryWrap(sWI.CreatedDate,sWI.CreatedDate,sWI.OriginalActor.Name, sWI.StepStatus,sWI.Actor.Name,sWI.Comments,sWI.Id,false,false,true,false)); 
                    System.debug('list of steps3 '+aSWr.listOfSteps);
               }
               if(sWI.StepStatus == 'Started')
               {  
                    aSWr.listOfSteps.add(new ApprovalHistoryWrap(sWI.CreatedDate,sWI.CreatedDate,sWI.OriginalActor.Name, sWI.StepStatus,sWI.Actor.Name,sWI.Comments,sWI.Id,false,false,false,true)); 
                    System.debug('list of steps '+aSWr.listOfSteps);
                    // sWI.StepStatus = 'submitted';
               }
           }  
           if(sWI.StepStatus == 'Pending')  
           {  
             isSubmitForApproval = false;  
           }  
         }  
         aSW.add(aSWr);  
       }  
     }  
     approvalResultForObject.approvals = aSW;  
     approvalResultForObject.recordId = recordId;  
     approvalResultForObject.isSubmitForApproval = isSubmitForApproval;  
     system.debug('asw'+aSW);  
     return approvalResultForObject;  
   }  
   
   /**
    * @description : This method queries the processinstance and workitem for the record  
    * @param: Record ID   
    * @return: Map of all processinstance related to the record id  
    */  
   @AuraEnabled  
   public static Map<Id,ProcessInstance> getProcessHistory(Id objectId)  
   {  
     return new Map<Id,ProcessInstance>([SELECT Id, (SELECT ID, ProcessNodeId,  
                             StepStatus,Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending  
                             ,OriginalActorId,ProcessInstanceId,RemindersSent,CreatedDate,Actor.Name,  
                             OriginalActor.Name , ProcessNode.Name FROM StepsAndWorkitems order by CreatedDate DESC, StepStatus ASC )   
                       FROM ProcessInstance where TargetObjectId =:objectId order by CreatedDate DESC]);  
   }  
   /*  
    * Wrapper class  
    */  
   public class ApprovalStepWrapper{  
     @AuraEnabled  
     public List<ApprovalHistoryWrap> listOfSteps {get;set;}  
     public ApprovalStepWrapper(){  
       listOfSteps = new List<ApprovalHistoryWrap>();  
     }  
   }  
    /*  
     * Wrapper class  
    */  
   public class ApprovalHistoryWrap  
   { 
       @AuraEnabled  
     public Id recordIdA {get;set;}  
      
     @AuraEnabled  
     public String createdDate {get;set;}  
     @AuraEnabled  
     public String createdTime {get;set;} 
     @AuraEnabled  
     public string actorName {get;set;}  
     @AuraEnabled  
     public string steps {get;set;}  
     @AuraEnabled  
     public string assignedTo {get;set;}
     @AuraEnabled  
     public string comments {get;set;}

    @AuraEnabled  
     public Boolean status_approve {get;set;}
    @AuraEnabled  
     public Boolean status_pending {get;set;}
    @AuraEnabled  
     public Boolean status_reject {get;set;}
    @AuraEnabled  
     public Boolean status_start {get;set;}  



     public ApprovalHistoryWrap(DateTime crDate,DateTime crTime, string name, string stp, string actor,string comment,Id recordId,Boolean sts_approve,Boolean sts_pending,Boolean sts_reject,Boolean sts_start)  
     {  
       createdDate = crDate.date().format();
       System.debug('Created time '+crTime);
       createdTime = crTime.format('h:mm a');
       actorName = name;  
       steps = stp;  
       assignedTo = actor;
       comments = comment;
       recordIdA = recordId;
       
       status_approve = sts_approve;
       status_pending=sts_pending;
       status_reject = sts_reject;
       status_start = sts_start; 
     }  
   }  
   /*  
    * Wrapper class  
    */  
   public class ApprovalList  
   {   
     @AuraEnabled  
     public List<ApprovalStepWrapper> approvals {get;set;}  
     @AuraEnabled    
     public Boolean isSubmitForApproval {get;set;}  
     @AuraEnabled  
     public Id recordId {get;set;}  
     public ApprovalList(){  
       approvals = new List<ApprovalStepWrapper>();  
       isSubmitForApproval = true;  
     }  
   }
}