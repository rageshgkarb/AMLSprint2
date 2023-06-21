public with sharing class BAA_Product_Specific_Ltng_Controller {
    private static aLog.Logger Log = new aLog.Logger('BAA_SecondLineAuth');


    @AuraEnabled
    public static Opportunity fetchOpportunityDetails( String opportunityId ){
        return [select id,Mandate_Signature__c , Mandate_How_Many_Signatures__c, Mandate_Compulsory_Signature__c,Mandate_Compulsory_Signature_Account__c, 
        Account_With_IBB__r.Name
                     from opportunity where id=:opportunityId];
    }
    @AuraEnabled
    public static List < ApplicantWrapper > fetchApplicantList( String opportunityId ){
        List < ApplicantWrapper > applicantWrapperList = new List < ApplicantWrapper > ();
        recordType business = [select id from recordType where developername='Business_account'];
        
        for ( applicant__c applicant: [select Has_Card__c, 
                                        Has_Mandate__c,
                                        Mandate_Unlimited__c, 
                                        Mandate_Limit__c,
                                        Prospect_Customer__r.name,
                                        Prospect_Customer__r.Card_Name__c , 
                                        Prospect_Customer__r.firstname, 
                                        Prospect_Customer__r.lastname 
                                    from applicant__c  
                                    where opportunity__c=:opportunityId
                                                    and Prospect_Customer__r.recordtypeId !=: business.id and Is_Beneficialowner__c != 'Yes']) {
                                                        
            ApplicantWrapper appWrapper = new ApplicantWrapper (
                ''+applicant.Has_Mandate__c, String.valueOf(applicant.Mandate_Limit__c), ''+applicant.Mandate_Unlimited__c, 
                ''+applicant.Has_Card__c,''+applicant.Prospect_Customer__r.Card_Name__c, ''+applicant.Prospect_Customer__r.firstname,  ''+applicant.Prospect_Customer__r.lastname,
                ''+applicant.Prospect_Customer__r.name,''+applicant.Prospect_Customer__c, ''+applicant.Id                                       
            );
            applicantWrapperList.add( appWrapper );
        }
        return applicantWrapperList;
        
    }

    @AuraEnabled
    public static ProductSpecificResultWrapper handleSaveApplicant( String opptyWrapper, String applicantWrapper ){
        System.debug ('opptyWrapper ' + opptyWrapper);
        System.debug ('applicantWrapper ' + applicantWrapper);
        ProductSpecificOppWrapper inputOppWrapper = (ProductSpecificOppWrapper)JSON.deserialize( opptyWrapper , ProductSpecificOppWrapper.class);
        List < Applicant__c > applicantList = new List < Applicant__c> ();
       

        ProductSpecificResultWrapper prodWrapper = new ProductSpecificResultWrapper ();
        Opportunity oppRecord ;

        if ( ! String.isBlank ( inputOppWrapper.opportunityId) ) {
            oppRecord = [ SELECT Id,Name FROM Opportunity WHERE Id=:inputOppWrapper.opportunityId];

            if ( ! String.isBlank ( inputOppWrapper.mandatesignfield )) {
                oppRecord.Mandate_Signature__c = inputOppWrapper.mandatesignfield;
            }
            if ( ! String.isBlank ( inputOppWrapper.howManySignField )) {
                oppRecord.Mandate_How_Many_Signatures__c = Integer.valueOf (inputOppWrapper.howManySignField);
            }
            if ( ! String.isBlank ( inputOppWrapper.mandateCmpsignfield )) {
                oppRecord.Mandate_Compulsory_Signature__c = inputOppWrapper.mandateCmpsignfield;
            }
            if ( ! String.isBlank ( inputOppWrapper.selectedaccountfield ) && !(inputOppWrapper.selectedaccountfield).equalsIgnoreCase ('--None--')) {
                oppRecord.Mandate_Compulsory_Signature_Account__c = inputOppWrapper.selectedaccountfield;
            }
        }

        if ( !String.isBlank ( applicantWrapper ) ) {
            applicantList = populateApplicantList ( applicantWrapper );
        }

        
        try {
            update oppRecord;
            if ( applicantList.size () > 0 ) {
                update applicantList;
            }
            
            prodWrapper = new ProductSpecificResultWrapper ( true );
        } catch (Exception e) {
            prodWrapper = new ProductSpecificResultWrapper ('Error While Updating Opportunity Record ' + oppRecord.Id);
        }
        System.debug (' prodWrapper' + prodWrapper);
        return prodWrapper;
    }

    public static List < Applicant__c > populateApplicantList ( String applicantWrapper ) {
        List< ApplicantWrapper > inputApplicantWrapperList = (List< ApplicantWrapper >)JSON.deserialize( applicantWrapper , List< ApplicantWrapper >.class);
        List < Applicant__c > applicantRecordList = new List < Applicant__c > ();
        for ( ApplicantWrapper applicantObj : inputApplicantWrapperList ) {
            Applicant__c applicantRec = new Applicant__c ();
            System.debug ('applicantObj.HasCard' + applicantObj.HasCard);
            System.debug ('applicantObj.HasMandate' + applicantObj.HasMandate);
            System.debug ('applicantObj.MandateUnlimited' + applicantObj.MandateUnlimited);

            if ( ! String.isBlank ( applicantObj.applicantId )) {
                applicantRec.Id = applicantObj.applicantId;
            }
            if ( ! String.isBlank ( applicantObj.HasCard )) {
                applicantRec.Has_Card__c = Boolean.valueOf (applicantObj.HasCard);
            }
            if ( ! String.isBlank ( applicantObj.HasMandate )) {
                applicantRec.Has_Mandate__c = Boolean.valueOf ( applicantObj.HasMandate );
            }
            if ( ! String.isBlank ( applicantObj.MandateLimit )) {
                applicantRec.Mandate_Limit__c = Integer.valueOf (applicantObj.MandateLimit );
            }
            if ( ! String.isBlank ( applicantObj.MandateUnlimited )) {
                applicantRec.Mandate_Unlimited__c = Boolean.valueOf ( applicantObj.MandateUnlimited );
            }
            if ( ! String.isBlank ( applicantObj.cardName )) {
                Account accountRecord ;
                if (! String.isBlank ( applicantObj.accountId ) ) {
                    accountRecord = [ SELECT Id, Card_Name__c FROM Account WHERE Id=:applicantObj.accountId];
                    if ( accountRecord != null ) {
                        accountRecord.Card_Name__c = applicantObj.cardName ;
                        update accountRecord;
                    }
                }
                
            }
            applicantRecordList.add ( applicantRec );
        }
        return applicantRecordList;
    }


    public class ProductSpecificOppWrapper {
        public String opportunityId;
        public String mandateSignField;
        public String howManySignField;
        public String mandateCmpsignfield;
        public String selectedaccountfield;
    }


    public class ApplicantWrapper {
        @AuraEnabled
        public String HasMandate;
        @AuraEnabled
        public String MandateLimit;
        @AuraEnabled
        public String MandateUnlimited;
        @AuraEnabled
        public String HasCard;
        @AuraEnabled
        public String cardName;
        @AuraEnabled
        public String firstName;
        @AuraEnabled
        public String lastName;
        @AuraEnabled
        public String fullname;
        @AuraEnabled
        public String accountId;
        @AuraEnabled
        public String applicantId;

        public ApplicantWrapper ( String HasMandate, String MandateLimit, String MandateUnlimited, String HasCard, 
                                String cardName, String firstName, String lastName, String fullName, String accountId,
                                String applicantId ) {
            this.HasMandate = HasMandate;
            this.MandateLimit = MandateLimit;
            this.MandateUnlimited = MandateUnlimited;
            this.HasCard = HasCard;
            this.cardName = cardName;
            this.firstName = firstName;
            this.lastName = lastName;
            this.fullname = fullName;
            this.accountId = accountId;
            this.applicantId = applicantId;
        }

    }

    public class ProductSpecificResultWrapper {
        @AuraEnabled
        public String pageMessage;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public String successMessage;

        public ProductSpecificResultWrapper( ) {
        }
        public ProductSpecificResultWrapper( Boolean isSuccess ) {
            if ( isSuccess ) {
                this.successMessage = 'Successfully Updated Record';
            }
            
        }

        public ProductSpecificResultWrapper( String message ) {
            this.pageMessage = message;
        }
        

    }

    @AuraEnabled
    public static NPAABaseEventController.Wrapper getWrapper(String evnId, String opportId){
        System.debug(evnId + opportId);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        System.debug(wrap);
        return wrap;
    }
     @AuraEnabled
    public static String Complete(String evnId, String opportId){
      NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        try{        
            wrap.CompleteEvent();            
        }
        catch(Exception ex){
            Log.Fatal('Exception',ex);            
        }  
        
        return wrap.GoToNextEvent().getUrl();
    }
    
}