public class DocuGenTemplateMigrator {
    
    public static void prepMigrationRecs(){
        //Create Attachment and CV map, 
        //this map will be used to the id of Contentversion Files 
        //created for an attachment
        
        List<ContentVersion> lsExistingMappedCV = [SELECT id,oldAttachmentId__c 
                                                   FROM contentversion 
                                                   WHERE oldAttachmentId__c !=null
                                                  		AND FirstPublishlocation.type='DocuGen_Template__c'];
        Map<Id,Id> mapAttIdToCVId = new Map<Id,Id>();
        
        for(ContentVersion cv : lsExistingMappedCV){
            if(!mapAttIdToCVId.containsKey(cv.oldAttachmentId__c)){
                mapAttIdToCVId.put(cv.oldAttachmentId__c, cv.Id);
            }
        }
        System.debug(mapAttIdToCVId.size());
        
        
        //Fetch the valid DocGenSettings
        List<CongaSettings__c> lsDocugenSettings = [Select id, Templates__c from CongaSettings__c];
        System.debug(lsDocugenSettings.size());
        
        Set<String> chkDupRec = new Set<String>();
        List<TmpDocGenMigration__c> lsCurTempDocGenMigration = [SELECT id,
                                                                Attachment_id__c,
                                                                Docugen_Template_Id__c,
                                                                Docugen_Setting_Id__c,
                                                                ContentVersion_Id__c
                                                                FROM TmpDocGenMigration__c];
        
        System.debug('Existing Size' + lsCurTempDocGenMigration.size());
        String key;
        for(TmpDocGenMigration__c t : lsCurTempDocGenMigration){
            key =  t.Docugen_Setting_Id__c + t.Docugen_Template_Id__c ;
            if (!chkDupRec.contains(key)){
                chkDupRec.add(key);
            }
        }
        
        
        TmpDocGenMigration__c tmpTmpDocGenMigration;
        List<TmpDocGenMigration__c> lsTmpDocGenMigration=new List<TmpDocGenMigration__c>();
        JSONParser parser;
        for(CongaSettings__c c : lsDocugenSettings){
            System.debug('CS Id ====>' + c.Id);
            parser = JSON.createParser(c.templates__c);
            while (parser.nextToken() != null) {
                
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            //system.debug('Current Parser Text ====>' + parser.getText());
                            try{
                                Templates tmp = (Templates)Parser.readValueAs(Templates.class);
                                
                                key= c.Id+tmp.TemplateId;
                                if(tmp.AttachmentId!=null && !chkDupRec.contains(key)){                     
                                    tmpTmpDocGenMigration = new TmpDocGenMigration__c();
                                    
                                    tmpTmpDocGenMigration.Attachment_id__c=tmp.AttachmentId;
                                    tmpTmpDocGenMigration.Docugen_Template_Id__c=tmp.TemplateId;
                                    tmpTmpDocGenMigration.Docugen_Setting_Id__c =c.Id;
                                    tmpTmpDocGenMigration.ContentVersion_Id__c = mapAttIdToCVId.get(tmp.AttachmentId);
                                    lsTmpDocGenMigration.add(tmpTmpDocGenMigration);
                                    chkDupRec.add(key);
                                }
                            }catch (Exception e) {
                                system.debug('Exception===>' + e.getMessage());
                                system.debug('Current Parser Text ====>' + parser.getText());
                            } 
                        }
                    }
                }
            }
            
        }
        system.debug('Total Templates size' + lsTmpDocGenMigration.size());
        
        if(lsTmpDocGenMigration.size()>0){ 
            Database.SaveResult[] saveResultList=Database.insert(lsTmpDocGenMigration,false);
            for(Database.SaveResult sr :saveResultList ){
                if(!sr.isSuccess()){
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
        }
    }
    
    
    
    //Stage 3: Execute Migration
    //Step 1 : Fetch all necessary DocumentSettings
    //Step 2 : Parse the JSON and replace related attachment Ids with the new File(ContentVersion) ids.
    //Step 3 : Update documentsettings, replace the attachmentids with the contentversion ids in the JSON
    public static void execMigration(){
        Map<ID,CongaSettings__c> mapDocugenSettings = new Map<ID,CongaSettings__C>([Select id, Templates__c from CongaSettings__c]);
        
        List<TmpDocGenMigration__c> lsTmpDocGenMigration = [SELECT id,
                                                            Attachment_id__c,
                                                            Docugen_Template_Id__c,
                                                            Docugen_Setting_Id__c,
                                                            ContentVersion_Id__c,
                                                            IsDocSettingUpdated__c
                                                            FROM TmpDocGenMigration__c
                                                            WHERE ContentVersion_Id__c<>NUll AND 
                                                            IsDocSettingUpdated__c=false];
        CongaSettings__c tmpCGSetting;
        for(TmpDocGenMigration__c t : lsTmpDocGenMigration){
            if(mapDocugenSettings.containsKey(t.Docugen_Setting_Id__c)){
                
                tmpCGSetting = mapDocugenSettings.get(t.Docugen_Setting_Id__c);
                
                String tmpTemplateJSON = tmpCGSetting.Templates__c;
                
                system.debug(t.Attachment_id__c + '=======' + t.ContentVersion_Id__c);
                if(tmpTemplateJSON.contains(t.Attachment_id__c)){
                    tmpTemplateJSON = tmpTemplateJSON.replaceAll(t.Attachment_id__c, t.ContentVersion_Id__c);
                    tmpCGSetting.Templates__c = tmpTemplateJSON;
                    
                    mapDocugenSettings.put(t.Docugen_Setting_Id__c,tmpCGSetting);
                    t.IsDocSettingUpdated__c=true;
                }
            }
        }
        
        
        update mapDocugenSettings.values();
        update lsTmpDocGenMigration;
        
    }
    
    
    public class Templates{
        public String TemplateId;
        public String AttachmentId;
        
        public Templates (String tmpId, String attId){
            TemplateId=tmpId;
            AttachmentId=attId;
        }
    }
    
}