@isTest
public class HPPCAA_SummaryController_LightningTest {

    @testSetup
    public static void setupData(){
       
           
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();  
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Testfirstname','TestLastname');
        oHelp.Director(director.id);
        Opportunity opp= oHelp.build();
       
        
        Event_Rewind__c rew = new Event_Rewind__c(opportunity__c=opp.id);
        insert rew;
    }
    
    @isTest
    public static void testgetLatestRewind(){
        
        Opportunity opp = [Select Id from Opportunity LIMIT 1];
        HPPCAA_SummaryController_Lightning.getLatestRewind(opp);
       
        }
}