global class DelIBBQuotationAttachmentBatch implements Database.Batchable<sObject>{
    
    // The batch job starts
    global Database.Querylocator start(Database.BatchableContext bc){
        String query = 'SELECT id,oldAttachmentId__c FROM contentversion WHERE oldAttachmentId__c !=null AND FirstPublishlocation.type=\'IBBQuotation__c\'';
        return Database.getQuerylocator(query);
    } 
    
    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<ContentVersion> scope){
        
        System.debug('>>>> execute ' + scope.size() + '>>>>' + scope);
        Set<Id> setAttIds = new Set<Id>();
        
        for(Contentversion cv : scope){
            if(cv.oldAttachmentId__c!=null && !setAttIds.contains(cv.oldAttachmentId__c)){
                setAttIds.add(cv.oldAttachmentId__c);
            }
            
        }
        System.debug(setAttIds);
        List<Attachment> lsDelAttachments = [select id from attachment where ID IN: setAttIds];
        system.debug(lsDelAttachments.size());
        if(lsDelAttachments.size()>0){ 
            Database.deleteResult[] deleteResultList=Database.delete(lsDelAttachments,false);
            
            List<Tmp_Opp_Migration_Err_Log__c> lsTOME = new List<Tmp_Opp_Migration_Err_Log__c>();
            Tmp_Opp_Migration_Err_Log__c t;
            for(Database.deleteResult dr :deleteResultList ){
                if(!dr.isSuccess()){
                    for(Database.Error err : dr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        t=new Tmp_Opp_Migration_Err_Log__c();
                        t.Fields__c = String.join(err.getFields(),'\n');
                        t.Error_Message__c = 'Deletion of IBB Attachments ' + err.getMessage();
                        t.Object_Type__c = 'Attachments';
                        t.recordId__c = dr.getId();
                        lsTOME.add(t);
                    }
                }
            }
            if(lsTOME.size()>0){
                insert lsTOME;
            }
        }
                
    }
    
    // The batch job finishes
    global void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
        System.debug('>>>> finish ' + job.Status);
    }
    
}