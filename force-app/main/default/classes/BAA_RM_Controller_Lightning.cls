/*******************************************************************
* @Class Name      : BAA_RM_Controller_Lightning
* @Author          : Amey Kashetwar
* @Created Date    : 12 May 2022
* @description     : This apex controller class is used for Lightning File Upload for BAA RM Page
* @JIRA            : SLM-160

  LOG   DATE        Author  UserStory         COMMENT      
* 001   07/06/2022  Amey                       First Commit
********************************************************************/

global class BAA_RM_Controller_Lightning
{   
    private static aLog.Logger Log = new aLog.Logger('BAA_SecondLineAuth');
    public static Opportunity Opp{get;set;}
    private static final String PICKLIST_COUNTRYCODE= 'COUNTRYCODE'; 
    private static final String PICKLIST_TINREASONCODE = 'TINREASONCODE';
    private static final String PICKLIST_SELFCERTCAPCITY='SELFCERTCAPCITY';
    private static final String PICKLIST_COUNTYOFBIRTH= 'COUNTYOFBIRTH';
    public static Boolean IsCompleted;
    
    public String Title{get;set;}
    
    @AuraEnabled
    public static NPAABaseEventController.Wrapper getWrapper(String evnId, String opportId){
        System.debug(evnId + opportId);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        System.debug(wrap);
        return wrap;
    }
     @AuraEnabled
    public static String Complete(String evnId, String opportId)
    {
      NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        try
        {        
            wrap.CompleteEvent();            
        }
        catch(Exception ex)
        {
            Log.Fatal('Exception',ex);            
        }  
        
        return wrap.GoToNextEvent().getUrl();
    }

   public Boolean IsABranch
    {
        get{
            User u = [select branch__c from user where id=:UserInfo.getUserId()];
            
            return (!u.branch__c.equalsIgnoreCase('Head Office') && !u.branch__c.equalsIgnoreCase('Head Office Birmingham'));
        }
    }

    @AuraEnabled
    public static List<Applicant__c> fetchApplicantList ( String opportunityId) {
        recordType rec = [select id from recordtype where developername='ProspectCustomer'];
        List<Applicant__c> tempAccs = [select id,Prospect_Customer__r.name,Prospect_Customer__c,Prospect_Customer__r.firstname,Prospect_Customer__r.lastname,Prospect_Customer__r.salutation, Prospect_Customer__r.Middle_Name__pc,
                            Prospect_Customer__r.Gender__c, Prospect_Customer__r.Home_Telephone_No__c, Prospect_Customer__r.Phone, Prospect_Customer__r.PersonEmail, Prospect_Customer__r.IsPersonAccount,
                            CPF_Relationship__r.Shareholder_Percentage__c, CPF_Relationship__r.Position_Held__c , CPF_Relationship__r.Is_Director__c ,CPF_Relationship__r.Is_Shareholder__c ,CPF_Relationship__r.Is_Signatory__c,
                            Is_Director__c, Is_ShareHolder__c, Is_Signatory__c
                            /* C0307 */
                            , CPF_Relationship__r.Is_Trustee__c
                            , CPF_Relationship__r.Is_BeneficialOwner__c
                            , CPF_Relationship__r.Is_Settlor__c
                            , Is_Trustee__c
                            , Is_BeneficialOwner__c
                            , Is_Settlor__c
                            /* C0307 end */
                            from Applicant__c where Opportunity__C=: opportunityId and Prospect_Customer__r.recordtypeid =:rec.id 
                                
                            ];
                            
             return tempAccs;
        } 

    @RemoteAction @AuraEnabled
   global static Teller_Data.GenericResponse PasswordVerification(String userName, String password)
   {
       return Teller_Function_Overrides.PasswordVerification(userName, password);
   }

   @AuraEnabled
    global static BAA_Data.GenericResponse GetApplicantData( String logId )
    {
        BAA_Data.BAADetailsDataResponse response = new BAA_Data.BAADetailsDataResponse (); 
       // try
       // {
            //PROCESS REQUEST
            System.debug('logId##'+logId);
            EventLog__c log = CAA_Helper.EventLog(logId);  
            response.Data = BAA_RM.LoadData(log.Opportunity__c);
            return BAA_RM.ReferDecision(logId,response);
       // }
        /*catch(Exception ex)
        {
            response.success = false;
            response.error = CAA_Helper.ErrorMessage(ex);
        }*/
       // return response;
    }

    @RemoteAction @AuraEnabled
    global static CAA_Data.GenericResponse CompleteRM(BAA_Data.BAADetailsCompleteData data,String sessionId)
    {
        CAA_Data.CompletePersonalDetailsResponse response = new CAA_Data.CompletePersonalDetailsResponse ();        
        try
        {       
            //PROCESS REQUEST                  
            response= BAA_RM.CompleteRM(data);
        }
        catch(Exception ex)
        {    
            response.Success = false;
            response.error = ex.getMessage();
            throw ex;
        }
        
        return response;
    }

    @RemoteAction @AuraEnabled
    global static CAA_Data.RMResponse CallRM(String eventLogId, String sessionId, Boolean isHigh,Boolean isABranch)
    {
        CAA_Data.RMResponse response = new CAA_Data.RMResponse ();
        try
        {       
            CAA_Helper.RequestHasCallout = true;
                
            //PROCESS REQUEST
            system.debug('CallRM - Calling CAA_RM.CallRM');
            response = CAA_RM.CallRMForPanoptic(eventLogId,sessionId,isHigh,false,isABranch,'Business');
        }
        catch(Exception ex)
        {    
            CAA_Helper.RequestHasCallout = false;
            CAA_Helper.GetActiveSession(sessionId);
            system.debug('CallRM - ex.message='+ex.getMessage());
            response.Success = false;
            response.error = ex.getMessage();
            throw ex;
        }

        CAA_Helper.RequestHasCallout = false;
        CAA_Helper.GetActiveSession(sessionId);
        return response;
    }

    @RemoteAction @AuraEnabled
    global static CAA_Data.GenericResponse SaveRMDetails(BAA_Data.BAADetailsCompleteData data, String sessionId)
    {
        CAA_Data.GenericResponse response = new CAA_Data.GenericResponse();
        
        try
        {      
            
            //SECURITY CHECK
            If(CAA_Helper.IsGuestUser() && !CAA_Helper.CheckCookieEventLog(data.EventLogId, sessionId))
                return CAA_Helper.CreateSecurityError();
            
            system.debug('processing');    
            //PROCESS REQUEST   
            BAA_RM.SaveRM(data);
            response.Success = true;
        }
        catch(Exception ex)
        {    
            system.debug('CAA_Data.GenericResponse SaveRMDetails:ex.message='+ex.getMessage());
            //throw ex;
            response.Success = false;
            response.error = ex.getMessage();
        }
        
        return response;
    }

    @AuraEnabled
    public static OpportunityWrapper fetchBaseOpportunity( String eventId ){
        OpportunityWrapper oppWrapper ;
        List<EventLog__c> listEvent = DataHelper.GetEventLog(eventId);
        opportunity oppty ;
        if (listEvent.size() == 0)
					return null;
        String opportunityId = ''+listEvent[0].Opportunity__c;            

        try {
            oppty = [select id,Account.IsPersonAccount, Name, AccountId,ProductEventDirector__c from opportunity where id=:opportunityId ];
					 I_IBBEvents director = new IBBEvents(oppty.ProductEventDirector__c);        
					 ProductEventDirector__c  oDirector = DataHelper.GetDirector(oppty.ProductEventDirector__c)[0];
					
					 HPPBaseEventHelper.EventType TypeofEvent = HPPBaseEventHelper.GetEventType(oDirector.BaseController__c);       
					 opportunity BaseOpportunity = HPPBaseEventHelper.LoadOpportunity(TypeofEvent,opportunityId) ;
                     String status = getRMFileStatus(opportunityId);

                     oppWrapper = new OpportunityWrapper ( BaseOpportunity, status );
            
        } catch (Exception e) {
            system.debug (' Exception Occured :  '+ e.getMessage ());
        }

        system.debug (' Returning oppWrapper :  '+ oppWrapper);

        return oppWrapper;
    }

    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId, String opportunityId) {
        System.debug ('recordId' + recordId);
        System.debug ('opportunityId' + opportunityId);

        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);

        String rmuploadStatus= '';
        try{
			Opportunity oppRecord = [ SELECT Id, Name, AccountId FROM Opportunity WHERE Id=: opportunityId LIMIT 1];
            if ( oppRecord!= null ) {
				//rmuploadStatus = RiskUtils.getBusinessCustomerRMStatus(oppRecord);
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE Id=:cdl.Id];
                if ( documents.size () > 0 ) {
                    rmuploadStatus = BAAConstantValues.STATUS_UPLOAD_REQUIRED;
                } else {
                    // Attachments present for Opportunity
                    List<Case> caseList = [Select Id, Referral_Decision__c, Status,IsClosed From Case Where Opportunity__c=:oppRecord.id AND (Subject LIKE 'Risk Score%' OR Subject LIKE 'Onboarding%' OR Subject LIKE 'Risk Rating%') ORDER BY Createddate DESC limit 1];

                    if(caseList.Size() > 0){
                        if(caseList[0].isClosed){
                            if (caseList[0].Referral_Decision__c == 'Accept') {
                                rmuploadStatus = BAAConstantValues.STATUS_ACCEPTED;
                            }
                            else {
                                rmuploadStatus = BAAConstantValues.STATUS_REJECTED;
                            }    
                        }
                        else {
                            rmuploadStatus = BAAConstantValues.STATUS_IN_PROGRESS;
                        }
                    }else{
                        rmuploadStatus = BAAConstantValues.STATUS_UPLOAD_SUCCESSFULLY;
                    }
                }

                System.debug ('rmuploadStatus1' + rmuploadStatus);
			}
        }catch(Exception e){
        } 
        
		
        System.debug ('rmuploadStatus2' + rmuploadStatus);
        //if (cv == null || cdl == null) { return null; }
        return rmuploadStatus;
    }

    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
          insert cv;
          return cv;
        } catch(DMLException e) {
          System.debug(e);
          return null;
        }
      }

      private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
          if (contentVersionId == null || recordId == null) { return null; }
              ContentDocumentLink cdl = new ContentDocumentLink();
              cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId].ContentDocumentId;
              cdl.LinkedEntityId = recordId;
            // ShareType is either 'V', 'C', or 'I'
            // V = Viewer, C = Collaborator, I = Inferred
              cdl.ShareType = 'V';
            try {
                insert cdl;
                return cdl;
            } catch(DMLException e) {
                System.debug(e);
                return null;
            }
      }


      private static String getRMFileStatus ( String opportunityId) {
          String rmuploadStatus = null;

        try{
			Opportunity oppRecord = [ SELECT Id, Name, AccountId FROM Opportunity WHERE Id=: opportunityId LIMIT 1];
            if ( oppRecord!= null ) {
				//rmuploadStatus = RiskUtils.getBusinessCustomerRMStatus(oppRecord);
                List<ContentDocumentLink> documentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId,Visibility, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =: oppRecord.AccountId];
                if ( documentLinks.size () <= 0 ) {
                    rmuploadStatus = BAAConstantValues.STATUS_UPLOAD_REQUIRED;
                } else {
                    // Attachments present for Opportunity
                    List<Case> caseList = [Select Id, Referral_Decision__c, Status,IsClosed From Case Where Opportunity__c=:oppRecord.id AND (Subject LIKE 'Risk Score%' OR Subject LIKE 'Onboarding%' OR Subject LIKE 'Risk Rating%') ORDER BY Createddate DESC limit 1];

                    if(caseList.Size() > 0){
                        if(caseList[0].isClosed){
                            if (caseList[0].Referral_Decision__c == 'Accept') {
                                rmuploadStatus = BAAConstantValues.STATUS_ACCEPTED;
                            }
                            else {
                                rmuploadStatus = BAAConstantValues.STATUS_REJECTED;
                            }    
                        }
                        else {
                            rmuploadStatus = BAAConstantValues.STATUS_IN_PROGRESS;
                        }
                    }else{
                        rmuploadStatus = BAAConstantValues.STATUS_UPLOAD_SUCCESSFULLY;
                    }
                }

                System.debug ('rmuploadStatus1' + rmuploadStatus);
			}
        }catch(Exception e){
        }
        return rmuploadStatus;
      }

    @AuraEnabled
    public static Boolean IsABranch()
    {
            User u = [select branch__c from user where id=:UserInfo.getUserId()];
            return (!u.branch__c.equalsIgnoreCase('Head Office') && !u.branch__c.equalsIgnoreCase('Head Office Birmingham'));
    }
	
    // Garnet - End 

    public class OpportunityWrapper {

        @AuraEnabled
        public Opportunity oppty;
        @AuraEnabled
        public String RMStatus;

        public OpportunityWrapper ( Opportunity oppObj, String status  ) {
            this.oppty = oppObj;
            this.RMStatus = status;
        }

    }
}