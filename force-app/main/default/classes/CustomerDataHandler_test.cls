/*******************************************************************
* Class Name: CustomerDataHandler_test
* Created By: Raiyan
* Purpose : Test Class for CustomerDataHandler and Data Governance related classes            
********************************************************************/
@isTest
public class CustomerDataHandler_test{
  static testMethod void testsingleDelete(){
  
        Account acc = new Account();        
        acc.FirstName = 'New';
        acc.LastName = 'Account';
        acc.Title_Other__c = 'xyz'; 
        acc.BillingStreet = 'A\nB\nC';
        acc.ShippingStreet = 'A\nB\nC';
        acc.PersonMailingStreet = 'A\nB\nC';
        acc.Risk_Score__c = 100;
        acc.Date_of_Birth__c = date.newInstance(1995, 12, 15);
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        acc.Customer_Type__c = 'Individuals';
        acc.Risk_Score__c=10;
        insert acc;
        
        
        Case cs = new Case(Description ='test');
        cs.AccountId = acc.Id; 
        insert cs;
        
        acc.Risk_Score__c = 10;
        acc.EBS_ID__c = '270156';
        acc.Risk_Score__c=86;
        update acc;
        
        Opportunity opp = new Opportunity();
        opp.name = 'unit test';
        opp.StageName = 'closed/won';
        opp.CloseDate = date.today();
        opp.AccountId= acc.id;
        insert opp;
        
       
        
        Audit__c a = new Audit__c();
        a.Prospect_Customer__c =  acc.id;
        insert a;
        
        Audit__c a1 = new Audit__c();
        a1.Case__c =  cs.id;
        insert a1;
        
        Audit__c a2 = new Audit__c();
        a2.Opportunity__c=  opp.id;
        insert a2;
        
         Applicant__c apl =  new Applicant__c();
        apl.Opportunity__c = opp.Id;
        apl.Prospect_Customer__c = acc.Id;
        insert apl;
      
        String webLogId = OpportunityTriggerMethods.createWebIntegrationLog( opp.Id );
           Web_Integration_Log__c wl = new Web_Integration_Log__c(Id=webLogId, AccountId__c=acc.Id);
           wl.Request_Action__c = 'AddJournalEntry';
   
        wl.OpportunityId__c = opp.Id;
        //wl.AccountwithIBBId__c = opp.Account_with_IBB__c;
        update wl;
        Debug__c log = new Debug__c(Opportunity__c=opp.Id);
        insert log;
       
        test.starttest();
         
        // CustomerDataHandler.deleteAccountData(new list<string>{acc.id});
         CustomerDataHandler.deleteAccountData(acc.id); 
        test.stoptest();     
       
       
    }
    
    static testMethod void testMultiDelete(){
  
        Account acc = new Account();        
        acc.FirstName = 'New';
        acc.LastName = 'Account';
        acc.Title_Other__c = 'xyz'; 
        acc.BillingStreet = 'A\nB\nC';
        acc.ShippingStreet = 'A\nB\nC';
        acc.PersonMailingStreet = 'A\nB\nC';
        acc.Risk_Score__c = 100;
        acc.Date_of_Birth__c = date.newInstance(1995, 12, 15);
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        acc.Customer_Type__c = 'Individuals';
        acc.Risk_Score__c=10;
        insert acc;
        
        
        Case cs = new Case(Description ='test');
        cs.AccountId = acc.Id; 
        insert cs;
        
        acc.Risk_Score__c = 10;
        acc.EBS_ID__c = '270156';
        acc.Risk_Score__c=86;
        update acc;
        
        Opportunity opp = new Opportunity();
        opp.name = 'unit test';
        opp.StageName = 'closed/won';
        opp.CloseDate = date.today();
        opp.AccountId= acc.id;
        insert opp;
        
        Audit__c a = new Audit__c();
        a.Prospect_Customer__c =  acc.id;
        insert a;
        
         Audit__c a1 = new Audit__c();
        a1.Case__c =  cs.id;
        insert a1;
        
        Audit__c a2 = new Audit__c();
        a2.Opportunity__c=  opp.id;
        insert a2;
        
         Applicant__c apl =  new Applicant__c();
        apl.Opportunity__c = opp.Id;
        apl.Prospect_Customer__c = acc.Id;
        insert apl;
      
        String webLogId = OpportunityTriggerMethods.createWebIntegrationLog( opp.Id );
           Web_Integration_Log__c wl = new Web_Integration_Log__c(Id=webLogId, AccountId__c=acc.Id);
           wl.Request_Action__c = 'AddJournalEntry';
   
        wl.OpportunityId__c = opp.Id;
        //wl.AccountwithIBBId__c = opp.Account_with_IBB__c;
        update wl;
        Debug__c log = new Debug__c(Opportunity__c=opp.Id);
        insert log;
      
       
        test.starttest();
         //SFAccountDataCleanUpService.doDeleteProspectCustomerData(); 
         CustomerDataHandler.deleteAccountData(new list<string>{acc.id});
        test.stoptest();
        
    }
    static testMethod void testWebservice(){
  
        Account acc = new Account();        
        acc.FirstName = 'New';
        acc.LastName = 'Account';
        acc.Title_Other__c = 'xyz'; 
        acc.BillingStreet = 'A\nB\nC';
        acc.ShippingStreet = 'A\nB\nC';
        acc.PersonMailingStreet = 'A\nB\nC';
        acc.Risk_Score__c = 100;
        acc.Date_of_Birth__c = date.newInstance(1995, 12, 15);
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        acc.Customer_Type__c = 'Individuals';
        acc.Risk_Score__c=10;
        insert acc;
        
        
        Case cs = new Case(Description ='test');
        cs.AccountId = acc.Id; 
        insert cs;
        
        acc.Risk_Score__c = 10;
        acc.EBS_ID__c = '270156';
        acc.Risk_Score__c=86;
        update acc;
        
        Opportunity opp = new Opportunity();
        opp.name = 'unit test';
        opp.StageName = 'closed/won';
        opp.CloseDate = date.today();
        opp.AccountId= acc.id;
        insert opp;
        
        Audit__c a = new Audit__c();
        a.Prospect_Customer__c =  acc.id;
        insert a;
        
         Audit__c a1 = new Audit__c();
        a1.Case__c =  cs.id;
        insert a1;
        
        Audit__c a2 = new Audit__c();
        a2.Opportunity__c=  opp.id;
        insert a2;
        
         Applicant__c apl =  new Applicant__c();
        apl.Opportunity__c = opp.Id;
        apl.Prospect_Customer__c = acc.Id;
        insert apl;
      
        String webLogId = OpportunityTriggerMethods.createWebIntegrationLog( opp.Id );
           Web_Integration_Log__c wl = new Web_Integration_Log__c(Id=webLogId, AccountId__c=acc.Id);
           wl.Request_Action__c = 'AddJournalEntry';
   
        wl.OpportunityId__c = opp.Id;
        //wl.AccountwithIBBId__c = opp.Account_with_IBB__c;
        update wl;
        Debug__c log = new Debug__c(Opportunity__c=opp.Id);
        insert log;
      
       
      
        String myJSON =  '{"data":["'+ acc.id+'"]}';
        
        
        system.RestRequest  req = new system.RestRequest();
        RestResponse res = new RestResponse();
    
        // pass the req and resp objects to the method     
        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() +'/services/apexrest/deleteProspectCustomerData'+myJSON ;
        req.httpMethod = 'DELETE';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        
  
        SFAccountDataCleanUpService.doDeleteProspectCustomerData();
        
        ProspectCustomerDeleteResponse res1 = new ProspectCustomerDeleteResponse();
        res1.accountId = acc.id;
        res1.success = true;
        res1.childRecordCount = 10;
        res1.message = 'test';
    }
}