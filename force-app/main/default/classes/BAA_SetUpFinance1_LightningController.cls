public class BAA_SetUpFinance1_LightningController {
     @AuraEnabled
    public static NPAABaseEventController.Wrapper getWrapper(String evnId, String opportId){
        System.debug('event+ opportId='+evnId + opportId);
        NPAABaseEventController.Wrapper wrap = new NPAABaseEventController.Wrapper( evnId, opportId);
        System.debug(wrap);
         
        return wrap;
    }
 
 	/*	@AuraEnabled(cacheable=true)
 	  public static List<SelectOption> getRelationships() 
    {        
        List<SelectOption> options = new List<SelectOption>();
        List<EBS_Relationship__c> relationships = [select code__c, text__c from EBS_Relationship__c where relationship_type__c = 'BUSINESS' order by code__c];
        
        options.add(new SelectOption('','Please select'));
        for(EBS_Relationship__c r :  relationships)
        {
            options.add(new SelectOption(r.Code__c,r.text__c));
        }            

        return options;
    }
    */
	@AuraEnabled
    public static detailWrap getDetails(IBB_Product__c Prod,String opportId)
    { 
		Account_With_IBB__c theIBBAccount = new Account_With_IBB__c();
                List<Account_With_IBB__c> theAccs = [SELECT    Id,
                                                               Primary_SFDC_Account__c,
                                                               IBB_Product__c,
                                                               Opportunity__c
                                                    FROM       Account_With_IBB__c
                                                    WHERE      Opportunity__c = :opportId];             
                if (theAccs.Size() > 0)
                {
                    theIBBAccount = theAccs[0];
                }
        system.debug('theIBBAccount='+theIBBAccount);
        Opportunity thisOpp = new Opportunity();        
		thisOpp = [SELECT NPAA_Application_signed__c,
                          NPAA_Documents_Received__c,
                          Date_Application_Received__c
                   FROM   Opportunity
                   WHERE  Id = :opportId];
	
		List<Applicant__c> theApplicants =new List<Applicant__c>();	
		 theApplicants = [SELECT  Id, ApplicantName__c,
                                            Applicant_Number__c,
                                            Has_Mandate__c,
                                            Is_Director__c,
                                            Is_Shareholder__c,
                                            Is_Signatory__c,
                                            Primary_Account_Holder__c,
                                            
                                            Prospect_Customer__r.name,
                                            Opportunity__c
                                  FROM     Applicant__c
                                  WHERE    Opportunity__c = :opportId
                                  ];
		
		Applicant__c thePrimaryApplicant=new Applicant__c();
		for (Applicant__c app:theApplicants)
                {
                    if (app.Primary_Account_Holder__c == true)
                    {
                        thePrimaryApplicant = app;
                    }
                }
        system.debug('thePrimaryApplicant='+thePrimaryApplicant);

		 List<Applicant__c> theSecondaryApplicants=new  List<Applicant__c>();
			for (Applicant__c app:theApplicants)
                {
                    if (app.Primary_Account_Holder__c == false)
                    {
                        theSecondaryApplicants.Add(app);
                    }
                }
        system.debug('theSecondaryApplicants='+theSecondaryApplicants);
    
        // Create the Account with IBB record then the JARs for the applicants
        theIBBAccount.Primary_SFDC_Account__c = thePrimaryApplicant.Prospect_Customer__c;
        theIBBAccount.IBB_Product__c = Prod.Id;
        theIBBAccount.Opportunity__c = opportId;
        upsert theIBBAccount;
        
        thisOpp.Account_with_IBB__c = theIBBAccount.Id;
        upsert thisOpp;
        
        List<Asset_Relationship__c > lstAss = new List<Asset_Relationship__c >();        
        List<Asset_Relationship__c > existing = [select id, Account_with_IBB__c , Prospect_Customer__c from Asset_Relationship__c  where Account_with_IBB__c =: theIBBAccount.id ];
        
        List<IBB_Product__c> products = new List<IBB_Product__c>();
        products = [SELECT    ID,
                              IBB_Product_set__r.Name
                    FROM    IBB_Product__c
                    WHERE    id = :Prod.id];
        IBB_Product__c product;
        if (products.size() > 0)
        {
            product = new IBB_Product__c();
            product = products[0];
        }
   		
		List<BAADecisionEngineMatrix__c> DEMatrixList=new List<BAADecisionEngineMatrix__c>();
        DEMatrixList  = [SELECT Id,
                                  EntityType__c,
                                  ProductCategory__c,
                                  DoAML__c,
                                  DoCredit__c,
                                  DoSanction__c,
                                  DoSetUp__c
                           FROM   BAADecisionEngineMatrix__c
                           WHERE  ProductCategory__c = :product.IBB_Product_set__r.Name];
               
        for(Applicant__c a : theApplicants)
        {
            if (!a.Primary_Account_Holder__c)
            {
                BusinessDecisionMatrix matrix = new BusinessDecisionMatrix (a, DEMatrixList);
                if (matrix.ApplicantFound && !matrix.doSetUp )
                {
                    continue;
                }
            }
        
            // CHeck the DEMatrix to see if they go or not 
            //if (IgnoreTheApplicant (a) && !a.Primary_Account_Holder__c)
            //{
            //    continue;
            //}
        
        
            Boolean found= false;
            for(Asset_Relationship__c ar : existing  )
            {
                if(ar.Prospect_Customer__c  == a.Prospect_Customer__c)
                {
                    found = true;
                    lstAss.add(ar);
                }
            }
        
        
        
            if(!found)
            {
                Asset_Relationship__c ass = new Asset_Relationship__c();
                ass.Account_with_IBB__c = theIBBAccount.id;
                ass.Prospect_Customer__c = a.Prospect_Customer__c;
                lstAss.add(ass);
            }
        }
        lstAss[0].Primary_Account_Holder__c = true;
        
        upsert lstAss;
        
		List<Asset_Relationship__c> theSecondaryAccountHolders=new List<Asset_Relationship__c>();
        theSecondaryAccountHolders = [SELECT id,
                                            Primary_Account_Holder__c,
                                            Prospect_Customer__r.Name,
                                            Prospect_Customer__c,
                                            Relationship_To_Primary_Applicant1__c,
                                            Account_with_IBB__c 
                                      FROM    Asset_Relationship__c
                                      WHERE    Primary_Account_Holder__c = false
                                      AND   Account_with_IBB__c =: theIBBAccount.id ];
         system.debug('theSecondaryAccountHolders='+theSecondaryAccountHolders);
        
         List<options> options = new List<options>();
        List<EBS_Relationship__c> relationships = [select code__c, text__c from EBS_Relationship__c where relationship_type__c = 'BUSINESS' order by code__c];
         options opp=new options();
            opp.value=' ';
            opp.label='Please select';
            options.add(opp);
        //options.add(new options('','Please select'));
        
        for(EBS_Relationship__c r :  relationships)
        {
            options op=new options();
            op.value=r.Code__c;
            op.label=r.text__c;
            options.add(op);
            
           // options.add(new SelectOption(r.Code__c,r.text__c));
        }    
		         system.debug('options='+options);
        detailWrap dW=new detailWrap();
        dW.thePrimaryApplicant=thePrimaryApplicant;
		dW.theSecondaryAccountHolders=theSecondaryAccountHolders;
        dW.getRelationships=options;
        system.debug('dW='+dW);
        return dW;
        
    }
    
     @AuraEnabled
	 public static void ContinueToEBS (List<Asset_Relationship__c> theSecondaryAccountHolders)
    {
        
        //update thisOpp;
        upsert theSecondaryAccountHolders;
        
        
       // return new PageReference ('/apex/BAA_SetUpFinance2?oppid=' + opp.id);
    }
	

	 public class detailWrap{
         @AuraEnabled
        public Applicant__c thePrimaryApplicant{get;set;}
        @AuraEnabled
        public List<Asset_Relationship__c> theSecondaryAccountHolders{get;set;}
         @AuraEnabled
         public List<options> getRelationships{get;set;}
        
    }
    
    public class options{
         @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String value{get;set;}
         
        
    }
    
    


}