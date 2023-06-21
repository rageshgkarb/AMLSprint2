@isTest
public class CustomerImagesTest {
    @testSetup
    public static void dataSetup(){
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
    public static void testCustomerImage(){
        Account acc= [SELECT Id, Name from Account Where LastName = 'Test' LIMIT 1];
       
        String accountId = String.valueOf(acc.id);
        CustomerImages cusImage = new CustomerImages();
        String CurrentImageId = cusImage.CurrentImageId(accountId);
          String CurrentSignatureId = cusImage.CurrentSignatureId(accountId);
         String CurrentImageURL = cusImage.CurrentImageURL(accountId);
        Map<String,String> CurrentImageURLs = cusImage.CurrentImageURLs(new List<String>{accountId});
        String CurrentSignatureURL =  cusImage.CurrentSignatureURL(accountId);
        
         Customer_Image__c co = new Customer_Image__c(Status__c = 'Not Approved',Account__c =acc.id,Current_Image__c = true );
        insert co;
        Customer_Image__c ci = new  Customer_Image__c();
        ci.id=co.id;
        ci.Status__c = 'Approved';
        update ci;
        CustomerImages.CustomerImageApproval( co, ci);
        delete ci;
    }
     @isTest
 	public static void testapproval(){
        try{
             Account acc= [SELECT Id, Name from Account Where LastName = 'Test' LIMIT 1];
        CustomerImages.AutomateSubmitApproval(acc.id);
        }catch(Exception e){
            
        }
    }
}