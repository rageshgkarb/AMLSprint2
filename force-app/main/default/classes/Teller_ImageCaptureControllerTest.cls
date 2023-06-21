@isTest
public class Teller_ImageCaptureControllerTest {
    @testsetup
    public static void testData(){
        List<Teller_Settings__c> settings = new List<Teller_Settings__c>();
        Teller_Settings__c activityAuditExistsCheckSetting = new Teller_Settings__c();
        activityAuditExistsCheckSetting.Name = 'ActivityAuditExistsCheck';
        activityAuditExistsCheckSetting.Value__c = 'true';
        settings.add(activityAuditExistsCheckSetting);
        
        Teller_Settings__c activityAuditTimeFrameSecSetting = new Teller_Settings__c();
        activityAuditTimeFrameSecSetting.Name = 'ActivityAuditTimeFrameSec';
        activityAuditTimeFrameSecSetting.Value__c = '60';
        settings.add(activityAuditTimeFrameSecSetting);
        
        insert(settings);
        Account testAccount = new Account();
        testAccount.LastName = 'Test';
        testAccount.FirstName = 'Test';
        testAccount.marketing_preference__C = 'email';
        testAccount.Net_Monthly_Income__c = 4000;
        testAccount.EBS_ID__c ='ebsId';
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name = 'Prospect/Customer' LIMIT 1];
        testAccount.RecordTypeId=rt.Id;
        
        insert testAccount;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorgARB.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgARB.com');
        insert u;
        
        User me = new User();
        me.id = UserInfo.getUserId();
        me.ManagerId = u.id;
        update me;
    }
    
    @isTest
    public static void testImageCapture(){
        PageReference pageRef = Page.Teller_core;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('EBSId', 'ebsId'); 
        ApexPages.currentPage().getParameters().put('Photo', 'Y'); 
        Teller_ImageCaptureController telimg = new Teller_ImageCaptureController();
        
        telimg.imageType = 'Photo';
        telimg.imageBase64Binary ='imgBase64Binary';
        telimg.SaveImage('ebsId', 'Photo', 'imgBase64Binary');
        telimg.SaveImage();
        
    }
    
}