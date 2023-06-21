public class FCUJobHandler {
    
    public static void jobFieldUpdate(map<Id, FCUJob__c> mapNewfcuJobs,map<Id, FCUJob__c> mapOldfcuJobs,String execType){
        
        Set<Id> caseIds = new Set<Id>();
        List<Case> csList = new List<Case>();
        Map<Id,FCUJob__c> mapjobCase = new Map<Id,FCUJob__c>();
      /*  Map<Id,FCUJob__c> newJobMap = new Map<Id,FCUJob__c>();
        
        if(mapNewfcuJobs.size()>0){
            if(mapNewfcuJobs.get(value).
               {
                FCUJob__c cs = [select Id,NTC_letter_due_date__c,Account_Restriction_actioned_date__c,Account_Restriction_due_date__c,
                    Account_Closure_actioned_date__c,Account_Closure_due_date__c,Trigger_Reason__c,PR_due_month__c 
                    from case where Id in: mapNewfcuJobs.Case__c]
                    System.debug('');
            }
        }  */
        
        for(FCUJob__c fcujObj: mapNewfcuJobs.Values()){
            if(fcujObj.Case__c != null)
            mapjobCase.put(fcujObj.Case__c,fcujObj);
            caseIds.add(fcujObj.Case__c);
            
        }

        csList = [select Id,NTC_letter_due_date__c,Account_Restriction_actioned_date__c,Account_Restriction_due_date__c,
                    Account_Closure_actioned_date__c,Account_Closure_due_date__c,Trigger_Reason__c,PR_due_month__c 
                    from case where Id in: caseIds]; 
         
        List<Case> caseList = new List<Case>();
        
        for(Case each : csList){
            if(execType=='update'){
                if(mapjobCase.containsKey(each.Id) && mapjobCase.get(each.Id)  != null && CheckUpdates(mapjobCase.get(each.Id), mapOldfcuJobs)){
                    each.NTC_letter_due_date__c = mapjobCase.get(each.Id).NTC_letter_due_date__c;
                    each.NTC_letter_sent_date__c = mapjobCase.get(each.Id).NTC_letter_sent_date__c;
                    each.Account_Restriction_actioned_date__c = mapjobCase.get(each.Id).Account_Restriction_actioned_date__c;
                    each.Account_Restriction_due_date__c  = mapjobCase.get(each.Id).Account_Restriction_due_date__c;
                    each.Account_Closure_actioned_date__c = mapjobCase.get(each.Id).Account_Closure_actioned_date__c;
                    each.Account_Closure_due_date__c = mapjobCase.get(each.Id).Account_Closure_due_date__c;
                    each.Trigger_Reason__c = mapjobCase.get(each.Id).Trigger_Reason__c;  
                    each.PR_due_month__c = mapjobCase.get(each.Id).PR_due_month__c;
                    caseList.add(each);
                }
            }
            else{
                    if(mapjobCase.containsKey(each.Id) && mapjobCase.get(each.Id)  != null){
                        each.NTC_letter_due_date__c = mapjobCase.get(each.Id).NTC_letter_due_date__c;
                        each.NTC_letter_sent_date__c = mapjobCase.get(each.Id).NTC_letter_sent_date__c;
                        each.Account_Restriction_actioned_date__c = mapjobCase.get(each.Id).Account_Restriction_actioned_date__c;
                        each.Account_Restriction_due_date__c  = mapjobCase.get(each.Id).Account_Restriction_due_date__c;
                        each.Account_Closure_actioned_date__c = mapjobCase.get(each.Id).Account_Closure_actioned_date__c;
                        each.Account_Closure_due_date__c = mapjobCase.get(each.Id).Account_Closure_due_date__c;
                        each.Trigger_Reason__c = mapjobCase.get(each.Id).Trigger_Reason__c;  
                        each.PR_due_month__c = mapjobCase.get(each.Id).PR_due_month__c;
                        caseList.add(each);
                    }
                }
           
        }
    

        if(caseList.size()>0){ 
            update caseList;    
        }   
        
    }

    public static boolean CheckUpdates(FCUJob__c updatedRec, map<Id, FCUJob__c> mapOldfcuJobs){
        if((updatedRec.NTC_letter_due_date__c !=mapOldfcuJobs.get(updatedRec.Id).NTC_letter_due_date__c)
            ||(updatedRec.NTC_letter_sent_date__c!= mapOldfcuJobs.get(updatedRec.Id).NTC_letter_sent_date__c)
            ||(updatedRec.Account_Restriction_actioned_date__c!=mapOldfcuJobs.get(updatedRec.Id).Account_Restriction_actioned_date__c)
            ||(updatedRec.Account_Restriction_due_date__c!=mapOldfcuJobs.get(updatedRec.Id).Account_Restriction_due_date__c)
            ||(updatedRec.Account_Closure_actioned_date__c!= mapOldfcuJobs.get(updatedRec.Id).Account_Closure_actioned_date__c)
            ||(updatedRec.Account_Closure_due_date__c!= mapOldfcuJobs.get(updatedRec.Id).Account_Closure_due_date__c)
            ||(updatedRec.Trigger_Reason__c!= mapOldfcuJobs.get(updatedRec.Id).Trigger_Reason__c) 
            ||(updatedRec.PR_due_month__c!= mapOldfcuJobs.get(updatedRec.Id).PR_due_month__c))
        {
            return TRUE;
        }
        return FALSE;
    }
    
    
}