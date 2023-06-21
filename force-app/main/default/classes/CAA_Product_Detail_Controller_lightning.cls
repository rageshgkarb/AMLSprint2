/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-04-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class CAA_Product_Detail_Controller_lightning extends CAA_Core_Controller
{
    /*
    Get the current opportunity and the selected product
    */   
    
    @AuraEnabled
    public static init_wrap ISASetup(String extid, String EventLogId)
    {
        
        init_wrap wrap= new init_wrap();
        wrap.ISAYears = new List<String>();
        String m_EventLogId = CAA_Core_Controller_Lightning.GetId(extid,EventLogId);
        //load opp
        wrap.opp = [select id, IBB_Product__r.FTD_Term_Months__c from opportunity where id=: CAA_Helper.GetOppId(m_EventLogId)];
        
        //if(opp.size() == 0) return null;
        
        If(wrap.opp.size() > 0 && wrap.opp[0].IBB_Product__r.FTD_Term_Months__c != null){
            wrap.TermMonths = integer.valueof(wrap.opp[0].IBB_Product__r.FTD_Term_Months__c);
            wrap.LessThanOr12Months = wrap.TermMonths < 12;
        }
        
        Schema.DescribeFieldResult fieldResult =
             Opportunity.Tax_year_applying_for__c.getDescribe();
               List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    
               for( Schema.PicklistEntry f : ple)
               {
                wrap.ISAYears.add(f.getValue());
               }       
        
        return wrap;
    }
    
    public class init_wrap{
        @AuraEnabled public transient List<String> ISAYears { get; set; }
        @AuraEnabled public Integer TermMonths { get; set; }
        @AuraEnabled public List<Opportunity> opp { get;set; }
        @AuraEnabled public Boolean LessThanOr12Months{get;set;}
     }
    
     @AuraEnabled
    public static CAA_Data.GenericResponse FTDISA(string eventLogId,CAA_Data.FTD data )
    {               
        system.debug(data);
        CAA_Data.GenericResponse response = new CAA_Data.GenericResponse();
        try
        {           
            //TODO SECurity for external
            //DECRYPT DATA
            if(CAA_Helper.IsGuestUser())
            {
                 eventLogId = CAA_Helper.DecryptData(eventLogId);
            }
        
            //PROCESS REQUEST    
            CAA_ProductDetail product = new CAA_ProductDetail(eventLogId,data);
            
            response.Url = product.CompleteFTDISA();           
            response.Success = response.Url != null;
        }
        catch(Exception ex)
        {
            response.Error = ex.getMessage();
            response.Success = false;
        }        
        return response;
    }
    
    @AuraEnabled
     public static CAA_Data.GenericResponse ISATerms(string eventLogId,CAA_Data.ISATerms data )
    {               
        CAA_Data.GenericResponse response = new CAA_Data.GenericResponse();
        try
        {           
            //TODO SECurity for external
            //DECRYPT DATA
            if(CAA_Helper.IsGuestUser())
            {
                 eventLogId = CAA_Helper.DecryptData(eventLogId);
            }
        
            //PROCESS REQUEST    
            CAA_ProductDetail product = new CAA_ProductDetail(eventLogId);
            response.Url = product.CompleteISATerms(data);           
            response.Success = response.Url != null;
        }
        catch(Exception ex)
        {
            response.Error = ex.getMessage();
            response.Success = false;
        } 
        System.debug(response);
        return response;
    }
    
    @RemoteAction @AuraEnabled
    global static CAA_Data.GenericResponse FTD(string eventLogId,CAA_Data.FTD data )
    {               
        system.debug('FTD apex class method');
        CAA_Data.GenericResponse response = new CAA_Data.GenericResponse();
        try
        {           
            //TODO SECurity for external
            //DECRYPT DATA
            if(CAA_Helper.IsGuestUser())
            {
                 eventLogId = CAA_Helper.DecryptData(eventLogId);
            }
        
            //PROCESS REQUEST 
            CAA_ProductDetail product = new CAA_ProductDetail(eventLogId,data);   
            response.Url = product.CompleteFTD();           
            response.Success = response.Url != null;
        }
        catch(Exception ex)
        {
            response.Error = ex.getMessage();
            response.Success = false;
        }        
        return response;
    }
    

}