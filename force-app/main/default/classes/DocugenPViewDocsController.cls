public class DocugenPViewDocsController {
    public string templates {get; set;}

    public PageReference onLoad(){
        templates=JSON.serialize(GetTemplateList());
        system.debug(templates);
        return null;
    }
    
    @RemoteAction
    public static List<Doc> GetDocs(List<ID> templateIDs,Date FromDate,Date ToDate){
        List<Docugen_Job__c> jobs=new List<Docugen_Job__c>();
        
        Map<ID, Docugen_Job__c> jobMap = new Map<ID, Docugen_Job__c>();
        
         List<Doc> lstDocs=new List<Doc>();
        
        jobs=[select id,Name,status__c,CreatedDate from Docugen_Job__c where Docugen_EBS_Template__r.Id in :templateIDs and CreatedDate >=:FromDate and CreatedDate<=:ToDate];
        
       List<ID> jobIDs=new List<ID>();
       
        
       for (Docugen_Job__c j : jobs){
           jobIDs.add(j.Id);
           jobMap.put(j.Id,j);
       }
        System.debug(jobIDs);
        if(!jobIDs.isEmpty())  {
        List<Attachment> lstAttachments=[SELECT id,Name,parentId FROM Attachment WHERE parentid in :jobIDs order by parentid desc];
       
    
       
       for(Attachment a:lstAttachments){
           Doc d=new Doc();
           d.JobName=jobMap.get(a.parentid).Name;
           d.JobId=a.parentid;
           d.AttachmentName=a.Name;
           d.AttachmentId=a.Id;
           d.JobStatus=jobMap.get(a.parentid).Status__c;
           d.JobDate=string.valueOf(jobMap.get(a.parentid).CreatedDate);
           d.isFiles =false;
           lstDocs.add(d);
       }
       
       system.debug(lstDocs); 
           
        
	   List<ContentDocumentLink>  cdls= [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: jobIDs ORDER BY LinkedEntityId DESC];
	   
	   
	   if(!cdls.isEmpty()){
	   			Map<Id,Id> cdlToLink = new Map<Id,Id>();
			for(ContentDocumentLink lnk : cdls){
				cdlToLink.put(lnk.ContentDocumentId,lnk.LinkedEntityId);
			}
			for(ContentVersion cv : [SELECT Id,Title,ContentDocumentId From ContentVersion WHERE ContentDocumentId IN: cdlToLink.keySet() AND isLatest = true]){
			   Doc d=new Doc();
			   d.JobName=jobMap.get(cdlToLink.get(cv.ContentDocumentId)).Name;
			   d.JobId=cdlToLink.get(cv.ContentDocumentId);
			   d.AttachmentName=cv.Title;
			   d.AttachmentId=cv.Id;
			   d.JobStatus=jobMap.get(cdlToLink.get(cv.ContentDocumentId)).Status__c;
			   d.JobDate=string.valueOf(jobMap.get(cdlToLink.get(cv.ContentDocumentId)).CreatedDate);
           		d.isFiles =true;
				lstDocs.add(d);
			
			}
		
			
		
		}
        }
        return lstDocs;
    }
    
    public List<Docugen_EBS_Template__c> GetTemplateList(){
        List<Docugen_EBS_Template__c> t=new List<Docugen_EBS_Template__c>();
        
        
        t=[select id,EBS_Template__c from Docugen_EBS_Template__c];
        
        
        
        return t;
    }
    
    
    public class Doc
    {
        public String JobId {get;set;}
        public String AttachmentName {get; set;}
        public String AttachmentId{get;set;}
        public String JobDate {get;set;}
        public String TemplateName {get;set;}
        public String JobName{get; set;}
        public String JobStatus{get;set;}
        public boolean isFiles{get;set;}
    }
    
}