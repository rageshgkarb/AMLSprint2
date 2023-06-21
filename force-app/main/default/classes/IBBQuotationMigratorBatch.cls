global class IBBQuotationMigratorBatch implements Database.Batchable<sObject>{
    
           
    // The batch job starts
    global Database.Querylocator start(Database.BatchableContext bc){
        String query = 'SELECT Id,Name,Body,ParentId,Parent.Type,LastModifiedDate,OwnerId FROM Attachment WHERE Parent.type=\'IBBQuotation__c\' ORDER By LastModifiedDate';
        return Database.getQuerylocator(query);
    } 
    
    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<Attachment> scope){
        System.debug('>>>> execute ' + scope.size() + '>>>>' + scope);
        
        Set<Id> setAttIds = new Set<Id>();
        
        for(Attachment a : scope){
            if(!setAttIds.contains(a.id)){
                setAttids.add(a.id);
            }
        }
        
        List<ContentVersion> lsClonedCV = [SELECT id,oldAttachmentId__c FROM contentversion Where oldAttachmentId__c IN: setAttids];
        
        Set<ID> clonedAttachIds = new set<Id>();
        
        for(ContentVersion cv : lsClonedCV)
        	clonedAttachIds.add(cv.oldAttachmentId__c);
            
        
        List<ContentVersion> lsCV = new List<ContentVersion>() ;
        ContentVersion tmpCV;
       
        for(Attachment a : scope){
            if(!clonedAttachIds.contains(a.id)){
                tmpCV=cloneCVfromAttachment(a);
                System.debug('The returned tmpCV is ====>' + tmpCV);
                if(tmpCV!=null){
                    lsCV.add(tmpCV);
                    clonedAttachIds.add(a.id);
                }
            }
        }
        system.debug(lsCV.size());
        if(lsCV.size()>0){ 
            Database.SaveResult[] saveResultList=Database.insert(lsCV,false);
            
            List<Tmp_Opp_Migration_Err_Log__c> lsTOME = new List<Tmp_Opp_Migration_Err_Log__c>();
            Tmp_Opp_Migration_Err_Log__c t;
            for(Database.SaveResult sr :saveResultList ){
                if(!sr.isSuccess()){
                    for(Database.Error err : sr.getErrors()) {
                        t=new Tmp_Opp_Migration_Err_Log__c();
                        t.Fields__c = String.join(err.getFields(),'\n');
                        t.Error_Message__c = 'Content Version Creation for IBB ' + err.getMessage();
                        t.Object_Type__c = 'Content Version';
                        t.recordId__c = sr.getId();
                        lsTOME.add(t);
                    }
                }
            }
            
            system.debug('Size of error list ' + lsTOME.size());
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
    
    public static ContentVersion cloneCVfromAttachment(Attachment a){
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = a.Name;//File name with extention
        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        cVersion.OwnerId = a.OwnerId;//Owner of the file
        cVersion.Title = a.Name;//Name of the file
        cVersion.VersionData = a.Body;//File content
        cVersion.oldAttachmentId__c = a.Id;
        cVersion.FirstPublishLocationId= a.ParentId;
        System.debug(cVersion);
        return cVersion;
    }
    
}