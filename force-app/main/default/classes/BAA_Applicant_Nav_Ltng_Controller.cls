public with sharing class BAA_Applicant_Nav_Ltng_Controller {
    
    @AuraEnabled
    public static List < ApplicantWrapper > fetchApplicantList( String opportunityId, String accountId, String eventId ){
        List < ApplicantWrapper > applicantWrapperList = new List < ApplicantWrapper > ();

        for ( Applicant__c applicant : [select id,Prospect_Customer__r.name,Prospect_Customer__c,Prospect_Customer__r.firstname,Prospect_Customer__r.lastname,Prospect_Customer__r.salutation, Prospect_Customer__r.Middle_Name__pc,
                    Prospect_Customer__r.Gender__c, Prospect_Customer__r.Home_Telephone_No__c, Prospect_Customer__r.Phone, Prospect_Customer__r.PersonEmail, Prospect_Customer__r.IsPersonAccount,
                    CPF_Relationship__r.Shareholder_Percentage__c, CPF_Relationship__r.Position_Held__c , CPF_Relationship__r.Is_Director__c ,CPF_Relationship__r.Is_Shareholder__c ,CPF_Relationship__r.Is_Signatory__c,
                    Is_Director__c, Is_ShareHolder__c, Is_Signatory__c 
                    from Applicant__c where Opportunity__C=: opportunityId]) {
            ApplicantWrapper appObj = new ApplicantWrapper ();
            if ( applicant.Is_Director__c == 'Yes' || applicant.Is_Signatory__c == 'Yes') {
                appObj.isDirectorApplicant = true;
                appObj.directorUrl = '/apex/BAA_Director_Details_Lightning?id='+eventId+'&accId='+applicant.Prospect_Customer__c;
            } else {
                appObj.isDirectorApplicant = false;
                appObj.directorUrl = '/apex/BAA_Shareholder_Details_Lightning?id='+eventId+'&accId='+applicant.Prospect_Customer__c;
            }  
            if ( !String.isBlank (accountId) && (accountId == applicant.Prospect_Customer__c) ) {
                appObj.className = 'active';
            } 
            appObj.customerName = applicant.Prospect_customer__r.name; 
            applicantWrapperList.add ( appObj );
            
        }

        System.debug ('applicantWrapperList ' + applicantWrapperList);

        return applicantWrapperList;
    }


    public class ApplicantWrapper {
        @AuraEnabled
        public Boolean isDirectorApplicant;
        @AuraEnabled
        public String className;
        @AuraEnabled
        public String directorUrl;
        @AuraEnabled
        public String customerName;

        public ApplicantWrapper ( ) {}
        
    }
}