public with sharing class CustomerDataHandler {
    
    public static ProspectCustomerDeleteResponse deleteAccountData(String accountID){
        
        Trigger_Helper.TriggerItem itemAcc = new Trigger_Helper.TriggerItem();
        itemAcc.Name = 'Account';
        itemAcc.IgnoreAudit = true;
        itemAcc.IgnoreTrigger = true;
        Trigger_Helper.Items.add(itemAcc);
        
        Trigger_Helper.TriggerItem oppItem = new Trigger_Helper.TriggerItem();
        oppItem.Name = 'Opportunity';
        oppItem.IgnoreTrigger =true ;      
        oppItem.IgnoreAudit = true;  
        Trigger_Helper.Items.add(oppItem);
        
        Trigger_Helper.TriggerItem oItem = new Trigger_Helper.TriggerItem();
        oItem .Name = 'HPP_extended_opportunity__c';
        oItem .IgnoreTrigger =true ;
        oItem .IgnoreAudit = true;        
        Trigger_Helper.Items.add(oItem );
        
        Trigger_Helper.TriggerItem cItem = new Trigger_Helper.TriggerItem();
        cItem.Name = 'Case';
        cItem.IgnoreTrigger =true ;
        cItem.IgnoreAudit = true;        
        Trigger_Helper.Items.add(cItem);
        
        ProspectCustomerDeleteResponse deleteResponse = new ProspectCustomerDeleteResponse();
        deleteResponse.accountId = accountID;        
        Integer recordsSize = 0;
        
        try{
            
            List <AccountRelatedEntities__mdt> accRelatedEntities = AccountRelatedEntities__mdt.getAll().values();
            Map<String,Map<Integer,List<String>>> areMap = new Map<String,Map<Integer,List<String>>> ();
            Map<String,Map<Integer,List<String>>> areNameMap = new Map<String,Map<Integer,List<String>>> ();
            for(AccountRelatedEntities__mdt are: accRelatedEntities) {          
                if(areMap.containskey(are.Parent_Object__c)){
                    Map<integer,List<string>> childObjectmap = areMap.get(are.Parent_Object__c);
                    Map<integer,List<string>> childObjectNameMap = areNameMap.get(are.Parent_Object__c);
                    if(childObjectmap.get(childObjectmap.size()).size()<8){
                        childObjectmap.get(childObjectmap.size()).add('(select Id from '+ are.Relationship_Name__c + ' )');
                        areMap.put(are.Parent_Object__c,childObjectmap);
                        
                        childObjectNameMap.get(childObjectNameMap.size()).add(are.Relationship_Name__c);
                        areNameMap.put(are.Parent_Object__c,childObjectNameMap);
                        
                    }else{
                        childObjectmap.put(childObjectmap.size()+1,new List<string>());
                        childObjectmap.get(childObjectmap.size()).add('(select Id from '+ are.Relationship_Name__c + ' )');
                        areMap.put(are.Parent_Object__c,childObjectmap);
                        
                        childObjectNameMap.put(childObjectNameMap.size()+1,new List<string>());
                        childObjectNameMap.get(childObjectNameMap.size()).add(are.Relationship_Name__c);
                        areNameMap.put(are.Parent_Object__c,childObjectNameMap);
                    }             
                    
                } else {
                    Map<integer,List<string>> childObjectmap = new Map<integer,List<string>>();
                    Map<integer,List<string>> childObjectNameMap = new Map<integer,List<string>>();
                    
                    childObjectmap.put(1,new List<string>());
                    childObjectmap.get(childObjectmap.size()).add('(select Id from '+ are.Relationship_Name__c + ' )');
                    areMap.put(are.Parent_Object__c,childObjectmap);
                    
                    childObjectNameMap.put(1,new List<string>());
                    childObjectNameMap.get(childObjectNameMap.size()).add(are.Relationship_Name__c);
                    areNameMap.put(are.Parent_Object__c,childObjectNameMap);               
                }
            }
            
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([Select id from Opportunity where AccountId =:accountID ]);
            
            List<Id> oppIds = new List<Id>();
            for(Id oppId: oppMap.keySet()){
                oppIds.add(oppId);
            }
            Map<integer,List<string>> oppIntMap = areMap.get('Opportunity');
            Map<integer,List<string>> oppNameMap = areNameMap.get('Opportunity');
            for(integer i:oppIntMap.keyset()){
                List<Id> oppRelatedIds = new List<Id>();
                Map<String,List<Id>> oppChildMap = new Map<String,List<Id>>();
                string qString = 'Select id,'+ string.join(oppIntMap.get(i),',') +' from Opportunity where Id in:oppIds';
                system.debug('***qString:'+qString);
                List<sObject> records = database.query(qString);
                for(sObject record: records) {
                    for(string childObjectRec:oppNameMap.get(i)) {
                        for(sobject ch:record.getSObjects(childObjectRec)) {
                            Id recordId = String.valueof(ch.get('Id'));
                            String objectType = String.valueof(recordId.getsobjecttype());
                            oppRelatedIds.add(recordId);
                            recordsSize+=1;
                            if(oppChildMap.containsKey(objectType)){
                                oppChildMap.get(objectType).add(recordId);
                            }else{
                                oppChildMap.put(objectType, new List<string>());  
                                oppChildMap.get(objectType).add(recordId);
                            }
                        }                    
                    }                   
                }
                for(String oppChild: oppChildMap.keyset()){
                    system.debug('oppChildMap'+oppChildMap.get(oppChild).size());
                    Database.DeleteResult[] result = Database.delete(oppChildMap.get(oppChild), false);
                }
            }
            system.debug('recordsSize--'+recordsSize);
            recordsSize+= oppIds.size();
            Database.DeleteResult[] resultoppIds = Database.delete(oppIds, false);
            
            Map<Id,Case> caseMap = new Map<Id,Case>([Select Id from Case where AccountId =:accountID or SA_Same_as__c=:accountID ]);
            
            List<Id> caseIds = new List<Id>();
            for(Id caseId: caseMap.keySet()){
                caseIds.add(caseId);
            }
            Map<integer,List<string>> caseIntMap = areMap.get('Case');
            Map<integer,List<string>> caseNameMap = areNameMap.get('Case');
            for(integer i:caseIntMap.keyset()){
                List<Id> caseRelatedIds = new List<Id>();
                Map<String,List<Id>> caseChildMap = new Map<String,List<Id>>();
                system.debug('caseIntMap.keyset()'+caseIntMap);
                string qString = 'Select id,'+ string.join(caseIntMap.get(i),',') +' from Case where Id in:caseIds';
                system.debug('***qString:'+qString);
                List<sObject> records = database.query(qString);
                for(sObject record: records) {
                    for(string childObjectRec:caseNameMap.get(i)) {
                        for(sobject ch:record.getSObjects(childObjectRec)) {
                            Id recordId = String.valueof(ch.get('Id'));
                            String objectType = String.valueof(recordId.getsobjecttype());
                            caseRelatedIds.add(String.valueof(ch.get('Id')));
                            recordsSize+=1;
                            if(caseChildMap.containsKey(objectType)){
                                caseChildMap.get(objectType).add(recordId);
                            }else{
                                caseChildMap.put(objectType, new List<string>());  
                                caseChildMap.get(objectType).add(recordId);
                            }
                        }
                    }
                }
                for(String caseChild: caseChildMap.keyset()){
                    system.debug('caseChildMap'+caseChildMap.get(caseChild).size());
                    Database.DeleteResult[] result = Database.delete(caseChildMap.get(caseChild), false);
                }
            }
            system.debug('recordsSize--'+recordsSize);
            recordsSize+= caseIds.size();
            Database.DeleteResult[] resultcaseIds = Database.delete(caseIds, false);
            
            Map<integer,List<string>> accIntMap = areMap.get('Account');
            Map<integer,List<string>> accNameMap = areNameMap.get('Account');
            for(integer i:accIntMap.keyset()){
                List<Id> accRelatedIds = new List<Id>();
                Map<String,List<Id>> accChildMap = new Map<String,List<Id>>();
                string qString = 'Select id,'+ string.join(accIntMap.get(i),',') +' from Account where Id=:accountID LIMIT 1';
                system.debug('***qString:'+qString);
                List<sObject> records = database.query(qString);
                for(sObject record: records) {
                    for(string childObjectRec:accNameMap.get(i)) {
                        for(sobject ch:record.getSObjects(childObjectRec)) {
                            Id recordId = String.valueof(ch.get('Id'));
                            String objectType = String.valueof(recordId.getsobjecttype());
                            accRelatedIds.add(String.valueof(ch.get('Id')));
                            recordsSize+=1;
                            if(accChildMap.containsKey(objectType)){
                                accChildMap.get(objectType).add(recordId);
                            }else{
                                accChildMap.put(objectType, new List<string>());  
                                accChildMap.get(objectType).add(recordId);
                            }
                        }
                    }
                }
                for(String accChild: accChildMap.keyset()){
                    system.debug('accChildMap'+accChildMap.get(accChild).size());
                    Database.DeleteResult[] result = Database.delete(accChildMap.get(accChild), false);
                }
            }
            system.debug('recordsSize--'+recordsSize);
            Database.DeleteResult result = Database.delete(accountID, true);
            deleteResponse.message = 'Deleted Successfully';
            deleteResponse.childRecordCount = recordsSize;
            deleteResponse.success = true;
        } catch(exception ex){
            system.debug('******exception:'+ex.getmessage());
            deleteResponse.message = ex.getmessage();
            deleteResponse.childRecordCount = recordsSize;
            deleteResponse.success = false;
            return deleteResponse;
        }
        System.debug(recordsSize);
        return deleteResponse;
    }
    
    public static String deleteAccountData(List<Id> accountIDsList){
        integer failCount = 0;
        integer count = 0;
        Trigger_Helper.TriggerItem itemAcc = new Trigger_Helper.TriggerItem();
        itemAcc.Name = 'Account';
        itemAcc.IgnoreAudit = true;
        itemAcc.IgnoreTrigger = true;
        Trigger_Helper.Items.add(itemAcc);
        
        Trigger_Helper.TriggerItem oppItem = new Trigger_Helper.TriggerItem();
        oppItem.Name = 'Opportunity';
        oppItem.IgnoreTrigger =true ;      
        oppItem.IgnoreAudit = true;  
        Trigger_Helper.Items.add(oppItem);
        
        Trigger_Helper.TriggerItem oItem = new Trigger_Helper.TriggerItem();
        oItem .Name = 'HPP_extended_opportunity__c';
        oItem .IgnoreTrigger =true ;
        oItem .IgnoreAudit = true;        
        Trigger_Helper.Items.add(oItem );
        
        Trigger_Helper.TriggerItem cItem = new Trigger_Helper.TriggerItem();
        cItem.Name = 'Case';
        cItem.IgnoreTrigger =true ;
        cItem.IgnoreAudit = true;        
        Trigger_Helper.Items.add(cItem);
        
        System.Savepoint sp = Database.setSavepoint();
        String response = '';
        
        try{         
            set<id> contactIdSet = new set<id>();  
            //Additional Logic added by Raiyan on 25-02-2022 for tackling issues with contact's cases.
            for(Account acc:[Select PersonContactId From Account Where Id IN:accountIDsList AND PersonContactId != null]){
                if(acc.PersonContactId != null )
                contactIdSet.add(acc.PersonContactId);
            }
            if(contactIdSet.size() > 0){
                List<case> caseList = [SELECT id,ContactId FROM Case WHERE contactId IN:contactIdSet AND AccountId NOT IN:accountIDsList];
                for(case c:caseList){
                    c.ContactId = null;
                }
                try{
                    if(caseList.size() >0)
                        update caseList;
                }catch(exception e){
                    system.debug('Error While updating case contact details:'+e.getMessage());
                }
            }
            
            List <AccountRelatedEntities__mdt> accRelatedEntities = AccountRelatedEntities__mdt.getAll().values();
            Map<String,Map<Integer,List<String>>> areMap = new Map<String,Map<Integer,List<String>>> ();
            Map<String,Map<Integer,List<String>>> areNameMap = new Map<String,Map<Integer,List<String>>> ();
            Map<String,Map<String,Boolean>> childCasecadeMap = new Map<String,Map<String,Boolean>> ();
            for(AccountRelatedEntities__mdt are: accRelatedEntities) {          
                if(areMap.containskey(are.Parent_Object__c)){
                    Map<integer,List<string>> childObjectmap = areMap.get(are.Parent_Object__c);
                    Map<integer,List<string>> childObjectNameMap = areNameMap.get(are.Parent_Object__c);
                    Map<String,Boolean> tempCascadeMap = childCasecadeMap.get(are.Parent_Object__c);
                    
                    if(childObjectmap.get(childObjectmap.size()).size()<10){
                        childObjectmap.get(childObjectmap.size()).add('(select Id from '+ are.Relationship_Name__c + ' )');
                        areMap.put(are.Parent_Object__c,childObjectmap);
                        
                        childObjectNameMap.get(childObjectNameMap.size()).add(are.Relationship_Name__c);
                        areNameMap.put(are.Parent_Object__c,childObjectNameMap);
                        
                    }else{
                        childObjectmap.put(childObjectmap.size()+1,new List<string>());
                        childObjectmap.get(childObjectmap.size()).add('(select Id from '+ are.Relationship_Name__c + ' )');
                        areMap.put(are.Parent_Object__c,childObjectmap);
                        
                        childObjectNameMap.put(childObjectNameMap.size()+1,new List<string>());
                        childObjectNameMap.get(childObjectNameMap.size()).add(are.Relationship_Name__c);
                        areNameMap.put(are.Parent_Object__c,childObjectNameMap);
                    } 
                    
                    tempCascadeMap.put(are.Relationship_Name__c,are.Cascade_Delete__c);
                    childCasecadeMap.put(are.Parent_Object__c,tempCascadeMap);
                    
                } else {
                    Map<integer,List<string>> childObjectmap = new Map<integer,List<string>>();
                    Map<integer,List<string>> childObjectNameMap = new Map<integer,List<string>>();
                    Map<String,Boolean> tempCascadeMap = new Map<String,Boolean>();
                    
                    childObjectmap.put(1,new List<string>());
                    childObjectmap.get(childObjectmap.size()).add('(select Id from '+ are.Relationship_Name__c + ' )');
                    areMap.put(are.Parent_Object__c,childObjectmap);
                    
                    childObjectNameMap.put(1,new List<string>());
                    childObjectNameMap.get(childObjectNameMap.size()).add(are.Relationship_Name__c);
                    areNameMap.put(are.Parent_Object__c,childObjectNameMap);  
                    
                    tempCascadeMap.put(are.Relationship_Name__c,are.Cascade_Delete__c);
                    childCasecadeMap.put(are.Parent_Object__c,tempCascadeMap);
                    
                }
            }
            
            Map<Id,Account> accountMap = new Map<Id,Account>([Select Id from Account Where id in:accountIDsList]);
            List<Id> accountIDs = new List<Id>();
            Map<Id,Integer> accChildCount = new Map<Id,Integer>();
            Map<Id,Set<String>> accChildCountMap = new Map<Id,Set<String>>();
            
            for(Account acc : accountMap.values()){
                accountIDs.add(acc.Id);
                accChildCount.put(acc.Id,0);
                Set<String> childString = new Set<String>();
                accChildCountMap.put(acc.Id,childString);
            }
            
            
            List<SObject> auditSet = new List<SObject>();
            
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([Select Id,AccountId from Opportunity where AccountId in:accountIDs ]);
            
            List<Id> oppIds = new List<Id>();
            for(Opportunity opp: oppMap.values()){
                oppIds.add(opp.Id);
                if(accChildCount.containsKey(opp.AccountId)){
                    accChildCount.put(opp.AccountId,accChildCount.get(opp.AccountId)+1);
                }else{
                    accChildCount.put(opp.AccountId,1);
                }
                Set<String> chiCountString = accChildCountMap.get(opp.AccountId);
                chiCountString.add(opp.Id);
                accChildCountMap.put(opp.AccountId,chiCountString);
            }
            system.debug('Child Count--Opp-------'+oppMap.size());
            Map<integer,List<string>> oppIntMap = areMap.get('Opportunity');
            Map<integer,List<string>> oppNameMap = areNameMap.get('Opportunity');
            Map<String,Set<SObject>> oppChildMap = new Map<String,Set<SObject>>();
            
            for(integer i:oppIntMap.keyset()){                
                string qString = 'Select id,AccountId,'+ string.join(oppIntMap.get(i),',') +' from Opportunity where Id in:oppIds';
                system.debug('***qString:'+qString);
                List<sObject> records = database.query(qString);
                Map<String,Boolean> tempCascadeMap = childCasecadeMap.get('Opportunity');
                for(sObject record: records) {
                    String accId = String.valueof(record.get('AccountId'));
                    system.debug('accId---'+accId);
                    Integer childCount = accChildCount.get(accId);
                    Set<String> childCountString = accChildCountMap.get(accId);
                    for(string childObjectRec:oppNameMap.get(i)) {
                        //system.debug('childObjectRec---'+childObjectRec);
                        SObject[] childObjects = record.getSObjects(childObjectRec);
                        for(sobject ch:record.getSObjects(childObjectRec)) {
                            String recordId = String.valueof(ch.get('id'));
                            childCountString.add(recordId);
                        }
                        if(childObjects!= null){
                            childCount += childObjects.size();
                            system.debug('Child Count--Opp-'+childObjectRec+'------'+childObjects.size());
                            if(tempCascadeMap.get(childObjectRec) == true){
                                continue;
                            }else if(childObjectRec == 'Audits__r'){
                                auditSet.addAll(childObjects);
                            }else{
                                if(oppChildMap.containsKey(childObjectRec)){
                                    oppChildMap.get(childObjectRec).addAll(childObjects);
                                }else{
                                    oppChildMap.put(childObjectRec, new Set<SObject>());  
                                    oppChildMap.get(childObjectRec).addAll(childObjects);
                                }  
                            }
                        }
                        /*for(sobject ch:record.getSObjects(childObjectRec)) {
                        Id recordId = String.valueof(ch.get('Id'));
                        String objectType = String.valueof(recordId.getsobjecttype());
                        childCount++;                           
                        if(objectType == 'Audit__c'){
                        auditSet.add(recordId);
                        }else{
                        if(oppChildMap.containsKey(objectType)){
                        oppChildMap.get(objectType).add(recordId);
                        }else{
                        oppChildMap.put(objectType, new List<string>());  
                        oppChildMap.get(objectType).add(recordId);
                        }
                        }
                        }*/
                    }
                    accChildCount.put(accId,childCount);    
                    accChildCountMap.put(accId,childCountString);    
                }                                
            }
            
            for(String oppChild: oppChildMap.keyset()){
                //system.debug('oppChild----'+oppChild);
                //system.debug('oppChildMap----'+oppChildMap.get(oppChild).size());
                List<SObject> childList = new List<SObject>();
                childList.addAll(oppChildMap.get(oppChild));
                
                
                try{
                    Database.DeleteResult[] result = Database.delete(childList, true);
                    for (Database.DeleteResult result1: result )
                    {
                      if (!result1.isSuccess())
                      {                
                        failCount++;
                      }else{
                          count++;
                      }
                    }
                }catch(exception e){
                    string msg = e.getMessage();
                    if(msg.containsIgnoreCase('ENTITY_IS_DELETED') && msg.containsIgnoreCase('with id')){
                        msg = msg.substringBetween('id',';');
                        msg = msg.deleteWhitespace();
                        system.debug('Msg Val:'+msg);
                        if(msg.left(3) == '500'){
                            childList = [SELECT ID FROM Case WHERE id IN:childList];
                            DELETE childList;
                        }else if(msg.left(3) == 'a3G'){
                            system.debug('Account_with_IBB__c');
                            childList = [SELECT ID FROM Account_with_IBB__c WHERE id IN:childList];
                            DELETE childList;
                        }
                    }
                }    
                
                
            } 
            
            Database.DeleteResult[] resultoppIds = Database.delete(oppIds, true);
            
            Map<Id,Case> caseMap = new Map<Id,Case>([Select Id,AccountId from Case where AccountId in:accountIDs]);
            Map<Id,Id> accCaseMap = new Map<Id,Id>();
            system.debug('Child Count--Case-------'+caseMap.size());
            List<Id> caseIds = new List<Id>();
            for(Case cas: caseMap.values()){
                caseIds.add(cas.Id);
                if(accChildCount.containsKey(cas.AccountId)){
                    accChildCount.put(cas.AccountId,accChildCount.get(cas.AccountId)+1);
                }else{
                    accChildCount.put(cas.AccountId,1);
                }
                String accId ;
                if(accChildCountMap.containskey(cas.AccountId)){
                    accId = cas.AccountId;
                    accCaseMap.put(cas.Id,cas.AccountId);
                }else {
                    accId = cas.Contact.AccountId;
                    accCaseMap.put(cas.Id,cas.Contact.AccountId);
                }
                Set<String> chiCountString = accChildCountMap.get(accId);
                chiCountString.add(cas.Id);
                accChildCountMap.put(accId,chiCountString);
            }
            
            Map<integer,List<string>> caseIntMap = areMap.get('Case');
            Map<integer,List<string>> caseNameMap = areNameMap.get('Case');
            Map<String,Set<SObject>> caseChildMap = new Map<String,Set<SObject>>();
            
            for(integer i:caseIntMap.keyset()){               
                string qString = 'Select Id,AccountId,'+ string.join(caseIntMap.get(i),',') +' from Case where Id in:caseIds';
                system.debug('***qString:'+qString);
                List<sObject> records = database.query(qString);
                Map<String,Boolean> tempCascadeMap = childCasecadeMap.get('Case');
                for(sObject record: records) {
                    //system.debug('--record--'+record);
                    String accId = accCaseMap.get(String.valueof(record.get('Id')));
                    //system.debug('has next accct id'+accId);
                    Integer childCount = accChildCount.get(accId);
                    Set<String> childCountString = accChildCountMap.get(accId);
                    //system.debug('has next childCountString id'+childCountString);
                    for(string childObjectRec:caseNameMap.get(i)) {
                        SObject[] childObjects = record.getSObjects(childObjectRec);
                        for(sobject ch:record.getSObjects(childObjectRec)) {
                            String recordId = String.valueof(ch.get('Id'));
                            childCountString.add(recordId);
                        }
                        if(childObjects!= null){
                            childCount += childObjects.size();
                            system.debug('Child Count--Count-'+childObjectRec+'------'+childObjects.size());
                            if(tempCascadeMap.get(childObjectRec) == true){
                                continue;
                            }else if(childObjectRec == 'Audits__r'){
                                auditSet.addAll(childObjects);
                            }else{
                                if(caseChildMap.containsKey(childObjectRec)){
                                    caseChildMap.get(childObjectRec).addAll(childObjects);
                                }else{
                                    caseChildMap.put(childObjectRec, new Set<SObject>());  
                                    caseChildMap.get(childObjectRec).addAll(childObjects);
                                }   
                            }
                        }
                        /*
                        for(sobject ch:record.getSObjects(childObjectRec)) {
                        Id recordId = String.valueof(ch.get('Id'));
                        String objectType = String.valueof(recordId.getsobjecttype());
                        //caseRelatedIds.add(String.valueof(ch.get('Id')));
                        childCount++;
                        if(objectType == 'Audit__c'){
                        auditSet.add(recordId);
                        }else{
                        if(caseChildMap.containsKey(objectType)){
                        caseChildMap.get(objectType).add(recordId);
                        }else{
                        caseChildMap.put(objectType, new List<string>());  
                        caseChildMap.get(objectType).add(recordId);
                        }
                        }
                        }*/
                    }
                    accChildCount.put(accId,childCount);
                    accChildCountMap.put(accId,childCountString);
                }                
            }
            
            for(String caseChild: caseChildMap.keyset()){
                //system.debug('caseChildMap'+caseChildMap.get(caseChild).size());
                List<SObject> childList = new List<SObject>();
                childList.addAll(caseChildMap.get(caseChild));
               
                
                try{
                     Database.DeleteResult[] result = Database.delete(childList, true);
                    for (Database.DeleteResult result1: result )
                    {
                      if (!result1.isSuccess())
                      {                
                        failCount++;
                      }else{
                          count++;
                      }
                    }
                }catch(exception e){
                    string msg = e.getMessage();
                    if(msg.containsIgnoreCase('ENTITY_IS_DELETED') && msg.containsIgnoreCase('with id')){
                        msg = msg.substringBetween('id',';');
                        msg = msg.deleteWhitespace();
                        system.debug('Msg Val:'+msg);
                        if(msg.left(3) == '500'){
                            childList = [SELECT ID FROM Case WHERE id IN:childList];
                            DELETE childList;
                        }else if(msg.left(3) == 'a3G'){
                            system.debug('Account_with_IBB__c');
                            childList = [SELECT ID FROM Account_with_IBB__c WHERE id IN:childList];
                            DELETE childList;
                        }
                    }
                }         
            }
            
            Database.DeleteResult[] resultcaseIds = Database.delete(caseIds, true);
             for (Database.DeleteResult result: resultcaseIds )
                {
                  if (!result.isSuccess())
                  {                
                    failCount++;
                  }else{
                      count++;
                  }
                }
            
            Map<integer,List<string>> accIntMap = areMap.get('Account');
            Map<integer,List<string>> accNameMap = areNameMap.get('Account');
            Map<String,Set<SObject>> accChildMap = new Map<String,Set<SObject>>();
            
            for(integer i:accIntMap.keyset()){
                string qString = 'Select Id,'+ string.join(accIntMap.get(i),',') +' from Account where Id in:accountIDs';
                system.debug('***qString:'+qString);
                List<sObject> records = database.query(qString);
                Map<String,Boolean> tempCascadeMap = childCasecadeMap.get('Account');
                for(sObject record: records) {
                    String accId = String.valueof(record.get('Id'));
                    Integer childCount = accChildCount.get(accId);
                    Set<String> childCountString = accChildCountMap.get(accId);
                    for(string childObjectRec:accNameMap.get(i)) {
                        SObject[] childObjects = record.getSObjects(childObjectRec);
                        for(sobject ch:record.getSObjects(childObjectRec)) {
                            String recordId = String.valueof(ch.get('Id'));
                            childCountString.add(recordId);
                        }
                        if(childObjects!= null){
                            childCount += childObjects.size();
                            system.debug('Child Count--Child-'+childObjectRec+'------'+childObjects.size());
                            if(tempCascadeMap.get(childObjectRec) == true){
                                continue;
                            }else if(childObjectRec == 'Audits__r'){
                                auditSet.addAll(childObjects);
                            }else{
                                if(accChildMap.containsKey(childObjectRec)){
                                    accChildMap.get(childObjectRec).addAll(childObjects);
                                }else{
                                    accChildMap.put(childObjectRec, new Set<SObject>());  
                                    accChildMap.get(childObjectRec).addAll(childObjects);
                                }  
                            }
                        }
                        /*
                        for(sobject ch:record.getSObjects(childObjectRec)) {
                        Id recordId = String.valueof(ch.get('Id'));
                        String objectType = String.valueof(recordId.getsobjecttype());
                        //accRelatedIds.add(String.valueof(ch.get('Id')));
                        childCount++;
                        if(objectType == 'Audit__c'){
                        auditSet.add(recordId);
                        }else{
                        if(accChildMap.containsKey(objectType)){
                        accChildMap.get(objectType).add(recordId);
                        }else{
                        accChildMap.put(objectType, new List<string>());  
                        accChildMap.get(objectType).add(recordId);
                        }
                        }
                        }*/
                    }
                    accChildCount.put(accId,childCount);
                    accChildCountMap.put(accId,childCountString);
                }
                
            }
            for(String accChild: accChildMap.keyset()){
                //system.debug('accChild'+accChild);
                //system.debug('accChild'+accChildMap.get(accChild));
                List<SObject> childList = new List<SObject>();
                childList.addAll(accChildMap.get(accChild));
                try{
                    Database.DeleteResult[] result = Database.delete(childList, true);
                    for (Database.DeleteResult result1: result )
                    {
                      if (!result1.isSuccess())
                      {                
                        failCount++;
                      }else{
                          count++;
                      }
                    }
                }catch(exception e){
                    string msg = e.getMessage();
                    if(msg.containsIgnoreCase('ENTITY_IS_DELETED') && msg.containsIgnoreCase('with id')){
                        msg = msg.substringBetween('id',';');
                        msg = msg.deleteWhitespace();
                        system.debug('Msg Val:'+msg);
                        if(msg.left(3) == '500'){
                            childList = [SELECT ID FROM Case WHERE id IN:childList];
                            DELETE childList;
                        }else if(msg.left(3) == 'a3G'){
                            system.debug('Account_with_IBB__c');
                            childList = [SELECT ID FROM Account_with_IBB__c WHERE id IN:childList];
                            DELETE childList;
                        }
                    }
                }                
            }
            
            Database.DeleteResult[] result = Database.delete(accountIDs, true);
            for (Database.DeleteResult result1: result )
                {
                  if (!result1.isSuccess())
                  {                
                    failCount++;
                  }else{
                      count++;
                  }
                }
            if(auditSet.size() > 0){
                CustomerDataAuditDeletionBatch objbatch = new CustomerDataAuditDeletionBatch(auditSet);
                Database.executeBatch(objbatch, 200);
            }
            system.debug('Total Accounts:'+accountIDsList.size());
            List<Map<String,String>> accountChildData = new List<Map<String,String>>();
            for(String accountId : accountIDsList){
                Map<String,String> responseData = new Map<String,String>();
                
                if(accChildCountMap.containskey(accountId)){
                    if(accChildCountMap.get(accountId).size()>0){
                        responseData.put('Child Record Count',String.valueof(accChildCountMap.get(accountId).size()));
                    }else {
                        responseData.put('Child Record Count','0');
                    }
                    
                }else{
                    responseData.put('Child Record Count','0');
                }
                responseData.put('Account Id',accountId);                
                accountChildData.add(responseData);
            }
            Map<String,Object> res= new Map<String,Object>();
            res.put('response',accountChildData);
            res.put('message', 'Deleted Successfully');
            res.put('success','true');            
            response = JSON.serialize(res); 
           
            system.debug('******accountChildData:'+accountChildData);  
            sendErrorEmail(count,failCount,'');
                    
        }catch(exception ex){
            system.debug('******exception:'+ex.getmessage());
            Map<String,Object> res= new Map<String,Object>();
            res.put('response','');
            res.put('message', ex.getmessage());
            res.put('success','false');
            response = JSON.serialize(res);
            Database.rollback(sp);        
            sendErrorEmail(count,failCount,ex.getmessage());   
        } 
        return response;
    }
    public static void sendErrorEmail(integer count,integer failCount,string exceptionMsg){
        string theSubject = 'Customer Delete';
        string theHtmlBody = 'Hi,<br/> <p>The  deletion is completed, Number of records deleted sucessfully:'+count+'</p>';
        theHtmlBody += failCount>0?'<br/> <p>Thedeletion is completed, Number of records not deleted sucessfully:'+failCount+'</p>':'';
        theHtmlBody +=!string.isblank(exceptionMsg)?'<br/><p>Exception Occured:'+exceptionMsg:'';
        
        theHtmlBody += '<br/>Thank You';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //String[] toAddresses = system.label.AuditEmail;//.split(','); 
        mail.setToAddresses(new list<string>{system.label.AuditEmail});
        mail.setReplyTo('noreply@alrayanbank.co.uk');
        mail.setSenderDisplayName('');        
        mail.setSubject(theSubject);
        mail.setHtmlBody(theHtmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}