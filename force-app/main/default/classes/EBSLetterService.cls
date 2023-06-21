@RestResource(urlMapping='/ebsletters/*')

global class EBSLetterService {
    @HttpGet
    global static string doGet() {
        RestContext.response.addHeader('Access-Control-Allow-Origin', 'https://*.salesforce.com');
    
        string success='0';
    
        string action=RestContext.request.params.get('action');
        
        if(action=='deleteAttachmentData'){
            string id=RestContext.request.params.get('id');
            List<Attachment_Data__c > lstAttachmentData=[select id from Attachment_Data__c where id=:id];
            
            if(lstAttachmentData!=null){
                List<Attachment> lstAttachments=[select id from Attachment where parentid=:id];
                
                if(lstAttachments!=null){
                    delete lstAttachments;
                }else{
                    List<ContentDocumentLink> documentLinks = [SELECT Id, ContentDocumentID,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.title,ContentDocument.LatestPublishedVersion.createddate,ContentDocument.LatestPublishedVersion.FileType,ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId=:id];
                    system.debug('attS '+documentLinks[0].ContentDocumentID);
                    
                    list<string>  contentDocId = new list<string>();
                    
                    
                    for(ContentDocumentLink con:documentLinks){
                        system.debug('content version details:'+con.ContentDocument.LatestPublishedVersionId);
                        
                        contentDocId.add(con.ContentDocumentID);
                    }
              
                    if(contentDocId!= null && !contentDocId.isEmpty()){
                        //delete lstContentVersion;
                        try{Delete [Select Id from contentDocument where Id in: contentDocId];}catch(Exception e){System.debug('Exception Caught while deleting ContentDocument : '+e);}
                    }
                }
                
                delete lstAttachmentData;
                success='1';
            }
            
        }
    
        return success;
    
     /* try
      {
          
      }
      catch(Exception ex)
      {
         return Error('System Exception - ' + ex.getMessage());
      }*/      
    }
}