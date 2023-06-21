/*  Class Name  : EBSCaseHelper
    Description : Helper/Service class for CaseTrigger
    Modifications
    DevName      UserStory       Modified date       Description             
    Avinash      SLM-072         30/03/2022          Refactoring/Merging the trigger    */

public class EBSCaseHelper{
    //Function for Callouts to EBS
    // Please do not remove the debug logs
    public static void caseEBSAfterInsert(list<Case> lstnewCases){
        System.debug('CaseEBSActionExecute');
        for(Case c : lstnewCases){
            System.debug(c.EBS_Action_Status__c);
            if(c.EBS_Action_Status__c == 'Open'){                               
                System.debug('EBSAction for Case Number: ' + c.CaseNumber+' EBSAction for Case Id: ' + c.Id); 
                IBBEBSActionMethods.ExecuteRequest(c.Id); 
            }
        }
    }
}