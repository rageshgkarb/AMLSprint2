/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-22-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class CAA_Core_Controller_Test1 {
    @Testsetup
    static void createProspectCustomer() {
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();
        
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test12');
        oHelp.Director(director.id);
        id prod = createproduct();
        opportunity o= oHelp.build();
        o.name = 'test';
        o.stagename = 'Open';
        o.closedate = date.today();
        o.ProductEventDirector__c = director.id;
        o.IBB_Product__c = prod;
        o.caa_decision__c = 'Test';
        o.From_Upload__c = true;
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
        insert log;
        
    }
    /*
    @IsTest 
    static void testGuestUser(){
        
        Account portalAccount = new Account(name = 'External User' );
        insert portalAccount;
        
        Contact portalContact = new contact(
            FirstName = 'External', 
            LastName = 'User', 
            Email = 'abctest@gmail.com', 
            AccountId = portalAccount.Id
        );
        insert portalContact;
        
        User us = new User();
        us.Username= 'trghygjhaf@gmail.com';
        us.LastName='User';
        us.Email= 'abctest@gmail.com';
        us.Alias='ates';
        us.TimeZoneSidKey= 'Europe/London';
        us.LocaleSidKey='en_GB';
        us.EmailEncodingKey='ISO-8859-1';
        us.profileId = '00e3z000001tTBm';
        us.LanguageLocaleKey='en_US';
        us.Branch__c='DEWSBURY';
        us.EBSUserId__c='12234';
        us.IsActive =true;
        insert us;
        
        id prod = createproduct();
        
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();
        
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test');
        oHelp.Director(director.id);
        
        opportunity o= oHelp.build();
        o.name = 'test';
        o.stagename = 'Open';
        o.closedate = date.today();
        o.ProductEventDirector__c = director.id;
        o.IBB_Product__c = prod;
        o.caa_decision__c = 'Test';
        o.From_Upload__c = true;
        update o;
        
        Event__c e = dHelp.Event;
        e.name = 'Awaiting Valuation';
        e.CustomPageLocation__c = '/apex/CAA_PersonalDetails';
        update e;
        
        Eventlog__c log1 = new Eventlog__c();
        log1.event__c = e.id;
        log1.eventstatus__c = 'Open';
        log1.isexpired__c = false;
        log1.opportunity__c = o.id;
        insert log1;
		
        Account Acc = oHelp.acc;   
        
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
            
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
            
        
            
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=Acc.id;
        apl.Opportunity__c=log.opportunity__c;
        //insert apl;
        campaign  c = new campaign();
        c.Name = 'Test Campaign';
        insert c;
        
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=Acc.id;
        es.Opportunity__c= o.id;
        insert es;
       
        system.runAs(us){
   
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
            CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
            String m_SessionId = core.m_SessionId;
            String SessionId = core.SessionId;
            CAA_Core_Controller_Lightning.CallRM(log.id,SessionId,false,false);
        } 
    }
    */
    @IsTest 
    static void testMethod1(){
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        //insert apl;
        campaign  c = new campaign();
        c.Name = 'Test Campaign';
        insert c;
		List<CAA_Settings__c> caaSeeting = new List<CAA_Settings__c>();
        CAA_Settings__c caa = new CAA_Settings__c();
        caa.Name ='UseFITAccount';
        caa.Value__c ='YES';
        caaSeeting.add(Caa);
        CAA_Settings__c caa1 = new CAA_Settings__c();
        caa1.Name ='UseISAFITAccount';
        caa1.Value__c ='YES';
        caaSeeting.add(Caa1);
        insert caaSeeting;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();
        
        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        Test.setMock(HttpCalloutMock.class, new RestMock());
        test.startTest();
        CAA_Core_Controller_Lightning.GetHostData(log.id);
        CAA_Core_Controller_Lightning.CompleteSummary(log.id);
        CAA_Core_Controller_Lightning.AddApplicant(log.id,acc.id);
        CAA_Core_Controller_Lightning.GetProductSuitability();
        CAA_Core_Controller_Lightning.CreateANC('test',acc.id);
        CAA_Core_Controller_Lightning.GetApplicantData(log.id,SessionId);
        CAA_Core_Controller_Lightning.GetRMApplicantData(log.id,SessionId);
        CAA_Core_Controller_Lightning.RemoveApplicant(acc.id,log.id);
        CAA_Core_Controller_Lightning.FindExistingAccounts('Test',log.id);
         CAA_Data.AddNewApplicantData appdata = new CAA_Data.AddNewApplicantData();
        appdata.FirstName = 'Applicant Account DM1';
        appdata.LastName = 'Force26';
        appdata.Title = 'xyz'; 
        CAA_Core_Controller_Lightning.IsExistingAccount(appdata,log.id,true);
        CAA_Data.ProductSelectedData data = new CAA_Data.ProductSelectedData();
        data.ProductId = Product.Id;
        data.PurposeOfAccount = 'Loan';
        data.NumberOfApplicants = 20;  
        data.Deposit =123.01;
        data.AccountId =acc.Id;
        CAA_Core_Controller_Lightning ob = new CAA_Core_Controller_Lightning();
        data.OpportunityId= o.Id;
        data.Receive_Salary_Benefits = true;
        data.Pay_Bills_Expenses= true;
        data.Domestic_Transfers_In_Out= true;
        data.International_Transfer_In_Out= true;
        data.Cash_Deposit_In_Out= true;
        data.Saving_Goals= true;
        data.Over16= 'test';
        data.Regular_payment_amount_c = 123.23;
        data.Payment_Frequency_c='test';
        data.Direct_debit_date_day_c='test';
        data.Name_of_current_Bank_Building_Society_c='test';
        data.Sort_Code_c = '123';
        
        data.HasRegularPayment= 'test';
        //CAA_Core_Controller_Lightning.ProductSelected(data, SessionId, false, false, false, false, false, false,false,false,false,false,false,false);     
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        //personaldata.Campaign = c.Id;
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = acc.id;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
        //CAA_Core_Controller_Lightning.SavePersonalDetails(personaldata,SessionId);
        //CAA_Core_Controller_Lightning.GetDocumentData(log.id,SessionId,'test');
		CongaSettings__c docu = [select id from CongaSettings__c limit 1];
		//CAA_Core_Controller_Lightning.CreateDocument(log.id,SessionId,docu.id);
        //CAA_Core_Controller_Lightning.CompletePersonalDetails(personaldata,SessionId);
        //CAA_Core_Controller_Lightning.CompletePersonalDetailsOverride(personaldata,SessionId);
        //CAA_Core_Controller_Lightning.CompleteRM(personaldata,SessionId);
        CAA_Core_Controller_Lightning.ApplicantDeclaration appli = new CAA_Core_Controller_Lightning.ApplicantDeclaration();
        appli.capacity ='test';
        //CAA_Core_Controller_Lightning.CallDe(log.id,SessionId,new List<CAA_Core_Controller_Lightning.ApplicantDeclaration>{appli});
        //CAA_Core_Controller_Lightning.CallRM(log.id,SessionId,false,false);
        CAA_Core_Controller_Lightning.CallAJE(log.id,SessionId);
        //CAA_Core_Controller_Lightning.CallEBS(log.id,SessionId,null);
        //CAA_Core_Controller_Lightning.CallEBSDE(log.id,SessionId);
        CAA_Core_Controller_Lightning.SetupFTD(log.id);
        CAA_Core_Controller_Lightning.FTDSetup(log.id);
        CAA_Core_Controller_Lightning.CompleteExternal(log.id,SessionId);
        CAA_Core_Controller_Lightning.CompleteSummaryExternal(log.id,SessionId);
        CAA_Core_Controller_Lightning.FTDSetupInit(log.id);
        CAA_Data.SetupFTDInitData setdata = new CAA_Data.SetupFTDInitData();
        
        setdata.PaymentAmount =1234.01;
        setdata.AJECompleted =true;
        setdata.FTDCompleted= true;
        setdata.ShowAJE= true;
        CAA_Core_Controller_Lightning.FTDSetupSave(log.id,setdata);
        CAA_Core_Controller_Lightning.SaveISATransfer(log.id,SessionId,null,false);
        CAA_Core_Controller_Lightning.Eligibility(null);
        CAA_Core_Controller_Lightning.FindCustomer('Test');
        CAA_Core_Controller_Lightning.GetCampaigns('Test');
        test.stopTest();
    }

    @IsTest 
    static void testMethod2(){
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        //insert apl;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        ApexPages.currentPage().getParameters().put('id',log.Id);
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;  
        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        Test.setMock(HttpCalloutMock.class, new RestMock());
        test.startTest();
        String logId = log.id;
        CAA_Core_Controller_Lightning.GetHostData(logId);
        CAA_Core_Controller_Lightning.CompleteSummary(log.id);
        CAA_Core_Controller_Lightning.AddApplicant(log.id,acc.id);
        CAA_Core_Controller_Lightning.GetProductSuitability();
        CAA_Core_Controller_Lightning.CreateANC('test',acc.id);
        CAA_Core_Controller_Lightning.GetApplicantData(log.id,SessionId);
        CAA_Core_Controller_Lightning.GetRMApplicantData(log.id,SessionId);
        CAA_Core_Controller_Lightning.RemoveApplicant(acc.id,log.id);
        CAA_Core_Controller_Lightning.FindExistingAccounts('Test',log.id);
         CAA_Data.AddNewApplicantData appdata = new CAA_Data.AddNewApplicantData();
        appdata.FirstName = 'Applicant Account DM1';
        appdata.LastName = 'Force26';
        appdata.Title = 'xyz'; 
        CAA_Core_Controller_Lightning.IsExistingAccount(appdata,log.id,true);
        CAA_Data.ProductSelectedData data = new CAA_Data.ProductSelectedData();
        data.ProductId = Product.Id;
        data.PurposeOfAccount = 'Loan';
        data.NumberOfApplicants = 20;  
        data.Deposit =123.01;
        data.AccountId =acc.Id;
        CAA_Core_Controller_Lightning ob = new CAA_Core_Controller_Lightning();
        data.OpportunityId= o.Id;
        data.Receive_Salary_Benefits = true;
        data.Pay_Bills_Expenses= true;
        data.Domestic_Transfers_In_Out= true;
        data.International_Transfer_In_Out= true;
        data.Cash_Deposit_In_Out= true;
        data.Saving_Goals= true;
        data.Over16= 'test';
        data.Regular_payment_amount_c = 123.23;
        data.Payment_Frequency_c='test';
        data.Direct_debit_date_day_c='test';
        data.Name_of_current_Bank_Building_Society_c='test';
        data.Sort_Code_c = '123';
        data.HasRegularPayment= 'test';
        //CAA_Core_Controller_Lightning.ProductSelected(data,SessionId,false,false,false,false,false,false);
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        personaldata.Campaign = 'test';
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = acc.id;
        app.HasMail = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
        CAA_Core_Controller_Lightning.checkIsFTD(log.id);
        CAA_Core_Controller_Lightning.getLoadSourceofFundPickLists();
        getApplicantListTest();
        getLoadSourceofFundPickListsTestCopy();

        test.stopTest();
    }
    
    static void createOpportunity() {
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Current Account-LIB946568';
        
        opp.Hand_out_Introductory_Leaflets__c = True;   
        opp.Purpose_of_Account_Account_T_Cs__c =True;  
        opp.Paying_in_book__c = True; 
        opp.Statements__c = True; 
        opp.Telephone_Banking__c	= True; 
        opp.Online_Banking__c= True; 
        opp.Tariff_List__c= True; 
        opp.Counter_Fee_Current_Account_Only__c= True; 
        opp.Debit_Card_Current_Account_Only__c= True; 
        opp.PIN_Current_Account_Only__c= True; 
        opp.Chequebook_Current_Account_Only__c= True;    
        opp.closedate=date.parse('12/04/2023');
        opp.StageName = 'Completed';
        opp.Finance_Required__c=600000;
        opp.Purpose_of_Finance__c= 'Refinancing';
        opp.Term_of_Finance__c=6000;
        opp.Purchase_price_market_value__c=800000;
        
        //   opp.Seller__c      lookup user
        
        User us = [select id from user limit 1];
        
        
        
        // opp.No_of_Applicants__c=38;
        opp.Keep_up_to_date_New__c = 'yes';
        opp.Products_Interested_In_with_IBB__c ='Buy To Let Purchase Plan';
        opp.Marketing_Consents_Preferences__c='Contact by All Methods';
        
        opp.CloseDate = date.today();
        opp.CAA_Decision__c='Test';
        
        Campaign camp = [select id from Campaign limit 1];
        opp.CampaignId =camp.id;
        Account acc = [select id from Account limit 1];
        opp.AccountId = acc.id;
        
        opp.US_Person_Signed_App_Form_Received__c=true;
        // opp.Application_Reference_Number__c='';
        
        
        // opp.EventLog__c = event.id;
        insert opp;
        System.debug('8= '+opp);
        
    }
    static void createUser(){
        User us = new User();
        us.Username= 'trghygjhaf@gmail.com';
        us.LastName='test';
        us.Email= 'abctest@gmail.com';
        us.Alias='ates';
        us.TimeZoneSidKey= 'Europe/London';
        us.LocaleSidKey='en_GB';
        us.EmailEncodingKey='ISO-8859-1';
        us.profileId = '00eD0000001QbyY';
        us.LanguageLocaleKey='en_US';
        us.Branch__c='DEWSBURY';
        us.EBSUserId__c='12234';
        
        insert us;
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
    private class RestMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = 'Json Response';
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    
    
       @isTest
    static void getLoadSourceofFundPickListsTestCopy(){
         CAA_Picklist__c caa = new CAA_Picklist__c();
        caa.name = 'Testing';
        caa.value__c = '78987';
        caa.text__c = 'test';
        caa.Field__c = 'SOURCEOFFUNDS';
        insert caa;
        CAA_Core_Controller_Lightning.getLoadSourceofFundPickLists();
    }
    
    @isTest
    Public static Void testMethod3(){
        
        CAA_Core_Controller_Lightning.HasEmailOption = true;
		System.assertEquals(CAA_Core_Controller_Lightning.HasEmailOption, true);
        CAA_Core_Controller_Lightning.HasMailOption = true;
		System.assertEquals(CAA_Core_Controller_Lightning.HasMailOption, true);
        CAA_Core_Controller_Lightning.HasPhoneOption = true;
		System.assertEquals(CAA_Core_Controller_Lightning.HasPhoneOption, true);
        CAA_Core_Controller_Lightning.HasSMSOption = true;
		System.assertEquals(CAA_Core_Controller_Lightning.HasSMSOption, true);
        
        CAA_Core_Controller_Lightning ccc = New CAA_Core_Controller_Lightning();
        /*ccc.AncEbsId = 'xyz';
		System.assertEquals(ccc.AncEbsId, 'xyz');
        ccc.AncFirstName = 'xyz';
		System.assertEquals(ccc.AncFirstName, 'xyz');
        ccc.AncLastName = 'xyz';
		System.assertEquals(ccc.AncLastName, 'xyz');
        ccc.EligibilityAccDate = 'xyz';
		System.assertEquals(ccc.EligibilityAccDate, 'xyz');
        */
        
        //Opportunity op2 = new Opportunity();
        //CAA_Core_Controller_Lightning.m_Opp = op2;
        //
        
        CAA_Core_Controller_Lightning.init_wrap ini = new CAA_Core_Controller_Lightning.init_wrap();
        ini.DeResponse='';
        ini.ibbProductName='';
        ini.OppLibRef='';
        ini.AllowComplete=false;
        ini.EventLogId='';
        ini.isISA=false;
        ini.IsYPSA=false;
        ini.loginURL='';
        ini.showYPSATC=false;
        ini.showYPNATC=false;
        ini.showSavingText=false;
        ini.showCurrentAccountTC=false;
        List<String> li = new List<String>();
        ini.applicantNames = li;
        
        ini.FirstName='';
        ini.LastName='';
        ini.Salutation='';
        ini.Email='';
        ini.PreferedContact='';
        ini.Postcode='';
        ini.WebFormDataId='';
        ini.EligibilityAccDate='';
        ini.AncEbsId='';
        ini.AncFirstName ='';
        ini.AncLastName='';
        
        //CAA_Core_Controller_Lightning.ANCSetup('');
        
        
       /*@AuraEnabled public transient String DeResponse { get; set; }
       @AuraEnabled public String ibbProductName { get; set; }
       @AuraEnabled public transient String OppLibRef { get; set; }
       @AuraEnabled public Boolean AllowComplete { get; set; }
       @AuraEnabled public List<Case> Cases { get;set; }
       @AuraEnabled public List<Opportunity> opps { get;set; }
       @AuraEnabled public string EventLogId{ get;set; }
       @AuraEnabled public Boolean isISA{get;set;}
       @AuraEnabled public Boolean IsYPSA{get;set;} 
       //@AuraEnabled public List<String> applicantNames{get;set;}
       @AuraEnabled public String loginURL {get;set;}
       @AuraEnabled public Boolean showYPSATC {get;set;}
       @AuraEnabled public Boolean showYPNATC {get;set;}
       @AuraEnabled public Boolean showSavingText {get;set;}
       @AuraEnabled public Boolean showCurrentAccountTC {get;set;}
*/
    }
    
    
     @isTest
     static list<String> getApplicantListTest(){
        String jsonInput = '[ "powerCord", "RavindranathReddy" ]';
        CAA_Core_Controller_Lightning.getApplicantList(jsonInput);
        return null; 
        
    }
    
   	
    @isTest
    Public static Void isYPSAAccountTest(){
        Account acc =new Account();
        //acc.Salutation = 'Mr';
        acc.Name='Test';
        acc.Date_of_Birth__c = Date.newInstance(2022, 01, 01);
        acc.Customer_Type__c = 'Minors (EB)';
        insert acc;
        CAA_Core_Controller_Lightning ccc = New CAA_Core_Controller_Lightning();
        ccc.m_AccountId = acc.Id;
        String xyz = ccc.isYPSAAccount;
        
    }
   
    @isTest
    Public static Void SavePersonalDetailsTest(){
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];

        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        //insert apl;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        
        Campaign cam=new Campaign();
        cam.name='test';
        cam.IsActive=true;
        cam.StartDate=Date.today();
        cam.Type='TV';
        insert cam;
        
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        personaldata.Campaign = cam.Id;
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = acc.id;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
        app.LastName = 'test';
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
            
        CAA_Core_Controller_Lightning.SavePersonalDetails(personaldata,SessionId);
    }
    
    @isTest
    Public static Void GetDocumentDataTest(){
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test');
        oHelp.Director(director.id);
        id prod = createproduct();
        opportunity o= oHelp.build();
        
        o.name = 'test';
        o.stagename = 'Open';
        o.closedate = date.today();
        o.ProductEventDirector__c = director.id;
        o.IBB_Product__c = prod;
        o.caa_decision__c = 'Test';
        o.From_Upload__c = true;
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
        insert log;
        
        CAA_Core_Controller_Lightning.GetDocumentData(log.id,'xyz','DOCS');
    }
    
    /*@isTest
    Public static Void MakePaymentTest(){
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();
        
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test');
        oHelp.Director(director.id);
        id prod = createproduct();
        opportunity o= oHelp.build();
        o.name = 'test';
        o.stagename = 'Open';
        o.closedate = date.today();
        o.ProductEventDirector__c = director.id;
        o.IBB_Product__c = prod;
        o.caa_decision__c = 'Test';
        o.From_Upload__c = true;
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
        insert log;
        
        IBBOpportunityPayment__c oppPayment = new IBBOpportunityPayment__c ();
        
        CAA_Core_Controller_Lightning.MakePayment(null,null,log.id,'xyz');
    }*/
    
    @isTest
    Public static Void CallDetest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        /*Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;*/
        
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();
        
        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        List<CAA_Core_Controller_Lightning.ApplicantDeclaration> appli = new List<CAA_Core_Controller_Lightning.ApplicantDeclaration>();
        for(Integer i = 0; i<=1; i++){
            CAA_Core_Controller_Lightning.ApplicantDeclaration appli1 = new CAA_Core_Controller_Lightning.ApplicantDeclaration();
            	appli1.capacity='Self';
            	appli.add(appli1);     
        }
		//Test.setMock(HttpCalloutMock.class, new RestMock());
        String logId = log.id;
        z_XmlMessage.CreateXmlMessageDE(); 
        System.test.startTest();         
        z_WebServiceMock mock = new z_WebServiceMock();
        mock.xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><OperationResponse xmlns="http://www.islamic-bank.com/HPPDecisionEngine"><HPPDecisionEngineResponse><MessageID>a0oD0000007OHwZIAW</MessageID><MessageType>HPPDecisionEngineResponse</MessageType><DecisionId>86BF2236-E7F8-4244-B16B-D1C0E75A59DE</DecisionId><Decision>DECLINE-BDM14;REFER-BDM35;REFER-BDM36;</Decision><DecisionReason>DECLINE-BDM14 (DFF5AC28-6EC6-46A8-AF5F-F73ECD82B0D6 - Property not equal to \'absolute ownership\' in Scotland;) REFER-BDM35 (05B7D6AA-4D0D-472E-B982-652828AA8F3F - No of credit searches within the last 3 months at current address;) REFER-BDM36 (F0FE17BC-621E-40CD-A071-CDD50A252E5A - No of credit searches within the last 3 months at previous address;) </DecisionReason><DecisionExcludingWarnings>REFER-NOMATCH</DecisionExcludingWarnings><AcceptedFacilities /><RejectedFacilities /><SupplierScore>800</SupplierScore></HPPDecisionEngineResponse></OperationResponse></soap:Body></soap:Envelope>';
                     
        System.Test.setMock(WebServiceMock.class,mock);
        CAA_Core_Controller_Lightning.CallDe(log.id,SessionId,appli);
        system.test.stopTest();
    }
    
    @isTest
    Public static Void CallRMtest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        /*Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;*/
        
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        String logId = log.id;
        
        CAA_Core_Controller_Lightning.CallRM(logId,SessionId,False,False);
    }
    
    @isTest
    Public static Void CallEBStest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        acc.Salutation = 'MR';
        acc.PersonEmail = 'Test@gmail.com';
        acc.Home_Telephone_No__c = '34567890';
        acc.Date_Of_Birth__c = Date.newInstance(1992, 12, 9);
        update acc;
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
      	
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        Account_with_IBB__c a = new Account_with_IBB__c ();
        a.Opportunity__c = o.id;
        a.Primary_SFDC_Account__c = acc.id;
        insert a;
        
        
        Asset_Relationship__c ass = new Asset_Relationship__c();
        ass.Account_with_IBB__c = a.id;
        ass.Prospect_Customer__c = acc.id;
        ass.Primary_Account_Holder__c = true;
        insert ass;
        
        Account_Reference_Information__c aInfor = new Account_Reference_Information__c();
        aInfor.Payment_Type__c = 'Test';
        aInfor.Request_Type__c = 'OCA';
        insert aInfor;
        
        Debug__c d = new Debug__c();
        d.opportunity__c = o.id;
        insert d;
        
        Web_Integration_Log__c wlog = new Web_Integration_Log__c();
        wlog.Accountid__c = acc.id;
        wlog.OpportunityId__c = o.Id;
        wlog.Request_Action__c = 'AddNewCustomer';
        insert wlog;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
       
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();
        
        ApexPages.currentPage().getParameters().put('accountid',acc.Id);
        ApexPages.currentPage().getParameters().put('webFormDataId','test');
        //core.ANCSetup();
        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        z_XmlMessage.CreateAddNewCustomerMessage();
        z_XmlMessage.CreateAJREssage();
        z_XmlMessage.CreateANCAllMessage();
        Z_TheXmlMessages.CreateOCAMessage();
        //IBBDependentObjectFactory.CreateANCRLAJARStubs (o);
        System.test.startTest(); 
        z_WebServiceMock mock = new z_WebServiceMock();
        mock.xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><OperationResponse xmlns="http://www.islamic-bank.com/HPPDecisionEngine"><HPPDecisionEngineResponse><MessageID>a0oD0000007OHwZIAW</MessageID><MessageType>HPPDecisionEngineResponse</MessageType><DecisionId>86BF2236-E7F8-4244-B16B-D1C0E75A59DE</DecisionId><Decision>DECLINE-BDM14;REFER-BDM35;REFER-BDM36;</Decision><DecisionReason>DECLINE-BDM14 (DFF5AC28-6EC6-46A8-AF5F-F73ECD82B0D6 - Property not equal to \'absolute ownership\' in Scotland;) REFER-BDM35 (05B7D6AA-4D0D-472E-B982-652828AA8F3F - No of credit searches within the last 3 months at current address;) REFER-BDM36 (F0FE17BC-621E-40CD-A071-CDD50A252E5A - No of credit searches within the last 3 months at previous address;) </DecisionReason><DecisionExcludingWarnings>REFER-NOMATCH</DecisionExcludingWarnings><AcceptedFacilities /><RejectedFacilities /><SupplierScore>800</SupplierScore></HPPDecisionEngineResponse></OperationResponse></soap:Body></soap:Envelope>';             
        System.Test.setMock(WebServiceMock.class,mock);
        
        String logId = log.id;     
        CAA_Core_Controller_Lightning.CallEBS(logId,SessionId,null);
         system.test.stopTest();
    }
    
    
    @isTest
    Public static Void CallEBSDEtest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        Account_with_IBB__c a = new Account_with_IBB__c ();
        a.Opportunity__c = o.id;
        a.Primary_SFDC_Account__c = acc.id;
        insert a;
        
        
        Asset_Relationship__c ass = new Asset_Relationship__c();
        ass.Account_with_IBB__c = a.id;
        ass.Prospect_Customer__c = acc.id;
        ass.Primary_Account_Holder__c = true;
        insert ass;
        
        Account_Reference_Information__c aInfor = new Account_Reference_Information__c();
        aInfor.Payment_Type__c = 'Test';
        aInfor.Request_Type__c = 'OCA';
        insert aInfor;
        
        Debug__c d = new Debug__c();
        d.opportunity__c = o.id;
        insert d;
        
        Web_Integration_Log__c wlog = new Web_Integration_Log__c();
        wlog.Accountid__c = acc.id;
        wlog.OpportunityId__c = o.Id;
        wlog.Request_Action__c = 'AddNewCustomer';
        insert wlog;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        
        String logId = log.id;
        z_XmlMessage.CreateAddNewCustomerMessage();
        z_XmlMessage.CreateAJREssage();
        z_XmlMessage.CreateANCAllMessage();
        Z_TheXmlMessages.CreateOCAMessage();
        //IBBDependentObjectFactory.CreateANCRLAJARStubs (o);
        System.test.startTest(); 
        z_WebServiceMock mock = new z_WebServiceMock();
        mock.xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><OperationResponse xmlns="http://www.islamic-bank.com/HPPDecisionEngine"><HPPDecisionEngineResponse><MessageID>a0oD0000007OHwZIAW</MessageID><MessageType>HPPDecisionEngineResponse</MessageType><DecisionId>86BF2236-E7F8-4244-B16B-D1C0E75A59DE</DecisionId><Decision>DECLINE-BDM14;REFER-BDM35;REFER-BDM36;</Decision><DecisionReason>DECLINE-BDM14 (DFF5AC28-6EC6-46A8-AF5F-F73ECD82B0D6 - Property not equal to \'absolute ownership\' in Scotland;) REFER-BDM35 (05B7D6AA-4D0D-472E-B982-652828AA8F3F - No of credit searches within the last 3 months at current address;) REFER-BDM36 (F0FE17BC-621E-40CD-A071-CDD50A252E5A - No of credit searches within the last 3 months at previous address;) </DecisionReason><DecisionExcludingWarnings>REFER-NOMATCH</DecisionExcludingWarnings><AcceptedFacilities /><RejectedFacilities /><SupplierScore>800</SupplierScore></HPPDecisionEngineResponse></OperationResponse></soap:Body></soap:Envelope>';             
        System.Test.setMock(WebServiceMock.class,mock);
        CAA_Core_Controller_Lightning.CallEBSDE(logId,SessionId);
        system.test.stopTest();
    }
    
    /*@isTest
    Public static Void CreateDocumenttest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();
    
        core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        
        String logId = log.id;
        
        CongaSettings__c docu= new CongaSettings__c();
        docu.Name ='test';
        docu.Document_name__c = 'test';
        insert docu;
		CongaSettings__c docu1 = [select id from CongaSettings__c limit 1];
        CAA_Core_Controller_Lightning.CreateDocument(logId,SessionId,docu1.Id);
    }*/
    
    @isTest
    Public static Void CompletePersonalDetailstest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        /*Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;*/
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        String logId = log.id;
        
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        //personaldata.Campaign = c.Id;
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = acc.id;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
        app.LastName = 'test';
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
            
        CAA_Core_Controller_Lightning.CompletePersonalDetails(personaldata,SessionId);
    }
    
    @isTest
    Public static Void CompletePersonalDetailsOverridetest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        
        /*Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;*/
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        String logId = log.id;
        
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        //personaldata.Campaign = c.Id;
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = acc.id;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
        app.LastName = 'test';
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
            
        CAA_Core_Controller_Lightning.CompletePersonalDetailsOverride(personaldata,SessionId);
    }
    
    @isTest
    Public static Void CompleteRMtest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        //system.debug(log.id);
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        
        /*Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;*/
        
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        String logId = log.id;
        
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        //personaldata.Campaign = c.Id;
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = acc.id;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
        app.LastName = 'test';
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
            
        CAA_Core_Controller_Lightning.CompleteRM(personaldata,SessionId);
    }
    
    /*@isTest
    Public static Void ResumeCallRecordingtest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();

        core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        String logId = log.id;
        
        CAA_Core_Controller_Lightning.ResumeCallRecording('5255',logId,SessionId);
    }*/
    
    @isTest
    Public static Void get_Declaration_Summarytest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();

        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        String logId = log.id;
        
        CAA_Core_Controller_Lightning.get_Declaration_Summary(logId,SessionId);
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        
        External_Session__c exse = new External_Session__c();
        exse.Active_Date__c = Date.today();
        //exse.Expires__c =Date.today().adddays(1);
        exse.Opportunity__c=o.id;
        exse.Account__c =acc.id;
        insert exse;
        
        system.runAs(u){
            sessionid = CAA_Helper.EncryptData(exse.id);
            CAA_Core_Controller_Lightning.get_Declaration_Summary(logId,SessionId);
        }
        
    }
    
    
	@isTest
    Public static Void ProductSelectedtest(){
        test.startTest();
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c,event__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller_Lightning core = New CAA_Core_Controller_Lightning();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();

        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        CAA_Data.AddNewApplicantData appdata = new CAA_Data.AddNewApplicantData();
        appdata.FirstName = 'Applicant Account DM1';
        appdata.LastName = 'Force26';
        appdata.Title = 'xyz'; 
        CAA_Core_Controller_Lightning.IsExistingAccount(appdata,log.id,true);
        CAA_Data.ProductSelectedData data = new CAA_Data.ProductSelectedData();
        data.ProductId = Product.Id;
        data.PurposeOfAccount = 'Loan';
        data.NumberOfApplicants = 20;  
        data.Deposit =123.01;
        data.AccountId =acc.Id;
        CAA_Core_Controller_Lightning ob = new CAA_Core_Controller_Lightning();
        data.OpportunityId= o.Id;
        data.Receive_Salary_Benefits = true;
        data.Pay_Bills_Expenses= true;
        data.Domestic_Transfers_In_Out= true;
        data.International_Transfer_In_Out= true;
        data.Cash_Deposit_In_Out= true;
        data.Saving_Goals= true;
        data.Over16= 'test';
        data.Regular_payment_amount_c = 123.23;
        data.Payment_Frequency_c='test';
        data.Direct_debit_date_day_c='test';
        data.Name_of_current_Bank_Building_Society_c='test';
        data.Sort_Code_c = '123';
        data.HasRegularPayment= 'test';
        
        String logId = log.id;
        
        CAA_Core_Controller_Lightning.ProductSelected(data,SessionId,false,false,false,false,false,false,false,false,false,false,false,false);
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        
        External_Session__c exse = new External_Session__c();
        exse.Active_Date__c = Date.today();
        //exse.Expires__c =Date.today().adddays(1);
        exse.Opportunity__c=o.id;
        exse.Account__c =acc.id;
        insert exse;
        
        system.runAs(u){
             
            data.accountid = CAA_Helper.EncryptData(acc.id);
            data.opportunityid = CAA_Helper.EncryptData(o.id);
            sessionid = CAA_Helper.EncryptData(exse.id);
            CAA_Core_Controller_Lightning.ProductSelected(data,sessionid,false,false,false,false,false,false,false,false,false,false,false,false);
        }
        test.stopTest();
        
    }
    
    @isTest
    Public static void ResumeCallRecordingTest(){
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        system.runAs(u){
            CAA_Core_Controller_Lightning.ResumeCallRecording(CAA_Helper.EncryptData('transactionId'),CAA_Helper.EncryptData('eventLogId'),CAA_Helper.EncryptData('sessionId'));
    	
        }
    }
    
    @isTest
    Public static void MakePaymentTest(){
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        system.runAs(u){
            CAA_Core_Controller_Lightning.MakePayment(new CAA_Data.TakePaymentData(),CAA_Helper.EncryptData('transactionId'),CAA_Helper.EncryptData('eventLogId'),CAA_Helper.EncryptData('sessionId'));
    	
        }
    }
    
    @isTest
    Public static void CreateDocumentTest(){
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        system.runAs(u){
            CAA_Core_Controller_Lightning.CreateDocument(CAA_Helper.EncryptData('eventLogId'),CAA_Helper.EncryptData('sessionId'),CAA_Helper.EncryptData('settingId'));
    	
        }
    }
    
    @isTest
    Public static Void ANCSetuptest(){
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        String accid = acc.id;
        CAA_Core_Controller_Lightning.ANCSetup(accid);
    }

    @isTest
    Public static Void EligibilitySetuptest(){
        
        Account acc1 = new Account();
        acc1.Firstname='Test1';
        acc1.Lastname='Test12';
        acc1.Salutation='Mr';
        acc1.Home_Telephone_No__c='9876543210';
        acc1.PersonEmail='test@test.com';
        acc1.BillingPostalCode='522510';
        acc1.Date_of_Birth__c=date.today();
        insert acc1;
       // Account acc = [Select Id,Salutation,Lastname from Account Limit 1];
        system.debug('salu str'+acc1);
        String accid = acc1.id;
        CAA_Core_Controller_Lightning.EligibilitySetup(accid,'test');
    }
    
    @isTest
    static list<Campaign> CampaignsTest(){
        Campaign c1 = new Campaign();
        c1.name = 'test';
        c1.isActive = true;
        Campaign c2 = new Campaign();
        c2.name = 'test';
        c2.isActive = true;
        insert new List<Campaign>{c1,c2};
        CAA_Core_Controller_Lightning.Campaigns();
        return null;
    }
 
    
    
}