global class OpportunityMigratorBatch implements Database.Batchable<sObject>{
    
    // The batch job starts
    global Database.Querylocator start(Database.BatchableContext bc){
        String query = 'SELECT Id,Name,Body,ParentId,Parent.Type,CreatedDate,LastModifiedDate,OwnerId FROM Attachment WHERE Parent.type=\'Opportunity\' LIMIT 50000';
        return Database.getQuerylocator(query);
    } 
    
    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<Attachment> scope){
        
        //Step 1 : create contentversions
        System.debug('>>>> execute ' + scope.size() + '>>>>' + scope);
        Map<Id,Attachment> mapAttRecs = new Map<Id,Attachment>();
        
        for(Attachment a : scope){
           
            if(!mapAttRecs.containsKey(a.id)){
                mapAttRecs.put(a.id,a);
            }
        }
        
        List<ContentVersion> lsClonedCV = [SELECT id,oldAttachmentId__c FROM contentversion Where oldAttachmentId__c IN: mapAttRecs.keySet()];
        Set<ID> clonedAttachIds = new set<Id>();
        Set<Id> clonedCVIds = new Set<Id>();
        
        for(ContentVersion cv : lsClonedCV){
            if(!clonedAttachIds.contains(cv.oldAttachmentId__c)){
                clonedAttachIds.add(cv.oldAttachmentId__c);
            }
            if(!clonedCVIds.contains(cv.id)){
                clonedCVIds.add(cv.id);
            }
        }  
        
        List<ContentVersion> lsCV = new List<ContentVersion>() ;
        ContentVersion tmpCV;
        
        for(Attachment a : scope){
            if(!clonedAttachIds.contains(a.id)){
                tmpCV=cloneCVfromAttachment(a);
                if(tmpCV!=null){
                    lsCV.add(tmpCV);
                    clonedAttachIds.add(a.id);
                }
            }
        }
        system.debug(lsCV.size());
       
        if(lsCV.size()>0){ 
            Database.SaveResult[] saveResultList=Database.insert(lsCV,false);
            
            List<Tmp_Opp_Migration_Err_Log__c> lsTOME = new List<Tmp_Opp_Migration_Err_Log__c>();
            Tmp_Opp_Migration_Err_Log__c t;
            for(Database.SaveResult sr :saveResultList ){
                if(!sr.isSuccess()){
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        t=new Tmp_Opp_Migration_Err_Log__c();
                        t.Fields__c = String.join(err.getFields(),'\n');
                        t.Error_Message__c = 'Opportunity Content Version Creation : ' + err.getMessage();
                        t.Object_Type__c = 'ContentVersion';
                        t.recordId__c = sr.getId();
                        lsTOME.add(t);
                    }
                }else{
                    if(!clonedCVIds.contains(sr.getId())) {
                        clonedCVIds.add(sr.getId());
                    }
                }
                
            }
            System.debug(clonedCVIds);
            Map<Id,Contentversion> mapClonedCVs = new Map<Id,ContentVersion>([SELECT id,oldAttachmentId__c FROM contentversion Where Id IN: clonedCVIds]);
            
            System.debug(mapClonedCVs.size());
           
        	Map<Id,Id> mapAttCVIds = new Map<Id,Id>();
            
            for(ContentVersion cv : mapClonedCVs.values()){
                if(!mapAttCVIds.containsKey(cv.oldAttachmentId__c)){
                    mapAttCVIds.put(cv.oldAttachmentId__c,cv.id);
                }
            }
            
            //Step 2 : Update Opportunity records with attachment references
            
            Set<Id> setClonedAtts = mapAttCVIds.keySet();
            System.debug(setClonedAtts);
            List<Opportunity> lsOppAttRefs = [SELECT Id,
                                              	Attachment_AIP_Letter__c,
                                              	Attachment_App_Form__c,
                                              	Attachment_Offer_Letter__c,
                                              	Attachment_Welcome_Letter__c,
                                              	Attachment_Cash_ISA__c  
                                              FROM Opportunity
                                              WHERE Attachment_AIP_Letter__c IN:setClonedAtts
                                              	OR Attachment_App_Form__c IN:setClonedAtts
                                              	OR Attachment_Offer_Letter__c IN: setClonedAtts
                                              	OR Attachment_Welcome_Letter__c IN: setClonedAtts
                                              	OR Attachment_Cash_ISA__c IN: setClonedAtts];
            System.debug('Opp Attachment reference record count ====' + lsOppAttRefs);
            
            List<Opportunity> lsOppToUpdate = new List<Opportunity>();
            boolean addToUpdateList=false;
            for(Opportunity opp : lsOppAttRefs ){
                if(opp.Attachment_AIP_Letter__c !=null && (opp.Attachment_AIP_Letter__c).left(3).equalsIgnoreCase('00P')){
                    if(mapAttCVIds.containsKey(opp.Attachment_AIP_Letter__c)) {
                        opp.Attachment_AIP_Letter__c = mapAttCVIds.get(opp.Attachment_AIP_Letter__c);
                        addToUpdateList=true;
                    }    
            	}
                if(opp.Attachment_App_Form__c !=null && (opp.Attachment_App_Form__c).left(3).equalsIgnoreCase('00P')){
                    if(mapAttCVIds.containsKey(opp.Attachment_App_Form__c)) {
                        opp.Attachment_App_Form__c = mapAttCVIds.get(opp.Attachment_App_Form__c);
                        addToUpdateList=true;
                    }    
            	}
                if(opp.Attachment_Offer_Letter__c !=null && (opp.Attachment_Offer_Letter__c).left(3).equalsIgnoreCase('00P')){
                    if(mapAttCVIds.containsKey(opp.Attachment_Offer_Letter__c)) {
                        opp.Attachment_Offer_Letter__c = mapAttCVIds.get(opp.Attachment_Offer_Letter__c);
                        addToUpdateList=true;
                    }    
            	}
                if(opp.Attachment_Welcome_Letter__c !=null && (opp.Attachment_Welcome_Letter__c).left(3).equalsIgnoreCase('00P')){
                    if(mapAttCVIds.containsKey(opp.Attachment_Welcome_Letter__c)) {
                        opp.Attachment_Welcome_Letter__c = mapAttCVIds.get(opp.Attachment_Welcome_Letter__c);
                        addToUpdateList=true;
                    }    
            	}
                if(opp.Attachment_Cash_ISA__c !=null && (opp.Attachment_Cash_ISA__c).left(3).equalsIgnoreCase('00P')){
                    if(mapAttCVIds.containsKey(opp.Attachment_Cash_ISA__c)) {
                        opp.Attachment_Cash_ISA__c = mapAttCVIds.get(opp.Attachment_Cash_ISA__c);
                        addToUpdateList=true;
                    }    
            	}
                
                if(addToUpdateList){
                	lsOppToUpdate.add(opp);
            	}
            }
            
            if(lsOppToUpdate.size()>0){
             	Trigger_Helper.runOpportunityTrigger=false;
            	saveResultList=Database.update(lsOppToUpdate,false);
                
            	for(Database.SaveResult sr :saveResultList ){
                	if(!sr.isSuccess()){
                    	for(Database.Error err : sr.getErrors()) {
                        	t=new Tmp_Opp_Migration_Err_Log__c();
                        	t.Fields__c = String.join(err.getFields(),'\n');
                        	t.Error_Message__c = 'Opportunity Record Update ' + err.getMessage();
                        	t.Object_Type__c = 'Opportunity';
                        	t.recordId__c = sr.getId();
                        	lsTOME.add(t);
                    	}
                	}
            	}
				Trigger_Helper.runOpportunityTrigger=true;
        	}
            
        	//Step 3 : delete cloned attachments    
            System.debug('=====Begin Deletion ====' + setClonedAtts.size());
            List<Attachment> lsDelAtts = new List<Attachment>();
            for(Id attId : setClonedAtts){
                if(mapAttRecs.containsKey(attId)){
                    lsDelAtts.add(mapAttRecs.get(attId));
                }
            }
            
            System.debug('Deletion Attachment Size   ' + lsDelAtts);
            
           if(lsDelAtts.size()>0){ 
                Database.deleteResult[] deleteResultList=Database.delete(lsDelAtts,false);
                for(Database.deleteResult dr :deleteResultList ){
                    if(!dr.isSuccess()){
                        for(Database.Error err : dr.getErrors()) {
                            t=new Tmp_Opp_Migration_Err_Log__c();
                            t.Fields__c = String.join(err.getFields(),'\n');
                            t.Error_Message__c = 'Opportunity Attachment Deletion' + err.getMessage();
                            t.Object_Type__c = 'Attachments';
                            t.recordId__c = dr.getId();
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
        
        
    }
    
    // The batch job finishes
    global void finish(Database.BatchableContext bc){
        Trigger_Helper.runOpportunityTrigger=true;
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
        System.debug('>>>> finish ' + job.Status);
        
        Database.executeBatch(new OpportunityMigratorBatch(),Attachment_Migration_Settings__c.getvalues('Batch Size').Batch_Size__c.intvalue());
        
    }
    
    public static ContentVersion cloneCVfromAttachment(Attachment a){
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = a.Name;//File name with extention
        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        cVersion.OwnerId = a.OwnerId;//Owner of the file
        cVersion.Title = a.Name;//Name of the file
        cVersion.VersionData = a.Body;//File content
        cVersion.oldAttachmentId__c = a.Id;
        cVersion.FirstPublishLocationId= a.ParentId;
        cVersion.CreatedDate = a.CreatedDate;
        cVersion.LastModifiedDate = a.LastModifiedDate;
        
        return cVersion;
    }
    
}