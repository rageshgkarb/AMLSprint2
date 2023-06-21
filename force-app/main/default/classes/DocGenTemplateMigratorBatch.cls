global class DocGenTemplateMigratorBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    global String query;
    global List<ContentVersion> lsExistingCV = new List<ContentVersion>();
    global Set<Id> setExistingAttIds=new Set<Id>();
        
    // The batch job starts
    global Database.Querylocator start(Database.BatchableContext bc){
        
       
        System.debug('>>>> start ' + query);
        lsExistingCV = [SELECT id,oldAttachmentId__c 
                        FROM contentversion 
                        WHERE oldAttachmentId__c !=null
                        	AND FirstPublishlocation.type='DocuGen_Template__c'];
        
        
        if(lsExistingCV.size()>0){
            for(ContentVersion cv : lsExistingCV){
                if(!setExistingAttIds.contains(cv.oldAttachmentId__c)){
                    setExistingAttIds.add(cv.oldAttachmentId__c);
                }
            }
        }
        system.debug('Existing Attachment Ids Size====>>' + setExistingAttIds.size());
        String query = 'SELECT Id,Name,Body,ParentId,Parent.Type,createdDate,LastModifiedDate,OwnerId FROM Attachment WHERE Parent.type=\'DocuGen_Template__c\' ORDER By LastModifiedDate';
        return Database.getQuerylocator(query);
    } 
    
    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<Attachment> scope){
        System.debug('>>>> execute ' + scope.size());
        
        List<ContentVersion> lsCV = new List<ContentVersion>() ;
        ContentVersion tmpCV;
        system.debug('Existing Set Size is' + setExistingAttIds.size());
        for(Attachment a : scope){
            if(!setExistingAttIds.contains(a.id)){
                tmpCV=cloneCVfromAttachment(a);
                System.debug('The returned tmpCV is ====>' + tmpCV);
                if(tmpCV!=null){
                    lsCV.add(tmpCV);
                    setExistingAttIds.add(a.id);
                }
            }
        }
        system.debug(lsCV.size());
        Set<Id> setClonedCVIds = new Set<Id>();
        Tmp_Opp_Migration_Err_Log__c t;
        if(lsCV.size()>0){ 
            Database.SaveResult[] saveResultList=Database.insert(lsCV,false);
            for(Database.SaveResult sr :saveResultList ){
                if(!sr.isSuccess()){
                    for(Database.Error err : sr.getErrors()) {
                         t=new Tmp_Opp_Migration_Err_Log__c();
                            t.Fields__c = String.join(err.getFields(),'\n');
                            t.Error_Message__c = err.getMessage();
                            t.Object_Type__c = 'Attachments';
                            t.recordId__c = sr.getId();
                            insert t;
                    }
                }else{
                    setClonedCVIds.add(sr.getId());
                }
            }
        }
        
        //Deletion of attachments
        List<ContentVersion> lsClonedCVs = [Select id,oldAttachmentId__c from contentversion where ID in : setClonedCVIds];
        Set<Id> setClonedAttIds = new Set<Id>();
        for(ContentVersion cv: lsClonedCVs){
            setClonedAttIds.add(cv.oldAttachmentId__c);
        }
        
        List<Attachment> lsDelAtts = [Select id from Attachment where ID IN : setClonedAttIds];
        if(lsDelAtts.size()>0){
            
            Database.deleteResult[] deleteResultList=Database.delete(lsDelAtts,false);
                for(Database.deleteResult dr :deleteResultList ){
                    if(!dr.isSuccess()){
                        for(Database.Error err : dr.getErrors()) {
                            t=new Tmp_Opp_Migration_Err_Log__c();
                            t.Fields__c = String.join(err.getFields(),'\n');
                            t.Error_Message__c = err.getMessage();
                            t.Object_Type__c = 'Attachments';
                            t.recordId__c = dr.getId();
                            insert t;
                        }
                    }
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
        cVersion.CreatedDate=a.CreatedDate;
        cVersion.LastModifiedDate=a.LastModifiedDate;
        return cVersion;
    }
    
}