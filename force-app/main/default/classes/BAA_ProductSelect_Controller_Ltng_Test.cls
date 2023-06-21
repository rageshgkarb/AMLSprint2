@isTest
public class BAA_ProductSelect_Controller_Ltng_Test {
    
    @isTest
    static void createTestData() {
        
        test.startTest();
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();  
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Testfirstname','TestLastname');
        oHelp.Director(director.id);
        id product = createproduct(director.id);
        
       
        opportunity o= oHelp.build();
        o.name = 'test';
        o.stagename = 'Open';
        o.closedate = date.today();
        o.ProductEventDirector__c = director.id;
        o.IBB_Product__c = product;
        o.caa_decision__c = 'Test';
        o.From_Upload__c = true;
        o.interested_in__c = 'test';
        update o;
        
        Event__c e = dHelp.Event;
        e.name = 'Awaiting Valuation';
       
        e.CustomPageLocation__c = '/apex/CAA_PersonalDetails';
     
        update e;
        
        Eventlog__c log = new Eventlog__c();
        log.event__c = e.id;
        log.eventstatus__c = 'Open';
        log.isexpired__c = false;
        log.opportunity__c = o.id;
        log.CreatedDate__c = date.today();
        log.CompletedBy__c = 'Rishi';
        log.ActualCompletedDate__c = date.today();
        insert log;
        
        
           
        
        test.stopTest();
    }

    static Id createproduct(String directorId){
        IBB_Product__c prod = new IBB_Product__c();
        
        createDocuGenSetting();
        CongaSettings__c docu = [select id from CongaSettings__c limit 1];
        
        prod.congaISATransfer__c = docu.Id;
        createProductSet(directorId);
        IBB_Product_Set__c  ps = [select id from IBB_Product_Set__c limit 1];
        prod.IBB_Product_Set__c = ps.id;
        
        prod.Staff_Only_Product__c = 'yes';
        prod.Term__c= '6 Months';
        prod.Max_finance_to_value_FTV__c= 22.1;
        prod.Rental_Rate_Type__c = 'F';
        prod.Benchmark_rate__c= 22.22;
        prod.Rent_or_occupancy__c= 'rent';
        prod.Offer_Letter_Version__c='Pre-September 2014';
        prod.Fixed_or_Discounted__c='Fixed';
        prod.Type_of_product_for_solicitor_letter__c ='HPP';
        prod.Product_live_date__c= system.today();
        prod.Short_Product_Name__c= 'testproduct';
        prod.Account_Type__c='Bid Bonds';
        prod.Product_code__c= 'The IBB product code';
        
        prod.Category_of_Product__c= 'Current Account';  
        prod.Type_of_Product__c= 'Current Account';
        prod.Product_Description__c= 'testproduct';
        prod.Profit_calculated__c='monthly';
        prod.Profit_Rate__c= 3.3574;
        prod.Profit_accrued__c= 'monthly';
        prod.Profit_paid_to__c='External account';
        prod.Statement_frequency__c='Monthly';
        prod.Name='test';
        prod.DocuGen_Liability_App_1_CAA_Face2Face__c = docu.Id;
        prod.DocuGen_Liability_App_2_CAA_Face2Face__c = docu.Id;
        prod.DocuGen_Liability_App_3_CAA_Face2Face__c = docu.Id;
        prod.Conga_Liability_App_1_caa__c = docu.Id;
        prod.Conga_Liability_App_2_caa__c = docu.Id;
        prod.Conga_Liability_App_3_caa__c = docu.Id;
        prod.Conga_Failed_EKYC_Letter__c = docu.Id;
        insert prod;
        return prod.id;
    }
    static void createDocuGenSetting() {
        CongaSettings__c docu= new CongaSettings__c();
        docu.Name ='test';
        docu.Document_name__c = 'test';
        /*docu.Queries__c = '{"Queries":[{"QueryId":"a5aD0000000GmfWIAS","Order":1,"Name":"Applicant2","Alias":""}]}';
        docu.Templates__c = '{"Templates":[{"TemplateId":"a5bD0000000GmisIAC","SystemModstamp":null,"Order":0,"Name":"AIP Letter","MinApplicants":0,"AttachmentId":null}]}';
        */
        insert docu;
        System.debug('8= '+docu);
        
    }
    static void createProductSet(String directorId){
        IBB_Product_Set__c  ps = new IBB_Product_Set__c();
        ps.Name ='test';
        ps.EventDirector__c=directorId;
        insert ps;
        
        System.debug('8= '+ps);
    }
    
    static testMethod void testCampaignOppNegative () {
        Campaign camp = new Campaign ();
        camp.Name = 'Test Campaign';
        camp.IsActive = true;
        insert camp;
        
       
        system.debug (' campaignRecord' + camp);
        createTestData();
        IBB_Product__c prod = [ SELECT Id, Name,ibb_product_set__c FROM IBB_Product__c LIMIT 1 ];
        system.debug('ibb_product_set__c in test='+prod);
        NPAAInputWrapper inputWrapper = new NPAAInputWrapper ();
        inputWrapper.selectedOrgType = 'Limited Company';
         inputWrapper.selectedBusinessType = 'Business';
         inputWrapper.selectedOrgSubType = 'Public Limited Company (Plc)';
         inputWrapper.selectedAccountType = 'Current Account';
         inputWrapper.selectedAccessType = 'Limited Company';
         inputWrapper.selectedProductItem = ''+prod.Id;
         inputWrapper.selectedCampaign = ''+camp.Id;
         inputWrapper.selectedHowHear = 'Press advertising';
         inputWrapper.selectedOrgName = 'ABCCCMP';
        inputWrapper.Name = 'ABCCCMP';
        inputWrapper.existingAccountId = '';
        String inputJSON =  JSON.serialize( inputWrapper );
        ProductEventDirector__c director = [SELECT Id, Name FROM ProductEventDirector__c LIMIT 1];
         System.debug(' director.id' + director.id);
        //String wrapperObj = '{"selectedOrgType":"Limited Company","selectedBusinessType":"Business","selectedOrgSubType":"Public Limited Company (Plc)","selectedAccountType":"Current Account","selectedAccessType":"Instant","selectedProductItem":"a0mD0000005eJ31IAE","selectedCampaign":"7013z000001eUuHAAU","selectedHowHear":"Press advertising","selectedOrgName":"ABCCCMP"}';
        System.debug ( 'resultt'+BAA_ProductSelect_Controller_Lightning.createApplication (inputJSON));
        
        
        
        
    }
    
    
    static testMethod void testExistingAccountDetails () {
        createTestData();
        Account accountRecord = [ SELECT Id, Name FROM Account LIMIT 1];
        BAA_ProductSelect_Controller_Lightning.fetchExistingAccountDetails ( ''+accountRecord.Id );
    }
    static testMethod void testCampaignList () {
        Campaign camp = new Campaign ();
        camp.Name = 'Test Campaign';
        camp.IsActive = true;
        insert camp;
        BAA_ProductSelect_Controller_Lightning.fetchCampaignList ();
    }

}