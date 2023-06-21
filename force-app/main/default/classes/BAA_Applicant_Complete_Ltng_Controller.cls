public with sharing class BAA_Applicant_Complete_Ltng_Controller {
    private static aLog.Logger Log = new aLog.Logger('BAA_SecondLineAuth');
    
    @AuraEnabled
    public static EventLog__c fetchEventDetails( String eventId ){
        List<EventLog__c> listEvent = DataHelper.GetEventLog(eventId);
        
        return listEvent[0];
    }

    @AuraEnabled
    public static NPAABaseEventController.Wrapper getWrapper(String evnId, String opportId){
        System.debug(evnId + opportId);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        System.debug(wrap);
        return wrap;
    }
    @AuraEnabled
    public static String Complete(String evnId, String opportId, String comment ){
      NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
      Opportunity oppRecord = [ SELECT Id, Name, General_comments_box__c FROM Opportunity WHERE Id=: opportId LIMIT 1];
      if ( oppRecord !=null ) {
          if ( !String.isBlank ( comment )) {
             oppRecord.General_comments_box__c = comment;
             try{ 
                update oppRecord;       
            }
            catch(Exception ex){
                Log.Fatal('Exception',ex);            
            }  
          }
         
      }
        try{ 
            wrap.CompleteEvent();            
        }
        catch(Exception ex){
            Log.Fatal('Exception',ex);            
        }  
        
        return wrap.GoToNextEvent().getUrl();
    }

    
}