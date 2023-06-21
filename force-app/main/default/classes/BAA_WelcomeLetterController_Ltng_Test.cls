@IsTest
public class BAA_WelcomeLetterController_Ltng_Test {

   @testsetup 
          
    public static void SetUpObjects()
    {
       NPAA_TestSetupData.dataSetup();  
    }
    
   @istest
     public static void checkTestMethods()
    {
        EventLog__c log =[select id from EventLog__c limit 1];
        Opportunity o = [Select Id from Opportunity limit 1];

                    
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper(log.id,null);
        wrap.GoToNextEvent();
         test.startTest();
       BAA_WelcomeLetterController_Ltng.complete(wrap);
        BAA_WelcomeLetterController_Ltng.getWrapper(log.id,o.id);
    
        BAA_WelcomeLetterController_Ltng.CreateDoc(o.id,true,true);
               test.stopTest();     
  
        
    } 

}