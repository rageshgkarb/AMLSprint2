/**
 * Created by lbrindle on 05/11/2019.
 */

public with sharing class DotConnect_BypassRegistration_Controller {

    public Datetime bypassDate {get;set;}
    public Datetime bypassExpire {get;set;}
    public String currentBypassPeriod {get;set;}
    public Account acc {get;set;}
    public String errorMessage {get;set;}
    public Boolean displayMessage {get;set;}
    public Boolean refreshPage {get;set;}

    public DotConnect_BypassRegistration_Controller(ApexPages.StandardController stdController) {
        this.acc = [SELECT Id,SFDC_ID__c,EBS_ID__c, Bypass_Registration_Security_Until__c, Bypass_Registration_Started__c,Registration_Bypass_Active__c,IsPersonAccount,Reset_User_Completed__c FROM Account
                   WHERE Id =: stdController.getRecord().Id];

    }


    public PageReference bypass(){
        acc.Bypass_Registration_Started__c = DateTime.Now();
        update acc;

        acc = [SELECT Id,SFDC_ID__c,EBS_ID__c,Bypass_Registration_Security_Until__c, Bypass_Registration_Started__c,Registration_Bypass_Active__c,IsPersonAccount,Reset_User_Completed__c FROM Account
        WHERE Id =: acc.Id];
        return null;
    }

    public PageReference resetUser () {
        displayMessage = false;
        errorMessage = '';
        acc = [SELECT Id,SFDC_ID__c,EBS_ID__c, Bypass_Registration_Security_Until__c, Bypass_Registration_Started__c,Registration_Bypass_Active__c,IsPersonAccount,Reset_User_Completed__c FROM Account
        WHERE Id =: acc.Id];

        Map < String, String > responseMap = ARBResetCustomerAPIUtils.fetchBrokerAPIResponse ( acc );
        if ( responseMap.containsKey ('ResponseCode')) {
            if ( responseMap.get ('ResponseCode') == 'SUCCESS') {
                acc.Reset_User_Completed__c = DateTime.Now();
                update acc;
                acc = [SELECT Id,SFDC_ID__c,EBS_ID__c, Bypass_Registration_Security_Until__c, Bypass_Registration_Started__c,Registration_Bypass_Active__c,IsPersonAccount,Reset_User_Completed__c FROM Account
        		WHERE Id =: acc.Id];
                refreshPage = true;
                
                System.debug ('acc.Reset_User_Completed__c' + acc.Reset_User_Completed__c);
            } else if ( responseMap.get ('ResponseCode') == 'FAILED' ) {
                if ( responseMap.containsKey ('ResponseMessage') ) {
                    displayMessage = true;
                    errorMessage = '' + responseMap.get ('ResponseMessage');
                }
                
            }
            
        }

        return null;
    }
}