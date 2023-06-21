/**
 * @description       : 
 * @author            : Anuradha Dabhadkar
 * @group             : 
 * @last modified on  : 06-02-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class BAA_SummaryController_Lightning {
    public static Opportunity Opp{get;set;}

    @AuraEnabled
    public static NPAABaseEventController.Wrapper getWrapper(String evnId, String opportId){
        System.debug(evnId + opportId);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        System.debug(wrap);
        return wrap;
    }

    @AuraEnabled
    public Static initWrapper summaryDetails(NPAABaseEventController.Wrapper wrap)
    {
        system.debug('wrap.opportunityId: '+wrap.opportunityId);
        initWrapper summaryWrap = new initWrapper();
        if (Opp == null){
            Opp = [SELECT    NPAA_Application_signed__c,
                                    NPAA_Documents_Received__c,
                                    Date_Application_Received__c,
                                    Attachment_App_Form__c ,
                                    Attachment_Welcome_Letter__c,
                                    Opportunity_Status__c
                        FROM     Opportunity
                            WHERE    Id = :wrap.opportunityId];
                                        
        }
        summaryWrap.Opportuniy = Opp;
        
         if(Opp.Attachment_App_Form__c!= null){
            if((Opp.Attachment_App_Form__c).left(3).equalsIgnoreCase('068')){
                summaryWrap.ApplicationForm = '/sfc/servlet.shepherd/version/download/'+ Opp.Attachment_App_Form__c;    
            }else{
                summaryWrap.ApplicationForm = '/servlet/servlet.FileDownload?file='+ Opp.Attachment_App_Form__c;
            }
            system.debug('summaryWrap.ApplicationForm: '+summaryWrap.ApplicationForm);
        }
        
        if(Opp.Attachment_Welcome_Letter__c != null){
            if((Opp.Attachment_Welcome_Letter__c).left(3).equalsIgnoreCase('068')){
                summaryWrap.WelcomeLetter = '/sfc/servlet.shepherd/version/download/'+ Opp.Attachment_Welcome_Letter__c;    
            }else{
                summaryWrap.WelcomeLetter = '/servlet/servlet.FileDownload?file='+ Opp.Attachment_Welcome_Letter__c;
            }
            system.debug('summaryWrap.WelcomeLetter: '+summaryWrap.WelcomeLetter);
        }

        return summaryWrap;  
    } 


    public class initWrapper{
        @AuraEnabled public Opportunity Opportuniy{get;set;}
        @AuraEnabled public string ApplicationForm {get;set;}
        @AuraEnabled public string WelcomeLetter{get;set;}
    }
}