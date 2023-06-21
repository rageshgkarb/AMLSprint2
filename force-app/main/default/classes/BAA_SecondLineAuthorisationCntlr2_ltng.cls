public class BAA_SecondLineAuthorisationCntlr2_ltng {

    public static List<Case> FiCases{get;set;}
    @AuraEnabled
    public static Boolean IsCompleted{get;set;}
    
    @AuraEnabled
    public static Boolean LoadEvent(String eventId){
        IsCompleted = false;
        List<EventLog__c> listEvent = DataHelper.GetEventLog(eventId);
        System.debug('listEvent'+listEvent);
        System.debug('listEvent size'+listEvent.size());
        if (listEvent.size() == 0)
        return IsCompleted;

        EventLog__c EventLog = listEvent[0];
        Event__c Event = DataHelper.GetEvent(EventLog.Event__r.id) [0];
        if (EventLog.eventstatus__c != 'Open')
        {
            IsCompleted = true;
        }
        return IsCompleted;
    }
    
    
    @AuraEnabled
    public static String Setup(Id OppId)
    {
        Integer rowIndex=0;
        FiCases= new List<Case>();
        FiCases = [select CaseNumber, 
                            id,
                            satisfied__c, 
                            Further_Information__c, 
                            Further_Info_Satisfied__c , 
                            underwriter_comments__c,  
                            BDM_comments__c,  
                            createddate, 
                            CreatedBy.Name 
                    from case 
                    where Opportunity__c=:OppId 
                    and Pre_or_Post_Case__c='PRE' ];
        
        List<caseWrap> caseWrapList= new List<caseWrap>();
        for(Case c: FiCases){
            caseWrapList.add(new caseWrap(c.id,c.CaseNumber,c.Further_Information__c,c.BDM_Comments__c,c.Further_Info_Satisfied__c,c.Underwriter_Comments__c,rowIndex));
            rowIndex++;
        }
                    
        return JSON.serialize(caseWrapList);
    }
    
     @AuraEnabled
     public static Boolean Authorise (String OppId)
    {
        Boolean authorised=false;
        Opportunity thisOpp=[Select id,X2nd_Line_authorisation_Decision_1__c,X2nd_Line_Authorisation_Decision_Date_1__c,X2nd_Line_authorisation_Decision_2__c,
                             X2nd_Line_Authorisation_Decision_Date_2__c,NPAA_Approver_Name__c,StageName,Opportunity_Status__c
                             from Opportunity where id=:OppId];
        if (String.IsBlank(thisOpp.X2nd_Line_authorisation_Decision_1__c))
        {
            thisOpp.X2nd_Line_authorisation_Decision_1__c = 'Authorised';
            thisOpp.X2nd_Line_Authorisation_Decision_Date_1__c = Date.Today();
        }
        else
        {
            thisOpp.X2nd_Line_authorisation_Decision_2__c = 'Authorised';
            thisOpp.X2nd_Line_Authorisation_Decision_Date_2__c = Date.Today();
        }
        thisOpp.NPAA_Approver_Name__c = UserInfo.getName();
        thisOpp.StageName = 'Application Authorised';
        thisOpp.Opportunity_Status__c = 'Application Authorised';
        try{
              update thisOpp;
              authorised=true;
        }catch(Exception ex){
            System.debug('Authorise Update failed'+ex.getMessage());
        }
        
        return authorised;
    }
    
    @AuraEnabled
    public static Boolean FurtherInformation (String OppId, String cases)
    {
        Boolean furtherInformationAdded=false;
        Opportunity thisOpp=[Select id,X2nd_Line_authorisation_Decision_1__c,X2nd_Line_Authorisation_Decision_Date_1__c,NPAA_Approver_Name__c,StageName,Opportunity_Status__c
                             from Opportunity where id=:OppId];
        thisOpp.X2nd_Line_authorisation_Decision_1__c = 'Further Information';
        thisOpp.X2nd_Line_Authorisation_Decision_Date_1__c = Date.Today();
        thisOpp.NPAA_Approver_Name__c = UserInfo.getName();
        thisOpp.StageName = 'Further Information';
        thisOpp.Opportunity_Status__c = 'Further Information';
        
        List<caseWrap> CasesToUpdate  = (List<caseWrap>) JSON.deserialize(cases,List<caseWrap>.class); 
        List<Case> FiCases = new List<Case>();
        for(caseWrap cs:CasesToUpdate){
            FiCases.add(createCaseInstance(cs));
        }
        try{
            update thisOpp;
            update FiCases;
            furtherInformationAdded=true;
        }catch(Exception ex){
            System.debug('FurtherInformation Update failed'+ex.getMessage());
        }
       
        return furtherInformationAdded;
    }
    
    @AuraEnabled
    public static Boolean Decline (String OppId)
    {
        Boolean Declined=false;
        Opportunity thisOpp=[Select id,X2nd_Line_authorisation_Decision_1__c,X2nd_Line_Authorisation_Decision_Date_1__c,X2nd_Line_authorisation_Decision_2__c,
                             X2nd_Line_Authorisation_Decision_Date_2__c,NPAA_Approver_Name__c,StageName,Opportunity_Status__c
                             from Opportunity where id=:OppId];
        if (String.IsBlank(thisOpp.X2nd_Line_authorisation_Decision_1__c))
        {
            thisOpp.X2nd_Line_authorisation_Decision_1__c = 'Declined';
            thisOpp.X2nd_Line_Authorisation_Decision_Date_1__c = Date.Today();
        }
        else
        {
            thisOpp.X2nd_Line_authorisation_Decision_2__c = 'Declined';
            thisOpp.X2nd_Line_Authorisation_Decision_Date_2__c = Date.Today();
        }
        thisOpp.NPAA_Approver_Name__c = UserInfo.getName();
        thisOpp.StageName = 'Application Declined';
        thisOpp.Opportunity_Status__c = 'Application Declined';
        update thisOpp;
        return Declined = true;
    }
    
    @AuraEnabled
    public static Boolean Save(String cases)
    {
        List<caseWrap> CasesToUpdate  = (List<caseWrap>) JSON.deserialize(cases,List<caseWrap>.class); 
        System.debug('FiCases##'+FiCases);
        List<Case> FiCases = new List<Case>();
        for(caseWrap cs:CasesToUpdate){
            FiCases.add(createCaseInstance(cs));
        }
       // update thisOpp;
        update FiCases;
        return true;
    }

    @AuraEnabled
    public static void DeleteFI(String caseId)
    {
       Case c=[Select Id from Case where Id=:caseId];
       delete c;
    }
    
    public static Case createCaseInstance(caseWrap cs){
        Case c= new Case();
        c.Id=cs.ID;
        c.Further_Information__c=cs.Further_Information;
        c.BDM_Comments__c=cs.BDM_Comments;
        c.Further_Info_Satisfied__c=cs.Further_Info_Satisfied;
        c.Underwriter_Comments__c=cs.Underwriter_Comments;
        return c;
    }
    
     @AuraEnabled
     public Static Case AddCase(String OppId, String cases)
    {
        Opportunity opp=[Select id,Name,Seller__c from Opportunity where id=:OppId];
        RecordType recTypeCase = [select id from recordType where  sobjectType='case' and DeveloperName = 'Further_Information' limit 1];
        List<Applicant__c> Applicants = DataHelper.GetApplicants(Opp.Id);
        List<Account> Accounts = new List<Account>();
        System.debug(cases);
        List<caseWrap> FiCases = (List<caseWrap>) JSON.deserialize(cases,List<caseWrap>.class); 
        System.debug('FiCases##'+FiCases);
        List<Case> CasesToUpdate = new List<Case>();
        for(caseWrap cs:FiCases){
            CasesToUpdate.add(createCaseInstance(cs));
        }
         System.debug('CasesToUpdate##'+CasesToUpdate);
        for(Integer i = 0; i< Applicants.Size();i++)
        {       
                Account applicant = DataHelper.GetAccount(Applicants [i].Prospect_Customer__c)[0];
                Applicants[i].Prospect_Customer__r = applicant;
                Accounts.add(applicant);
        }
        
        Case c = new Case();
        c.recordTypeid = recTypeCase.id ;
        c.Further_Information__c = 'Enter Information';
        c.Opportunity__c = opp.id;
        c.Subject = 'Further information for ' + Opp.Name;
        c.Description = c.Subject;
        c.Priority = 'Medium';
        c.Status = 'Open';
        c.Origin = 'Salesforce';
        c.ContactId =  Accounts[0].PersonContactId ;
        if(Opp.Seller__c != null)
        {
            c.OwnerId = opp.Seller__c;
        }
        c.Pre_or_Post_Case__c='PRE';
        c.Further_Info_Satisfied__c = 'No';
        insert c;
       
                        
      //  AddFiText ='';
        SaveFurtherInfo(opp,CasesToUpdate);
        return c;
    }
    
     private static void SaveFurtherInfo(Opportunity thisOpp, List<Case> FiCases)
    {
        HPP_extended_opportunity__c exOpp = DataHelper.GetHPPExtendedOpportunityByOpp(string.valueof(thisOpp.Id))[0];
       
        thisOpp.Stagename = 'Affordability Assesment';

        if(exOpp.Pre_Val_1_Date__c == null)
        {
            exOpp.Pre_Val_1_Date__c = Date.today();
        }
        exOpp.Pre_Val_decision_1_underwriter__c = UserInfo.getName();
        
        exOpp.Pre_Val_Dec_1__c = 'Further Information Required';        
        thisOpp.Status_HPP_CAA__c= 'Affordability Further Information';
        
        update FiCases;
        update exOpp;
        update thisOpp;
    }
    
    public class caseWrap{
        public String ID;
        public String caseNumber;
        public String Further_Information;
        public String BDM_Comments;
        public String Further_Info_Satisfied;
        public String Underwriter_Comments;
        public Integer index;
        
        public caseWrap(String ID,String caseNumber,String Further_Information,String BDM_Comments,String Further_Info_Satisfied,String Underwriter_Comments,Integer index){
            this.ID=ID;
            this.caseNumber=caseNumber;
            this.Further_Information=Further_Information;
            this.BDM_Comments=BDM_Comments;
            this.Further_Info_Satisfied=Further_Info_Satisfied;
            this.Underwriter_Comments=Underwriter_Comments;
            this.index=index;
        }
        
        
        
    }
}