public class BAA_Mandates_Lightning {
	private static aLog.Logger Log = new aLog.Logger('BAA_Mandate');
    public static List<Applicant__c> Applicants{get;set;}
    public static Opportunity Opp{get;set;}
    
    
    @AuraEnabled
    public static NPAABaseEventController.Wrapper getWrapper(String evnId, String opportId){
        System.debug(evnId + opportId);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        System.debug(wrap);
        return wrap;
    }
    
    @AuraEnabled
    public static Opportunity getSetup(String opp)
    {
		recordType business = [select id from recordType where developername='Business_account'];
		aLog.Save();
        return [select id,Mandate_Signature__c , Mandate_How_Many_Signatures__c, Mandate_Compulsory_Signature__c,Mandate_Compulsory_Signature_Account__c, Account_With_IBB__r.Name
                     from opportunity where id=: opp];
    }
    
   @AuraEnabled
    public static String Complete(NPAABaseEventController.Wrapper wrap)
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
    
    @AuraEnabled
    public static String LoadMandatesAndSignatories(String findText)
    {
		Teller_Security.TellerFunctionSecurityCheck('Account Settings');
        return JSON.serialize(Teller_Mandates_Controller.LoadMandatesAndSignatories(findText));
    }
    
    @AuraEnabled
    public static String LoadSignatoriesAndGroups(String accountNo)
    {
        Teller_Security.TellerFunctionSecurityCheck('Account Settings');
        return JSON.serialize(Teller_Signatory_Controller.LoadSignatoriesAndGroups(accountNo));
    }
    @AuraEnabled
    public static String DeleteMandate(String mandateId)
    {		
        System.debug('MAndate Id : '+mandateId);
		Teller_Security.TellerFunctionSecurityCheck('Account Settings');
        return JSON.serialize(Teller_Mandates_Controller.DeleteMandate(mandateId));
    }
    @AuraEnabled
    public static String LoadMandateItems(String mid,String ibbacc)
    {
        Teller_Mandate_Controller.LoadMandateItemsRequest request= new Teller_Mandate_Controller.LoadMandateItemsRequest();
        request.MandateId = mid;
        request.AccountWithIBBId = ibbacc;
		Teller_Security.TellerFunctionSecurityCheck('Account Settings');
        system.debug('Mandate List : '+Teller_Mandate_Controller.LoadMandateItems(request));
        return JSON.serialize(Teller_Mandate_Controller.LoadMandateItems(request));
    }
    @AuraEnabled
    public static String SaveMandateItems(String request)
    {
        System.debug('Request : '+ request);
        Type tp = Type.forName('Teller_Mandate_Controller.SaveMandateItemsRequest');
        Teller_Mandate_Controller.SaveMandateItemsRequest req= (Teller_Mandate_Controller.SaveMandateItemsRequest)JSON.deserialize(request, tp);
        system.debug('Req : '+req);
		Teller_Security.TellerFunctionSecurityCheck('Account Settings');
        return JSON.serialize(Teller_Mandate_Controller.SaveMandateItems(req));
    }
    @AuraEnabled
    public static String SaveSignatories(String request)
    {
         System.debug('Request : '+ request);
        Type tp = Type.forName('List<Teller_Mandates_Controller.Signatory>');
        List<Teller_Mandates_Controller.Signatory> req= (List<Teller_Mandates_Controller.Signatory>)JSON.deserialize(request, tp);
        system.debug('Req : '+req);
        Teller_Security.TellerFunctionSecurityCheck('Account Settings');
        return JSON.serialize(Teller_Signatory_Controller.SaveSignatories(req));
    }
}