@isTest
public class FCUJobHandlerTest {
    
    @TestSetup static void casesMethod() {
        
        List<FCUJob__c> fcList = new List<FCUJob__c>();
        List<Case> csList = new List<Case>();
        
        for(Integer i=0;i<2;i++){
        	 Case cs = new case();
        	 cs.Additional_Information_Provided__c = 'Case '+i;
       		 csList.add(cs);
        }
        if(csList.size()>0){
            insert csList;
        }

        for(Integer i=0;i<2;i++){
        	FCUJob__c fcRec = new FCUJob__c();        
        	fcRec.Case__c=cslist[i].Id;  
        	fclist.add(fcRec);
        }
        if(fcList.size()>0){
            insert fcList;
        }   
    }   
    @isTest static void jobCaseTest(){
    
        List<FCUJob__c> fcList1 = [Select id, Case__c, NTC_letter_sent_date__c,Account_Restriction_actioned_date__c,Account_Restriction_due_date__c,
                                   Account_Closure_actioned_date__c,Account_Closure_due_date__c,Trigger_reason__c, PR_due_month__c From FCUJob__c];
        system.debug('fcList1'+fcList1);
        
        fcList1[0].NTC_letter_due_date__c = Date.today();
        fcList1[0].NTC_letter_sent_date__c = Date.today()+2;
        
        fcList1[1].Additional__c = 'Testing';
        
        update fcList1;
        
    }    
}