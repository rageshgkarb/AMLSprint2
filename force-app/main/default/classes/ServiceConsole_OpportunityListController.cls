public with sharing class ServiceConsole_OpportunityListController {
	
	public String parentObjId {get;set;}
	public Integer oppRowLimit {get;set;}
	public Integer attachmentRowLimit {get;set;}
	public FINAL Integer rowIncrementor = 5;
    public Map < Id, Opportunity > oppDataMap = new Map < Id, Opportunity > ();
    public Boolean isAttachment {get;set;}
    Public Set < Id > contentDocIdSet = new Set < Id > ();


    
    public Integer totalOpps{
        get{
            if(totalOpps == null){
                totalOpps = [SELECT COUNT() FROM Opportunity WHERE AccountId =: parentObjId];
            }
            return totalOpps;
        }set;
    }

    public Integer totalOppAttachments{
        get{
            if(totalOppAttachments == null && isAttachment == true){
                totalOppAttachments = [SELECT COUNT() FROM Attachment WHERE ParentId IN : getRecentOpps()];
            }else if(totalOppAttachments == null && isAttachment == false){
                        totalOppAttachments = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId IN: contentDocIdSet];
            }
            return totalOppAttachments;
        }set;
    }

    //Constructor
	public ServiceConsole_OpportunityListController() {
		parentObjId = ApexPages.currentPage().getParameters().get('id');
        oppRowLimit = rowIncrementor;
        attachmentRowLimit = rowIncrementor;
        showMoreOppsValue = 0;
        showMoreAttachmentsValue = 0;
    }

    public list<Opportunity> getRecentOpps(){
        list<Opportunity> opps = [SELECT Id, Name, StageName, Amount, Finance_Required__c, Initial_Payment_Amount__c, RecordTypeId, RecordType.DeveloperName FROM Opportunity WHERE AccountId =: parentObjId ORDER BY CreatedDate DESC LIMIT : oppRowLimit];
        
        for ( Opportunity odata : opps) {
            oppDataMap.put ( odata.Id, odata);
        }
        return opps;
    }
    
    
    public list<Attachment> getRecentAttachments(){
    	list<Attachment> attachments = [SELECT Id, Name, Parent.Name FROM Attachment WHERE ParentId IN : getRecentOpps() ORDER BY CreatedDate DESC LIMIT : attachmentRowLimit];
        if(!attachments.isEmpty()){
           isAttachment = true;     
        } 
    	return attachments;
    }

    public list<AttachmentFile> getContentVersionRecs(){
         contentDocIdSet = oppDataMap.keySet();
         List < AttachmentFile > attachments = new List < AttachmentFile > ();
        List<ContentDocumentLink>  cdls= [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: contentDocIdSet ORDER BY LinkedEntityId DESC LIMIT : attachmentRowLimit];
       
           if(!cdls.isEmpty()){
            isAttachment = false;
            Map<Id,Id> cdlToLink = new Map<Id,Id>();
            for(ContentDocumentLink lnk : cdls){
                cdlToLink.put(lnk.ContentDocumentId,lnk.LinkedEntityId);
            }
            for(ContentVersion cv : [SELECT Id,Title,ContentDocumentId From ContentVersion WHERE ContentDocumentId IN: cdlToLink.keySet()]){
                AttachmentFile attachWrapper =new AttachmentFile();
               attachWrapper.attachmentName=cv.Title;//attachDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Name;
               attachWrapper.attachmentId=cdlToLink.get(cv.ContentDocumentId);
              // attachWrapper.LastModifiedDate =string.valueOf(oppDataMap.get(cdlToLink.get(cv.ContentDocumentId)).LastModifiedDate);
               attachWrapper.contentVersionId = cv.Id;
               attachWrapper.OppName = oppDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Name;
               attachWrapper.OppId = oppDataMap.get(cdlToLink.get(cv.ContentDocumentId)).Id;
               attachments.add(attachWrapper);
            
            }
            system.debug('attachments-if'+attachments);            
        } 
           return attachments;
    }
    
      public class AttachmentFile {
          public String attachmentName {get;set;}
          public String attachmentId {get;set;}
          public String contentVersionId {get;set;}
          public String LastModifiedDate{get;set;}
          public String attachmentDataId {get;set;}
          public String OppName{get;set;}
          public String OppId{get;set;}

    }
    
    
  
    public Integer showMoreOppsValue{
    	get{
    		if((totalOpps - oppRowLimit) > rowIncrementor){
    			showMoreOppsValue = rowIncrementor;
    		}else{
            
            	showMoreOppsValue = totalOpps - oppRowLimit;
	        }
	        return showMoreOppsValue;
    	}set;
    }

    public void getMoreOpps(){
    	if(showMoreOppsValue < rowIncrementor){
    		oppRowLimit += showMoreOppsValue;
    	}else{
    		oppRowLimit += rowIncrementor;
    	}
    }

    public void showAllOpps(){
    	oppRowLimit = totalOpps;
    }

    public Integer showMoreAttachmentsValue{
    	get{
    		if((totalOppAttachments - attachmentRowLimit) > rowIncrementor){
    			showMoreAttachmentsValue = rowIncrementor;
    		}else{
            
            	showMoreAttachmentsValue = totalOppAttachments - attachmentRowLimit;
	        }
	        return showMoreAttachmentsValue;
    	}set;
    }

    public void getMoreAttachments(){
    	if(showMoreAttachmentsValue < rowIncrementor){
    		attachmentRowLimit += showMoreAttachmentsValue;
    	}else{
    		attachmentRowLimit += rowIncrementor;
    	}
    }

    public void showAllAttachments(){
    	attachmentRowLimit = totalOppAttachments;
    }
	
}