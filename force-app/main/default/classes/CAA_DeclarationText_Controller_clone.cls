/* Class Name : CAA_DeclarationText_Controller_clone
Description : Controller class is used get boolean to show hide section depending on ibb product type 
Modifications: clone of CAA_DeclarationText_Controller
DevName UserStory  Description
Amey    CAA_Declaration    Caa lightning migration */

public class CAA_DeclarationText_Controller_clone extends CAA_Core_Controller{
    
    @AuraEnabled
    public static Map<String, Boolean> getCAA_DeclarationText(String ibbProductName){
        Map<String, Boolean> productMap= new Map<String, Boolean>();
        productMap.put('showDirectSavingsAccountTC',showDirectSavingsAccountTC(ibbProductName));
        productMap.put('show60DayNoticeAccountTC',show60DayNoticeAccountTC(ibbProductName));
        productMap.put('show120DayNoticeAccountTC',show120DayNoticeAccountTC(ibbProductName));
        productMap.put('showOnDemandSavingsAccountTC',showOnDemandSavingsAccountTC(ibbProductName));
        productMap.put('showYPSATC',showYPSATC(ibbProductName));
        productMap.put('showISA',showISA(ibbProductName));
        productMap.put('show60DayISA',show60DayISA(ibbProductName));
        productMap.put('showInstantISA',showInstantISA(ibbProductName));
        productMap.put('showFTDISA',showFTDISA(ibbProductName));
        productMap.put('showYPNATC',showYPNATC(ibbProductName));
        productMap.put('showFixedTermAccountTC',showFixedTermAccountTC(ibbProductName));
        productMap.put('showSmallFixedTermAccountTC',showSmallFixedTermAccountTC(ibbProductName));
        productMap.put('showCurrentAccountTC',showCurrentAccountTC(ibbProductName));
        productMap.put('showCurrentText',showCurrentText(productMap));
        productMap.put('showSavingText',showSavingText(productMap));
        System.debug('productMap'+productMap);
        return productMap; 
    }
    
    public static boolean showDirectSavingsAccountTC(String ibbProductName) {
        return ('DIRECT SAVINGS ACCOUNT'.equalsIgnoreCase(ibbProductName) ? true : false);
    }
    public static boolean show60DayNoticeAccountTC(String ibbProductName) {
            return ('60 DAY NOTICE ACCOUNT'.equalsIgnoreCase(ibbProductName) ? true : false);
    }
    public static boolean show120DayNoticeAccountTC(String ibbProductName) {
            return ('120 DAY NOTICE ACCOUNT'.equalsIgnoreCase(ibbProductName) ? true : false);
    }
    public static boolean showOnDemandSavingsAccountTC(String ibbProductName) {
            return ('ON DEMAND SAVINGS ACCOUNT'.equalsIgnoreCase(ibbProductName) ? true : false);
    }
    public static boolean showYPSATC(String ibbProductName) {
            return ('YOUNG PERSONS SAVINGS ACCOUNT'.equalsIgnoreCase(ibbProductName) ? true : false);
    }
    public static boolean showISA(String ibbProductName) {
            return ('Notice Cash ISA'.equalsIgnoreCase(ibbProductName) ? true : false);
    }
    public static boolean show60DayISA(String ibbProductName) {
            return ('60 Day Notice Cash ISA'.equalsIgnoreCase(ibbProductName) ? true : false);
    }
    public static boolean showInstantISA(String ibbProductName){        
         return ('Instant Access Cash ISA'.equalsIgnoreCase(ibbProductName) ? true : false);        
       }  
      
    public static boolean showFTDISA(String ibbProductName){          
         return ('12 Month Fixed Term ISA'.equalsIgnoreCase(ibbProductName) ? true : false);        
       }    
   
     public static boolean showYPNATC(String ibbProductName) {
            return ('YOUNG PERSON\'S NOTICE SAVINGS ACCOUNT'.equalsIgnoreCase(ibbProductName) ? true : false);
    }
    public static boolean showFixedTermAccountTC(String ibbProductName) {
        if ('12 MONTH FIXED TERM DEPOSIT ACCOUNT'.equalsIgnoreCase(ibbProductName)
            || '18 MONTH FIXED TERM DEPOSIT ACCOUNT'.equalsIgnoreCase(ibbProductName)
            || '24 MONTH FIXED TERM DEPOSIT ACCOUNT'.equalsIgnoreCase(ibbProductName)
            || '36 MONTH FIXED TERM DEPOSIT ACCOUNT'.equalsIgnoreCase(ibbProductName)){
                return true;
            }else{
                return false;
            }
    }
     public static boolean showSmallFixedTermAccountTC(String ibbProductName) {
            if ('03 MONTH FIXED TERM DEPOSIT ACCOUNT'.equalsIgnoreCase(ibbProductName)
                || '06 MONTH FIXED TERM DEPOSIT ACCOUNT'.equalsIgnoreCase(ibbProductName)){
                return true;
            }else{
                return false;
            }
    }
    public static boolean showCurrentAccountTC(String ibbProductName) {
            System.debug('*** -- ibbProductName = ' + ibbProductName + ' -- ***');
            return ('CURRENT ACCOUNT'.equalsIgnoreCase(ibbProductName) ? true : false);
    }
    public static boolean showCurrentText(Map<String, Boolean> productMap){
        if(productMap.get('showYPSATC') || productMap.get('showYPNATC')){
            return false;
        }
        else{
            return productMap.get('showCurrentAccountTC');
        }
    }
    public static boolean showSavingText(Map<String, Boolean> productMap){
        if(productMap.get('showYPSATC') || productMap.get('showYPNATC')){
            return false;
        }
        else{
            return !productMap.get('showCurrentAccountTC');
        }
    }
    
    
}