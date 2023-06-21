@IsTest
public class HPPOfferLetterController_Test {
	
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
    }

	static testmethod void Setup_Test()
    {
        HPPOfferLetterController_Test testable = new HPPOfferLetterController_Test();
        testable.SetUpObjects();
        
        
        HPP_extended_opportunity__c exOpp = [SELECT Offer_letter_sent__c
                                                FROM HPP_extended_opportunity__c 
                                                WHERE Opportunity__c =: testable.opp.id];
        exOpp.Offer_letter_sent__c = date.today();
        update exOpp;          
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        

        HPPOfferLetterController ctl = new HPPOfferLetterController();
        ctl.Setup();        
    }
    
    static testmethod void RCECompleted_Test()
    {
        HPPOfferLetterController_Test testable = new HPPOfferLetterController_Test();
        testable.SetUpObjects();
        
        IBBQuotation__c quote = new IBBQuotation__c();
        quote.opportunity__c = testable.opp.id;
        insert quote;
        
        Opportunity opp = [SELECT IBBQuotation__c from Opportunity WHERE id=:testable.opp.id];
        opp.IBBQuotation__c = quote.id;
        opp.purpose_of_finance__c = 'test';
        update opp;  
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id); 
        
        HPPOfferLetterController ctl = new HPPOfferLetterController();
        
        Boolean b = ctl.RCECompleted;
        ctl.PoolRCE();
      	
    }
    
    static testmethod void CallRCE_Test()
    {
        HPPOfferLetterController_Test testable = new HPPOfferLetterController_Test();
        testable.SetUpObjects();
        
        IBBQuotation__c quote = new IBBQuotation__c();
        quote.opportunity__c = testable.opp.id;
        insert quote;
        
        Opportunity opp = [SELECT IBBQuotation__c from Opportunity WHERE id=:testable.opp.id];
        opp.IBBQuotation__c = quote.id;
        opp.purpose_of_finance__c = 'test';
        update opp;  
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id); 
        
        Actions.FakeAction fake = new Actions.FakeAction();
        fake.eventArgs = new IBBEvents.CompleteEventArgs();
        fake.eventArgs.returnValue = 'SUCCESS';
        
       
        HPPOfferLetterController ctl = new HPPOfferLetterController();
        ctl.RCEACtion = fake;        
    
        ctl.CallRCE();
    }
    
    static testmethod void CreateDoc_Test()
    {
        HPPOfferLetterController_Test testable = new HPPOfferLetterController_Test();
        testable.SetUpObjects();
    
        InterfaceFakes.FakeCongaSettings conga = new InterfaceFakes.FakeCongaSettings();        
        Attachment attach=new Attachment();   
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testable.opp.id;
        insert attach;
        
        IBBQuotation__c quote = new IBBQuotation__c();
        quote.opportunity__c = testable.opp.id;
        insert quote;
        
        Opportunity opp = [SELECT IBBQuotation__c from Opportunity WHERE id=:testable.opp.id];
        opp.IBBQuotation__c = quote.id;
        opp.purpose_of_finance__c = 'test';
        update opp;        
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);
        
        
        conga.Id = attach.id;
        HPPOfferLetterController ctl = new HPPOfferLetterController();
        
        //ctl.DocugenSetting = conga;
        
        ctl.CreateDoc();
    }
    
    static testmethod void save_Test()
    {
        HPPOfferLetterController_Test testable = new HPPOfferLetterController_Test();
        testable.SetUpObjects();
        
        IBBQuotation__c quote = new IBBQuotation__c();
        quote.opportunity__c = testable.opp.id;
        insert quote;
        
        Opportunity opp = [SELECT IBBQuotation__c from Opportunity WHERE id=:testable.opp.id];
        opp.IBBQuotation__c = quote.id;
        opp.purpose_of_finance__c = 'test';
        opp.stagename = 'Offer';
        update opp;  
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id); 
        
       
        HPPOfferLetterController ctl = new HPPOfferLetterController();
        
        test.startTest();
        ctl.save();
        ctl.Complete();
        ctl.BulkDeleteCondition();
        //ctl.EditCondition();
        ctl.Cancel();
        test.stopTest();
        //ctl.Save2();
        //ctl.Hide();
    }
    
    static testmethod void getset_Test()
    {
        HPPOfferLetterController_Test testable = new HPPOfferLetterController_Test();
        testable.SetUpObjects();
        
        IBBQuotation__c quote = new IBBQuotation__c();
        quote.opportunity__c = testable.opp.id;
        insert quote;
        
        Opportunity opp = [SELECT IBBQuotation__c from Opportunity WHERE id=:testable.opp.id];
        opp.IBBQuotation__c = quote.id;
        opp.purpose_of_finance__c = 'test';
        opp.stagename = 'Offer';
        opp.Attachment_Offer_Letter__c = '00Pxyz';
        update opp;  
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id); 
        
       
        HPPOfferLetterController ctl = new HPPOfferLetterController();
        ctl.edCondition = 123;
        ctl.s='';
        ctl.sortedAppliBTLLTD = new List<Applicant__c>();
        ctl.RCECalled = true;
        ctl.StartRCEPolling = true;
        ctl.AttachId = '00Pxyz';
        String KeyFactsstr = ctl.KeyFactsLink;
        String DocLinkstr = ctl.DocLink;
        
        ctl.AttachId = '068xyz';
        String DocLinkstr2 = ctl.DocLink;
        //ctl.DocLinkCreated = true;
        //ctl.KeyFactsLink= '';
        //ctl.DocLink= 'test';
        
    }
    static testmethod void save_Test2()
    {
        HPPOfferLetterController_Test testable = new HPPOfferLetterController_Test();
        testable.SetUpObjects();
        
        IBBQuotation__c quote = new IBBQuotation__c();
        quote.opportunity__c = testable.opp.id;
        insert quote;
        
        IBB_Product_Set__c prod = [Select id, name from IBB_Product_Set__c limit 1];
        prod.name = 'Buy To Let Limited Company Purchase Plan';
        update prod;
        
        Opportunity opp = [SELECT IBBQuotation__c from Opportunity WHERE id=:testable.opp.id];
        opp.IBBQuotation__c = quote.id;
        opp.purpose_of_finance__c = 'test';
        opp.stagename = 'Offer';
        opp.Interested_in__c = 'Buy To Let Limited Company Purchase Plan';
        update opp; 
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id); 
        
       
        HPPOfferLetterController ctl = new HPPOfferLetterController();
        
        test.startTest();
        ctl.save();
    }
    
    static testmethod void save_Test3()
    {
        HPPOfferLetterController_Test testable = new HPPOfferLetterController_Test();
        testable.SetUpObjects();
        
        IBBQuotation__c quote = new IBBQuotation__c();
        quote.opportunity__c = testable.opp.id;
        insert quote;
       
        Opportunity opp = [SELECT IBBQuotation__c from Opportunity WHERE id=:testable.opp.id];
        opp.IBBQuotation__c = quote.id;
        opp.purpose_of_finance__c = 'test';
        opp.stagename = 'Offer';
        update opp;  
        
        Account acc = new Account();
        acc.name = 'test test';
        acc.BillingCountry='USA';
        acc.BillingPostalCode='001';
        acc.BillingStreet='street';
        acc.BillingCity='city';
        acc.Customer_Address_District__c='district';
        insert acc;
        
        Applicant__c appli=[select id, Prospect_Customer__c from Applicant__c where Opportunity__c=:opp.id order by Applicant_Number__c LIMIT 1];
        appli.Prospect_Customer__c = acc.id;
        update appli;
        
        PageReference pageRef = Page.HPPProduct_Switch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id); 
        
       
        HPPOfferLetterController ctl = new HPPOfferLetterController();
        
        test.startTest();
        ctl.save();
    }
}