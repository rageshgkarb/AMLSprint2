trigger fcuJobsTrigger on FCUJob__c (after insert, after update) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        
        FCUJobHandler.jobFieldUpdate(Trigger.NewMap, Trigger.OldMap,'update');    
    }
    if(Trigger.isAfter && Trigger.isInsert){
        
       FCUJobHandler.jobFieldUpdate(Trigger.NewMap, Trigger.OldMap,'insert');    
    }
}