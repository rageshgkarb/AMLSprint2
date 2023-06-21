/* Class Name : LX_RelatedFilesController
Description : Controller class to get/create/Update Enhanced notes on opportunity one view 
Modifications:Newly created class
DevName UserStory  Description
Amey    SLM-047    Opportunity oneview enable in lightning */

public class LX_RelatedFilesController {
    @AuraEnabled
    public static List<ContentNote> getRelatedDocs(Id recordId){
        Set<Id> newRecSet = new Set<Id>();
        newRecSet.add(recordId);
        List<ContentNote> cdList = new List<ContentNote>();
        List<ContentDocumentLink> cdlList;
        if(newRecSet.size() > 0){
            cdlList = [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: newRecSet];
        }
        Set<Id> cdIds = new Set<Id>();
        for (ContentDocumentLink cdl : cdlList) {
            cdIds.add(cdl.ContentDocumentId); 
        }        
        cdList = [SELECT Id, Title, FileType, OwnerId, Owner.Name, CreatedDate,
                  CreatedById, CreatedBy.Name, ContentSize,TextPreview,LastModifiedDate
                  FROM ContentNote WHERE Id IN :cdIds order by CreatedDate asc];
        return cdList;
    }
    
    @AuraEnabled
    public static noteWrap getContentNote(Id recordId){
        noteWrap nw = new noteWrap();
        nw.cNote=[SELECT Id, Title, FileType, OwnerId, Owner.Name, CreatedDate,LastModifiedDate,
                  CreatedById, CreatedBy.Name,LastModifiedBy.Name, ContentSize,TextPreview,Content
                  FROM ContentNote WHERE Id=:recordId];
        blob blobvar=nw.cNote.Content;
        if(nw.cNote.Content!=null){
            string data= blobvar.toString();
            //encodingUtil.base64encode(blobvar);
            nw.content=  blobvar.toString();
        }
        System.debug('nw.content##'+nw.content);
        return nw;
    } 
    
    @AuraEnabled
    public static void deleteDoc(Id docId){
        ContentDocument conDoc = new ContentDocument(Id = docId);
        delete conDoc;
    }
    
    @AuraEnabled
    public static void createRecord (ContentNote nt, id PrentId){
        try{
            if(nt != null){
                insert nt;
                ContentDocument cd=[select id from ContentDocument where id=:nt.Id];
                ContentDocumentLink cdl=new ContentDocumentLink();
                cdl.ContentDocumentId= nt.Id;//cd.id;
                cdl.LinkedEntityId=PrentId;
                cdl.ShareType='V';
                cdl.Visibility='AllUsers';
                insert cdl;
            }
        } catch (Exception ex){
            
        }
    }  
    
    @AuraEnabled
    public static void updateNotes(String noteId, String noteTitle, String noteContent){
        ContentNote cn = new ContentNote();
        cn.Id=noteId;
        cn.Title=noteTitle;
        cn.Content=Blob.valueOf(noteContent);
        try{
            update cn;
        } catch (Exception ex){
            
        }
    }  
    
    @AuraEnabled
    public static List<ContentDocument> getRelatedContentDocs(Id recordId){
        List<ContentDocument> cdList = new List<ContentDocument>();
        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink
                                             WHERE LinkedEntityId = :recordId];
        Set<Id> cdIds = new Set<Id>();
        for (ContentDocumentLink cdl : cdlList) {
            cdIds.add(cdl.ContentDocumentId); 
        }        
        cdList = [SELECT Id, Title, FileType, OwnerId, Owner.Name, CreatedDate,
                  CreatedById, CreatedBy.Name, ContentSize,LastModifiedDate
                  FROM ContentDocument WHERE Id IN :cdIds AND FileType!='SNOTE'];
        System.debug('cdList'+cdList);
        return cdList;
    }
    
    
    @AuraEnabled
    public static Id SaveFile(Id parentId, String fileName, String base64Data, String contentType) {
        
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = fileName; 
        conVer.Title = fileName; 
        conVer.VersionData = EncodingUtil.base64Decode(base64Data); 
        insert conVer;    
        
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = parentId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        return conDocLink.id;
    }
    
    @AuraEnabled
    public static string getDocURL(Id docId){
        ContentVersion cv = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :docId AND IsLatest = true];
        String cvDownloadURL = URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + cv.Id;
        System.debug('cvDownloadURL##'+cvDownloadURL);
        return cvDownloadURL;
    }
    
    
    public class noteWrap{
        @AuraEnabled
        public ContentNote cNote;
        @AuraEnabled
        public string content;
    }
   
}