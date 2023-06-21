public class BAA_SubmissonResults_LightningController {
     @AuraEnabled
    public static NPAABaseEventController.Wrapper getWrapper(String evnId, String opportId){
        System.debug('event+ opportId='+evnId + opportId);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        System.debug(wrap);
         
        return wrap;
    }
    
     @AuraEnabled
    public static details getDetails(List<Account>accounts,String opportId){
        system.debug('Accounts= '+accounts);
        system.debug('opportId= '+opportId);
          Map<String,List<CaseDetail>> Cases = new Map<String,List<CaseDetail>>();
         List<Case> caseList;
        caseList = DataHelper.GetCases(opportId);  
        system.debug('caseList= '+caseList);
        Map<String,String>  Status = new Map<String,String>();
        
    // Set US Person flag based on whether we've received a signed form already
    Boolean USPersonSignedForm = checkUSPersonsSignedForm(opportId);
    Boolean containsUSPerson = false;
    System.debug('After checkUSPersonsSignedForm, USPersonSignedForm='+USPersonSignedForm);
        List<detailList> detailList=new List<detailList>();
        
        for(Account a : accounts)
        {
            //System.debug('Account = '+a);
           
           
        	detailList dl=new detailList();
            dl.Cases=new List<CaseDetail>();
            dl.account=a;
            
            
      List<CaseDetail> caseDetailList = new List<CaseDetail>();
            Cases.put(a.id,caseDetailList );
           // dl.Cases.add();
            
      if(!USPersonSignedForm && a.US_Person_Check__c=='Yes') // We don't have a form yet and the applicants contain a US Person
      {
        containsUSPerson = true;
        Status.put(a.id,'Refer (US Person - Signed application form required before continuing)');
        //System.debug('Added US Person Status');
        dl.status='Refer (US Person - Signed application form required before continuing)';
      }
      else
      {
        Status.put(a.id,'Approved');
          dl.status='Approved';
      }
            detailList.add(dl);
        }
    System.debug('After looping through, containsUSPerson='+containsUSPerson);
        
    
        
        for(Case c : caseList)
        {
            for(Account a : accounts)
            { 
                
                   
                if(c.ContactId == a.PersonContactId )
                {	
                    List<CaseDetail> clist = Cases.get(a.id);
                    CaseDetail detail = new CaseDetail();
                    detail.subject = c.subject;
                    detail.detail = c.Description;
                    detail.Decision = c.referral_decision__c;
                    detail.CaseNumber= c.CaseNumber;
                    detail.Satisfied = c.satisfied__c;
                    detail.id = c.id;
                    detail.ShowComment=false;
                    if(c.comments__c==null){detail.comment='';}
                    else{detail.comment = c.comments__c;}
                    if(detail.Decision == null)
                    {
                        detail.Decision = 'Refered';
                    }
                    
                    clist.add(detail);
                    
                    String stat = Status.get(a.id);
                    
                    if(detail.Decision.equalsIgnoreCase('declined'))
                    {
                        stat = 'Declined';
                    }
                    
                    if(detail.Decision.equalsIgnoreCase('refered') && !stat.equalsIgnoreCase('declined'))
                    {
                        stat = 'Refered';
                    }
                    Status.put(a.id,stat );
                    break;
                }
            }
        }
       		/*List<detailList> detailList=new List<detailList>();
        for(Account a:accounts){
        	detailList dl=new detailList();
			dl.account=a;
            List<CaseDetail> clist = dl.Cases.get(a.id);
             List<CaseDetail> ctemplist = Cases.get(a.id);
            system.debug('cases.get(a.id)='+Cases.get(a.id));
            /*if(Cases.get(a.id)!=null){
            dl.Cases.put(a.id,Cases.get(a.id));
            }
             clist.add(ctemplist);
            dl.Cases.put(a.id,ctemplist);
			dl.status=status.get(a.id);
			detailList.add(dl);
        }*/
        for(detailList dl:detailList){
             List<CaseDetail> clist = Cases.get(dl.account.id);
           // dl.Cases.put(dl.account.id,Cases.get(dl.account.id));
           	dl.Cases.addAll(clist);
            dl.status=status.get(dl.account.id);
        }
		details dtls=new details();
		dtls.detailList=detailList;
		dtls.containsUSPerson=containsUSPerson;

     System.debug('End of getDetails, Status='+Status);
        System.debug('End of getDetails, dtls='+dtls);
     	   return dtls;
    }
    
     @AuraEnabled
    public static Opportunity getOpp(String opportId){
        Opportunity opp=[select id,SellerBDM_Case_Summary__c,Company_House_Check__c,Co_Hse_Check_Copy_Attached__c from Opportunity where id=:opportId Limit 1];
       // if(opp.SellerBDM_Case_Summary__c==null){opp.SellerBDM_Case_Summary__c=' ';}
        system.debug('opp='+opp);
        return opp;
    }
	 @AuraEnabled    
     public static void SaveCase(details dtls,Opportunity opp,String opportId)
    {
		List<Case> caseList;
        caseList = DataHelper.GetCases(opportId);  
        system.debug('detailList='+dtls.detailList);
        for(detailList dt :dtls.detailList){
       
            
            List<CaseDetail> clist = dt.Cases;
            if(clist == null)
                continue;
            if(clist.size() == 0 )
                continue;    
            
            for(CaseDetail det : clist )
            {
                for(Case c : caseList)
                { 
                    if(c.id == det.id)
                    {
                        c.satisfied__c = det.Satisfied;
                        if (det.Satisfied == 'Yes')
                        {
                            c.referral_decision__c = 'Accept';
                        }
                        system.debug('det.Comment='+det.Comment);
                        system.debug('c.comments__c'+ c.comments__c);
                        c.comments__c= det.Comment;
                        system.debug(' c.comments__c'+ c.comments__c);
                        break;
                    }
                }            
            }
        } 
        
         	//update opp;
        	update caseList;
           
        
    }
    @AuraEnabled
    public static List<String> allAccepted (boolean containsUSPerson, String oppid)
    {
        boolean rtv = !containsUSPerson; // C0695 Cannot complete if app contains a US Person and signed form not received
        List<Case> lstCases = DataHelper.GetCases(oppid);  
        List<String> casenumberList=new List<String>();
        system.debug ('These are the cases ' + lstCases + ' - opp.id = ' + oppid);
        for (Case cs:lstCases)
        {
            if (String.IsEmpty(cs.referral_decision__c))
            {
                casenumberList.add(cs.CaseNumber);
               // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Case  ' + cs.CaseNumber + ' is not accepted. ' )); 
                rtv = false;
            }
            else if (!cs.referral_decision__c.EqualsIgnoreCase('Accept'))
            {
                 casenumberList.add(cs.CaseNumber);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Case  ' + cs.CaseNumber + ' is not accepted. ' )); 
                rtv = false;
            }
        }
        return casenumberList;
    }

	 @AuraEnabled
    public static String complete(NPAABaseEventController.Wrapper wrap,boolean allAccept)
    {
         if(wrap.IsCompleted)
            return null;
        try
        {    if(allAccept){
            	wrap.CompleteEvent(); 
        	}
        }
        catch(Exception ex)
        {
            system.debug('error='+ex);            
        }  
        
        return wrap.GoToNextEvent().getUrl();
    }    
      // public PageReference Complete()
   // {
       // if(IsCompleted)
         //   return null;
        
       // SaveCase();
        //AllSatisfied();
        //if(AllSatisfied() && CheckComments())
       // if (AllAccepted())
        //{
          //  NPAABaseEventController.CompleteEvent();
        //}
        
        //return NPAABaseEventController.GoToNextEvent();
   // }

    public static Boolean checkUSPersonsSignedForm(String OppId)
  {
    Opportunity SignedForm = [select US_Person_Signed_App_Form_Received__c from Opportunity where Id=:OppId][0];
    if(SignedForm.US_Person_Signed_App_Form_Received__c)
    {
       return true;
    }
    else
    {
       return false;
    }

  }
    
    public class details{
        @AuraEnabled public List<detailList> detailList{get;set;}
        @AuraEnabled public Boolean containsUSPerson {get; set;}
    }
    public class detailList{
         @AuraEnabled
        public Account account{get;set;}
        @AuraEnabled
        public List<CaseDetail> Cases{get;set;}
        @AuraEnabled
        public string status{get;set;}
    }
    
    public class CaseDetail
    {
       @AuraEnabled public String id{get;set;}
       @AuraEnabled public String CaseNumber {get;set;}
       @AuraEnabled public String Subject{get;set;}
       @AuraEnabled public String Detail{get;set;}
       @AuraEnabled public String Owner{get;set;}
       @AuraEnabled public String Decision{get;set;}
       @AuraEnabled public String Comment{get;set;}
       @AuraEnabled public String Satisfied{get;set;}
       @AuraEnabled public Boolean ShowComment{get;set;}
        
        
    }
    

}