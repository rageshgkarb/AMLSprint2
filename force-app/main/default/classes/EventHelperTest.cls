@isTest
public class EventHelperTest {
     @testSetup 
    public static void dataSetup(){
         NPAA_TestSetupData.dataSetup();
    }
    @isTest
    public static void testEventHelper(){
        EventLog__c el = [select id,Opportunity__c,Opportunity__r.AccountId from EventLog__c limit 1];
        Test.startTest();
        try{ EventHelper.CreateCaseOpportunity(el,new Event__c(), el.opportunity__c);}catch(Exception e){}
        try{  EventHelper.CreateCase(el,new Event__c(), el.Opportunity__r.AccountId);}catch(Exception e){}
        try{List<EventHelper.ProjectedEvent> var1 = EventHelper.GetEvents(el.opportunity__c, 'directorId');}catch(Exception e){}
        try{List<EventHelper.ProjectedEvent> var1 = EventHelper.GetEventsAdhoc(el.opportunity__c, 'directorId');}catch(Exception e){}
        try{string var1 = EventHelper.GetExternalDirectorIdByProductSet(el.id);}catch(Exception e){}
        try{string var1 = EventHelper.GetDirectorIdByProductSet(el.id);}catch(Exception e){}
        try{string var1 = EventHelper.GetDirectorIdByProduct(el.id);}catch(Exception e){} 
        try{
            EventHelper.ProjectedEvent pe= new EventHelper.ProjectedEvent();
            string str = pe.CompletedDate;
            string str1 = pe.CompletedBy;}catch(Exception e){}
        Test.stopTest();
}

}