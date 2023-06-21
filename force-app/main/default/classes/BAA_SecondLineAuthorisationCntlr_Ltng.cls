public class BAA_SecondLineAuthorisationCntlr_Ltng {
    
private static aLog.Logger Log = new aLog.Logger('BAA_SecondLineAuth');
    public static Opportunity Opp{get;set;}
    private static final String PICKLIST_COUNTRYCODE= 'COUNTRYCODE'; 
    private static final String PICKLIST_TINREASONCODE = 'TINREASONCODE';
    private static final String PICKLIST_SELFCERTCAPCITY='SELFCERTCAPCITY';
    private static final String PICKLIST_COUNTYOFBIRTH= 'COUNTYOFBIRTH';
    public static Boolean IsCompleted;
    
    public String Title{get;set;}
    
    @AuraEnabled
    public static NPAABaseEventController.Wrapper getWrapper(String evnId, String opportId){
        System.debug(evnId + opportId);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        System.debug(wrap);
        return wrap;
    }
     @AuraEnabled
    public static String Complete(String evnId, String opportId)
    {
      NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        try
        {        
            wrap.CompleteEvent();            
        }
        catch(Exception ex)
        {
            Log.Fatal('Exception',ex);            
        }  
        
        return wrap.GoToNextEvent().getUrl();
    }
    
    @AuraEnabled
    public static Boolean LoadEvent(String eventId){
        IsCompleted = false;
        List<EventLog__c> listEvent = DataHelper.GetEventLog(eventId);
        System.debug('listEvent'+listEvent);
        System.debug('listEvent size'+listEvent.size());
        if (listEvent.size() == 0)
        return IsCompleted;

        EventLog__c EventLog = listEvent[0];
        Event__c Event = DataHelper.GetEvent(EventLog.Event__r.id) [0];
        if (EventLog.eventstatus__c != 'Open')
        {
            IsCompleted = true;
        }
        return IsCompleted;
    }
}