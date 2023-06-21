@isTest
public class DocugenPViewDocsControllerTest {
    
	@isTest
    public static void testViewDocs(){
        Docugen_EBS_Template__c ebs = new Docugen_EBS_Template__c();
        ebs.EBS_Template__c = 'Test';
        insert ebs;
        
        Docugen_Job__c job = new Docugen_Job__c();
      
        job.Docugen_EBS_Template__c = ebs.id;
        insert job;
        
        Attachment att = new Attachment ();
        att.parentid = job.id;
        att.body =  Blob.valueOf('Test Data');
        att.name = 'test';
        insert att;
         ContentVersion cv=new Contentversion();
cv.title='ABC';
cv.PathOnClient ='test';
Blob b=Blob.valueOf('Unit Test Attachment Body');
cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
insert cv;
        String ContentDocumentId  = [SELECT ContentDocumentId from ContentVersion WHERE id =: cv.Id LIMIT 1 ].ContentDocumentId;
        ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityId = job.id, ContentDocumentId = ContentDocumentId);
         insert cdl;
        
        
        List<Id> ids = new  List<Id>();
        ids.add(ebs.id);
        
        //DocugenPViewDocsController
       // onLoad
        DocugenPViewDocsController.GetDocs(ids,System.today()-1,System.today()+1);
    }

}