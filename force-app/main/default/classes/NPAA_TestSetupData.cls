@istest
public class NPAA_TestSetupData {
   
      public static void dataSetup() {
        
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();  
        
        Account_with_IBB__c ibb = new Account_with_IBB__c();
        ibb.Name='toss';
        insert ibb;
        
        ibb.Name = ibb.Id;
          update ibb;
          
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Testfirstname','TestLastname');
        oHelp.Director(director.id);
        id product = createproduct();
        opportunity o= oHelp.build();
        o.name = 'test1';
        o.stagename = 'Open';
        o.closedate = date.today();
        o.ProductEventDirector__c = director.id;
        o.IBB_Product__c = product;
        o.caa_decision__c = 'Test';
        o.From_Upload__c = true;
        o.interested_in__c = 'Director';
        o.General_comments_box__c = 'test';
          o.Mandate_Set_Up__c=true;
         o.Customer_Images_Set_Up__c=true;
        o.User_Branch__c='Head Office Birmingham';
        o.Attachment_App_Form__c='Attachemnet form';
        o.Attachment_Welcome_Letter__c='Welcome letter';
        o.Account_with_IBB__c = ibb.Id;
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
          log.Name='Awaiting Valuation';
        insert log;
          
          XML_Message__c x = new XML_Message__c();
          x.Type__c = 'Request';
          x.Name = 'DecisionEngineRequest';
          x.Active__c = true;
          x.Element_Name__c = 'TEST OpenCustomerAccount';
          x.Buffered__c=false;
          
          insert x;
          
          BAADecisionEngineMatrix__c mt = new BAADecisionEngineMatrix__c();
          mt.DoAML__c = true;
          mt.DoCredit__c = true;
          mt.DoSanction__c = true;
          mt.Name = 'Director';
          mt.EntityType__c='Director';
          mt.DoSetUp__c=true;
          mt.ProductCategory__c='Director';
          
          insert mt;
          
          IBB_Product_Set__c ps = [select id,name from IBB_Product_Set__c limit 1];
          mt.ProductCategory__c = ps.name;
          update mt;
        
        List<Account> accList = new List<Account>();
        Account acc1 =new Account();
        acc1.Name='Test11';
        accList.add(acc1);
        Account acc2 =new Account();
        acc2.Name='Test12';
        accList.add(acc2);
        insert accList;
        
        List<string> strList = new List<String>();
        string Str ='testdata';
        string str1 ='datatest';
        strList.add(str);
        strList.add(str1);
        
        List<Applicant__c> appList = new List<Applicant__c>();
        Applicant__c app1 =  new Applicant__c();
        app1.Prospect_Customer__c=accList[0].id;
          app1.Applicant_Number__c=12;
              app1.Is_Director__c='Yes';
              app1.Is_Signatory__c='No';
              app1.Is_Shareholder__c='No';
        app1.Opportunity__c=o.id;
        appList.add(app1);
        Applicant__c app2 =  new Applicant__c();
        app2.Prospect_Customer__c=accList[0].id;
          app2.Applicant_Number__c=34;
              app2.Is_Director__c='Yes';
              app2.Is_Signatory__c='No';
              app2.Is_Shareholder__c='No';
        app2.Opportunity__c=o.id;
        appList.add(app2);
        insert appList;
        profile prof = [Select id from Profile where name = 'System Administrator' limit 1];
        User us = new User();
        us.Username= 'trghygjhaf@gmail.com';
        us.LastName='test';
        us.Email= 'abctest@gmail.com';
        us.Alias='ates';
        us.TimeZoneSidKey= 'Europe/London';
        us.LocaleSidKey='en_GB';
        us.EmailEncodingKey='ISO-8859-1';
        us.profileId = prof.id;
        us.LanguageLocaleKey='en_US';
        us.Branch__c='DEWSBURY';
        us.EBSUserId__c='12234';
        insert us;
        
        ProductEventDirector__c ped = new ProductEventDirector__c();
        ped.Name='data';
        insert ped;
          Credit_Score__c cs= new Credit_Score__c();
          cs.Decision__c='SYSTEMERROR';
         
          cs.Prospect_Customer__c=accList[0].id;
          cs.Opportunity__c=o.id;
          insert cs;
        
        BudgetPlannerConfig__c conf = new BudgetPlannerConfig__c();
        conf.SingleApp_ONS__c=23;
        conf.Single_App_1_Dep_ONS__c=54;
        conf.Single_App_2_Dep_ONS__c=98;
        conf.Joint_App_ONS__c=76;
        conf.Joint_App_1_Dep_ONS__c=65;
        conf.Joint_App_2_Dep_ONS__c=45;
        conf.Joint_App_3_Dep_ONS__c=12;
        conf.Triple_ONS__c=32;
        conf.Triple_with_children_ONS__c=9;
        insert conf; 
       
        HPP_extended_opportunity__c hpp = new HPP_extended_opportunity__c();
        hpp.Opportunity__c=o.id;
          hpp.Application_form_signed__c=true;
          hpp.Documents_Received__c=true;
          hpp.All_customer_documents_recieved__c=date.today();
   
        insert hpp;
        /*
        Account_with_IBB__c ibb = new Account_with_IBB__c();
        ibb.Name='toss';
        insert ibb;
       */
          Teller_Settings__c ts = new Teller_Settings__c(Name='ActivityAuditExistsCheck', Value__c = 'false');
          insert ts;
		 Account_Mandate__c am= new Account_Mandate__c(Name='hello',Account_with_IBB__c=ibb.Id);
		insert am;

        List<Asset_Relationship__c> assList = new List<Asset_Relationship__c>();
        Asset_Relationship__c ass1 = new Asset_Relationship__c();
        ass1.Account_with_IBB__c = ibb.id;
        ass1.Prospect_Customer__c = accList[0].id;
        ass1.Is_Active__c=true;
        assList.add(ass1);
        Asset_Relationship__c ass2 = new Asset_Relationship__c();
        ass2.Account_with_IBB__c = ibb.id;
        ass2.Prospect_Customer__c = accList[0].id;
        ass2.Is_Active__c= true;
        assList.add(ass2);
        insert assList;
          
		Teller_Role__c tr = new Teller_Role__c(Name='Salesforce Administrator',User_Role__c='Salesforce Administrator');
        insert tr;
        
        Teller_Function_Root__c tfr = new Teller_Function_Root__c(Name='Account Settings');
        tfr.FX_Limit_Amount_Field_to_Check__c ='test';
        tfr.FX_Limit_Currency_Field_to_Check__c='test';
        insert tfr;

        Teller_Function__c tf = new Teller_Function__c();
        tf.Name = 'Account Settings';
        tf.Teller_Function_Root__c = tfr.Id;
        tf.Is_Account_Function__c = true;
        tf.Is_Teller_Function__c=true;
        tf.Is_Vault_Function__c= true;
        insert tf;
        
        Teller_Access__c ta = new Teller_Access__c(Name='Account Settings');
        ta.Teller_Function__c = tf.Id;
        ta.Teller_Role__c = tr.Id;
        insert ta;
        
    }
    static Id createproduct(){
        IBB_Product__c prod = new IBB_Product__c();
      
        
        createDocuGenSetting();
        CongaSettings__c docu = [select id from CongaSettings__c limit 1];
        
        prod.congaISATransfer__c = docu.Id;
        createProductSet();
        IBB_Product_Set__c	ps = [select id from IBB_Product_Set__c limit 1];
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
    static void createProductSet(){
        IBB_Product_Set__c	ps = new IBB_Product_Set__c();
        ps.Name ='Director';
        insert ps;
         IBB_Product_Set__c	ps1 = new IBB_Product_Set__c();
        ps1.Name ='Shareholder';
        insert ps1;
         IBB_Product_Set__c	ps2 = new IBB_Product_Set__c();
        ps2.Name ='Signatory';
        insert ps2;
        System.debug('8= '+ps);
    }

}