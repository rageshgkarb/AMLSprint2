@isTest
public class BAA_Application_Signed_Ltng_Test {
  
	@testsetup
    public static void dataTestMethod(){
        NPAA_TestSetupData.dataSetup();
      
      
    }
    @istest
    static void testMethod1() {
        EventLog__c log =[select id, event__c, opportunity__c from EventLog__c limit 1];
        Event__c e = [select id from Event__c limit 1];
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account limit 1];
        
        system.debug('@@Log='+log);
        system.debug('@@e='+e);
        system.debug('@@o='+o);
        system.debug('@@acc='+acc);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper(log.id,null);
        test.startTest();
        BAA_Application_Signed_Controller_Ltng.Complete(wrap);
        BAA_Application_Signed_Controller_Ltng.SubmitToDe(log.id);
        test.stopTest();
     
       

    }
   
}