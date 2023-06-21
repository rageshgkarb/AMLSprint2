public class DocugenP_Job_Controller {
    public string job {get; set;}
    public string adocs { get; set;}

    public string filesDocs { get; set;}
    public string docs {get;set;}
    public string filedocstr {get;set;}
    
    public string jobId {get; set;}
    
    public string combinedDoc {get; set;}
    
    public String docugenSettings{get; set;}
    
    public PageReference onLoad(){
        list<DocugenPlusSettings__c> settings=DocugenPlusSettings__c.getall().values();
        docugenSettings=settings[0].JsonSettings1__c;
        List<ContentVersion> conVersion = new List<ContentVersion>();
        jobId=ApexPages.currentPage().getParameters().get('id');
        system.debug('jobId : '+jobId);
        List<Docugen_Job__c> jobs=[SELECT id,Name,LastModifiedDate,Records__c,Status__c FROM Docugen_Job__c where id=:jobId];
        
        List<Attachment_Data__c> lstAttachmentData=[SELECT id,Account__r.Name,Account__r.AccountNumber,Account__r.Id,Account__r.EBS_ID__c, Docugen_Job__r.Id FROM Attachment_Data__c where Docugen_Job__c=:jobId order by id];
        
        List<Attachment> lstDocs=[SELECT id,Name,ParentId FROM Attachment WHERE parentid in (SELECT id from Attachment_Data__c where Docugen_Job__c=:jobId) order by parentid ];             
                
        
        List<Attachment> lstAttachments=[SELECT id,Name FROM Attachment where parentid=:jobId];


        if(!Test.isRunningTest()){
            List<ContentDocumentLink> conDocumentLink = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: jobId];
            set<Id> conDocumentId = new set<Id>();
            for(ContentDocumentLink con :conDocumentLink){
                conDocumentId.add(con.ContentDocumentId);
            }
            conVersion = [SELECT Id,Title,ContentDocumentId, FileType From ContentVersion WHERE ContentDocumentId IN: conDocumentId order by createddate DESC];
        }
        
        System.debug ('lstDocs' + lstDocs.size());
        Map < Id, Attachment_Data__c > attachDataMap = new Map < Id, Attachment_Data__c > ();
        for ( Attachment_Data__c attachData : lstAttachmentData) {
            attachDataMap.put ( attachData.Id, attachData);
            
        }       
        Set < Id > contentDocIdSet = new Set < Id > ();
        contentDocIdSet = attachDataMap.keySet();
        List<ContentDocumentLink>  cdls= [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: contentDocIdSet ORDER BY LinkedEntityId DESC];


        
        Docugen_Job__c objJob;
        
        if(jobs.isEmpty()){
            objJob=new Docugen_Job__c();
        }
        else{
            objJob=jobs[0];
        }
        
        
        
        job=JSON.serialize(objJob);
        adocs='[]';
        List < AttachmentFile > attachments = new List < AttachmentFile > ();
        if(!lstAttachmentData.isEmpty()){
            if(!cdls.isEmpty()){
                
                Map<Id,Id> cdlToLink = new Map<Id,Id>();
                for(ContentDocumentLink lnk : cdls){
                    cdlToLink.put(lnk.ContentDocumentId,lnk.LinkedEntityId);
                }
                for(ContentVersion cv : [SELECT Id,Title,ContentDocumentId, FileType From ContentVersion WHERE ContentDocumentId IN: cdlToLink.keySet()]){
                    AttachmentFile attachWrapper =new AttachmentFile();
                   attachWrapper.attachmentName=cv.Title;//attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Name;
                   attachWrapper.contentVersionId = cv.Id;
                   attachWrapper.AccountName = attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Account__r.Name;
                   attachWrapper.AccountId = attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Account__r.Id;
                   attachWrapper.AccountEBSID = attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Account__r.EBS_ID__c;

                   attachWrapper.DocugenJobId = attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Docugen_Job__r.Id;
                   attachments.add(attachWrapper);
                
                }
                filesDocs = JSON.serialize(attachments);
                
            } 
            List<Attachment_Data__c> lstAttachmentDataUpdate = new List<Attachment_Data__c> ();
      if(!lstAttachmentData.isEmpty()){
                for ( Attachment attachmentRecord : lstDocs) {
                    if ( (''+attachmentRecord.Id).left(3).equalsIgnoreCase('00P') ) {
                        if ( attachDataMap.containsKey ( attachmentRecord.ParentId)) {
                            lstAttachmentDataUpdate.add ( attachDataMap.get ( attachmentRecord.ParentId));
                        }
                    }
                }
            }
              adocs=JSON.serialize(lstAttachmentDataUpdate);
            
        }

        System.debug ('filesDocs' + filesDocs);
        System.debug ('adocs' + adocs);
        
        docs='[]';
        filedocstr = '[]';
        if(!lstDocs.isEmpty()){
            docs=JSON.serialize(lstDocs);
            filedocstr = JSON.serialize(attachments);
            filesDocs = JSON.serialize(attachments);
        }
        
        if(conVersion.isEmpty()){
            if(lstAttachments.isEmpty()){
                combinedDoc=JSON.serialize(new ContentVersion());
            }
            else{
                combinedDoc=JSON.serialize(lstAttachments[0]);
            }
        }
        else{
            combinedDoc=JSON.serialize(conVersion[0]);
        }
        
        /*if(lstAttachments.isEmpty()){
            combinedDoc=JSON.serialize(new Attachment());
        }
        else{
            combinedDoc=JSON.serialize(lstAttachments[0]);
        }*/
        
        system.debug('combinedDoc : '+combinedDoc);
        
        
        return null;        
    }

    public class AttachmentFile {
        public String AccountName {get;set;}
        public String attachmentName {get;set;}
        public String AccountId{get;set;}
        public String AccountEBSID{get;set;}
        public String DocugenJobId{get;set;}
        public String contentVersionId {get;set;}
    }
    
}