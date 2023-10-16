/**
 * @description       : This class provides methods to work with ProcessInstanceWorkitem records.
 * @author            : Saurabh Pandey
 * @group             : 
 * @last modified on  : 10-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class ProcessInstanceWorkitemSelector extends LibSObjectSelector {

    /**
     * @Description - Constructor for ProcessInstanceWorkitemSelector class.
     */
    public ProcessInstanceWorkitemSelector() {
        super(true, false, false, false);
    }

    /**
     * @Description - Gets the SObjectType for ProcessInstanceWorkitem records.
     * @return Schema.SObjectType : ProcessInstanceWorkitem object type.
     */
    public Schema.SObjectType getSObjectType() {
        return ProcessInstanceWorkitem.SObjectType;
    }

    /**
     * @Description - Gets a list of SObject fields for ProcessInstanceWorkitem records.
     * @return List<Schema.SObjectField> : List of SObject fields.
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ProcessInstanceWorkitem.Id,
            ProcessInstanceWorkitem.ProcessInstanceId
        };
    }

    /**
     * @Description - This method is for Approves a record.
     * @param recordId : String : Record ID to approve.
     * @return List<ProcessInstanceWorkitem> : List of ProcessInstanceWorkitem records.
     */
    public List<ProcessInstanceWorkitem> approve(String recordId) {
        return Database.query(
            newQueryFactory()
                .selectField('ProcessInstance.TargetObjectId')
                .setCondition('ProcessInstance.TargetObjectId = :recordId')
                .toSOQL()
        );
    }

    /**
     * @Description - This method is for Rejects a record.
     * @param recordId : String : Record ID to reject.
     * @return List<ProcessInstanceWorkitem> : List of ProcessInstanceWorkitem records.
     */
    public List<ProcessInstanceWorkitem> reject(String recordId) {
        return Database.query(
            newQueryFactory()
                .selectField('ProcessInstance.TargetObjectId')
                .setCondition('ProcessInstance.TargetObjectId = :recordId')
                .toSOQL()
        );
    }
}
