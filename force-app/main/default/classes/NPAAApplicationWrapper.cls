public class NPAAApplicationWrapper {
    @AuraEnabled
    public Opportunity oppty;
    
    @AuraEnabled
    public String pageMessage; 
    
    @AuraEnabled
    public Applicant__c Applicant;
    
    @AuraEnabled
    public Account Applicant1;
    
    public NPAAApplicationWrapper ( ) {
    }

    public NPAAApplicationWrapper ( String pageMessage) {
        this.pageMessage = pageMessage;
    }

    public NPAAApplicationWrapper ( Opportunity oppObj  ) {
        this.oppty = oppObj;
    }

}