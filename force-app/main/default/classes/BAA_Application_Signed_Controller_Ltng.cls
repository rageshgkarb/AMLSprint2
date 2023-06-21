/* ------------------------------------------------------------------------------------------------- */
/* C00233    Submit to Decision Engine Lightning cmp                                                              */    
/* ------------------------------------------------------------------------------------------------- */
/* C0359    Web logs                                                                                 */
/* ------------------------------------------------------------------------------------------------- */

public class BAA_Application_Signed_Controller_Ltng
{

    @AuraEnabled
    public static isWrapper SubmitToDe(string eventId)
    {       
         isWrapper w = new isWrapper();
        Boolean isError = false;
        string message = 'Unknown Error';
        Boolean DeResponce;
          EventLog__c EventLog;
        string opportunityId;
        
            List<EventLog__c> listEvent = DataHelper.GetEventLog(eventId);
            if (listEvent.size() == 0)
              //  return null;
               isError = true;
            
            EventLog = listEvent[0];
            if(EventLog == null)
              //  return null;
              isError = true;
            opportunityId= EventLog.Opportunity__c;
        
        
        if(opportunityId != null){
        opportunity Opp = [select id, Accountid, General_comments_box__c from opportunity where id=:opportunityId];
        
        
        //Call decision engine  
            
        Actions.ActionBAADecisionEngine DecisionEngineAction = new Actions.ActionBAADecisionEngine ();
        system.debug ('This is the opp id ' + opp.id);
        IBBEvents.CompleteEventArgs args = DecisionEngineAction.RunAction(opp.id); // getting error;
        
        system.debug('DEResponse : ' +args.DEResponse.Decision);
        
        
        
        if(args.DEResponse.Decision.equalsIgnoreCase('Failed IN EBS') ||
            args.DEResponse.Decision.equalsIgnoreCase('SYSTEMERROR')) 
            
        {
          // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Fatal,'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above'));
          // return null;
          isError = true;
          message = 'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above';
        }
        else if(args.DEResponse.Decision.equalsIgnoreCase('ADDRESSMISMATCH') )
        {
          // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Fatal,'The address you have entered for the customer could not be found during the credit check. Please check the address on Royal Mail Postcode search. If this error continues to occur, please contact IT on 0121-452-7333'));
          // return null;
          isError = true;
         message ='The address you have entered for the customer could not be found during the credit check. Please check the address on Royal Mail Postcode search. If this error continues to occur, please contact IT on 0121-452-7333';
        }
        else if (!args.DEResponse.Decision.equalsIgnoreCase('REFER') && 
            !args.DEResponse.Decision.equalsIgnoreCase('DECLINE') &&
            !args.DEResponse.Decision.equalsIgnoreCase('SUCCESS') )
        {
         //  ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Fatal,'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above'));
          // return null;
          isError = true;
           message = 'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above';
        }
        
            
        DeResponce  = true;
       isError = false;
       // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Info,'Your request to decision engine has been successful, please complete the event'));
       // return null;
        message = 'Your request to decision engine has been successful, please complete the event';
        }
        w.isError = isError;
        w.message = message;
        
        return w;
    }
    
    
   	 @AuraEnabled
    public static String complete( NPAABaseEventController.Wrapper wrap)
    {
     
        try
        {        
            wrap.CompleteEvent();            
        }
        catch(Exception ex)
        {
          //  Log.Fatal('Exception',ex);            
        }  
        
        //if(wrap.GoToNextEvent() != null)
        	return wrap.GoToNextEvent().getUrl();
       // else
         //   return null;
    }
	
    
 
   
    public class isWrapper{
        @AuraEnabled public boolean isError{ get; set;}
        @AuraEnabled public string message{get; set;}
        
          public isWrapper()
        {
            this.message = '';
            this.isError = false;
        }
    }
   
   
}