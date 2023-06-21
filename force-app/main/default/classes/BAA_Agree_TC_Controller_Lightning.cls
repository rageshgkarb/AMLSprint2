public class BAA_Agree_TC_Controller_Lightning {

    private static aLog.Logger Log = new aLog.Logger('BAA_Agree_TC_Controller_Lightning');
    
    //public static Boolean IsAgree {get;set;}
    //public static String ProductDoc{get;set;}
    
    @AuraEnabled
    public static String Complete(NPAABaseEventController.Wrapper wrap)
    {
        
        //if(!IsAgree)
        //	return null;
        
      	//NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        
        try
        {        
            wrap.CompleteEvent();            
        }
        catch(Exception ex)
        {Log.Fatal('Exception',ex);            
        }  
        if(wrap.GoToNextEvent() != null)
        	return wrap.GoToNextEvent().getUrl();
        else
            return null;
    }
    
}