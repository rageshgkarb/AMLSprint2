@isTest
public class CAA_DocumentsTest {
    private class RestMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = 'your Json Response';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    
    @TestSetup
     static void SetUpObjects()
    {
        NPAA_TestSetupData.dataSetup();
        CongaSettings__c cs = new CongaSettings__c();
        cs.Name = 'Testint';
        insert cs;
    }    
    
    @IsTest
    static void CreateDocumentTest(){
        CongaSettings__c cs = [SELECT id from CongaSettings__c limit 1];
        EventLog__c ev = [select id from EventLog__c limit 1];

        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        CAA_Documents cd = new CAA_Documents(ev.Id,System.UserInfo.getSessionId());
        cd.CreateDocument(cs.Id);
        Test.stopTest();
    }
    
    @IsTest
    static void GetDocumentsTest(){
        Opportunity opp = [SELECT Id FROM Opportunity limit 1];
        opp.CAA_Decision__c = 'SUCCESS';
        update opp;
        ContentVersion cv = new ContentVersion();
        cv.PathOnClient='test.txt';
        cv.VersionData = Blob.valueOf('Testing data');
        insert cv;
        ContentDocumentLink cdl= new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id,ContentDocumentId FROM ContentVersion limit 1].ContentDocumentId;
        cdl.LinkedEntityId=opp.Id;
        insert cdl;
        CongaSettings__c cs = [SELECT id from CongaSettings__c limit 1];
        EventLog__c ev = [select id from EventLog__c limit 1];
        
        //Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        CAA_Documents cd = new CAA_Documents(ev.Id,System.UserInfo.getSessionId());
        try{cd.GetDocuments('SIG');}catch(Exception e){}
        try{cd.GetDocuments('docs');}catch(Exception e){}
        try{cd.GetDocuments('Test');}catch(Exception e){}
        List<CAA_Documents.FileWrapper> files = cd.Attachments;
        Test.stopTest(); 
    }
    
    @IsTest
    static void GetDocumentsTest1(){
        Opportunity opp = [SELECT Id FROM Opportunity limit 1];
        ContentVersion cv = new ContentVersion();
        cv.PathOnClient='test.txt';
        cv.VersionData = Blob.valueOf('Testing data');
        insert cv;
        ContentDocumentLink cdl= new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id,ContentDocumentId FROM ContentVersion limit 1].ContentDocumentId;
        cdl.LinkedEntityId=opp.Id;
        insert cdl;
        CongaSettings__c cs = [SELECT id from CongaSettings__c limit 1];
        EventLog__c ev = [select id from EventLog__c limit 1];
        
        //Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        CAA_Documents cd = new CAA_Documents(ev.Id,System.UserInfo.getSessionId());
        try{cd.GetDocuments('SIG');}catch(Exception e){}
        try{cd.GetDocuments('docs');}catch(Exception e){}
        try{cd.GetDocuments('Test');}catch(Exception e){}
        List<CAA_Documents.FileWrapper> files = cd.Attachments;
        Test.stopTest(); 
    }
    @IsTest
    static void GetDocumentsTest2(){
        Opportunity opp = [SELECT Id FROM Opportunity limit 1];
        opp.CAA_Decision__c = 'REFER';
        update opp;
        ContentVersion cv = new ContentVersion();
        cv.PathOnClient='test.txt';
        cv.VersionData = Blob.valueOf('Testing data');
        insert cv;
        ContentDocumentLink cdl= new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id,ContentDocumentId FROM ContentVersion limit 1].ContentDocumentId;
        cdl.LinkedEntityId=opp.Id;
        insert cdl;
        CongaSettings__c cs = [SELECT id from CongaSettings__c limit 1];
        EventLog__c ev = [select id from EventLog__c limit 1];
        
        //Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        CAA_Documents cd = new CAA_Documents(ev.Id,System.UserInfo.getSessionId());
        try{cd.GetDocuments('SIG');}catch(Exception e){}
        try{cd.GetDocuments('docs');}catch(Exception e){}
        try{cd.GetDocuments('Test');}catch(Exception e){}
        List<CAA_Documents.FileWrapper> files = cd.Attachments;
        Test.stopTest(); 
    }
    
    @IsTest
    static void attachmentTest(){
        EventLog__c ev = [select id from EventLog__c limit 1];
        Opportunity opp = [SELECT Id FROM Opportunity limit 1];
        CAA_Documents cd = new CAA_Documents(ev.Id,System.UserInfo.getSessionId());
        
        Attachment att = new Attachment();
        att.Name='Test.txt';
        att.ParentId=opp.Id;
        att.Body=blob.valueOf('test');
        insert att;
        List<CAA_Documents.Filewrapper> files=cd.Attachments;
    }

 
}