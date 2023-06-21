/*******************************************************************
* @Class Name      : BAA_ProductSelect_Controller_Lightning
* @Author          : RAGESH G
* @Created Date    : 19 May 2022
* @description     : This apex controller class is used for Lightning Migration of BAA_ProductSelect
* @JIRA            : SLM-160

  LOG   DATE        Author  UserStory         COMMENT      
* 001   19/05/2022  RG                       First Commit
********************************************************************/

public with sharing class BAA_ProductSelect_Controller_Lightning {

    @AuraEnabled
    public static List<Campaign> fetchCampaignList () {
        return [select name, id from Campaign where IsActive = true and (EndDate = null or EndDate < TOMORROW) order by name];
    }


    @AuraEnabled
    public static NPAAApplicationWrapper createApplication( String wrapperObj ) {

        // save logs 
        aLog.Logger Log = new aLog.Logger('BAA_ProductSelect_Controller_Lightning');
        aLog.Save();
        System.debug (' wrapperObj ' + wrapperObj) ;
        NPAAInputWrapper inputWrapper = (NPAAInputWrapper)JSON.deserialize( wrapperObj , NPAAInputWrapper.class);
        NPAAApplicationWrapper npaaWrapper ;
        List < Account > accountList ;
        if ( inputWrapper.Name != null && inputWrapper.existingAccountId != null) {
            accountList = [select id from account where id!=:inputWrapper.existingAccountId and name=:inputWrapper.Name limit 1];
            
        } else {
            if ( !String.isBlank ( inputWrapper.selectedOrgName)) {
                accountList =  [select id from account where name=:inputWrapper.selectedOrgName limit 1];
            }
        }
        
        if( accountList !=null && accountList.size() > 0){
            npaaWrapper = new NPAAApplicationWrapper ('Business name already exists');
            return npaaWrapper;
        }
        IBB_Product__c product ;
        if ( !String.isBlank ( inputWrapper.selectedProductItem ) ) {
            product =  [select ibb_product_set__c, ibb_product_set__r.name from ibb_Product__c where id=:inputWrapper.selectedProductItem ];
        }
		
		RecordType recType = [select id from recordType where ispersontype=false and sobjectType='account' and DeveloperName = 'Business_Account' limit 1];
		RecordType oppRecType = [select id from recordType where  sobjectType='opportunity' and DeveloperName = 'NPAA' limit 1];
		
		Account Acc = new Account(RecordTypeid=recType.id );    
		if ( !String.isBlank ( inputWrapper.selectedOrgName ) ) {
			Acc.Name= inputWrapper.selectedOrgName;
           
		}
        if ( !String.isBlank ( inputWrapper.selectedOrgType )) {
            Acc.Organisation_Type__c = inputWrapper.selectedOrgType;
        }
        if ( !String.isBlank ( inputWrapper.selectedOrgSubType ) ) {
            Acc.Organisation_sub_type__c = inputWrapper.selectedOrgSubType;
        }

        if ( !String.isBlank ( inputWrapper.selectedBusinessType ) ) {
            Acc.Business_Type__c = inputWrapper.selectedBusinessType;
        }
		npaaWrapper = new NPAAApplicationWrapper ();
        try {
            upsert Acc;
       } catch ( Exception Ex) {
           npaaWrapper = new NPAAApplicationWrapper ( 'Error while upserting Account ' +ex.getMessage () );
           return npaaWrapper;
       }

        
		Opportunity oppRecord = populateOpportunity ( inputWrapper );

        oppRecord.RecordTypeId = oppRecType.id;
        oppRecord.AccountId = Acc.id;
        oppRecord.Name = 'Test';
        oppRecord.StageName = 'Product Select';
        oppRecord.closedate = datetime.now().date();
        oppRecord.ibb_product__c = product.id;
        oppRecord.Interested_in__c = product.ibb_product_set__r.name;
        
        oppRecord.ProductEventDirector__c = EventHelper.GetDirectorIdByProductSet(product.ibb_product_set__c);        
        
        system.debug('Director on opp:' + oppRecord.ProductEventDirector__c);
        
        system.debug('About to insert opp');

        try {
            upsert oppRecord;
        } catch ( Exception Ex) {
           npaaWrapper = new NPAAApplicationWrapper ( 'Error while upserting Opportunity ' +ex.getMessage () );
           return npaaWrapper;
        }
        system.debug('insert opp finished');

        if(oppRecord.HPP_extended_opportunity__c == null){
            HPP_extended_opportunity__c tempExOpp = new HPP_extended_opportunity__c ();
            tempExOpp.Opportunity__c = oppRecord.id;
            
            try {
                insert tempExOpp;
            } catch ( Exception Ex) {
               npaaWrapper = new NPAAApplicationWrapper ( 'Error while inserting extended Opportunity ' +ex.getMessage () );
               return npaaWrapper;
            }

            oppRecord.HPP_extended_opportunity__c = tempExOpp.id;
            try {
                update oppRecord;
            } catch ( Exception Ex) {
               npaaWrapper = new NPAAApplicationWrapper ( 'Error while updating Opportunity for Extended' +ex.getMessage () );
               return npaaWrapper;
            }
        }

        system.debug('Inserted ex opp');
        
        //create applicant
        Applicant__c app = new Applicant__c();
        app.Opportunity__c = oppRecord.id;
        app.Applicant_Number__c = 1;
        app.Primary_Account_Holder__c = true;
        app.Prospect_Customer__c = Acc.id;
        insert app;
                
        IBBEvents ibbEvent = new IBBEvents(oppRecord.ProductEventDirector__c );
        system.debug('Created ibb events');        
        ibbEvent.CreateFirstEvent(oppRecord.id);        
        system.debug('Created first event');


        npaaWrapper.oppty = oppRecord;
        npaaWrapper.Applicant1 = Acc;
        npaaWrapper.Applicant = app;
        
        return npaaWrapper;
    }

    @AuraEnabled
    public static Account fetchExistingAccountDetails ( String accountId ) {
        return [ SELECT Id, Name, Organisation_type__c, Organisation_sub_type__c, Business_Type__c 
                 FROM Account 
                 WHERE Id=: accountId];
    }

     // populate opportunity fields 

     public static Opportunity populateOpportunity ( NPAAInputWrapper inputWrapper ) {
        Opportunity oppRecord = new Opportunity();

        if ( !String.isBlank ( inputWrapper.selectedCampaign ) ) {
            oppRecord.CampaignId = inputWrapper.selectedCampaign;
        }

        if ( !String.isBlank ( inputWrapper.selectedHowHear ) ) {
            oppRecord.How_did_you_hear_about_IBB__c = inputWrapper.selectedHowHear;
        }

        return oppRecord;
    }

    
}