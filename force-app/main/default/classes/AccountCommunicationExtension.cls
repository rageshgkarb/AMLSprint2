public class AccountCommunicationExtension {
    public Account Acc{get;set;}
    private ApexPages.StandardController stdCtrl;
    
    public List<Attachment_Data__c> lstAttachmentData{get;set;}
    
    public string adocs{get;set;}
    
    public String docugenSettings{get; set;}
    public Boolean isAttachment {get;set;}

    public AccountCommunicationExtension(ApexPages.StandardController stdController) {
        
        this.Acc= (Account)stdController.getRecord();
        
        this.adocs='';
                
        // Acc = DataHelperTemp.GetAccount(Acc.Id)[0];
        stdCtrl = stdController;      
        
        list<DocugenPlusSettings__c> settings=DocugenPlusSettings__c.getall().values();
        docugenSettings=settings[0].JsonSettings1__c;
        
        
    }
    
    /*@RemoteAction
    public static string GenerateSingleDocument(string AccountId,string JobId){
        Docugen_Job__c job=[SELECT Name, Data_1__c, Data_2__c, Data_3__c, Data_4__c, Data_5__c FROM Docugen_Job__c WHERE Id=:JobId];
        

        String jsonData = IBB_Helper.RebuildString(job, 'Data_', 5).replace('&amp;','&');
        
        
        
        return jsonData;
    }*/
    
    
    
    public PageReference onLoad(){
        adocs='';
        lstAttachmentData=[SELECT id,Name,Account__r.Name,Account__r.AccountNumber,Docugen_Job__r.Id,Account__r.Id,Account__r.EBS_ID__c,(SELECT Id,Name FROM Attachments),LastModifiedDate FROM Attachment_Data__c where Account__r.Id=:Acc.Id order by LastModifiedDate desc];
        Map < Id, Attachment_Data__c > attachDataMap = new Map < Id, Attachment_Data__c > ();
        
        for ( Attachment_Data__c attachData : lstAttachmentData) {
            attachDataMap.put ( attachData.Id, attachData);
            
        }       
        Set < Id > contentDocIdSet = new Set < Id > ();
        contentDocIdSet = attachDataMap.keySet();
        List<ContentDocumentLink>  cdls = new List < ContentDocumentLink > ();
        if( contentDocIdSet.size () > 0 ) {
       		cdls= [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: contentDocIdSet];
  
        }
        
        if(!cdls.isEmpty()){
            isAttachment = false;
            List < AttachmentFile > attachments = new List < AttachmentFile > ();
            Map<Id,Id> cdlToLink = new Map<Id,Id>();
            for(ContentDocumentLink lnk : cdls){
                cdlToLink.put(lnk.ContentDocumentId,lnk.LinkedEntityId);
            }
            for(ContentVersion cv : [SELECT Id,Title,ContentDocumentId From ContentVersion WHERE ContentDocumentId IN: cdlToLink.keySet()]){
                AttachmentFile attachWrapper =new AttachmentFile();
               attachWrapper.attachmentName=cv.Title;//attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Name;
               attachWrapper.attachmentId=cdlToLink.get(cv.ContentDocumentId);
               attachWrapper.LastModifiedDate =string.valueOf(attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).LastModifiedDate);
               attachWrapper.contentVersionId = cv.Id;
               attachWrapper.AccountId = attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Account__r.Id;
               attachWrapper.DocugenJobId = attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Docugen_Job__r.Id;
               attachments.add(attachWrapper);
            
            }
            
            adocs=JSON.serialize(attachments);
            
        } else {
            isAttachment = true;
            adocs=JSON.serialize(lstAttachmentData);
        }

        System.debug( 'adocs' + adocs);

        
        return null;
    }

    public class AttachmentFile {
        public String attachmentName {get;set;}
        public String attachmentId {get;set;}
        public String contentVersionId {get;set;}
        public String LastModifiedDate{get;set;}
        public String attachmentDataId {get;set;}
        public String AccountId;
        public String DocugenJobId;

    }
}