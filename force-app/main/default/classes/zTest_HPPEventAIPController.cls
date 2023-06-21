@istest
public class zTest_HPPEventAIPController
{
    
    public ProductEventDirector__c director{get;set;}
    public Event__c event{get;set;} 
    public Opportunity Opp{get;set;}  
    public EventLog__c Log{get;set;} 
    public Attachment att{get;set;}
    public HPP_extended_opportunity__c ex{get;set;} 
    z_ProductHelper pHelp ;
    
    public void AddApplicants(Integer no)
    {
        for(Integer i = 1;i < no;i++)
        {
            Account tacc = new Account();
            tacc.firstname = 'Account';
            tacc.lastname= 'Acc' + i;
            tacc.Salutation='mr';
            
            insert tacc;            
            
           
            
            Applicant__c applic = new Applicant__c ();
            applic.Applicant_Number__c = i;
            applic.Opportunity__c = opp.id;
            applic.Prospect_Customer__c = tacc.id;
            
            insert applic;
        }
        opp.Number_of_People_Applying__c = 1;
        opp.Attachment_Offer_Letter__c='test';
        opp.Dear_Customer__c='dear';
        update opp;
    }
    
    @testSetup
    public static void datSetup(){
        
       NPAA_TestSetupData.dataSetup(); 
    }
    
    public void SetUpObjects()
    {
        
    
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        director = dHelp.Build();
                
        pHelp = new z_ProductHelper();        
        pHelp.Director(director.id);
        IBB_Product_Set__c prod  = pHelp.Build();
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test');
        oHelp.Director(director.id);
        Opp = oHelp.build();
        
        Opp.IBB_product__c = pHelp.Product.id;
        update opp;
        
        att = new Attachment ();
        att.parentid = Opp.id;
        att.body =  Blob.valueOf('Test Data');
        att.name = 'test';
        insert att;
       
        ex  = new HPP_extended_opportunity__c ();
        ex.Opportunity__c = opp.id;
        insert ex;
        
        XML_Message__c x = new XML_Message__c();
          x.Type__c = 'Request';
          x.Name = 'DecisionEngineRequest';
          x.Active__c = true;
          x.Element_Name__c = 'TEST OpenCustomerAccount';
          x.Buffered__c=false;
        
          
          insert x;
                       
        log = new EventLog__c();
        log.Event__c = dHelp.Event.id;
        log.Opportunity__c = opp.id;
        log.EventStatus__c = 'Open';
        insert log;
        
        IBB_Product_Set__c ibb = new IBB_Product_Set__c();
        ibb.Max_No_of_Applicants__c=20;

        insert ibb;
        
       /* IBB_Product__c ib= new IBB_Product__c();
        ib.Max_finance_to_value_FTV__c=20;
        ib.Conga_FIS__c='test';
        ib.Conga_Offer_Letter__c='test';
         ib.CongaWelcomeLetter__c='test';
        ib.IBB_Product_Set__c=ibb.id;
       
        insert ib;*/
        
    }

    static testMethod void Constuctor()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();
        
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        HPPEventAIPController ctl = new HPPEventAIPController();
    }
    
    static testMethod void BasicPropertiesTest()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();
        
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        HPPEventAIPController ctl = new HPPEventAIPController();
        List<SelectOption> titles = ctl.getTitles();
        String facts = ctl.KeyFactsLink;
        String iddlink = ctl.IDDLink;
        Boolean quote = ctl.QuoteReceived;
        Boolean created =  ctl.DocLinkCreated;        
        
        String doclink = ctl.DocLink;
    }    
    
    static testMethod void Save()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();
        
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.Save();
    }   
    
    static testMethod void GetNumApplicants()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();
        
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        HPPEventAIPController ctl = new HPPEventAIPController();
        List<SelectOption> no =ctl.getNumApplicants();
    }   
    
    static testMethod void GetNumApplicants4()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();
        testable.AddApplicants(4);
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        HPPEventAIPController ctl = new HPPEventAIPController();
        List<SelectOption> no =ctl.getNumApplicants();
    }      
    
    static testMethod void Complete()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();
        testable.Opp.IBB_Product__c = testable.pHelp.Product.id;
        update testable.Opp;
        
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.Setup();
        ctl.Complete();
    }  
    
    static testMethod void GetProductItems()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();
        
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.getProductItems();
       // ctl.AddApplicant();
       // ctl.CallRCE();
        //ctl.LookupApplicant();
      //  ctl.ExternalProductEntered();
       // ctl.CreateDoc();
       // ctl.LastApp();
       // ctl.PreviousAPP();
       // ctl.delItem();
       // ctl.ApplicantsPage();
       // ctl.CreateAIPLetter();
    }  
    
    
    /*
    static testMethod void Applicants4()
    {
            
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(4);
        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.IsExternal=false;
        ctl.NextAPP();
        ctl.PreviousAPP();
        ctl.Applicant4();
        ctl.whichline = 1;
        ctl.delItem();
        
    }    
    
    

static testMethod void Applicants4()
    {
            
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        TEST.startTest();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(4);
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.IsExternal=false;
        ctl.NextAPP();
        ctl.PreviousAPP();
        ctl.Applicant4();
        ctl.AddApplicant();
        // ctl.UpdateDearField();
        //ctl.LookupApplicant();
        // ctl.IsPremier;
        ctl.NextAPP();
        ctl.ApplicantsPage();
        ctl.CreateAIPLetter();
        
        
        ctl.whichline = 1;
        ctl.delItem();
       TEST.stopTest(); 
    }      
    */
    
    
    static testMethod void RemoveApplicant()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(4);
        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.CurApp = 2;
        //ctl.RemoveApplicant();

    }     
    
    static testMethod void Setup()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(3);
        testable.opp.Number_of_People_Applying__c = 4;
        update testable.opp;
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.Setup();
        Boolean b = ctl.DocCreated;
    }  
    
    static testMethod void SetupExternal()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(3);
        testable.opp.Number_of_People_Applying__c = 4;
        update testable.opp;
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.setUpExternal();
        Boolean b = ctl.DocCreated;
    }     
    
    static testMethod void ProductEntered()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController ();
        testable.SetUpObjects();
        testable.Opp.IBB_Product__c = testable.pHelp.Product.id;
        update testable.Opp;
        testable.AddApplicants(4);
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        HPPEventAIPController ctl = new HPPEventAIPController();
        
            //inject a fake action
        ctl.RCEAction = new Actions.FakeAction ();
        ctl.ProductEntered();
        
        
        String s = ctl.DocLink;
        Boolean b= ctl.DocCreated;
    } 
    
    static testMethod void ProductEntered_QuoteExists()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController ();
        testable.SetUpObjects();
        testable.Opp.IBB_Product__c = testable.pHelp.Product.id;
        update testable.Opp;
        testable.AddApplicants(4);
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);   
        
        //Create quotation
        IBBQuotation__c quote = new IBBQuotation__c ();
        quote.DealType__c = testable.opp.Deal_Type__c ;
        quote.IBBProduct__c = testable.opp.IBB_Product__c ;
        quote.Term_Of_Finance__c = testable.opp.Term_Of_Finance__c ;
        quote.DealAmount__c  = testable.opp.Finance_Required__c;
        quote.Opportunity__c = testable.opp.id;
        quote.RCERetrieved__c=true;
        quote.QuoteToBeAIP__c=true;
        quote.Attachment_FIS__c='test';
        insert quote ;
        
       /* Attachment att = new Attachment ();
        att.parentid = quote.id;
        att.body =  Blob.valueOf('Test Data');
        att.name = 'test';
        insert att; */
        
             
        HPPEventAIPController ctl = new HPPEventAIPController();
            //inject a fake action
        ctl.RCEAction = new Actions.FakeAction ();
        ctl.ProductEntered();
        String s = ctl.DocLink;

    }     
    
    static testMethod void NavigateApplicants()
    {
        zTest_HPPEventAIPController  testable = new zTest_HPPEventAIPController ();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(4);
        test.startTest();
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.setUp();
        ctl.Applicant1();
        ctl.Applicant2();
        ctl.Applicant3();                

        
        //inject a fake action
        ctl.RCEAction = new Actions.FakeAction ();
        
        ctl.ProductDetails();
          test.stopTest();
        
        
        
    }    
    
    static testMethod void NavigateLinks()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController ();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(4);
        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.setUp();
        ctl.SaveValidate();
        ctl.AIPDeclaration();
        ctl.AIPConfirmation();    
        ctl.CompleteAIP();    
    }    
    
    static testMethod void DocumentLinks()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController ();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(4);
        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.setUp();
        Boolean b = ctl.AIPLinkCreated;
        String s = ctl.AIPLetterLink;
        testable.Opp.Attachment_AIP_Letter__c = testable.att.id;
        update testable.Opp;
        Boolean b1 = ctl.AIPLinkCreated;
        String s1 = ctl.AIPLetterLink;
        
        
             
    }      
    
    static testMethod void external()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController ();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(1);
        
        Eventlog__c elg = [SELECT id, Opportunity__c from EventLog__c WHERE id =: testable.log.id LIMIT 1];
        Opportunity opp = new Opportunity();
        opp.id = elg.Opportunity__c;
        opp.Number_of_People_Applying__c = 1;
        update opp;
        
        List<IBB_Product_Set__c> pro =[select id from IBB_Product_Set__c limit 25];
        for(IBB_Product_Set__c p : pro){
            p.Max_No_of_Applicants__c =30;
        }
        update pro;
        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.IsExternal =false;
        ctl.setUp();
        ctl.TempTitle = 'dr';
        ctl.TempLastName='test';
        ctl.AddApplicant();
        ctl.IsExternal =true;
       
        ctl.AddApplicant();
        RecordType oprt  = ctl.oppRecType;
        RecordType exrty= ctl.recTypeExternal;
        RecordType acrty= ctl.accRecType;
        Boolean b = ctl.AIPLinkCreated;
        String s = ctl.AIPLetterLink;
        testable.Opp.Attachment_AIP_Letter__c = testable.att.id;
        update testable.Opp;
        Boolean b1 = ctl.AIPLinkCreated;
        String s1 = ctl.AIPLetterLink;
        
        
             
    }      
     static testMethod void AddApplicant()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();  
       // PageReference pageRef = Page.HPPEventAIP;
        //Test.setCurrentPage(pageRef);
        //ApexPages.currentPage().getParameters().put('id', testable.log.id);        
       
        
         PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('X-UA-Compatible', 'IE=edge'); 
       ApexPages.currentPage().getParameters().put('id', testable.log.id); 
         testable.AddApplicants(4);
            //Create quotation
        IBBQuotation__c quote = new IBBQuotation__c ();
        quote.DealType__c = testable.opp.Deal_Type__c ;
        quote.IBBProduct__c = testable.opp.IBB_Product__c ;
        quote.Term_Of_Finance__c = testable.opp.Term_Of_Finance__c ;
        quote.DealAmount__c  = testable.opp.Finance_Required__c;
        quote.Opportunity__c = testable.opp.id;
        quote.RCERetrieved__c=true;
        quote.QuoteToBeAIP__c=true;
        quote.Attachment_FIS__c='test';
        insert quote ;
        
        Account acc =[select id from Account Limit 1];
        IBBQuotation__c  qu = [select id,DealType__c,IBBProduct__c,Term_Of_Finance__c,DealAmount__c from IBBQuotation__c Limit 1];
        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.CurApp = 2;
        ctl.AddApplicant();
        ctl.AddExistingAccount(acc.Id);
        ctl.LookupApplicant();
        ctl.CreateAcc(34);
        ctl.ExternalProductEntered();
        ctl.CreateDoc();
        ctl.delItem();
        ctl.CreateAIPLetter();
        String App1Css = ctl.App1Css;
        String App2Css = ctl.App2Css;
        String App3Css = ctl.App3Css;
        String App4Css = ctl.App4Css;
        Boolean IsPremier = ctl.IsPremier;
        Boolean ShowExisting = ctl.ShowExisting;
        Integer whichLine = ctl.whichLine;
        String TempFirstName = ctl.TempFirstName;
        String TempLastName = ctl.TempLastName;
        String TempTitle = ctl.TempTitle;
        Boolean HasNone =ctl.HasNone;
        Test.startTest();
        try{
      ctl.NextAPP();
        }catch(Exception e){
            
        }try{
        ctl.PreviousAPP();
        }catch(Exception e){}
        try{
        ctl.Applicant4();
        }catch(Exception e){}
        try{
        ctl.ApplicantsPage();            
        }catch(Exception e){}
        try{
        ctl.LastApp();
        }catch(Exception e){}
        Test.stopTest();
    }   
      static testMethod void CallRCE()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(4);
        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.CurApp = 2;
        try{ctl.CallRCE();}catch(exception e){}
      
    }   
      static testMethod void UpdateDearField()
    {
        zTest_HPPEventAIPController testable = new zTest_HPPEventAIPController();
        testable.SetUpObjects();  
        PageReference pageRef = Page.HPPEventAIP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testable.log.id);        
        testable.AddApplicants(4);
        
        HPPEventAIPController ctl = new HPPEventAIPController();
        ctl.CurApp = 2;
       // ctl.UpdateDearField();

    }   
     
     
}