@isTest
public class HPPEventMenuController_LightningTest {

    
    @testSetup
    public static void dataSetup(){
       NPAA_TestSetupData.dataSetup(); 
    }
    
    @isTest
    public static void testEventMenu(){
       EventLog__c event = [Select Id,Opportunity__c from EventLog__c Limit 1];
        event.isExpired__c = false;
        update event;
        
        ProductEventDirector__c direct = [Select Id from ProductEventDirector__c LIMIT 1];
       
      HPPEventMenuController_Lightning.Wrapper wrap = HPPEventMenuController_Lightning.getConstructor(event.Id, event.Opportunity__c, direct.Id);
            String sLink =HPPEventMenuController_Lightning.CompleteE(wrap);
       String js = wrap.JsonAdHocEvents;
       js= wrap.JsonEvents;
        wrap.getopp_Id();
       List<EventHelper.ProjectedEvent> pre = wrap.AdhocEvents;
        List<EventLog__c> elog = wrap.EventLogs;
        List<EventHelper.ProjectedEvent> pe =wrap.MyEvents;
        wrap = new HPPEventMenuController_Lightning.Wrapper();
        
    }
}