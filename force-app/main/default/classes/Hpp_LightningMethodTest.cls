@isTest
public class Hpp_LightningMethodTest {
    @testSetup
    public static void dataSetup(){
        Account acc = new Account();
        acc.FirstName = 'Test Account1';
        acc.LastName = 'Test Account2';
        acc.BillingPostalCode = '5679821';
        acc.Title_Other__c = 'xyz';
        acc.Self_Cert_Capacity__c='Self';
        acc.Self_Certification_Declaration_Date__c=system.today();
        acc.Is_the_customer_an_expat__c = 'Yes';
        acc.Is_the_customer_going_to_return_in_the_n__c = 'No';
        acc.No_Contact__c=true;
        acc.Contact_by_Email_New__c=true;
        acc.Contact_by_Newsletter_New__c=true;
        acc.Contact_by_Post_New__c=true;
        acc.Contact_by_SMS_New__c=true;
        acc.Contact_by_Telephone_New__c=true;
        insert acc; 
       
        
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();
        
          z_MMRQuerySettings.CreateAll();
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test');
        oHelp.Director(director.id);
       // opportunity o= oHelp.build();
        
        opportunity opp = oHelp.build();
        opp.name = 'test';
        opp.stagename = 'test';
        opp.closedate = date.today();
        opp.ProductEventDirector__c = director.id;
        opp.Sort_Code__c = '';
        opp.Account_Number__c = '';
        opp.Name_of_current_Bank_Building_Society__c  = '';
        opp.interested_in__c = 'Home Purchase Plan Premier';
        opp.AccountId = acc.id;
      
        update opp;
        
        IBB_Product_Set__c ProductSet = new IBB_Product_Set__c();
        ProductSet.Name = 'Home Purchase Plan Premier'; 
        ProductSet.Max_No_of_Applicants__c = 4;
        ProductSet.ProductSetType__c = 'hpp';
        insert ProductSet;
        
        IBB_Product__c Product = new IBB_Product__c();
        Product.Name = 'Test';
        Product.IBb_product_set__c =ProductSet.id;
        Product.Max_finance_to_value_FTV__c = 80;
        Product.ShowOnAIP__c = true;
        Product.Benchmark_rate__c = 4;
        insert Product;
       
                       
        EventLog__c log = new EventLog__c();
        log.Event__c = dHelp.Event.id;
        log.Opportunity__c = opp.id;
        log.EventStatus__c = 'Open';
        insert log;
        
        
        HPP_extended_opportunity__c hpp = new HPP_extended_opportunity__c();
        hpp.Opportunity__c=opp.id;
        hpp.Mainland__c='yes';
        insert hpp;
        
        List< Applicant__c> appList = new List< Applicant__c>();
        Applicant__c app1 =new Applicant__c();
        app1.HTBQ1__c = 'Yes';
        app1.HTBQ2__c = 'Yes';
        app1.HTBQ3__c = 'Yes';
        app1.opportunity__c = opp.id;
        app1.applicant_number__c = 123.35 ;
        app1.Prospect_Customer__c = acc.id;
        appList.add(app1);
        Applicant__c app2 =new Applicant__c();
        app2.HTBQ1__c = 'No';
        app2.HTBQ2__c = 'No';
        app2.HTBQ3__c = 'No';
        app2.opportunity__c = opp.id;
        app2.applicant_number__c = 123.35 ;
        app2.Prospect_Customer__c = acc.id;
        appList.add(app2);
        insert appList;
        
        List<GenericObject__c> genList = new List<GenericObject__c>();
        GenericObject__c gen1 = new GenericObject__c();
        gen1.Deposit_Source__c='Gift';
        gen1.Deposit_Value__c=56789.02;
        gen1.Deposit_Details__c ='data1';
        gen1.Refinance_Details__c = 'test1';
        gen1.Refinance_Type__c ='Other';
        gen1.Refinance_Value__c = 2000.98;
        gen1.Type__c='DepositSource';
        gen1.Opportunity__c=opp.id;
        gen1.Account__c=acc.id;
        genList.add(gen1);
        GenericObject__c gen2 = new GenericObject__c();
        gen2.Deposit_Source__c='Another source';
        gen2.Deposit_Value__c=234567.91;
        gen2.Deposit_Details__c ='data2';
        gen2.Refinance_Details__c ='test2';    
        gen2.Refinance_Type__c ='Furnishings';
        gen2.Refinance_Value__c =3450.98;
        gen2.Type__c='RefinanceSource';
        gen2.Opportunity__c=opp.id;
        gen2.Account__c=acc.id;
        genList.add(gen2);
        insert genList;
        
        Other_adults_in_the_property__c adult= new Other_adults_in_the_property__c();
        adult.First_name__c='test';
        adult.Last_name__c='test1';
        adult.Date_of_birth__c=date.today();
        adult.Relationship_to_primary_applicant__c='Brother';
        adult.HPP_Application__c=opp.id;
        insert adult;
        
        
        Valuation_Table__c val= new Valuation_Table__c();
        val.Type_of_valuation__c='Standard';
        val.Price_of_valuation__c=100.02;
        val.Minimum_property_value__c=100.02;
        val.Property_up_to_the_value_of__c=200;
        val.HPP_extended_opportunity__c=hpp.id;
        insert val;
        
        Property_information__c info = new Property_information__c();
        info.Opportunity__c=opp.id;
        info.PersonAccount__c=acc.id;
        insert info;
    }
    
    @istest
    public static void checkLightningNewMethods(){
    
        EventLog__c log = [Select Id from EventLog__c Limit 1];
        Account acc = [Select Id,Is_the_customer_an_expat__c from Account Limit 1];
        List<Applicant__c> appList = [Select Id from Applicant__c Limit 1];
        List<GenericObject__c> genList = [Select Id from GenericObject__c Limit 1];
        Other_adults_in_the_property__c adult = [Select Id from Other_adults_in_the_property__c Limit 1];
      
        Opportunity opp = [Select Id,interested_in__c,Account.Is_the_customer_an_expat__c from Opportunity Limit 1];
        opp.interested_in__c='Home Purchase Plan Premier';
        opp.Account.Is_the_customer_an_expat__c='';
        update opp;
        
        HPP_extended_opportunity__c hpp =[Select Id from HPP_extended_opportunity__c Limit 1];
        test.starttest();
        MMR_AIP_Controller aipController = new MMR_AIP_Controller();
        aipController.PrevLight();
        MMR_AIP_Applicants_Controller appliController = new MMR_AIP_Applicants_Controller();
        appliController.NextAIPLightning();
        
        MMR_App_Applicant applicant= new MMR_App_Applicant();
        applicant.accs = new List<Account>{acc};
        applicant.Previous();
        applicant.Additional();

        MMR_FF_BTLLC_Income incomeController = new MMR_FF_BTLLC_Income();
        incomeController.accs = new List<Account>{acc};
        incomeController.Previous();
        incomeController.NextStep();
        
      
        
       
        
        MMR_FF_BTLLC_Financial financial = new MMR_FF_BTLLC_Financial();
        financial.Accs = new List<Account>{acc};
        financial.DepositSource =genList;   
        financial.RefinanceSource=genList;
        financial.Opp=opp;
        financial.NextLtng();
        financial.Prev();
        MMR_App_BTLLC_Confirmation conf = new MMR_App_BTLLC_Confirmation();
        conf.Prev();
        MMR_App_Confirmation confirmation = new MMR_App_Confirmation();
        confirmation.Prev();
        MMR_APP_BTLLC_Applicant btl = new MMR_APP_BTLLC_Applicant();
        btl.Accs = new List<Account>{acc};
        btl.Additional();
        btl.Previous();
        MMR_FF_BTLLC_Credit credit = new MMR_FF_BTLLC_Credit();
        credit.Accs = new List<Account>{acc};
        credit.Prev();
        credit.Nextlt();
        
        MMR_App_BTLLC_Payment ap = new MMR_App_BTLLC_Payment();
        ap.opp = opp;
        ap.Exopp = hpp;
        ap.Previous();
        ap.Nxt();
        
        
        MMR_FF_PropertyAddress address= new MMR_FF_PropertyAddress();
        address.opp = opp;
        address.Exopp = hpp;
        address.Next_Ltng();
        address.NextBTLLClt();
        address.NextBTLLC();
        address.getItemsFinance();
        
        MMR_App_BTLLC_ApplicationDetails details= new MMR_App_BTLLC_ApplicationDetails();
        details.opp = opp;
        details.Exopp = hpp;
        details.OtherAdults= new List<Other_adults_in_the_property__c>{adult};
        details.GoAddApplt();
        
        MMR_App_BTLLC_Valuation valuation= new MMR_App_BTLLC_Valuation();
        valuation.Opp= opp;
        valuation.ExOpp= hpp;
        valuation.ValuationId= '';
        valuation.Previous();
        valuation.Next();
        
        MMR_App_BTLLC_Additional Additional= new MMR_App_BTLLC_Additional();
        Additional.Opp= opp;
        Additional.ExOpp= hpp;
        Additional.OtherAdults= new List<Other_adults_in_the_property__c>{adult};
        Additional.Nxt();
        Additional.Prev();
        test.stoptest();
        
    }
    @istest
    public static void checkingTestMethod(){
      
         Property_information__c info = [Select Id from Property_information__c Limit 1];
        EventLog__c log = [Select Id from EventLog__c Limit 1];
        List<Applicant__c> appList = [Select Id from Applicant__c Limit 1];
        Account acc = [Select Id from Account Limit 1];
        Opportunity opp = [Select Id,interested_in__c,Account.Is_the_customer_an_expat__c from Opportunity Limit 1];
        Other_adults_in_the_property__c adult = [Select Id from Other_adults_in_the_property__c Limit 1];
        HPP_extended_opportunity__c hpp =[Select Id from HPP_extended_opportunity__c Limit 1];
        test.startTest();
        MMR_FF_BTLLC_Addresses add = new MMR_FF_BTLLC_Addresses();
        add.Accs = new List<Account>{acc};
        add.Nxt();
        add.Prev();
        
        MMR_App_Additional appadd = new MMR_App_Additional();
        appadd.Opp = opp;
        appadd.ExOpp= hpp;  
        appadd.OtherAdults= new List<Other_adults_in_the_property__c>{adult};
        appadd.NextLtng();
        appadd.PreviousLtng();
        
        PageReference pageRef = Page.MMR_FF_BTLLC_PersonalDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', log.id);
        
        
        MMR_FF_BTLLC_PersonalDetails personalDetails = new MMR_FF_BTLLC_PersonalDetails();
        personalDetails.Accs = new List<Account>{acc};
        personalDetails.Applicants =appList;
        personalDetails.GoAddressesLtng();
        personalDetails.GoCompanyLtng();
        personalDetails.GoIncomeLtng();
        personalDetails.GoAddresses();
        personalDetails.GoCompany();
        personalDetails.GoIncome();
        personalDetails.Save();
        personalDetails.Setup_Ownership();
        //personalDetails.GetProperty(acc.id);
        personalDetails.SaveDirProperty();
        List<SelectOption> selApplicant = personalDetails.selApplicant;
        personalDetails.RemoveItem(info.id);
       
        test.stoptest();
        
         
    }
       @istest
    public static void checkTestMethods(){
         EventLog__c log = [Select Id from EventLog__c Limit 1];
         Account acc = [Select Id from Account Limit 1];
         Opportunity opp = [Select Id,interested_in__c,Account.Is_the_customer_an_expat__c from Opportunity Limit 1];
         HPP_extended_opportunity__c hpp =[Select Id from HPP_extended_opportunity__c Limit 1];
         test.startTest();
         MMR_App_ApplicationDetails appli = new MMR_App_ApplicationDetails();
         appli.Next();
         MMR_APP_Payment payment = new MMR_APP_Payment();
         payment.Opp= opp;
         payment.Exopp = hpp;
         payment.accs = new List<Account>{acc};
         payment.Previous();
         payment.Nextstep();
        
        MMR_App_Valuation appval = new MMR_App_Valuation();
        appval.Opp = opp;
        appval.ExOpp= hpp; 
        appval.ValuationId= '';
        appval.GoAdditionalLtng();
        appval.GoPaymentLtng();
        
        PageReference pageRef = Page.MMR_OnlyAssessment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',log.id);
          
        
        MMR_OnlyAssessment only = new MMR_OnlyAssessment();
        only.Setup_Opp();
        only.Opp.Customer_prompt_for_execution_only__c = 'Yes';
        only.Opp.require_advice__c= 'Yes';   
        
        only.PreviousLightning();
        only.NextLightning();
        test.stopTest();
        
    }
     @istest
    public static void checkIncomeTestMethod(){
        EventLog__c log = [Select Id from EventLog__c Limit 1];
        Account acc = [Select Id,Is_the_customer_an_expat__c from Account Limit 1];
        Opportunity opp = [Select Id,interested_in__c,Account.Is_the_customer_an_expat__c from Opportunity Limit 1];
        opp.interested_in__c='Home Purchase Plan Premier';
        opp.Account.Is_the_customer_an_expat__c='';
        update opp;
        PageReference pageRef = Page.MMR_FF_Income;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',log.id);
        
        MMR_FF_Income income =new MMR_FF_Income();
        income.accs = new List<Account>{acc};
        income.bopp=opp;
        income.NextPage();
        income.Previous();
        
    }
    @istest
    public static void checkCreditTestMethod(){
        EventLog__c log = [Select Id from EventLog__c Limit 1];
        Account acc = [Select Id,Is_the_customer_an_expat__c from Account Limit 1];
        
        PageReference pageRef = Page.MMR_FF_Credit;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',log.id);
        
        MMR_FF_Credit credit = new MMR_FF_Credit();
        credit.accs = new List<Account>{acc};
        credit.NextLightning();
        credit.PreviousLightning();
        
        
        PageReference page = Page.MMR_FF_Addresses;
        Test.setCurrentPage(page);
        ApexPages.currentPage().getParameters().put('id',log.id);
        
        MMR_FF_Addresses addr = new MMR_FF_Addresses();
        addr.accs = new List<Account>{acc};
        addr.NextLightning();
        addr.PreviousLightning();
        
    }
    
}