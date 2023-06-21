/*  Class Name  : DMCaseHelper
    Description : Helper/Service class for CaseTrigger
    Modifications
    DevName      UserStory       Modified date       Description             
    Avinash      SLM-072         30/03/2022          Refactoring/Merging the trigger    */

public class DMCaseHelper{
    // Function for update DSX
    // Please do not remove the debug logs
    public static void caseDMAfterUpdate(list<Case> lstnewCases){
        for(Case c : lstnewCases){
            System.debug(c.EBS_Action_Status__c);
            if(c.IsClosed && c.Status == 'Closed' && !String.isEmpty(c.DM_EBS_ID__c)){                               
                System.debug('EBSAction for Case Number: ' + c.CaseNumber+' EBSAction for Case Id: ' + c.Id); 
                DMCaseMethods.UpdateDSX(c.Id);
            }
        }
    } 
}