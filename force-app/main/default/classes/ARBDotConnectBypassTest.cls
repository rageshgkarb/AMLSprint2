@isTest
public class ARBDotConnectBypassTest {
    
    @Testsetup
    static void testResetCustomer(){

       List<Account> accounts = new List<Account>();
        Account a = new Account();
        a.FirstName = 'John';
        a.LastName = 'Smith';
        a.EBS_ID__c = '101234';
        a.Mother_s_family_name_security_question__c = 'mom';
        a.School_name_security_question__c = 'high';
        a.Town_of_Birth__c = 'town';
        a.Date_of_Birth__c = Date.newInstance(1980,1,1);


        accounts.add(a);

        Account b = new Account();
        b.FirstName = 'Joe';
        b.LastName = 'Bloggs';
        b.EBS_ID__c = '101235';
        accounts.add(b);

        Account c = new Account();
        c.FirstName = 'Jane';
        c.LastName = 'Doe';
        c.EBS_ID__c = '101236';
        accounts.add(c);
        insert accounts;

        List<Webservice_Setting__c> ws = new List<Webservice_Setting__c>();
        
        Webservice_Setting__c w1 = new Webservice_Setting__c();
        w1.name='HTTP Soap NS';
        w1.Value__c='test';
        ws.add(w1);
        
        Webservice_Setting__c w2 = new Webservice_Setting__c();
        w2.name='HTTP xsi';
        w2.Value__c='test';
        ws.add(w2);
        
        insert ws;

        EBS_Message_Data__c ebs1 = new EBS_Message_Data__c();
        ebs1.SourceID__c = 'test';
        ebs1.TokenID__c = 'test';
        ebs1.name = 'Default';
        insert ebs1;


        

    }
    
    static TestMethod void resetUserRequestFailedTest () {
        

         Test.startTest();
        z_WebServiceMock mock = new z_WebServiceMock();
        mock.xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ResetDigitalUserResponse xmlns="http://Bank.Service.Digital"><ResetDigitalUserResult xmlns="http://Bank.Service.ResetDigitalUser"><MessageID xmlns="">9999999</MessageID><ResponseCode xmlns="">FAILED</ResponseCode><ResponseMessage xmlns="">Unlock failed on both. User not found in vasco db. - IAM: Cannot perform runtime binding on a null reference</ResponseMessage></ResetDigitalUserResult></ResetDigitalUserResponse></soap:Body></soap:Envelope>';
        Test.setMock(WebServiceMock.class,mock);
       
        Account acc = [SELECT Id,SFDC_ID__c,EBS_ID__c,Bypass_Registration_Security_Until__c, Bypass_Registration_Started__c,Registration_Bypass_Active__c,IsPersonAccount,Reset_User_Completed__c FROM Account LIMIT 1];

        PageReference pageRef = Page.DotConnectBypassRegistration;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        DotConnect_BypassRegistration_Controller bypassController = new DotConnect_BypassRegistration_Controller ( sc );
        bypassController.resetUser ();
        Test.stopTest();
    }
    static TestMethod void resetUserRequestSuccessTest () {
        

         Test.startTest();
        z_WebServiceMock mock = new z_WebServiceMock();
        mock.xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ResetDigitalUserResponse xmlns="http://Bank.Service.Digital"><ResetDigitalUserResult xmlns="http://Bank.Service.ResetDigitalUser"><MessageID xmlns="">ef86a60e-f78e-8bb2-b07e-db5551f8a7a9</MessageID><ResponseCode xmlns="">SUCCESS</ResponseCode></ResetDigitalUserResult></ResetDigitalUserResponse></soap:Body></soap:Envelope>';
        Test.setMock(WebServiceMock.class,mock);
       
        Account acc = [SELECT Id,SFDC_ID__c,EBS_ID__c,Bypass_Registration_Security_Until__c, Bypass_Registration_Started__c,Registration_Bypass_Active__c,IsPersonAccount,Reset_User_Completed__c FROM Account LIMIT 1];
		

        PageReference pageRef = Page.DotConnectBypassRegistration;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        DotConnect_BypassRegistration_Controller bypassController = new DotConnect_BypassRegistration_Controller ( sc );
        bypassController.resetUser ();
        bypassController.bypass();
        Test.stopTest();
    }


}