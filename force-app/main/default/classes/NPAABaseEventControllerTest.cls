/**
 * @description       : 
 * @author            : Rishitha
 * @group             : 
 * @last modified on  : 05-30-2022
 * @last modified by  : Rishitha
**/
@isTest
public class NPAABaseEventControllerTest {
  @isTest
    static void testMethod1() {
        
        test.startTest();
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();  
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Testfirstname','TestLastname');
        oHelp.Director(director.id);
        id product = createproduct();
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
        
        List<Account> accList = new List<Account>();
        Account acc1 =new Account();
        acc1.Name='Test1';
        accList.add(acc1);
        Account acc2 =new Account();
        acc2.Name='Test2';
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
        app1.Opportunity__c=o.id;
        appList.add(app1);
        Applicant__c app2 =  new Applicant__c();
        app2.Prospect_Customer__c=accList[0].id;
        app2.Opportunity__c=o.id;
        appList.add(app2);
        insert appList;
        Profile pf = [select id from profile where name = 'System Administrator' limit 1 ];
        User us = new User();
        us.Username= 'trghygjhaf@gmail.com';
        us.LastName='test';
        us.Email= 'abctest@gmail.com';
        us.Alias='ates';
        us.TimeZoneSidKey= 'Europe/London';
        us.LocaleSidKey='en_GB';
        us.EmailEncodingKey='ISO-8859-1';
        us.profileId = pf.Id;
        us.LanguageLocaleKey='en_US';
        us.Branch__c='DEWSBURY';
        us.EBSUserId__c='12234';
        
        insert us;
       
        ProductEventDirector__c ped = new ProductEventDirector__c();
        ped.Name='data';
        insert ped;
        
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
        insert hpp;
        
        Account_with_IBB__c ibb = new Account_with_IBB__c();
        ibb.Name='toss';
        insert ibb;
        
        List<Asset_Relationship__c> assList = new List<Asset_Relationship__c>();
        Asset_Relationship__c ass1 = new Asset_Relationship__c();
        ass1.Account_with_IBB__c = ibb.id;
        ass1.Prospect_Customer__c = accList[0].id;
        assList.add(ass1);
        Asset_Relationship__c ass2 = new Asset_Relationship__c();
        ass2.Account_with_IBB__c = ibb.id;
        ass2.Prospect_Customer__c = accList[0].id;
        assList.add(ass2);
        insert assList;
        
            
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper(log.id,null);
       /* 
        wrap.CreatedEvent=log;
        wrap.EventLog=log;
        wrap.Event=e;
        wrap.CurApp=28;
        wrap.opportunityId='12345678';
        wrap.BaseOpportunity=o;
        wrap.IsCompleted=true;
        wrap.oppId='1234';
        wrap.Accounts=accList;
        wrap.lstAccountIds=strList;
        wrap.Applicants=appList;
        wrap.oDirector=ped;
        IBB_Product__c Prod = wrap.Prod;
        IBB_Product_set__c prodSet = wrap.prodSet;
        Date EventCreatedDate = wrap.EventCreatedDate;
        string BudgetPlannerVersion = wrap.BudgetPlannerVersion;*/
        Boolean ProductSwitch = wrap.ProductSwitch;
        Boolean IsUserAuthorised = wrap.IsUserAuthorised;
        Date EventCompletedDate = wrap.EventCompletedDate;
        string EventCompletedBy = wrap.EventCompletedBy;
        Boolean EventComplete = wrap.EventComplete;
        Boolean isCreditRiskUser = wrap.isCreditRiskUser;
        boolean IsCredit = wrap.IsCredit;
        Boolean is_BP_V1 = wrap.is_BP_V1;
        Boolean is_BP_V2 = wrap.is_BP_V2;
        Boolean IsBTL = wrap.IsBTL;
        String lightningErrorMsg = wrap.lightningErrorMsg;
        RecordType recType= wrap.recType;
        wrap.GoToNextEvent();
        wrap.getNumApplicants();
        wrap.IsCorrectPage('3');
        wrap.CorrectPage('5');
        BudgetPlannerConfig__c item=[select id,Single_App_1_Dep_ONS__c,Single_App_2_Dep_ONS__c,SingleApp_ONS__c,
                                     Joint_App_ONS__c,Joint_App_1_Dep_ONS__c,Joint_App_2_Dep_ONS__c,
                                     Joint_App_3_Dep_ONS__c,Triple_ONS__c,Triple_with_children_ONS__c 
                                     from BudgetPlannerConfig__c limit 1];
        wrap.ONS(item,'Single App + 1 dependent');
        wrap.ONS(item,'Single App + 2 dependents');
        wrap.ONS(item,'Single App');
        wrap.ONS(item,'Joint App');
        wrap.ONS(item,'Joint App + 1 dependent');
        wrap.ONS(item,'Joint App + 2 dependent');
        wrap.ONS(item,'Joint App 3 or more dependents');
        wrap.ONS(item,'Triple');
        wrap.ONS(item,'Triple with children');
        
         /*
        Account Acc = wrap.Acc;
        wrap.LoadEvent();
        Opportunity Opp = wrap.Opp;
        String RMStatus = wrap.RMStatus;
        Attachment attachToCustomer = wrap.attachToCustomer;*/
        String AccountIds = wrap.AccountIds;
        Opportunity thisOpp = wrap.thisOpp;
        wrap.CompleteEvent();
        wrap.GetAccount('0012z00000AAAbgAAH','test');
        wrap.GetAccount(2,'test3');
        wrap.GetAccount('test4');
        wrap.RemoveDuplicateAccounts(assList);
        NPAABaseEventController.Wrapper wrap1 = new NPAABaseEventController.Wrapper();
        Date EventCreatedDate =wrap1.EventCreatedDate;
        Date EventComplDate = wrap1.EventCompletedDate;
        String EventCompleted = wrap1.EventCompletedBy;
        test.stopTest();
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
        ps.Name ='test';
        insert ps;
        System.debug('8= '+ps);
    }
}