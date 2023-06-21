/**
 * @description       : Test class for BAA_SummaryController_Lightning which displays the welcome letter and application form
 * @author            : Anuradha Dabhadkar
 * @group             : 
 * @last modified on  : 06-02-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class BAA_SummaryController_Lightning_Test {
    public ProductEventDirector__c director{get;set;}
     public Event__c event{get;set;} 
     public Opportunity Opp{get;set;}  
     public EventLog__c Log{get;set;} 
     public List<Attachment> att{get;set;}
     public HPP_extended_opportunity__c ex{get;set;} 
     z_ProductHelper pHelp ;
    
    static testmethod void Test_AddOutwardPayment()
    {
        BAA_SummaryController_Lightning_Test testable = new BAA_SummaryController_Lightning_Test();
        testable.SetUpObjects();
        String eventId = testable.Log.Id;
        NPAABaseEventController.Wrapper wrap = BAA_SummaryController_Lightning.getWrapper(eventId, null);
        BAA_SummaryController_Lightning.initWrapper testInitWrapper = BAA_SummaryController_Lightning.summaryDetails(wrap);
    }

    public void SetUpObjects()
    {
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        director = dHelp.Build();
                
        pHelp = new z_ProductHelper();        
        pHelp.Director(director.id);
        IBB_Product_Set__c prod  = pHelp.Build();
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test');
        oHelp.Director(director.id);
        Opp = oHelp.build();
        
        Opp.IBB_Product__c = pHelp.Product.id;
        update opp;

        event = new Event__c();
        event.eventtype__c ='Flow';
        event.name = 'BAA Summary';
        Insert event;
        
        Log = new EventLog__c();
        Log.Opportunity__c = Opp.Id;
        Log.Event__c = event.Id;
        Log.EventStatus__c = 'Open';
        Log.Name = 'BAA Summary';
        insert Log;

        att = new List<Attachment>();
        Attachment att1 = new Attachment();
        att1.parentid = Opp.id;
        att1.body =  Blob.valueOf('Application Form');
        att1.name = 'Application Form';
        att.add(att1);

        Attachment att2 = new Attachment();
        att2.parentid = Opp.id;
        att2.body =  Blob.valueOf('Welcome Letter');
        att2.name = 'Welcome Letter';
        att.add(att2);
        
        insert att;

        Opp.Attachment_App_Form__c = att[0].Id;
        Opp.Attachment_Welcome_Letter__c = att[1].Id;
        update Opp;

    }
}