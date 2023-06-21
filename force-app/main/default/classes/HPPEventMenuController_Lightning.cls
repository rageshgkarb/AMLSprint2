public class HPPEventMenuController_Lightning {
  
    @AuraEnabled
    public static Wrapper getConstructor(String eventId,String Opp_Id,String Director_Id){
        Wrapper wrap = new Wrapper( eventId, Opp_Id, Director_Id);
        return wrap;
    }
        
    
    
    
   public class Wrapper{
       @AuraEnabled public List<EventHelper.ProjectedEvent> Events{get;set;}
       @AuraEnabled public List<EventHelper.ProjectedEvent> AdhocEvents{get;set;}
       @AuraEnabled public String Director_Id{get;set;}
       @AuraEnabled public List<EventHelper.ProjectedEvent> MyEvents{get;set;}
       @AuraEnabled public String eventId {get ;set; }
       @AuraEnabled public String opp_Id {get ;set; }
        
        Wrapper(String eventId,String Opp_Id,String Director_Id){
           
           this.eventId = eventId;
           this.Director_Id =Director_Id;
           this.setopp_Id(opp_Id);
            
        }
       @AuraEnabled public String JsonEvents 
        {
            get{
                return Json.serialize(Events);
            }
        }
        
       @AuraEnabled public String JsonAdHocEvents 
        {
            get{
                return Json.serialize(AdhocEvents);
            }
        }
        
   @AuraEnabled public List<EventLog__c> EventLogs
    {
        get{
            return [select id,lastModifieddate, CompletedBy__c,ActualCompletedDate__c,CreatedDate__c,
                    CreatedBy.name,LastModifiedBy.name, isExpired__c, Event__r.name  
                    from EventLog__c where opportunity__c =:opp_id order by CreatedDate__c desc];
        }
    }

        
       
        
     
        
         public void GetData()
        {
            this.Events = EventHelper.GetEvents(Opp_Id, Director_Id); 
            System.debug(this.Events);
        }
    
        
        
        
        
    public String getopp_Id() {
        return opp_Id;
    }
    
    
  
    
     public void setopp_Id(String s) {
        opp_Id= s;
        GetData();
    }
       public    Wrapper(){
            
        } 
        
    }
        @AuraEnabled
     public static String CompleteE(Wrapper wrap)
        {
 
            //check    
            IBBEvents director = new IBBEvents( wrap.Director_Id);
            
            EventLog__c EventLog = DataHelper.GetEventlog(wrap.eventId )[0];
            Opportunity opp = DataHelper.GetOpportunity(wrap.opp_id)[0];
            
            Boolean returnValue = director.CompleteEvent(EventLog, opp);  
            if(!returnValue)return null;                    
                    
            EventLog__c CreatedEvent = director.GetCreatedEvent(); 
           
            String NextEventUrl  ;
            if(director.GetCreatedEventLocation() != null)
            {
                NextEventUrl  = director.GetCreatedEventLocation() + '?id=' +CreatedEvent.id;
            }
            else
            {
                NextEventUrl  = '/apex/HPPBOEvent?id=' + CreatedEvent.id;
            }
                    
            return NextEventUrl;    
        }   
        

}