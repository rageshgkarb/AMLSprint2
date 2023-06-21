@isTest
public class ARBBatchUpdateShareTypeTest { 

	 @isTest
    public static void testShareType(){
         Recordtype rtyp = [SELECT id from RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'Liabilities_Opportunites'];
        String recTypeId = rtyp.Id;
        Account acc = new Account(
            FirstName = 'Test Account', LastName = 'Test Account', BillingPostalCode = 'Test Account', 
            Title_Other__c = 'xyz', Respond_Case_URL__c = null, Respond_Unique_ID__c = 'test'
        );
        insert acc;
		Opportunity opp = new Opportunity();      
        opp.Name = 'Test Data';
        opp.StageName = 'Test STage';
        opp.CloseDate = date.today();
        opp.AccountId = acc.Id;
        opp.Interested_in__c = 'test';
        opp.Ex_Pat__c = 'test';
        opp.Income_Assisted_Application__c = true;
        opp.Estimated_actual_monthly_rental_income__c = 900;
        opp.Number_of_People_Applying__c = 1;
        insert opp;
	
	
		ContentVersion cv = new ContentVersion();
         cv.Description  = 'test description';
         cv.PathOnClient ='test_file.txt';
         cv.Title = 'test file '+DateTime.now();
         cv.versiondata=Blob.valueOf('test file body');
         insert cv;
         ContentDocumentLink cdl = new ContentDocumentLink();
         cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
         cdl.LinkedEntityId =opp.id;
         cdl.ShareType = 'V';
         insert cdl;
		 
		 String CRON_EXP = '0 0 0 15 3 ? *';
                Test.startTest();
		
            string shareTypeValue = 'V';
            String soqlQuery = 'SELECT Id, ShareType,LinkedEntityId,contentDocumentId FROM ContentDocumentLink WHERE LINKEDENTITYID IN (select id from opportunity) AND ShareType=\''+String.escapeSingleQuotes(shareTypeValue)+'\''+' LIMIT 1';
            String jobId = System.schedule('objBatchxyz234444',  CRON_EXP, NEW ARBBatchUpdateShareTypeSchedulable(soqlQuery,1));
                CronTrigger ct = [ SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId ];
                Test.stopTest();
		 
	}
}