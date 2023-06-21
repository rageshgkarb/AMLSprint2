@IsTest
public class Edit_Docugen_EBS_Template_Test {
	@TestSetup
    static void dataSetup(){     
        Docugen_EBS_Template__c dt = new Docugen_EBS_Template__c();
        dt.EBS_Template__c = 'Test';
        dt.Field_Map__c = 'Test';
        dt.Template__c = 'Test';
        dt.Field_Map__c = 'Testing';
        //dt.Name = 'Testing';
        dt.EBS_Template__c ='Testing';
        insert dt;
	        
        ContentVersion cv = new ContentVersion();
         cv.Description  = 'test description';
         cv.PathOnClient ='test_file.txt';
         cv.Title = 'test file '+DateTime.now();
         cv.versiondata=Blob.valueOf('test file body');
         insert cv;

		ContentDocumentLink cdl = new ContentDocumentLink();
         cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
         cdl.LinkedEntityId =dt.id;
         cdl.ShareType = 'V';
         insert cdl;
        EBS_Letter_Fields__c field = new EBS_Letter_Fields__c();
        field.Config__c ='Testing';
        field.Name = 'Test';
        field.DataType__c ='String';
        field.Label__c ='Testing';
        insert field; 
        DocugenPlusSettings__c dp = new DocugenPlusSettings__c();
        dp.Name = 'Test';
        dp.JsonSettings1__c = 'Testing';
        insert dp;
        
        Test.setCurrentPage(new PageReference('https://alrayanbank--zensarpro--c.visualforce.com/apex/Edit_Docugen_EBS_Template?id='+dt.Id));
    }
    
    @IsTest
    static void doUploadAttachmentTest(){
        Docugen_EBS_Template__c dt = [SELECT Id FROM Docugen_EBS_Template__c limit 1]; 
        ApexPages.StandardController sc = new ApexPages.StandardController(dt);
        Edit_Docugen_EBS_Template edt = new Edit_Docugen_EBS_Template(sc);
		String result = Edit_Docugen_EBS_Template.doUploadAttachment(dt.Id, 'attachmentBody', 'attachmentName', null);        
		System.assert(result != null);
    }

    
    @IsTest
    static void getAttachmentsTest(){
        String templateID = [SELECT Id FROM Docugen_EBS_Template__c limit 1].Id;
        String Result = Edit_Docugen_EBS_Template.getAttachments(templateID);
        System.assert(Result != null);
    }
    
    @IsTest
    static void getAttachmentsTest2(){
        Docugen_EBS_Template__c dt = new Docugen_EBS_Template__c();
        dt.EBS_Template__c = 'Test';
        dt.Field_Map__c = 'Test';
        dt.Template__c = 'Test';
        dt.Field_Map__c = 'Testing';
        //dt.Name = 'Testing';
        dt.EBS_Template__c ='Testing';
        insert dt;
        
        Attachment att = new Attachment();
        att.Name = 'Test.txt';
        att.body= Blob.valueOf('Hello');
        att.ParentId = dt.Id;
        insert att ;
        
        String Result = Edit_Docugen_EBS_Template.getAttachments(dt.Id);
        System.assert(Result != null);
    }
    
    @IsTest
    static void removeAttachmentTest(){
        ContentVersion cv = [SELECT Id FROM ContentVersion limit 1];
        String result = Edit_Docugen_EBS_Template.removeAttachment(cv.Id);
        system.assertEquals('1', result);
    }
    @IsTest
    static void CreateDuplicateTest(){
        String templateID = [SELECT Id FROM Docugen_EBS_Template__c limit 1].Id;
        String result = Edit_Docugen_EBS_Template.CreateDuplicate(templateID);
        System.assert(result != null);
    }
    @IsTest
    static void saveTest(){
        Edit_Docugen_EBS_Template.getEBSFields();
        Edit_Docugen_EBS_Template.getWordFields(null);
        Docugen_EBS_Template__c documentTemplate = [SELECT Id,Field_Map__c FROM Docugen_EBS_Template__c limit 1];
        String result = Edit_Docugen_EBS_Template.save(documentTemplate);
        System.assert(result != null);
    }
    @IsTest
    static void GetTemplateDetailsTest(){
        Docugen_EBS_Template__c documentTemplate = [SELECT Id FROM Docugen_EBS_Template__c limit 1];
        Docugen_EBS_Template__c result = Edit_Docugen_EBS_Template.GetTemplateDetails(documentTemplate.Id);
        System.assert(result != null);
    }
    @IsTest
    static void GetTemplatesTest(){
        List<Docugen_EBS_Template__c> dts= Edit_Docugen_EBS_Template.GetTemplates();
        System.assert(dts.size() > 0);
    }
    @IsTest
    static void getAttachmentTest(){
        ContentVersion cv = [SELECT Id FROM ContentVersion limit 1];
        Attachment at = Edit_Docugen_EBS_Template.getAttachment(cv.Id);
        System.assert(at != null);
    }
    @IsTest
    static void onLoadTest(){
        Docugen_EBS_Template__c dt = [SELECT Id FROM Docugen_EBS_Template__c limit 1]; 
        ApexPages.StandardController sc = new ApexPages.StandardController(dt);
        Edit_Docugen_EBS_Template edt = new Edit_Docugen_EBS_Template(sc);
        PageReference p= edt.onLoad();
        System.assert(p == null);
    }
}