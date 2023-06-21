@isTest
private with sharing class AccountCommunicationExtensionTest {


    static testMethod void test(){
        Account acc = new Account();        
        acc.FirstName = 'CaseAccountDMA';
        acc.LastName = 'CaseAccountDMB';
        acc.Title_Other__c = 'xyz';        
        insert acc;  

        DocugenPlusSettings__c setting = new DocugenPlusSettings__c();
        setting.Name = 'Test Setting';
        setting.JsonSettings1__c = '{}';
        insert setting;

        Docugen_Job__c firstJob = new Docugen_Job__c ();
        Docugen_EBS_template__c foo = new Docugen_EBS_template__c ();
                insert foo;
                
                firstJob.Docugen_EBS_template__c = foo.Id;
                insert firstJob;


       

        Attachment_Data__c attachData = new Attachment_Data__c ();
        attachData.Account__r = acc;
        attachData.Docugen_Job__r = firstJob;

        insert attachData;

        List<Attachment> att = new List<Attachment>();
        Attachment att1 = new Attachment();
        att1.parentid = attachData.id;
        att1.body =  Blob.valueOf('Application Form');
        att1.name = 'Application Form';
        att.add(att1);

        Attachment att2 = new Attachment();
        att2.parentid = attachData.id;
        att2.body =  Blob.valueOf('Welcome Letter');
        att2.name = 'Welcome Letter';
        att.add(att2);
        
        insert att;

        ContentVersion cv = new ContentVersion();
         cv.Description  = 'test description';
         cv.PathOnClient ='test_file.txt';
         cv.Title = 'test file '+DateTime.now();
         cv.versiondata=Blob.valueOf('test file body');
         insert cv;
         ContentDocumentLink cdl = new ContentDocumentLink();
         cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
         cdl.LinkedEntityId =attachData.id;
         cdl.ShareType = 'V';
         insert cdl;



        ApexPages.StandardController sc = new ApexPages.StandardController( acc );
        AccountCommunicationExtension testAccPlan = new AccountCommunicationExtension(sc);
        testAccPlan.onLoad();
    }

    
}