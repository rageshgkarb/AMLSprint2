global class IBBQuotationAttIdRecUpdatesBatch implements Database.Batchable<sObject>{
   
    global Database.Querylocator start(Database.BatchableContext bc){
        String query = 'SELECT Id,Attachment_FIS__c FROM IBBQuotation__c where Attachment_FIS__c!=null';
        return Database.getQuerylocator(query);
    } 
    
    global void execute(Database.BatchableContext bc, List<IBBQuotation__c> scope){
        System.debug('Scope Size ====' + scope.size());
        
        Set<id> setAttIds = new Set<Id>();
        for(IBBQuotation__c quot : scope){
            if(quot.Attachment_FIS__c !=null && (quot.Attachment_FIS__c).left(3).equalsIgnoreCase('00P')){
                if(!setAttIds.contains(quot.Attachment_FIS__c)) {
                    setAttIds.add(quot.Attachment_FIS__c);
                }    
            }
        }
        
        List<ContentVersion> lsCV;
        if(setAttIds.size()>0){
            lsCV = [SELECT id,oldAttachmentId__c 
                    FROM ContentVersion
                    WHERE oldAttachmentId__c !=null
                    AND oldAttachmentId__c IN:setAttIds ];
        }
        
        Map<Id,Id> mapAttCVIds = new Map<Id,Id>();
        if(lsCV!=null && lsCV.size()>0){
            for(Contentversion cv : lsCV){
                if(!mapAttCVIds.containsKey(cv.oldAttachmentId__c)){
                    mapAttCVIds.put(cv.oldAttachmentId__c,cv.Id);
                }
            }    
        }
        
       System.debug('MapAttCVIds ====' + mapAttCVIds.size());
        List<IBBQuotation__c> lsIBBQuotToUpdate = new List<IBBQuotation__c>();
        boolean addToUpdateList = false;
        for(IBBQuotation__c quot : scope){
			if(quot.Attachment_FIS__c !=null && (quot.Attachment_FIS__c).left(3).equalsIgnoreCase('00P')){
                if(mapAttCVIds.containsKey(quot.Attachment_FIS__c)) {
                    quot.Attachment_FIS__c = mapAttCVIds.get(quot.Attachment_FIS__c);
                    addToUpdateList=true;
                }    
            }
            
            if(addToUpdateList){
                lsIBBQuotToUpdate.add(quot);
            }
        } 
        system.debug(lsIBBQuotToUpdate.size());
        if(lsIBBQuotToUpdate.size()>0){
            List<Tmp_Opp_Migration_Err_Log__c> lsTOME = new List<Tmp_Opp_Migration_Err_Log__c>();
            Tmp_Opp_Migration_Err_Log__c t;
			Database.SaveResult[] saveResultList=Database.update(lsIBBQuotToUpdate,false);
			for(Database.SaveResult sr :saveResultList ){
				if(!sr.isSuccess()){
					for(Database.Error err : sr.getErrors()) {
						System.debug('The following error has occurred.');                    
						System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        t=new Tmp_Opp_Migration_Err_Log__c();
                        t.Fields__c = String.join(err.getFields(),'\n');
                        t.Error_Message__c = 'Quotation record update ' + err.getMessage();
                        t.Object_Type__c = 'IBB Quotation';
                        t.recordId__c = sr.getId();
                        lsTOME.add(t);
					}
				}
			}
            system.debug('Size of error list ' + lsTOME.size());
            if(lsTOME.size()>0){
                insert lsTOME;
            }
		}
        
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
        System.debug('>>>> finish ' + job.Status);
    }

}