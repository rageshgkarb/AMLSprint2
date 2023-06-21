public class BAA_WelcomeLetterController_Ltng {
     private static aLog.Logger Log = new aLog.Logger('BAA_WelcomeLetter');
    
    @AuraEnabled
    public static NPAABaseEventController.Wrapper getWrapper(String evnId, String opportId){
        System.debug(evnId + opportId);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        System.debug(wrap);
        return wrap;
    }
    
    @AuraEnabled
    public static string CreateDoc(string opp,Boolean imageSetUp,Boolean authLevelSetup)
    {    
        Interfaces.ICongaSettings m_congaSettings;
        Interfaces.ICongaSettings m_congaSettingsAppForm;
        boolean FirstFinalView;
        boolean WelcomeLetterCreated;
        string WelcomeLetterLink = '';
        
         Opportunity thisOpp = [SELECT    Customer_Images_Set_Up__c,
                                      Mandate_Set_Up__c,
                                      User_Branch__c,
                                      IBB_product__c,
                                        Attachment_App_Form__c,
                                        Attachment_Welcome_Letter__c
                           FROM     Opportunity
                             WHERE    Id = :Opp limit 1];

                             if(thisOpp != null){
                                 thisOpp.Customer_Images_Set_Up__c = imageSetUp ;
                                 thisOpp.Mandate_Set_Up__c = authLevelSetup;

                             }
               
       // logger.trace('Get product ' + thisOpp.ibb_product__c);
       // system.debug('Get product ' + thisOpp.ibb_product__c);
        IBB_Product__c theProduct= [select Conga_Liability_App_1__c,Liability_Welcome_Letter_Post__c, Liability_Welcome_Letter__c,Conga_Liability_App_2__c,Conga_Liability_App_3__c from ibb_product__c where id=: thisOpp.ibb_product__c];
           // system.debug ( 'The Product ' + theProduct);
            if(thisOpp.User_Branch__c.equalsIgnoreCase('Head Office Birmingham') || thisOpp.User_Branch__c.equalsIgnoreCase('Online CAA Branch'))
            {
                system.debug ( 'The welcome letter ' + theProduct.Liability_Welcome_Letter__c);
                m_congaSettings = new CongaSettings(theProduct.Liability_Welcome_Letter__c); 
            }
            else
            {
                m_congaSettings = new CongaSettings(theProduct.Liability_Welcome_Letter_Post__c); 
            }
        
            //string body;
            if(!Test.isRunningTest()){
           string body= m_congaSettings.CallConga(thisOpp.id,true);   
    }
            if(m_congaSettings.GetAttachmentId() != null)
            {
                system.debug ( 'The Attachment ' + + m_congaSettings.GetAttachmentId());
                WelcomeLetterCreated = true;
               // WelcomeLetterLink = '<a target="_blank" href="/servlet/servlet.FileDownload?file=' + m_congaSettings.GetAttachmentId() + '"><b>Welcome Letter</b></a>';
         // WelcomeLetterLink = '/servlet/servlet.FileDownload?file=' + m_congaSettings.GetAttachmentId();
           //  new link   
       WelcomeLetterLink= ((m_congaSettings.GetAttachmentId()).left(3).equalsIgnoreCase('00P') || (m_congaSettings.GetAttachmentId()).left(3).equalsIgnoreCase('015'))?  '/servlet/servlet.FileDownload?file=' + m_congaSettings.GetAttachmentId():  '/sfc/servlet.shepherd/version/download/' + m_congaSettings.GetAttachmentId();

                thisOpp.Attachment_Welcome_Letter__c = m_congaSettings.GetAttachmentId();
                system.debug ( 'This is the WelcomeLetterLink ' + WelcomeLetterLink );
                //CreateAPPForm();
                
            }   
            else
            {
                system.debug ( 'Where is the welcome letter '); 
            }
             system.debug ( 'thisOpp'+thisOpp); 
             system.debug ( 'WelcomeLetterLink'+WelcomeLetterLink); 
          
           update thisOpp;      
           return WelcomeLetterLink; 
       
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
            Log.Fatal('Exception',ex);            
        }  
        
        return wrap.GoToNextEvent().getUrl();
    }
    
}