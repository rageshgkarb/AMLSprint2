@isTest
public class DocugenP_Job_ControllerTest {
    @isTest
    public static void testDocugen(){
        DocugenPlusSettings__c plus = new DocugenPlusSettings__c();
        plus.Name='test';
        plus.JsonSettings1__c = '{}';
        insert plus;
        
        Docugen_EBS_Template__c ebs = new Docugen_EBS_Template__c();
        ebs.EBS_Template__c = 'Test';
        insert ebs;
        
        Docugen_Job__c job = new Docugen_Job__c();
        job.Docugen_EBS_Template__c = ebs.id;
        insert job;
        
        Account acc = new Account();        
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.Title_Other__c = 'xyz';
        acc.Salutation='Mr';       
        insert acc;
        
        Attachment_Data__c attachData = new Attachment_Data__c ();
        attachData.Account__r = acc;
        attachData.Docugen_Job__r = job;
        insert attachData;
        
        List<Attachment> att = new List<Attachment>();
        Attachment att1 = new Attachment();
        att1.parentid = job.id;
        att1.body =  Blob.valueOf('Test Data');
        att1.name = 'test1';
        att.add(att1);

        Attachment att2 = new Attachment();
        att2.parentid = job.id;
        att2.body =  Blob.valueOf('Test Data2');
        att2.name = 'test2';
        att.add(att2);
        insert att;
        
        ContentVersion cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        //cdl.LinkedEntityId =job.id;
        cdl.LinkedEntityId =attachData.Id;
        cdl.ShareType = 'V';
        insert cdl;
        
  
        DocugenP_Job_Controller Doc = new DocugenP_Job_Controller();
        Doc.onLoad();
        
    }


}