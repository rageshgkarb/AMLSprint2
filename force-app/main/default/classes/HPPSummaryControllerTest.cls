@isTest
public class HPPSummaryControllerTest {

     @Testsetup
     public static void testHPPDataSetup(){
        
        Account acc =  new Account();
        acc.FirstName='test';
        acc.LastName='force26';
        acc.Salutation='Mr';
        insert acc;
        
        Campaign camp = new Campaign();
        camp.Name='Test Campaign';
        insert camp;
        
        IBB_Product_Set__c	ps = new IBB_Product_Set__c();
        ps.Name='test';
        insert ps;
        
        IBB_Product__c prod = new IBB_Product__c();
        prod.Name='test';
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
        prod.Risk_Features_Document__c='test';
        insert prod;
        
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
        o.IBB_Product__c = prod.id;
        o.caa_decision__c = 'Test';
        o.From_Upload__c = true;
        o.Attachment_AIP_Letter__c = 'test';
        o.Attachment_Welcome_Letter__c= 'test';
        o.Attachment_App_Form__c = 'test';
        o.Attachment_Offer_Letter__c = 'test';
        update o;
         
        Event__c event;
        event= dHelp.Event;
        
        Hpp_extended_opportunity__c ex  = new HPP_extended_opportunity__c ();
        ex.Opportunity__c = o.id;
        insert ex;
                       
        EventLog__c log = new EventLog__c();
        log.Event__c = dHelp.Event.id;
        log.Opportunity__c = o.id;
        log.EventStatus__c = 'Open';
        insert log;
        
        IBBQuotation__c quote = new IBBQuotation__c();
        quote.Name = 'test';
        quote.Opportunity__c = o.id;
        quote.Attachment_FIS__c = 'test';
        insert quote;
        
    }
    @istest
    public static void testHPPMethods(){
      
        HPPSummaryController hpp = new HPPSummaryController();
        hpp.prod = [SELECT Id,Risk_Features_Document__c,IDD_Document__c from IBB_Product__c LIMIT 1];
        IBBQuotation__c ibb = [SELECT Id FROM IBBQuotation__c LIMIT 1];
        hpp.opp= [SELECT id,Attachment_AIP_Letter__c,IBBQuotation__c,Attachment_Welcome_Letter__c,Attachment_App_Form__c,Attachment_Offer_Letter__c FROM Opportunity limit 1];
        IBB_Product__c Product = hpp.Product;
        Opportunity objOpp = hpp.objOpp;
        string FIS=hpp.FIS;
        string AIP = hpp.AIP;
        string ApplicationForm = hpp.ApplicationForm;
        string WelcomeLetter=hpp.WelcomeLetter;
        string OfferLetter=hpp.OfferLetter;
        String KeyFactsLink = hpp.KeyFactsLink;
        String IDDLink=hpp.IDDLink;
    } 
}