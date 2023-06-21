/*******************************************************************
* @Class Name      : BAA_SecondLineAuthorisation_Ltng_Test
* @Author          : Amey Kashetwar
* @Created Date    : 8 June 2022
* @description     : This apex test class for BAA_SecondLineAuthorisationCntlr_Ltng
* @JIRA            : SLM-191

  LOG     DATE        Author  UserStory         COMMENT      
* 001   8/06/2022      Amey   SLM-191          First Commit
********************************************************************/
@isTest
public class BAA_SecondLineAuthorisation_Ltng_Test {
public static Account acc;
public static Opportunity opp;
    
    
  @testSetup static void setup() {
    NPAA_TestSetupData.dataSetup();
  }  
 
    @isTest static void testMethod1() {
 
         Opportunity o =[Select id from Opportunity where stagename = 'Open'];
         EventLog__c log=[Select id from EventLog__c where Opportunity__c =: o.Id];
               test.startTest();
         NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper(log.id,null);
         wrap.GoToNextEvent();
      
        BAA_SecondLineAuthorisationCntlr_Ltng.getWrapper(log.id,o.id);
        
        BAA_SecondLineAuthorisationCntlr_Ltng.Complete(log.id,o.id);
        BAA_SecondLineAuthorisationCntlr_Ltng.LoadEvent(log.id);
        test.stopTest();
    }

}