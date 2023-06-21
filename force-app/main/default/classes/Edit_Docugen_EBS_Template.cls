public class Edit_Docugen_EBS_Template {
    public string EBSFieldsJson {get; set;}
    public string EBSFieldNameLabelJson {get; set;}
    public string templateId {get; set;}
    //public Boolean hasAttachment {get; set;}
    
    public String docugenSettings{get; set;}
    
    private final DocuGen_EBS_Template__c EBSTemplate;
    
    
    @RemoteAction
    public static String removeAttachment(String attachmentID){
        system.debug('attachmentID : '+attachmentID);
        List<Attachment> attList = [select id from Attachment where Id=:attachmentID];
        System.debug('attList : '+attList);
        if(! attList.isEmpty()){
            delete attList;
        }
        else {
            
            List<ContentVersion> cvList = [select id,ContentDocumentId from ContentVersion where Id=:attachmentID];
            System.debug('CVList : '+CVList);
            List<ContentDocument> cd = new List<ContentDocument>();
            for(ContentVersion cv : cvList){
                cd.add(new ContentDocument(Id=cv.ContentDocumentId));
            }
            delete cd;
        }
        
        return '1'; 
    }
    
    public Edit_Docugen_EBS_Template(ApexPages.StandardController stdController){
        DocuGen_EBS_Template__c t=(DocuGen_EBS_Template__c)stdController.getRecord();
        
        if(t.Id==null){
            //this.EBSTemplate=new DocuGen_EBS_Template__c();
            this.templateId='';
            this.EBSTemplate=new DocuGen_EBS_Template__c();
        }
        else{
            this.EBSTemplate = t;
            this.templateId = this.EBSTemplate.Id;
        }
    }
    
    public PageReference onLoad(){
        list<string> EBSFieldNames=new list<string>();
        
        list<string> EBSFieldNameLabel=new list<string>();
        
        list<EBS_Letter_Fields__c> EBSFields=EBS_Letter_Fields__c.getall().values();
        
        for(EBS_Letter_Fields__c f: EBSFields){
            EBSFieldNames.add(f.Name);
            EBSFieldNameLabel.add(f.Name+','+f.Label__c.replaceAll(',',''));
        }
        
        EBSFieldsJson=JSON.serialize(EBSFieldNames);
        EBSFieldNameLabelJson=JSON.serialize(EBSFieldNameLabel);
        
        list<DocugenPlusSettings__c> settings=DocugenPlusSettings__c.getall().values();
        docugenSettings=settings[0].JsonSettings1__c;
               
                
        return null;
    }
     
    public static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body, LastModifiedBy.Name, CreatedBy.Name, LastModifiedDate, Name
                                        FROM Attachment 
                                        WHERE Id =: attId];


        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }
    
    
    @RemoteAction
    public static List<DocuGen_EBS_Template__c> GetTemplates(){
        List<DocuGen_EBS_Template__c> documentTemplates = [SELECT CreatedBy.Name,
                                                           Name,
                                                           LastModifiedBy.Name,
                                                           Owner.Name,
                                                           EBS_Template__c,
                                                           Field_Map__c,
                                                           Template__c
                                                    FROM DocuGen_EBS_Template__c];
        
        
        
        
        
        
        return documentTemplates;
    }
    
    @RemoteAction
    public static DocuGen_EBS_Template__c GetTemplateDetails(string templateID){
        DocuGen_EBS_Template__c documentTemplate = [SELECT CreatedBy.Name,
                                                           Name,
                                                           LastModifiedBy.Name,
                                                           Owner.Name,
                                                           EBS_Template__c,
                                                           Field_Map__c,
                                                           Template__c
                                                    FROM DocuGen_EBS_Template__c
                                                    where id=:templateID];
        
                
        
        
        
        
        return documentTemplate;
    }
    
    
   @RemoteAction
    public static String doUploadAttachment(String templateID, String attachmentBody, String attachmentName, String attachmentId) {
        if(templateID != null) {
            DocuGen_EBS_Template__c template = getTemplate(templateID);
            if(template != null) {
                if(attachmentBody != null) {
                    String newBody = '';
                    if(attachmentId != null){
                        list<Attachment> attachments = [SELECT Id, Body, LastModifiedBy.Name, CreatedBy.Name, LastModifiedDate, Name
                                        FROM Attachment 
                                        WHERE Id =: attachmentId];
                        if(attachments != null){
                            Attachment att = attachments[0];
                            newBody=EncodingUtil.base64Encode(attachments[0].Body);
                            newBody += attachmentBody;
                            att.body = EncodingUtil.base64Decode(newBody);
                            upsert att;
                            return JSON.serialize(att);
                        }else{
                            //List<ContentDocumentLink>  cdls= [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId =: attachmentId  ORDER BY LinkedEntityId DESC];
                            List<ContentVersion> cvs = [SELECT id,VersionData,Title, LastModifiedBy.Name, CreatedBy.Name, LastModifiedDate, PathOnClient,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId ORDER BY ContentDocumentId DESC];
                            ContentVersion cv = new ContentVersion();
                            newBody= EncodingUtil.base64Encode(cvs[0].VersionData);
                            newBody += attachmentBody;
                            cv.VersionData=EncodingUtil.base64Decode(newBody);
                            upsert cv;
                            FileWrapper file = new FileWrapper();
                            file.Name=cv.Title;
                            return JSON.serialize(file);
                        }
                    }
                    else{
                        ContentVersion cv = new ContentVersion();
                        cv.PathOnClient =attachmentName;
                        cv.Title = attachmentName;
                        cv.versiondata=EncodingUtil.base64Decode(attachmentBody);
                        cv.FirstPublishLocationId = template.id;
                        insert cv;
                        
                        /*ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
                        cdl.LinkedEntityId =template.id;
                        insert cdl;*/
                        
                        FileWrapper file = new FileWrapper();
                        file.Name=cv.Title;
                        return JSON.serialize(file);
                    }
                } else {
                    return 'Attachment Body was null';
                }
            } else {
                return 'Template could not be found';
            }
        } else {
            return 'Template Id was null';
        }
    }
    
    @RemoteAction
    public static String getAttachments(String templateID) {
        
        if(templateID != null || templateID != ''){
            List<String> contentIds = new List<String>();
            FileWrapper file;
            List<FileWrapper> files=new List<FileWrapper>();
            List<ContentDocumentLink>  cdls= [SELECT Id, LinkedEntityId, ContentDocumentId ,ContentDocument.LatestPublishedVersionId 
                                              FROM ContentDocumentLink 
                                              WHERE LinkedEntityId =: templateID ORDER BY LinkedEntityId DESC];
            System.debug('CDLS : '+cdls);
            if(!cdls.isEmpty()){
                
                 for(ContentDocumentLink cdl : cdls){
                    contentIds.add(cdl.ContentDocument.LatestPublishedVersionId );
                }
                List<ContentVersion> cvList = [SELECT Id,Title, VersionData,ContentDocumentId, LastModifiedBy.Name, CreatedBy.Name, LastModifiedDate, PathOnClient
                                          FROM ContentVersion 
                                          WHERE Id IN : contentIds
                                          ORDER BY LastModifiedDate desc];
                System.debug('CVLIST : '+cvList);
            
                for(ContentVersion cv : cvList){
                    file=new FileWrapper();
                    file.Id=cv.Id;
                    file.Body = EncodingUtil.base64Encode(cv.VersionData);
                    file.LastModifiedBy = cv.LastModifiedBy.Name;
                    file.CreatedBy = cv.CreatedBy.Name;
                    file.LastModifiedDate= cv.LastModifiedDate;
                    file.Name = cv.Title; 
                    file.File = true;
                    files.add(file);
                }
                return JSON.serialize(files);
                
            }else{
                list<Attachment> attachments = [SELECT Id, Body, LastModifiedBy.Name, CreatedBy.Name, LastModifiedDate, Name
                                        FROM Attachment 
                                        WHERE parentId =: templateID
                                        ORDER BY LastModifiedDate desc];
                
                for(Attachment att : attachments){
                    file=new FileWrapper();
                    file.Id=att.Id;
                    file.Body = EncodingUtil.base64Encode(att.Body);
                    file.LastModifiedBy = att.LastModifiedBy.Name;
                    file.CreatedBy = att.CreatedBy.Name;
                    file.LastModifiedDate= att.LastModifiedDate;
                    file.Name = att.Name; 
                    file.File = false;
                    files.add(file);
                }
                system.debug('Attachments : '+attachments);
                return JSON.serialize(files);
            }
            
        }else{
            return 'Template Id Does Not Exist';
        }

    }
    
    
    @RemoteAction
    public static String getWordFields(String attactmentID){
       string wordFields='["Letter","AddressLine1","AddressLine2","AddressLine3","AddressLine4","AddressLine5","PostCode","CustomerName","AccountNo","BeneficiaryDetails","SOAmount","SOFrequency","Letter"]';
       
        return wordFields;
    }
    
    @RemoteAction
    public static String getEBSFields(){
        return '';
    }
     
    private static DocuGen_EBS_Template__c getTemplate(String templateID) {
        list<DocuGen_EBS_Template__c> templates = [SELECT CreatedBy.Name,
                                                           Name,
                                                           LastModifiedBy.Name,
                                                           Owner.Name,
                                                           EBS_Template__c,
                                                           Field_Map__c,
                                                           Template__c
                                                    FROM DocuGen_EBS_Template__c
                                                    where id=:templateID];
        if(templates.isEmpty()) {
            return null;
        } else {
            return templates[0];
        }
    }

    @RemoteAction
    public static string CreateDuplicate(String templateID){
        
        DocuGen_EBS_Template__c t=getTemplate(templateID);
        
        t.EBS_Template__c=t.EBS_Template__c+'_Duplicate';
        
        t.id=null;
        
        insert t;
        
        return t.id;
    }
        
    @RemoteAction
    public static string save(DocuGen_EBS_Template__c documentTemplate){
        
        update documentTemplate;
        
        return documentTemplate.Field_Map__c;
    }
    
    public class FileWrapper{
        String Id;
        String Body;
        String LastModifiedBy;
        String CreatedBy;
        datetime LastModifiedDate;
        String Name;
        boolean File;
    }
    
    
    
}