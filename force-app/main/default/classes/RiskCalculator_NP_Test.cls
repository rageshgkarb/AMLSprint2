/**
* @author Avinash
* @date 22-09-2022
* @description Test class created to test RiskCalculator_NP class and Account Trigger related to the RiskCalculator
*/
@isTest
public class RiskCalculator_NP_Test {
    private static Integer  COI_NPUK = 1;
    private static Integer  COI_NPAF = 1100;
    private static Integer  COI_NPAL = 100;
    private static Integer  COR_UBO_NPUK = 1;
    private static Integer  COR_UBO_NPAF = 1100;
    private static Integer  COR_UBO_NPAL = 100;
    private static Integer  COR_SC_NPUK = 1; 
    private static Integer  COR_SC_NPAF = 1100;
    private static Integer  COR_SC_NPAL = 100;
    private static Integer  INDUSTRY_NPCL = 5;
    private static Integer  INDUSTRY_NPCR = 5;
    private static Integer  PEC_NPNTM = 1;
    private static Integer  PEC_NPUBO = 100;
    private static Integer  ENTITY_NPLC = 1;
    private static Integer  ENTITY_NPRC = 5;
    private static Integer  PRODUCT_NPSA = 1;
    private static Integer  PRODUCT_NPCA = 1;
    private static Integer  FACETOFACE_NPSCUBO = 1;
    private static Integer  FACETOFACE_NPSC = 5;
    private static Integer  SIC_NPNTMI = 1;
    private static Integer  SIC_NPTCSMI = 1100;
    private static Integer  NEGSC_NPNTMI = 1;
    private static Integer  NEGSC_NPASCNFC = 100;
    private static Integer  PEODC_NPNTMI = 1;
    private static Integer  PEODC_NPTM = 1100;
    private static Integer  SOF_NPAF = 1;
    private static Integer  SOF_NPTO = 1;
    private static Integer  LOO_NP1L = 1;
    private static Integer  LOO_NP2L = 5;
    private static Integer  LOE_NPO3 = 1;
    private static Integer  LOE_NPU3 = 5;
    private static Integer  BS_NPU25 = 5;
    private static Integer  BS_NPO25 = 1;
    private static Integer  PEP_NPNTM = 1;
    private static Integer  PEP_NPUBO = 100;

    @testSetup static void setup() {
            Account acc = setupAccount('', 'United Kingdom', 'United Kingdom', 'Club, Association or Community', 'No True Match', 'Limited Company', 'No UBO or Significant Controller met face to face', 
                                        'No true match identified', 'No true match identified', 'No true match identified',
                                        'Account funded from a bank account in the UK','1 layer of ownership or less','Over 3 years','Under £2.5m','No True Match', 'Corporate');
            
            Opportunity opp1 = setupOpportunity(acc.Id, 'Completed', '120 Day Notice Savings Account', null, 'Cash Deposit');
            setupCustomerAccount('120 Day Notice Savings Account', acc.Id, true, '123451');  
            Account_with_IBB__c awi1 = setupCustomerAccount('Current Account', acc.Id, true, '123461');
            Account_with_IBB__c awi2 = setupCustomerAccount('Current Account', acc.Id, true, '123462');
            Account_with_IBB__c awi3 = setupCustomerAccount('Wakala Account', acc.Id, true, '123463');

            setupAssetRelationship(acc.Id, awi1.Id, true, true);
            setupAssetRelationship(acc.Id, awi2.Id, true, true);
            setupAssetRelationship(acc.Id, awi3.Id, true, true);    
    }

    public static TestMethod void newCustomer_WhenNotAllMMQuestionsPopulated_ShouldNotCalculate()
    {
        
            Account acc = [ Select Id,MLRO_scoring_adjustment__c, EBS_ID__c, Country_of_Residence__c, What_is_your_total_net_worth__c, 
                            Pep__c,Pep_Associate__c,Country_of_PEP_Exposure__c, Sanctioned_Individual_Check__c, Previously_Exited_or_Declined__c, 
                            Nature_of_Employers_Your_Business__c,Face_to_face_Contact__c, Negative_News_Screening__c, Source_of_Funds__c,
                            Country_of_Expected_Transactions_Credits__c, Country_of_Expected_Transactions_Debits__c, Currencies_of_Expected_Transactions__c,
                            Risk_Rating__c, Risk_Score__c, Risk_Segmentation__c, Previous_Risk_Rating__c, Previous_Risk_Score__c, Previous_Risk_Segmentation__c, 
                            Next_Risk_Review_Date__c,Layers_of_Ownership__c,Length_of_Establishment__c,Balance_Sheet_000s__c,Nature_of_Business_NPAA__c,
                            Politically_Exposed_Company__c, Organisation_type__c, Organisation_Domicile__c, High_risk_prohibited_sanctioned_countr__c, 
                            HR_Prohibited_sanctioned_COR_for_UBOs_I__c From Account where FirstName='Joe'];
            System.debug('acc : '+acc.Organisation_Domicile__c);
			
        	Test.startTest();
            update acc;                         
            Test.stopTest();
    }

    public static TestMethod void newCustomer_WhenExtreme()
    {
        
            Account acc = [ Select Id,MLRO_scoring_adjustment__c, EBS_ID__c, Country_of_Residence__c, What_is_your_total_net_worth__c, 
                            Pep__c,Pep_Associate__c,Country_of_PEP_Exposure__c, Sanctioned_Individual_Check__c, Previously_Exited_or_Declined__c, 
                            Nature_of_Employers_Your_Business__c,Face_to_face_Contact__c, Negative_News_Screening__c, Source_of_Funds__c,
                            Country_of_Expected_Transactions_Credits__c, Country_of_Expected_Transactions_Debits__c, Currencies_of_Expected_Transactions__c,
                            Risk_Rating__c, Risk_Score__c, Risk_Segmentation__c, Previous_Risk_Rating__c, Previous_Risk_Score__c, Previous_Risk_Segmentation__c, 
                            Next_Risk_Review_Date__c,Layers_of_Ownership__c,Length_of_Establishment__c,Balance_Sheet_000s__c,Nature_of_Business_NPAA__c,
                            Politically_Exposed_Company__c, Organisation_type__c, Organisation_Domicile__c, High_risk_prohibited_sanctioned_countr__c, 
                            HR_Prohibited_sanctioned_COR_for_UBOs_I__c From Account where FirstName='Joe'];
            System.debug('acc : '+acc.Organisation_Domicile__c);
            acc.Organisation_Domicile__c = 'United Kingdom (GB)';
                update acc;
            
            Test.startTest();
                acc.Organisation_Domicile__c = 'Afghanistan (AF)';
                update acc;                       
            Test.stopTest();
    }

    public static Account setupAccount(String OrganisationDomicile, String CORforUBOs, String CORforSignif,String NatureofBusinessNPAA, String PoliticallyExposedCompany, String Organisationtype, String FacetofaceContact, 
                                        String SanctionedIndividualCheck, String NegativeNewsScreening, String PreviouslyExitedorDeclined,
                                        String SourceofFunds,String LayersofOwnership,String LengthofEstablishment,String BalanceSheet,String PEPAssociate, String accountType)
                                        
    {
        setupCustomSettings();

        return setupAccountWithNoCustomSettings(OrganisationDomicile, CORforUBOs, CORforSignif ,NatureofBusinessNPAA, PoliticallyExposedCompany, Organisationtype, FacetofaceContact, 
                                                SanctionedIndividualCheck, NegativeNewsScreening, PreviouslyExitedorDeclined,
                                                SourceofFunds,LayersofOwnership,LengthofEstablishment,BalanceSheet,PEPAssociate, accountType, true);
                                                
    }

    public static Account setupAccountWithNoCustomSettings(String OrganisationDomicile, String CORforUBOs,String CORforSignif,String NatureofBusinessNPAA, String PoliticallyExposedCompany, String Organisationtype, String FacetofaceContact, 
                                                            String SanctionedIndividualCheck, String NegativeNewsScreening, String PreviouslyExitedorDeclined,
                                                            String SourceofFunds,String LayersofOwnership,String LengthofEstablishment,String BalanceSheet,String PEPAssociate, String accountType, Boolean insertFlag)
                                                            
    {
        Account acc = new Account();        
        acc.FirstName = 'Joe';
        acc.LastName = 'Bloggs';
        acc.Title_Other__c = 'Mr'; 
        acc.BillingStreet = 'A\nB';
        acc.ShippingStreet = 'A\nB';
        acc.PersonMailingStreet = 'A\nB';
        acc.Layers_of_Ownership__c  =       LayersofOwnership;      
        acc.Length_of_Establishment__c  =           LengthofEstablishment;
        acc.Balance_Sheet_000s__c       =       BalanceSheet;       
        acc.Sanctioned_Individual_Check__c  =   SanctionedIndividualCheck;  
        acc.Previously_Exited_or_Declined__c    =   PreviouslyExitedorDeclined; 
        acc.Source_of_Funds__c              =       SourceofFunds;
        acc.Nature_of_Business_NPAA__c          =   NatureofBusinessNPAA;   
        acc.Face_to_face_Contact__c         =       FacetofaceContact;  
        acc.Politically_Exposed_Company__c      =   PoliticallyExposedCompany;  
        acc.Negative_News_Screening__c          =   NegativeNewsScreening;
        acc.Organisation_type__c            =           Organisationtype;
        acc.Organisation_Domicile__c            =   OrganisationDomicile;   
        acc.High_risk_prohibited_sanctioned_countr__c   = CORforSignif;
        acc.HR_Prohibited_sanctioned_COR_for_UBOs_I__c = CORforUBOs;
        acc.Customer_Type__c = 'Limited Company';

        system.debug('XXXXX acc: ' + acc);

        if (insertFlag) {
            insert acc;
            return [Select Id,MLRO_scoring_adjustment__c, EBS_ID__c, Country_of_Residence__c, What_is_your_total_net_worth__c, 
                            Pep__c,Pep_Associate__c,Country_of_PEP_Exposure__c, Sanctioned_Individual_Check__c, Previously_Exited_or_Declined__c, 
                            Nature_of_Employers_Your_Business__c,Face_to_face_Contact__c, Negative_News_Screening__c, Source_of_Funds__c,
                            Country_of_Expected_Transactions_Credits__c, Country_of_Expected_Transactions_Debits__c, Currencies_of_Expected_Transactions__c,
                            Risk_Rating__c, Risk_Score__c, Risk_Segmentation__c, Previous_Risk_Rating__c, Previous_Risk_Score__c, Previous_Risk_Segmentation__c, 
                            Next_Risk_Review_Date__c,Layers_of_Ownership__c,Length_of_Establishment__c,Balance_Sheet_000s__c,Nature_of_Business_NPAA__c,
                            Politically_Exposed_Company__c, Organisation_type__c, Organisation_Domicile__c, High_risk_prohibited_sanctioned_countr__c, 
                            HR_Prohibited_sanctioned_COR_for_UBOs_I__c From Account Where Id=:acc.Id];
        }
        else {
            return acc;
        }
    }   

    public static Opportunity setupOpportunity(Id accountId, String status, String typeOfProduct, Id jointAccountId, String sourceOfFunds)
    {
        IBB_Product_Set__c productSet = new IBB_Product_Set__c();
        productSet.Name = 'Test'; 
        productSet.Max_No_of_Applicants__c = 4;
        productSet.ProductSetType__c = 'btl';
        insert productSet;
        
        IBB_Product__c product = new IBB_Product__c();
        product.Name = 'Test';
        product.IBb_product_set__c =productSet.id;
        product.Max_finance_to_value_FTV__c = 80;
        product.ShowOnAIP__c = true;
        product.Benchmark_rate__c = 4;
        product.Type_of_Product__c = typeOfProduct;
        insert product;

        Opportunity opp = new Opportunity();
        opp.closedate = date.today();
        opp.AccountId = accountId;
        opp.Name = 'Test Opp';
        opp.Interested_in__c = 'Test';
        opp.Purchase_price_market_value__c = 300000;
        opp.Finance_Required__c = 100000;
        opp.Term_of_Finance__c=25;
        opp.number_of_people_applying__c = 1;
        opp.Source_of_Funds__c = sourceOfFunds;
        opp.StageName = status;
        opp.IBB_Product__c = product.Id;
        insert opp;

        List<Applicant__c> applicantList = new List<Applicant__c> {
            new Applicant__c (Opportunity__c = opp.Id, Prospect_Customer__c=accountId, Primary_Account_Holder__c=true, Stage__c='Pre-Credit Check')
        };

        if (jointAccountId != null) {
            applicantList.add(
                new Applicant__c(Opportunity__c = opp.Id, Prospect_Customer__c=jointAccountId, Primary_Account_Holder__c=false, Stage__c='Pre-Credit Check')
            );
        }
        insert applicantList;

        return opp;
    }

    public static Account_with_IBB__c setupCustomerAccount(String typeOfProduct, Id accountId, Boolean active, String EBSID)
    {
        return setupCustomerAccount(typeOfProduct, accountId, active, null, EBSID, true);  
    }

    public static Account_with_IBB__c setupCustomerAccount(String typeOfProduct, Id accountId, Boolean active, Id productId, String EBSID, Boolean insertFlag)
    {
        Account_with_IBB__c awi = new Account_with_IBB__c();
        awi.Primary_SFDC_Account__c = accountId;
        awi.IBB_Product__c = productId == null ? setupProduct(typeOfProduct).Id : productId;
        awi.account_inactive__c = active == true ? 'N' : '';
        awi.EBS_Id__c = EBSID;
        if (insertFlag) { 
            insert awi;
        }
        return awi;
    }

    public static IBB_Product__c setupProduct(String typeOfProduct)
    {
        List<IBB_Product__c> productList = [Select Id, Type_of_Product__c From IBB_Product__c Where Type_of_Product__c=:typeOfProduct];
        IBB_Product__c product = new IBB_Product__c();

        if (productList.size() > 0) {
            product = productList[0];
        }
        else {
            IBB_Product_Set__c productSet = new IBB_Product_Set__c();
            productSet.Name = 'Test'; 
            productSet.Max_No_of_Applicants__c = 4;
            productSet.ProductSetType__c = 'btl';
            insert productSet;

            product.Name = typeOfProduct;
            product.IBb_product_set__c =productSet.id;
            product.Max_finance_to_value_FTV__c = 80;
            product.ShowOnAIP__c = true;
            product.Benchmark_rate__c = 4;
            product.Type_of_Product__c = typeOfProduct;
            insert product;
        }

        return product;
    }

    public static Asset_Relationship__c setupAssetRelationship(Id accountId, Id accountWithIBBId, Boolean primaryAccount, Boolean insertFlag)
    {
        Asset_Relationship__c ar = new Asset_Relationship__c();
        ar.Account_with_IBB__c = accountWithIBBId;
        ar.Prospect_Customer__c = accountId;
        ar.Primary_Account_Holder__c = primaryAccount;
        ar.Is_Active__c = true;

        if (insertFlag) { 
            insert ar;
        }
        return ar;
    }

    public static void setupCustomSettings(){
        String QC_SanctionedIndividualCheck = 'SIC_NP';
        String QC_NegativeNewsScreening = 'NEGSC_NP';
        String QC_PreviouslyExitedorDeclined    = 'PEODC_NP';
        String QC_SourceofFunds    = 'SOF_NP';
        String QC_LayersofOwnership    = 'LOO_NP';
        String QC_LengthofEstablishment    = 'LOE_NP';
        String QC_BalanceSheet    = 'BS_NP';
        String QC_NatureofBusinessNPAA = 'INDUSTRY_NP';
        String QC_PEPAssociate    = 'PEP_NP';
        String QC_PoliticallyExposedCompany    = 'PEC_NP';
        String QC_Organisationtype    = 'ENTITY_NP';
        String QC_Product    = 'PRODUCT_NP'; 
        String QC_FacetofaceContact = 'FACETOFACE_NP'; 
        String QC_OrganisationDomicile = 'COI_NP'; 
        String QC_CORforSignif= 'COR_SC_NP'; 
        String QC_CORforUBOs = 'COR_UBO_NP'; 

        List<Risk_Score_Weighting__c> riskWeightingList = new List<Risk_Score_Weighting__c> ();

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_OrganisationDomicile, Question_Answer__c='United Kingdom (GB)', Question_Answer_Weighting__c=COI_NPUK));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_OrganisationDomicile, Question_Answer__c='Afghanistan (AF)', Question_Answer_Weighting__c=COI_NPAF));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_OrganisationDomicile, Question_Answer__c='Albania (AL)', Question_Answer_Weighting__c=COI_NPAL));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_CORforUBOs, Question_Answer__c='United Kingdom', Question_Answer_Weighting__c=COR_UBO_NPUK));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_CORforUBOs, Question_Answer__c='Afghanistan', Question_Answer_Weighting__c=COR_UBO_NPAF));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_CORforUBOs, Question_Answer__c='Aland Islands', Question_Answer_Weighting__c=COR_UBO_NPAL));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_CORforSignif, Question_Answer__c='United Kingdom', Question_Answer_Weighting__c=COR_SC_NPUK));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_CORforSignif, Question_Answer__c='Afghanistan', Question_Answer_Weighting__c=COR_SC_NPAF));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_CORforSignif, Question_Answer__c='Aland Islands', Question_Answer_Weighting__c=COR_SC_NPAL));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_NatureofBusinessNPAA, Question_Answer__c='Club, Association or Community', Question_Answer_Weighting__c=INDUSTRY_NPCL));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_NatureofBusinessNPAA, Question_Answer__c='Charities Registered', Question_Answer_Weighting__c=INDUSTRY_NPCR));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_PoliticallyExposedCompany, Question_Answer__c='No True Match', Question_Answer_Weighting__c=PEC_NPNTM));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_PoliticallyExposedCompany, Question_Answer__c='True PEP or PEC Match Identified on UBO, Controller or Intermediate Layers', Question_Answer_Weighting__c=PEC_NPUBO));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_Organisationtype, Question_Answer__c='Limited Company', Question_Answer_Weighting__c=ENTITY_NPLC));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_Organisationtype, Question_Answer__c='Registered charity', Question_Answer_Weighting__c=ENTITY_NPRC));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_Product, Question_Answer__c='Savings Accounts', Question_Answer_Weighting__c=PRODUCT_NPSA));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_Product, Question_Answer__c='Current Account', Question_Answer_Weighting__c=PRODUCT_NPCA));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_FacetofaceContact, Question_Answer__c='One or more Significant Controller or UBO has been met face-to-face', Question_Answer_Weighting__c=FACETOFACE_NPSCUBO));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_FacetofaceContact, Question_Answer__c='No UBO or Significant Controller met face to face', Question_Answer_Weighting__c=FACETOFACE_NPSC));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_SanctionedIndividualCheck, Question_Answer__c='No true match identified', Question_Answer_Weighting__c=SIC_NPNTMI));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_SanctionedIndividualCheck, Question_Answer__c='True current sanction match identified', Question_Answer_Weighting__c=SIC_NPTCSMI));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_NegativeNewsScreening, Question_Answer__c='No true match identified', Question_Answer_Weighting__c=NEGSC_NPNTMI));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_NegativeNewsScreening, Question_Answer__c='Any Serious Convicted Non-Financial Crime', Question_Answer_Weighting__c=NEGSC_NPASCNFC));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_PreviouslyExitedorDeclined, Question_Answer__c='No true match identified', Question_Answer_Weighting__c=PEODC_NPNTMI));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_PreviouslyExitedorDeclined, Question_Answer__c='True match', Question_Answer_Weighting__c=PEODC_NPTM));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_SourceofFunds, Question_Answer__c='Account funded from a bank account in the UK', Question_Answer_Weighting__c=SOF_NPAF));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_SourceofFunds, Question_Answer__c='TREASURY ONLY – Financial Institution Funding', Question_Answer_Weighting__c=SOF_NPTO));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_LayersofOwnership, Question_Answer__c='1 layer of ownership or less', Question_Answer_Weighting__c=LOO_NP1L));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_LayersofOwnership, Question_Answer__c='2 – 3 layers of ownership', Question_Answer_Weighting__c=LOO_NP2L));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_LengthofEstablishment, Question_Answer__c='Over 3 years', Question_Answer_Weighting__c=LOE_NPO3));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_LengthofEstablishment, Question_Answer__c='Under 3 Years', Question_Answer_Weighting__c=LOE_NPU3));

        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_BalanceSheet, Question_Answer__c='Under £2.5m', Question_Answer_Weighting__c=BS_NPU25));
        riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_BalanceSheet, Question_Answer__c='Over £2.5m', Question_Answer_Weighting__c=BS_NPO25));

        //riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_PEPAssociate, Question_Answer__c='No True Match', Question_Answer_Weighting__c=PEP_NPNTM));
        //riskWeightingList.add(new Risk_Score_Weighting__c(Type__c = 'Non Personal',Question_Code__c=QC_PEPAssociate, Question_Answer__c='True PEP or PEC Match Identified on UBO, Controller or Intermediate Layers', Question_Answer_Weighting__c=PEP_NPUBO));

        insert riskWeightingList;

        List<RiskScoreCustomerType__c> customerTypeList = new List<RiskScoreCustomerType__c>();
        customerTypeList.add(new RiskScoreCustomerType__c(Name='Personal1', Customer_Category__c='Personal',Customer_Type__c='Individuals'));
        customerTypeList.add(new RiskScoreCustomerType__c(Name='Personal2', Customer_Category__c='Personal',Customer_Type__c='VIPs'));
        customerTypeList.add(new RiskScoreCustomerType__c(Name='Corporate1', Customer_Category__c='Corporate',Customer_Type__c='Limited Company'));
        customerTypeList.add(new RiskScoreCustomerType__c(Name='Corporate2', Customer_Category__c='Corporate',Customer_Type__c='Trust'));
        insert customerTypeList;
    }
}