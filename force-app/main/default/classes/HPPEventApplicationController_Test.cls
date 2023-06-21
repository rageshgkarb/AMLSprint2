@isTest
public class HPPEventApplicationController_Test {
	
    /* Test data setup */
    public ProductEventDirector__c director{get;set;}
    public Event__c event{get;set;} 
    public Opportunity Opp{get;set;}  
    public EventLog__c Log{get;set;} 
    public Attachment att{get;set;}
    public HPP_extended_opportunity__c ex{get;set;} 
    z_ProductHelper pHelp ;
    
    public void SetUpObjects()
    {
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        director = dHelp.Build();

        pHelp = new z_ProductHelper();        
        pHelp.Director(director.id);
        IBB_Product_Set__c prod  = pHelp.Build();


        //List<SOQLQuery__c> sql = [select id from SOQLQuery__c];
        //delete sql;
        
        z_MMRQuerySettings.CreateAll();
                
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test');
        oHelp.Director(director.id);
        Opp = oHelp.build();  
        //Opp.interested_in__c = 'Test';              
        //update opp;        
        
        event= dHelp.Event;        
        ex  = new HPP_extended_opportunity__c ();
        ex.Opportunity__c = opp.id;
        insert ex;
                       
        log = new EventLog__c();
        log.Event__c = dHelp.Event.id;
        log.Opportunity__c = opp.id;
        log.EventStatus__c = 'Open';
        insert log;
        
        Valuation_Report__c ValReport = new Valuation_Report__c(Opportunity__c = opp.Id);
        insert ValReport;
        
        Account act = [Select id,PersonContactId from Account][0];
        act.BillingCountry='GBR';
        update act;
        
        Card__c crd = new Card__c();
        crd.Name= 'crd test';
		crd.Card_Name__c='crd nm test';
        crd.Card_Type__c = 'Visa Debit';
        crd.Contact__c=act.PersonContactId;
        insert crd;
        
        SecureTradingSettings__c secureTradingSettings = new SecureTradingSettings__c(
            Alias__c = 'alias', Endpoint__c = 'endpoint', Password__c = 'password', SiteReference__c = 'siteref',
            TermURL__c = 'http://www.termurl.com/', UseCardTypeMapping__c = true, Username__c = 'username',
            Version__c = '1.0', Name = 'Card Store Settings'
        );
        insert secureTradingSettings;
        
    }
    
    static testmethod void Setup_Test()
    {
        HPPEventApplicationController_Test testable = new HPPEventApplicationController_Test();
        testable.SetUpObjects();
        
        
        HPP_extended_opportunity__c exOpp = [SELECT Offer_letter_sent__c
                                                FROM HPP_extended_opportunity__c 
                                                WHERE Opportunity__c =: testable.opp.id];
        exOpp.Offer_letter_sent__c = date.today();
        update exOpp;          
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        

        HPPEventApplicationController ctl = new HPPEventApplicationController();
        ctl.Setup();
        ctl.AddRefinanceSource();
        ctl.rowDeleteRefinanceSource=0;
        ctl.RemoveRefinanceSource();
        ctl.AddDefault();
        ctl.AddCCJ();
        ctl.AddDepositSource();
        ctl.rowDeleteDepositSource=0;
        ctl.RemoveDepositSource();
        ctl.rowDeleteCCJ=0;
        ctl.RemoveCCJ();
        ctl.rowDeleteDefault=0;
        ctl.RemoveDefault();
        ctl.AddCard();
		//ctl.Save();
		
		
		ctl.AddDebt();
        ctl.rowDelete=0;
        ctl.Remove();
        ctl.AddProperty();
		ctl.rowDeleteProperty=0;
		ctl.RemoveProperty();
		ctl.AddAdult();
		ctl.rowDeleteAdult=0;
		ctl.RemoveAdult();        
    }
    
    static testmethod void DeleteCard_Test()
    {
        HPPEventApplicationController_Test testable = new HPPEventApplicationController_Test();
        testable.SetUpObjects();
        
        
        HPP_extended_opportunity__c exOpp = [SELECT Offer_letter_sent__c
                                                FROM HPP_extended_opportunity__c 
                                                WHERE Opportunity__c =: testable.opp.id];
        exOpp.Offer_letter_sent__c = date.today();
        update exOpp;
        
        
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        

        HPPEventApplicationController ctl = new HPPEventApplicationController();
        
        Card__c crd = [Select id,Name from Card__c where name='crd test'][0];
        ctl.deleteCardId = crd.Id;
        //ctl.LoadCards();
        ctl.DeleteCard();
		//ctl.Save();        
    }
    
    static testmethod void EditCard_Test()
    {
        HPPEventApplicationController_Test testable = new HPPEventApplicationController_Test();
        testable.SetUpObjects();
        
        
        HPP_extended_opportunity__c exOpp = [SELECT Offer_letter_sent__c
                                                FROM HPP_extended_opportunity__c 
                                                WHERE Opportunity__c =: testable.opp.id];
        exOpp.Offer_letter_sent__c = date.today();
        update exOpp;
        
        
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        

        HPPEventApplicationController ctl = new HPPEventApplicationController();
        
        Card__c crd = [Select id,Name from Card__c where name='crd test'][0];
        ctl.editCardId = crd.Id;
        //ctl.LoadCards();
        ctl.EditCard();
		//ctl.Save();        
    }
    
    static testmethod void Save_Test()
    {
        HPPEventApplicationController_Test testable = new HPPEventApplicationController_Test();
        testable.SetUpObjects();
        
        
        HPP_extended_opportunity__c exOpp = [SELECT Offer_letter_sent__c
                                                FROM HPP_extended_opportunity__c 
                                                WHERE Opportunity__c =: testable.opp.id];
        exOpp.Offer_letter_sent__c = date.today();
        update exOpp;          
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        

        HPPEventApplicationController ctl = new HPPEventApplicationController();
        ctl.Setup();
        test.startTest();
		ctl.SaveValidate();
		test.stopTest();
        
		     
    }
    
    static testmethod void Application_Test()
    {
        HPPEventApplicationController_Test testable = new HPPEventApplicationController_Test();
        testable.SetUpObjects();
        
        
        HPP_extended_opportunity__c exOpp = [SELECT Offer_letter_sent__c
                                                FROM HPP_extended_opportunity__c 
                                                WHERE Opportunity__c =: testable.opp.id];
        exOpp.Offer_letter_sent__c = date.today();
        update exOpp;          
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        

        HPPEventApplicationController ctl = new HPPEventApplicationController();
        ctl.Setup();
        test.startTest();
        ctl.PageApplication1();
        ctl.PageApplication3();
        ctl.PageApplication4();
        ctl.PageApplication5();
        ctl.PageApplication6();
        ctl.PageApplication7();
		test.stopTest();
		     
    }
    
    static testmethod void Applicant_Test()
    {
        HPPEventApplicationController_Test testable = new HPPEventApplicationController_Test();
        testable.SetUpObjects();
        
        
        HPP_extended_opportunity__c exOpp = [SELECT Offer_letter_sent__c
                                                FROM HPP_extended_opportunity__c 
                                                WHERE Opportunity__c =: testable.opp.id];
        exOpp.Offer_letter_sent__c = date.today();
        update exOpp;          
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        

        HPPEventApplicationController ctl = new HPPEventApplicationController();
        ctl.Setup();
        test.startTest();
        ctl.PageApplicant1();
        ctl.PageApplicant2();
        ctl.PageApplicant3();
        ctl.PageApplicant4();
        
		test.stopTest();
		ctl.TestDE_SetAllIDs();    
    }
    
    static testmethod void Next_Test()
    {
        HPPEventApplicationController_Test testable = new HPPEventApplicationController_Test();
        testable.SetUpObjects();
        
        
        HPP_extended_opportunity__c exOpp = [SELECT Offer_letter_sent__c
                                                FROM HPP_extended_opportunity__c 
                                                WHERE Opportunity__c =: testable.opp.id];
        exOpp.Offer_letter_sent__c = date.today();
        update exOpp;          
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        

        HPPEventApplicationController ctl = new HPPEventApplicationController();
        ctl.Setup();
        ctl.NextEvent();
        ctl.SetPage(0);
        ctl.PreviousAPP();
        //ctl.NextAPP();
        //ctl.LastApp();
        
    }
    
    static testmethod void Address_Test()
    {
        HPPEventApplicationController_Test testable = new HPPEventApplicationController_Test();
        testable.SetUpObjects();
        
        
        HPP_extended_opportunity__c exOpp = [SELECT Offer_letter_sent__c
                                                FROM HPP_extended_opportunity__c 
                                                WHERE Opportunity__c =: testable.opp.id];
        exOpp.Offer_letter_sent__c = date.today();
        update exOpp;          
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        

        HPPEventApplicationController ctl = new HPPEventApplicationController();
        ctl.Setup();
        
        ctl.PageApplicant2();
        ctl.checkAddressDates();
        String doc = ctl.FISDocLink;
		Boolean getStoreCard = ctl.getStoreCardSecurityCode();
        ctl.cardExpiryDate = '';
        Boolean hascard = ctl.HasCards;
        Budget_planner__c bpc = ctl.Budget;
        Property_information__c pic = ctl.PropertyInfo;
        List<Person_Debts__c> per_lis = ctl.PersonDebts;
        Boolean IsBuy = ctl.IsBuyToLet;
        String AppMe = ctl.AppMenu;
        List<Other_adults_in_the_property__c> othadu = ctl.OtherAdults;
        ctl.AllPropertyInfo = new List<Property_information__c>();
        ctl.showPrevPrevAddress = true;
        ctl.showPrevPrevPrevAddress=true;
        
    }
}