@isTest
public class BAA_SelfCert_Controller_LightningTest {

    @testSetup
    public static void dataSetup(){
         NPAA_TestSetupData.dataSetup();
       		CAA_Picklist__c pick = new CAA_Picklist__c(name = 'test', value__c = 'test', text__c='test', Field__c = 'COUNTYOFBIRTH');
        insert pick;
        
         

String RecTypeId= [select Id from RecordType where developername='ProspectCustomer'].Id;
Account Accnt = new Account( RecordTypeID=RecTypeId, Salutation='Mr',FirstName='Test FName', LastName='Test LName',  
                            PersonMailingStreet='test@yahoo.com', PersonMailingPostalCode='12345',  
                            PersonMailingCity='SFO', PersonEmail='test@yahoo.com', PersonHomePhone='1234567',
                            PersonMobilePhone='12345678' );
insert Accnt;
	}
    
    @istest
    public static void testSelfCertPage(){
       
        EventLog__c event = [Select Id,Opportunity__c,Opportunity__r.accountid from EventLog__c Limit 1];
         
         
        recordType rec = [select id from recordtype where developername='Controlling_Person' LIMIT 1];
        Account accr = new Account();
        accr.id = event.Opportunity__r.accountid;
        accr.recordtypeid = rec.id;
         accr.US_Person_Check__c ='Yes';
        accr.US_Do_you_have_a_TIN__c ='No';
        accr.US_Tin_Reason_Code__c = 'Reason B - The Account holder is otherwise unable to obtain a TIN or equivalent number';
        update accr;
        Account acc2 = [SELECT id from Account where recordtype.developername = 'ProspectCustomer' LIMIT 1];
        Applicant__c apps = new Applicant__c(Opportunity__c =event.Opportunity__c, Prospect_Customer__c=acc2.id );
        insert apps;
    		Controlling_Person__c per = new Controlling_Person__c(Opportunity__c = event.Opportunity__c,Prospect_Customer__c = accr.id);
   		 insert per;
        
         Account acc = [Select Id,Name,Organisation_Domicile__c,TradingAddressStreet__c,TradingAddressCity__c,
                       TradingAddressCountry__c,TradingPostCode__c,CorrespondenceAddressStreet__c,CorrespondenceAddressCity__c,
                       CorrespondenceAddressCountry__c,CorrespondenceAddressPostCode__c,Country_Code__c,US_Person_Check__c,
                       TIN_1_Check__c,TIN_1__c,TIN_1_reason_B_explanation__c,TIN_1_reason_code__c,TIN1_Country_Tax_Residence__c,
                       TIN_2_Check__c,TIN_2__c,TIN_2_reason_B_explanation__c,TIN_2_reason_code__c,TIN2_Country_Tax_Residence__c,
                       TIN_3_Check__c,TIN_3__c,TIN_3_reason_B_explanation__c,TIN_3_reason_code__c,TIN3_Country_Tax_Residence__c,
                       TIN_4_Check__c,TIN_4__c,TIN_4_reason_B_explanation__c,TIN_4_reason_code__c,TIN4_Country_Tax_Residence__c,
                       TIN_5_Check__c,TIN_5__c,TIN_5_reason_B_explanation__c,TIN_5_reason_code__c,TIN5_Country_Tax_Residence__c,   
            			US_Tin__c,US_TIN_Reason_B_explanation__c,US_Tin_Reason_Code__c,US_Do_you_have_a_TIN__c,Non_UK_Tax__c,
                       Entity_Type__c,
                       Financial_Institution_Type__c,Investment_Entity_Type__c,GIIN_For_FATCA__c,Non_Financial_Entity_Type__c,
                       Non_Investment_Entity_Type__c,Passive_Status__c,Active_Statuses__c,Self_Cert_Acknowledged__c,
                       Self_Cert_Capacity__c,Regularly_Traded_Corporation__c,Established_Securities_Market__c,
                       ActiveNFEType__c from Account where id =: accr.id LIMIT 1];
        BAA_Data.BAAApplicant app = new  BAA_Data.BAAApplicant();
        app.assign(acc);
       Test.startTest();
        NPAABaseEventController.Wrapper wrap = BAA_SelfCert_Controller_Lightning.getWrapper(event.id,event.Opportunity__c);
        BAA_SelfCert_Controller_Lightning.getBAA_SelfCert_Controller_Lightning(event.Opportunity__c);
        BAA_SelfCert_Controller_Lightning.Save(event.id,app);
        BAA_SelfCert_Controller_Lightning.Complete(wrap);
        BAA_Data.BAAApplicantData appdata = BAA_SelfCert_Controller_Lightning.GetApplicant(event.id);
        List<BAA_Data.BAAApplicant> appdatas = BAA_SelfCert_Controller_Lightning.GetApplicants(event.id);
        List<BAA_Data.BAAApplicant> controlper = BAA_SelfCert_Controller_Lightning.GetControllingPersons(event.id);
        BAA_SelfCert_Controller_Lightning.CombinedSave(event.id, app, controlper,appdatas);
        BAA_SelfCert_Controller_Lightning.SaveControllingPersons(event.id,controlper);
        BAA_SelfCert_Controller_Lightning.SaveNonAppControllingPersons(event.id,controlper);
        
       Opportunity op = BAA_SelfCert_Controller_Lightning.Opp;
        Test.stopTest();
    }
    
}