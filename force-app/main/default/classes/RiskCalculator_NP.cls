public without sharing class RiskCalculator_NP {
    private static final String QC_SanctionedIndividualCheck = 'SIC_NP';
    private static final String QC_NegativeNewsScreening = 'NEGSC_NP';
    private static final String QC_PreviouslyExitedorDeclined    = 'PEODC_NP'; 
    private static final String QC_SourceofFunds    = 'SOF_NP';
    private static final String QC_LayersofOwnership    = 'LOO_NP';
    private static final String QC_LengthofEstablishment    = 'LOE_NP';
    private static final String QC_BalanceSheet    = 'BS_NP';
    private static final String QC_NatureofBusinessNPAA = 'INDUSTRY_NP';
    private static final String QC_PEPAssociate    = 'PEP_NP';
    private static final String QC_PoliticallyExposedCompany    = 'PEC_NP';
    private static final String QC_Organisationtype    = 'ENTITY_NP';
    private static final String QC_Product    = 'PRODUCT_NP'; 
    private static final String QC_FacetofaceContact = 'FACETOFACE_NP'; 
    private static final String QC_OrganisationDomicile = 'COI_NP'; 
    private static final String QC_CORforSignif= 'COR_SC_NP'; 
    private static final String QC_CORforUBOs = 'COR_UBO_NP'; 

    public static final String RS_MassMarket = 'MM';
    public static final String RR_Extreme = 'Extreme';
    public static final String RR_High = 'High';
    public static final String RR_Medium = 'Medium';
    public static final String RR_Low = 'Low';

    private static final String RiskHistory_Source_Batch = 'Batch';
    private static final String RiskHistory_Source_Trigger = 'Trigger';
    

    private static void raiseCase(Id accountId, Id oppId)
    {
        if (System.isBatch()) {
            RiskUtils.raiseCaseforRiskEscalationNP(accountId, null);
        }
        else {
            RiskUtils.raiseCaseforRiskEscalationFutureNP(accountId, oppId);
        }
    }

    public static List<Account> CheckCustomerBusiness(List<Account> accountList)
    {
        List<RiskScoreCustomerType__c> personalCustomerTypes = [Select Customer_Type__c From RiskScoreCustomerType__c Where Customer_Category__c='Corporate'];
        List<Account> responseAccList = new List<Account>();
        Set<String> personalCustomerTypesSet = new Set<String>();

        for (RiskScoreCustomerType__c rsct : personalCustomerTypes) {
            personalCustomerTypesSet.add(rsct.Customer_Type__c);
        }

        for (Account acc : accountList) {
            if (personalCustomerTypesSet.contains(acc.Customer_Type__c)) {
                responseAccList.add(acc);
            }
        }

        return responseAccList;
    }

    private static List<Account> checkRiskFieldsPopulated(List<Account> accountList)
    {
        List<Account> accListFieldsPopulated = new List<Account>();
 
        for (Account acc : accountList) {
            if(CAA_Helper.IsGuestUser()) {
                setDefaultFacetoFaceContact(acc);
            }
            
            // removed String.isNotBlank(acc.Country_of_nationality__c),String.isNotBlank(acc.Employment_Type__c) from if condition - CRA Tool Changes
            if (String.isNotBlank(acc.Negative_News_Screening__c) && 
                String.isNotBlank(acc.Previously_Exited_or_Declined__c) && 
                String.isNotBlank(acc.Source_of_Funds__c) && 
                String.isNotBlank(acc.Layers_of_Ownership__c) && 
                String.isNotBlank(acc.Length_of_Establishment__c) && 
                String.isNotBlank(acc.Balance_Sheet_000s__c) && 
                String.isNotBlank(acc.Nature_of_Business_NPAA__c) && 
                //String.isNotBlank(acc.PEP_Associate__c) && 
                String.isNotBlank(acc.Politically_Exposed_Company__c) && 
                String.isNotBlank(acc.Organisation_type__c) && 
                String.isNotBlank(acc.Face_to_face_Contact__c) && 
                String.isNotBlank(acc.Organisation_Domicile__c) && 
                String.isNotBlank(acc.High_risk_prohibited_sanctioned_countr__c) && 
                String.isNotBlank(acc.HR_Prohibited_sanctioned_COR_for_UBOs_I__c) &&
                String.isNotBlank(acc.Sanctioned_Individual_Check__c) )
            {
                accListFieldsPopulated.add(acc);
            }
        }
 
        return accListFieldsPopulated;
    }

    private static List<Account> checkRiskFieldsUpdated(Map<Id, Account> oldMap, List<Account> newList)
    {
        List<Account> accListFieldsUpdated = new List<Account>();

        for (Account acc : newList) {

            Account oldAccount = oldMap.get(acc.Id);
            if ((acc.Layers_of_Ownership__c != oldAccount.Layers_of_Ownership__c) ||
                (acc.Length_of_Establishment__c != oldAccount.Length_of_Establishment__c) ||
                //(acc.Pep_Associate__c != oldAccount.Pep_Associate__c) ||
                (acc.Balance_Sheet_000s__c != oldAccount.Balance_Sheet_000s__c) || //CRA Tool Changes 
                (acc.Sanctioned_Individual_Check__c != oldAccount.Sanctioned_Individual_Check__c) ||
                (acc.Previously_Exited_or_Declined__c != oldAccount.Previously_Exited_or_Declined__c) ||
                (acc.Source_of_Funds__c != oldAccount.Source_of_Funds__c) ||
                (acc.Nature_of_Business_NPAA__c!= oldAccount.Nature_of_Business_NPAA__c) ||
                (acc.Face_to_face_Contact__c != oldAccount.Face_to_face_Contact__c) ||
                (acc.Politically_Exposed_Company__c  != oldAccount.Politically_Exposed_Company__c) ||
                (acc.Negative_News_Screening__c != oldAccount.Negative_News_Screening__c) ||
                (acc.Organisation_type__c != oldAccount.Organisation_type__c) ||
                (acc.Organisation_Domicile__c != oldAccount.Organisation_Domicile__c) || 
                (acc.High_risk_prohibited_sanctioned_countr__c != oldAccount.High_risk_prohibited_sanctioned_countr__c) ||
                (acc.HR_Prohibited_sanctioned_COR_for_UBOs_I__c != oldAccount.HR_Prohibited_sanctioned_COR_for_UBOs_I__c)
                ) {
                    accListFieldsUpdated.add(acc);
                }
               
                system.debug('accListFieldsUpdated ##' + accListFieldsUpdated);
        }

        return accListFieldsUpdated;
    }

    private static Account setDefaultFacetoFaceContact(Account accObject){
        accObject.Face_To_Face_Contact__c = 'Customer has not been met face to face';
        return accObject;
    }

    private static String convertToTrueFalse(String value)
    {
        String uppercaseString = value.toUpperCase();
        String responseString = value;

        if (uppercaseString == 'Y' || uppercaseString == 'YES' || uppercaseString == 'TRUE') {
            responseString = 'true';
        }
        else if (uppercaseString == 'N' || uppercaseString =='NO' || uppercaseString == 'FALSE') {
            responseString = 'false';
        }

        return responseString;
    }

    private static Map<String, Decimal> loadRiskWeightings()
    {
        return loadRiskWeightings(null);
    }
    private static Map<String, Decimal> loadRiskWeightings(String questionCode)
    {
        Map<String, Decimal> riskWeightingsMap = new Map<String, Decimal>();
        List<Risk_Score_Weighting__c> riskWeightings = null;

        if (questionCode == null) {
            riskWeightings = [Select Question_Code__c, Question_Answer__c, Question_Answer_Weighting__c From Risk_Score_Weighting__c Where Type__c = 'Non Personal'];
        }
        else {
            riskWeightings = [Select Question_Code__c, Question_Answer__c, Question_Answer_Weighting__c From Risk_Score_Weighting__c Where Question_Code__c=:questionCode];
        }

        for (Risk_Score_Weighting__c rsw : riskWeightings) {
            riskWeightingsMap.put(rsw.Question_Code__c + convertToTrueFalse(rsw.Question_Answer__c), rsw.Question_Answer_Weighting__c);
        }

        return riskWeightingsMap;
    }

    private static Map<String, String> loadRiskSegmentations()
    {
        Map<String, String> riskSegmentationMap = new Map<String, String>();
        List<Risk_Segmentation__mdt> riskSegmentationMDTList = [Select Total_Net_Worth__c, Risk_Segmentation__c From Risk_Segmentation__mdt];

        for (Risk_Segmentation__mdt rsmdt : riskSegmentationMDTList) {
            riskSegmentationMap.put(rsmdt.Total_Net_Worth__c, rsmdt.Risk_Segmentation__c);
        }
        return riskSegmentationMap;
    }
    
    public static void CalculateRiskScores(List<Account> newList, Map<Id, Account> newMap)
    { 
        List<Account> accListFieldsPopulated = RiskCalculator_NP.checkRiskFieldsPopulated(newList);
        if (accListFieldsPopulated.size() > 0) {
          // Need to calculate Risk Scores
          calculateRiskScores(accListFieldsPopulated);
        } 
    }

    public static List<Account> CalculateRiskScores(List<Account> accountList)
    {        
        List<Account> updatedAccountList = new List<Account>();
        Map<String, Decimal> riskWeightingMap = loadRiskWeightings();
        List<Risk_Score_History__c> riskHistoryList = new List<Risk_Score_History__c>();
        list<Applicant__c> lstApplicants = new list<Applicant__c>();
        Map<String, String> riskSegmentationMap = loadRiskSegmentations();
        ID oppID = NULL;

        List<Account_with_IBB__c> CustomerAccountList = [Select Id, Primary_SFDC_Account__c, EBS_Id__c, Opportunity__c, Opportunity__r.LastModifiedDate, Opportunity__r.FIT_Account_Number__c, IBB_Product__r.Name, IBB_Product__r.Type_of_Product__c, CreatedDate
                                                          From Account_with_IBB__c Where Primary_SFDC_Account__c in :accountList Order By CreatedDate ASC];
        
        List<Asset_Relationship__c> openAssetRelationshipList = [Select Id, Account_with_IBB__r.Opportunity__c, Account_with_IBB__r.Opportunity__r.LastModifiedDate, Account_with_IBB__r.Opportunity__r.FIT_Account_Number__c, Account_with_IBB__r.EBS_Id__c, Account_with_IBB__r.IBB_Product_Name__c, Account_with_IBB__r.IBB_Product__r.Type_of_Product__c, Prospect_Customer__c, CreatedDate
                                                                From Asset_Relationship__c
                                                                Where Prospect_Customer__c in :accountList Order By CreatedDate ASC];

        lstApplicants = [Select Id,Opportunity__c,Opportunity__r.IBB_Product__c, Opportunity__r.IBB_Product__r.Name, Opportunity__r.IBB_Product__r.Type_of_Product__c from Applicant__c where Prospect_Customer__c in: accountList Order By CreatedDate DESC LIMIT 1];

        List<Case> openCasesList = [Select Id, AccountId From Case 
                                    Where   IsClosed=false and 
                                            AccountId in :accountList and 
                                            (Subject LIKE 'Risk Score%' OR Subject LIKE 'Onboarding%' OR Subject LIKE 'Risk Rating%') and 
                                            RecordTypeId =:RiskUtils.getCaseRecordTypeMap().get(RiskUtils.getRiskSetting('Non_Personal_Risk_Calculator_Review'))];

        // If calling via Batch then need to query all the fields for the Account
        // CRA Tool changes - Employment_Type__c,Country_of_nationality__c,Source_of_Wealth__c,Pep_Associate__c removed fields from query 
        if (System.isBatch()) {
            accountList = [Select Id,MLRO_scoring_adjustment__c, EBS_ID__c, Country_of_Residence__c, What_is_your_total_net_worth__c, 
                            Pep__c,Pep_Associate__c,Country_of_PEP_Exposure__c, Sanctioned_Individual_Check__c, Previously_Exited_or_Declined__c, 
                            Nature_of_Employers_Your_Business__c,Face_to_face_Contact__c, Negative_News_Screening__c, Source_of_Funds__c,
                            Country_of_Expected_Transactions_Credits__c, Country_of_Expected_Transactions_Debits__c, Currencies_of_Expected_Transactions__c,
                            Risk_Rating__c, Risk_Score__c, Risk_Segmentation__c, Previous_Risk_Rating__c, Previous_Risk_Score__c, Previous_Risk_Segmentation__c, 
                            Next_Risk_Review_Date__c,Layers_of_Ownership__c,Length_of_Establishment__c,Balance_Sheet_000s__c,Nature_of_Business_NPAA__c,
                            Politically_Exposed_Company__c, Organisation_type__c, Organisation_Domicile__c, High_risk_prohibited_sanctioned_countr__c, 
                            HR_Prohibited_sanctioned_COR_for_UBOs_I__c
                            From Account Where Id in :accountList];

            accountList = populateSourceOfFunds(new Map<Id, Account>(accountList));
        }

        Map<Id, List<Account_with_IBB__c>> CustomerAccountMap = new Map<Id, List<Account_with_IBB__c>>();
        Map<Id, List<Asset_Relationship__c>> openAssetRealtionshipMap = new Map<Id, List<Asset_Relationship__c>>();
        Map<Id, List<Case>> openCaseMap = new Map<Id, List<Case>>();

        for (Account_with_IBB__c CA: CustomerAccountList) {
            if (CustomerAccountMap.containsKey(CA.Primary_SFDC_Account__c)) {
                CustomerAccountMap.get(CA.Primary_SFDC_Account__c).add(CA);
            }
            else {
                CustomerAccountMap.put(CA.Primary_SFDC_Account__c, new List<Account_with_IBB__c> { CA });
            }
        }
        for (Asset_Relationship__c ar : openAssetRelationshipList) {
            if (openAssetRealtionshipMap.containsKey(ar.Prospect_Customer__c)) {
                openAssetRealtionshipMap.get(ar.Prospect_Customer__c).add(ar);
            }
            else {
                openAssetRealtionshipMap.put(ar.Prospect_Customer__c, new List<Asset_Relationship__c> { ar });
            }
        }

        for (Case c : openCasesList) {
            if (openCaseMap.containsKey(c.AccountId)) {
                openCaseMap.get(c.AccountId).add(c);
            }
            else {
                openCaseMap.put(c.AccountId, new List<Case> { c });
            }
        }


        for (Account acc : accountList) {
            
            
            Decimal riskScore = 0.0;
            
            String newLine = ' \r\n';
            String evidence = '';            
            
            System.debug('QC_Organisationtype : '+QC_Organisationtype+' acc.Organisation_type__c: '+acc.Organisation_type__c );
            riskScore += riskWeightingMap.get(QC_Organisationtype + acc.Organisation_type__c);
            evidence += 'Entity Type (' + acc.Organisation_type__c + ') = ' + riskWeightingMap.get(QC_Organisationtype + acc.Organisation_type__c) + newLine;

            Decimal productRiskWeighting = 0;
            DateTime LastProductDate = NULL;
            DateTime LastModifiedDate = NULL;
            Boolean noExistingProduct = TRUE;
            String productEvidence;

            system.debug('CustomerAccountMap##' + CustomerAccountMap.Size());
            if (CustomerAccountList.size() > 0 && CustomerAccountMap.containsKey(acc.Id)) {                
                for(Account_with_IBB__c app : CustomerAccountMap.get(acc.Id)){                    
                    if (String.isNotBlank(app.IBB_Product__r.Type_of_Product__c) && riskWeightingMap.get(QC_Product + app.IBB_Product__r.Type_of_Product__c) >= productRiskWeighting) {
                        system.debug(app.EBS_Id__c + '||' + app.Opportunity__r.FIT_Account_Number__c);
                        if(String.isNotBlank(app.EBS_Id__c) || String.isNotBlank(app.Opportunity__r.FIT_Account_Number__c)){
                            productRiskWeighting = riskWeightingMap.get(QC_Product + app.IBB_Product__r.Type_of_Product__c);
                            system.debug('productRiskWeighting#' + productRiskWeighting);
                            productEvidence = 'IBB Product (' + app.IBB_Product__r.Name + ') = ' + productRiskWeighting + newLine;
                            LastProductDate = app.createdDate;
                            noExistingProduct = FALSE;
                        }
                    }
                    system.debug('oppId#' + oppId);
                    if((LastModifiedDate == NULL || LastModifiedDate < app.Opportunity__r.LastModifiedDate) && String.isBlank(app.EBS_Id__c) && String.isBlank(app.Opportunity__r.FIT_Account_Number__c)){
                        oppId = app.Opportunity__c;
                        LastModifiedDate = app.Opportunity__r.LastModifiedDate;
                    }
                }
            }
            system.debug('oppId#' + oppId);
            system.debug('openAssetRealtionshipMap##' + openAssetRealtionshipMap.Size());
            
            if (openAssetRelationshipList.size() > 0 && openAssetRealtionshipMap.containsKey(acc.Id)) {
                for (Asset_Relationship__c ar : openAssetRealtionshipMap.get(acc.Id)) {
                    if (String.isNotBlank(ar.Account_with_IBB__r.IBB_Product_Name__c) && String.isNotBlank(ar.Account_with_IBB__r.EBS_Id__c)) {
                        system.debug('||' + ar.Account_with_IBB__r.EBS_Id__c);
                        if(riskWeightingMap.get(QC_Product + ar.Account_with_IBB__r.IBB_Product__r.Type_of_Product__c) > productRiskWeighting){
                            productRiskWeighting = riskWeightingMap.get(QC_Product + ar.Account_with_IBB__r.IBB_Product__r.Type_of_Product__c);
                            productEvidence = 'IBB Product (' + ar.Account_with_IBB__r.IBB_Product_Name__c + ') = ' + productRiskWeighting + newLine;                            
                            noExistingProduct = FALSE;
                        }else if((LastProductDate == NULL || LastProductDate <= ar.createdDate) && riskWeightingMap.get(QC_Product + ar.Account_with_IBB__r.IBB_Product__r.Type_of_Product__c) == productRiskWeighting){
                            productRiskWeighting = riskWeightingMap.get(QC_Product + ar.Account_with_IBB__r.IBB_Product__r.Type_of_Product__c);
                            productEvidence = 'IBB Product (' + ar.Account_with_IBB__r.IBB_Product_Name__c + ') = ' + productRiskWeighting + newLine;                            
                            noExistingProduct = FALSE;
                        }
                    }
                    if((LastModifiedDate == NULL || LastModifiedDate < ar.Account_with_IBB__r.Opportunity__r.LastModifiedDate) && String.isBlank(ar.Account_with_IBB__r.EBS_Id__c) && String.isBlank(ar.Account_with_IBB__r.Opportunity__r.FIT_Account_Number__c)){
                        oppId = ar.Account_with_IBB__r.Opportunity__c;
                        LastModifiedDate = ar.Account_with_IBB__r.Opportunity__r.LastModifiedDate;
                    }
                }
            }
            
            if(noExistingProduct && CustomerAccountMap.containsKey(acc.Id)){
                for(Account_with_IBB__c app : CustomerAccountMap.get(acc.Id)){                
                    if(String.isNotBlank(app.IBB_Product__r.Type_of_Product__c) && riskWeightingMap.get(QC_Product + app.IBB_Product__r.Type_of_Product__c) >= productRiskWeighting) {                        
                        productRiskWeighting = riskWeightingMap.get(QC_Product + app.IBB_Product__r.Type_of_Product__c);
                        productEvidence = 'IBB Product (' + app.IBB_Product__r.Name + ') = ' + productRiskWeighting + newLine;
                    }
                    if((LastModifiedDate == NULL || LastModifiedDate < app.Opportunity__r.LastModifiedDate)){
                        oppId = app.Opportunity__c;
                        LastModifiedDate = app.Opportunity__r.LastModifiedDate;
                    }
                }
            }

            if((productRiskWeighting == 0 || productRiskWeighting == null) && acc.EBS_ID__c == null && lstApplicants[0].Opportunity__r.IBB_Product__c != null){
                productRiskWeighting = riskWeightingMap.get(QC_Product + lstApplicants[0].Opportunity__r.IBB_Product__r.Type_of_Product__c);
                productEvidence = 'IBB Product (' + lstApplicants[0].Opportunity__r.IBB_Product__r.Name + ') = ' + productRiskWeighting + newLine;
            }
            
            if (productEvidence != null) {
                riskScore += productRiskWeighting;
                evidence += productEvidence;
            }

            riskScore += riskWeightingMap.get(QC_OrganisationDomicile + acc.Organisation_Domicile__c);
            evidence += 'Country of Incorporation (' + acc.Organisation_Domicile__c + ') = ' + riskWeightingMap.get(QC_OrganisationDomicile + acc.Organisation_Domicile__c) + newLine;

            riskScore += riskWeightingMap.get(QC_LayersofOwnership + acc.Layers_of_Ownership__c);
            evidence += 'Layers of Ownership (' + acc.Layers_of_Ownership__c + ') = ' + riskWeightingMap.get(QC_LayersofOwnership + acc.Layers_of_Ownership__c) + newLine;

            riskScore += riskWeightingMap.get(QC_LengthofEstablishment + acc.Length_of_Establishment__c);
            evidence += 'Length of Establishment (' + acc.Length_of_Establishment__c + ') = ' + riskWeightingMap.get(QC_LengthofEstablishment + acc.Length_of_Establishment__c) + newLine;

            riskScore += riskWeightingMap.get(QC_BalanceSheet + acc.Balance_Sheet_000s__c);
            evidence += 'Balance Sheet (£ 000s) (' + acc.Balance_Sheet_000s__c + ') = ' + riskWeightingMap.get(QC_BalanceSheet + acc.Balance_Sheet_000s__c) + newLine;

            riskScore += riskWeightingMap.get(QC_PoliticallyExposedCompany + acc.Politically_Exposed_Company__c);
            evidence += 'PEP Screening Match (' + acc.Politically_Exposed_Company__c + ') = ' + riskWeightingMap.get(QC_PoliticallyExposedCompany + acc.Politically_Exposed_Company__c) + newLine;

            riskScore += riskWeightingMap.get(QC_SanctionedIndividualCheck + acc.Sanctioned_Individual_Check__c);
            evidence += 'Sanction Screening Match (' + acc.Sanctioned_Individual_Check__c + ') = ' + riskWeightingMap.get(QC_SanctionedIndividualCheck + acc.Sanctioned_Individual_Check__c) + newLine;
            
            riskScore += riskWeightingMap.get(QC_NegativeNewsScreening + acc.Negative_News_Screening__c);
            evidence += 'Negative News Screening (' + acc.Negative_News_Screening__c + ') = ' + riskWeightingMap.get(QC_NegativeNewsScreening + acc.Negative_News_Screening__c) + newLine;
            
            riskScore += riskWeightingMap.get(QC_PreviouslyExitedorDeclined + acc.Previously_Exited_or_Declined__c);
            evidence += 'Previously Declined or Exited (' + acc.Previously_Exited_or_Declined__c + ') = ' + riskWeightingMap.get(QC_PreviouslyExitedorDeclined + acc.Previously_Exited_or_Declined__c) + newLine;
            
            riskScore += riskWeightingMap.get(QC_NatureofBusinessNPAA + acc.Nature_of_Business_NPAA__c);
            evidence += 'Industry (' + acc.Nature_of_Business_NPAA__c + ') = ' + riskWeightingMap.get(QC_NatureofBusinessNPAA + acc.Nature_of_Business_NPAA__c) + newLine;
            
            riskScore += riskWeightingMap.get(QC_SourceofFunds + acc.Source_of_Funds__c);
            evidence += 'Source of Funds (' + acc.Source_of_Funds__c + ') = ' + riskWeightingMap.get(QC_SourceofFunds + acc.Source_of_Funds__c) + newLine;
        
            evidence+= newLine + 'UBOs and Significant Controllers' + newLine;
        
            riskScore += riskWeightingMap.get(QC_FacetofaceContact + acc.Face_to_face_Contact__c);
            evidence += 'Face to face contact with significant controller or UBO (' + acc.Face_to_face_Contact__c + ') = ' + riskWeightingMap.get(QC_FacetofaceContact + acc.Face_to_face_Contact__c) + newLine;
            
            riskScore += riskWeightingMap.get(QC_CORforSignif + acc.High_risk_prohibited_sanctioned_countr__c);
            evidence += 'High risk, prohibited, sanctioned country of residence for significant controllers (' + acc.High_risk_prohibited_sanctioned_countr__c + ') = ' + riskWeightingMap.get(QC_CORforSignif + acc.High_risk_prohibited_sanctioned_countr__c) + newLine;
            
            riskScore += riskWeightingMap.get(QC_CORforUBOs + acc.HR_Prohibited_sanctioned_COR_for_UBOs_I__c);
            evidence += 'High risk, prohibited, sanctioned country of residence for Ultimate Beneficial Owners or IBOs(' + acc.HR_Prohibited_sanctioned_COR_for_UBOs_I__c + ') = ' + riskWeightingMap.get(QC_CORforUBOs + acc.HR_Prohibited_sanctioned_COR_for_UBOs_I__c) + newLine;
           
          // Recalculate Formula fields
            Account recalculateFormula = null;
            recalculateFormula = new Account();
            recalculateFormula.Id = acc.Id;
            recalculateFormula.Risk_Score__c = riskScore;
            recalculateFormula.recalculateFormulas();
            /* Maybe no change in score, but could have change in Risk Segmentation
            if ((acc.Risk_Segmentation__c != riskSegmentationMap.get(acc.What_is_your_total_net_worth__c)) || (riskScore != acc.Risk_Score__c)) {
                acc.Previous_Risk_Segmentation__c = acc.Risk_Segmentation__c;
                acc.Risk_Segmentation__c = riskSegmentationMap.get(acc.What_is_your_total_net_worth__c);
            }*/
            
            // Only want to set the Risk Score where the risk score changes
            system.debug('~~~~~ riskScore' +riskScore );
            system.debug('~~~~~ acc.Risk_Score__c' +acc.Risk_Score__c );
            if (riskScore != acc.Risk_Score__c) {
                // Set Previous fields
                acc.Previous_Risk_Rating__c = acc.Risk_Rating__c;
                acc.Previous_Risk_Score__c = acc.Risk_Score__c;                                
                
                // Set Current fields
                acc.Risk_Calculation_DateTime__c = Datetime.now();                
                acc.Risk_Score__c = riskScore;    
                system.debug('acc.Risk_Score__c: '+acc.Risk_Score__c);
                // Recalculate Formula fields
                recalculateFormula.Risk_Score__c = acc.Risk_Score__c;
                //recalculateFormula.Risk_Segmentation__c = acc.Risk_Segmentation__c;
                recalculateFormula.recalculateFormulas();
                

                
                if (!openCaseMap.containsKey(acc.Id)) {                    
                    system.debug('recalculateFormula.Risk_Rating__c'+recalculateFormula.Risk_Rating__c);
                    system.debug('acc.Previous_Risk_Rating__c'+acc.Previous_Risk_Rating__c);
                    if ((acc.Previous_Risk_Rating__c == RR_Medium || acc.Previous_Risk_Rating__c == RR_Low) && (recalculateFormula.Risk_Rating__c == RR_High || recalculateFormula.Risk_Rating__c == RR_Extreme)) {
                        system.debug('If loop');
                        // Need to create triggered Case
                        /*Id oppId = null;
                        
                        if (CustomerAccountMap.containsKey(acc.Id)) {
                            oppId = CustomerAccountMap.get(acc.Id)[0].Opportunity__c;
                        }*/
                        raiseCase(acc.Id, oppId);
                    } else if ((recalculateFormula.Risk_Rating__c != RR_High && acc.Previous_Risk_Rating__c == RR_High) ||
                             (recalculateFormula.Risk_Rating__c != RR_Extreme && acc.Previous_Risk_Rating__c == RR_Extreme) ||
                             ((recalculateFormula.Risk_Rating__c == RR_High || recalculateFormula.Risk_Rating__c == RR_Extreme) && (acc.Previous_Risk_Rating__c != RR_High && acc.Previous_Risk_Rating__c != RR_Extreme))) {    
                        // Need to create triggered Case
                        /*Id oppId = null;
                        
                        if (CustomerAccountMap.containsKey(acc.Id)) {
                            oppId = CustomerAccountMap.get(acc.Id)[0].Opportunity__c;
                        }*/
                        
                        system.debug('else loop');
                        raiseCase(acc.Id, oppId);
                    }
                }
             
                // Populate Risk Histories
                // As a design constraint, can only store Risk Histories where Account is being updated as the Account Id will be present to link to
                if (acc.Id != null) {
                    Risk_Score_History__c riskHistory = new Risk_Score_History__c();
                    riskHistory.Account__c = acc.Id;
                    riskHistory.Risk_Rating__c = recalculateFormula.Risk_Rating__c;
                    riskHistory.Risk_Score__c = acc.Risk_Score__c;
                    //riskHistory.Risk_Segmentation__c = acc.Risk_Segmentation__c;
                    riskHistory.Risk_Calculation_Evidence__c = evidence;
                    riskHistory.Source_of_Calculation__c = System.isBatch() ? RiskHistory_Source_Batch : RiskHistory_Source_Trigger;
                    riskHistoryList.add(riskHistory);
                }
                
                updatedAccountList.add(acc);
            }    
           
        }
        
        if (riskHistoryList.size() > 0) {
            insert riskHistoryList;
        }
        return updatedAccountList;
    }

    public static void CalculateRiskScores(List<Account> oldList, Map<Id, Account> oldMap, List<Account> newList, Map<Id, Account> newMap)
    {
        // Filtering only personal customer
        List<Account> personalAccountList = CheckCustomerBusiness(newList);
        system.debug('personalAccountList####' + personalAccountList);
        
        // Populate Source of Funds from Opportunity
        List<Account> updatedSourceOfFunds = new List<Account>();        
        if(personalAccountList.size() > 0){
            updatedSourceOfFunds = populateSourceOfFunds(new Map<Id, Account>(personalAccountList));
            system.debug('updatedSourceOfFunds####' + updatedSourceOfFunds);
        }
        
        // Check Risk Score fields has value   
        List<Account> accListFieldsPopulated = new List<Account>();        
        if(updatedSourceOfFunds.size() > 0){
            accListFieldsPopulated = RiskCalculator_NP.checkRiskFieldsPopulated(updatedSourceOfFunds);
            system.debug('accListFieldsPopulated####' + accListFieldsPopulated);
        }
        
        // Check Risk Score fields are modified
        List<Account> accListFieldsUpdated = new List<Account>();
        if(accListFieldsPopulated.size() > 0){
            accListFieldsUpdated = RiskCalculator_NP.checkRiskFieldsUpdated(oldMap, accListFieldsPopulated);
            system.debug('accListFieldsUpdated####' + accListFieldsUpdated);
        }
        
        // Need to calculate Risk Scores
        if(accListFieldsUpdated.size() > 0){            
            calculateRiskScores(accListFieldsUpdated);  
        }
    }

    private static List<Account> populateSourceOfFunds(Map<Id, Account> newMap)
    {
        List<Applicant__c> openApplicantsList = [Select Prospect_Customer__c, Opportunity__r.Source_of_Funds__c
                                                 From Applicant__c
                                                 Where Prospect_Customer__c in :newMap.KeySet() and Opportunity__r.RecordType.Name != 'HPP CAA' and Opportunity__r.RecordType.Name != 'ProductSwitching' and
                                                        Opportunity__r.Stagename not IN('Assigned to BDM - Rejected','Account lost','Not Eligible - HPP',
                                                                                        'HPP - Declined','Retention Call - Not Interested','HPP/BTL Opportunity - Closed Incomplete',
                                                                                        'Application declined','Redeemed','Abandoned','Client did not win bid','Financed with another Bank')];
        Map<String, Decimal> riskWeightingMap = loadRiskWeightings(QC_SourceOfFunds);
        Boolean setOppToAccSOF = false;

        for(Applicant__c app: openApplicantsList){
            setOppToAccSOF = false;

            // Check that Opportunity Source of Funds is set
            if (String.IsNotBlank(app.Opportunity__r.Source_Of_Funds__c)) {

                // Check that Account Source of Funds is set
                if (String.isNotBlank(newMap.get(app.Prospect_Customer__c).Source_Of_Funds__c)) {

                    // Check if Opp SOF is highter than the current Acc SOF (need to get the highest weighted SOF from the Opps for the Customer)
                    if (riskWeightingMap.get(QC_SourceOfFunds + app.Opportunity__r.Source_Of_Funds__c) > riskWeightingMap.get(QC_SourceOfFunds + newMap.get(app.Prospect_Customer__c).Source_Of_Funds__c)) {
                        setOppToAccSOF = true;
                    }
                }
                else {
                    // Account SOF not set so Opp SOF should overwrite it
                    setOppToAccSOF = true;
                }

                if (setOppToAccSOF) {
                    newMap.get(app.Prospect_Customer__c).Source_Of_Funds__c = app.Opportunity__r.Source_of_Funds__c;
                }
            }
        }
        return newMap.Values();
    }


}