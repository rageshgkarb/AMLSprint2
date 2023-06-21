@isTest
public class CAA_Product_Detail_Controller_lightTest {

    @TestSetup
    public static void dataSetup(){
      
      	Account acc = new Account();
        acc.Salutation = 'Mr';
        acc.FirstName = 'Test Account';
        acc.LastName = 'Test Account';
        acc.BillingPostalCode = 'Test Account';
        acc.Title_Other__c = 'xyz';
        acc.Self_Cert_Capacity__c='Self';
        acc.Self_Certification_Declaration_Date__c=system.today();
          acc.marketing_preference__C = 'email';
            acc.Net_Monthly_Income__c = 4000;  
        insert acc;  
        
        
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();
        
     
            
         
        
           Opportunity Opp = new Opportunity();
            Opp.stagename ='Open';
            Opp.closedate = date.today();
            Opp.AccountId = acc.id;
            Opp.Name = 'Test Opp';
            Opp.Interested_in__c = 'Test';
            Opp.Purchase_price_market_value__c = 300000;
            Opp.Finance_Required__c = 100000;
         
            opp.Term_of_Finance__c=25;
            opp.number_of_people_applying__c = 1;
       
        
        
    
        opp.stagename = 'test';
        opp.closedate = date.today();
        opp.ProductEventDirector__c = director.id;
        insert opp;
        
        Event__c e = dHelp.Event;
        e.name = 'Awaiting Valuation';
        update e;
        
        Eventlog__c log = new Eventlog__c();
        log.event__c = e.id;
        log.eventstatus__c = 'Open';
        log.isexpired__c = false;
        log.opportunity__c = opp.id;
        insert log;    
    }
    
    @istest
    public static void testProductDetail(){
         CAA_Product_Detail_Controller_lightning pdc = new CAA_Product_Detail_Controller_lightning();
       	 CAA_Product_Detail_Controller_lightning.init_wrap wrp = new CAA_Product_Detail_Controller_lightning.init_wrap();
        wrp.TermMonths = 12;
        wrp.LessThanOr12Months = false;
       	 EventLog__c evntLog = [select id,Opportunity__c from EventLog__c LIMIT 1];
         wrp = CAA_Product_Detail_Controller_lightning.ISASetup('', evntLog.id);
         
        CAA_Data.ISATerms isaTerms = new CAA_Data.ISATerms();
        isaTerms.ExistingAlRayanIsa = 'existing';
        isaTerms.ISA1 = true;
        
         CAA_Data.FTD FTD = new CAA_Data.FTD();
        FTD.WhatToDoWithProfit = 'maturity';
        
        CAA_Product_Detail_Controller_lightning.FTD(evntLog.id, FTD);
        CAA_Product_Detail_Controller_lightning.FTDISA(evntLog.id, FTD);
        CAA_Product_Detail_Controller_lightning.ISATerms(evntLog.id, isaTerms);
        
    }
    
   
}