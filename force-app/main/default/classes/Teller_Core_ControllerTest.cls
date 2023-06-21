@isTest
public class Teller_Core_ControllerTest {
    
    @testSetup
    public static void testDataSetup(){
        List<Teller_Settings__c> settings = new List<Teller_Settings__c>();
        Teller_Settings__c activityAuditExistsCheckSetting = new Teller_Settings__c();
        activityAuditExistsCheckSetting.Name = 'ActivityAuditExistsCheck';
        activityAuditExistsCheckSetting.Value__c = 'true';
        settings.add(activityAuditExistsCheckSetting);
        
        Teller_Settings__c activityAuditTimeFrameSecSetting = new Teller_Settings__c();
        activityAuditTimeFrameSecSetting.Name = 'ActivityAuditTimeFrameSec';
        activityAuditTimeFrameSecSetting.Value__c = '60';
        settings.add(activityAuditTimeFrameSecSetting);
        
        insert(settings);
        
        Branch__c testBranch = new Branch__c();
        testBranch.Name = 'Test Branch';
        testBranch.Branch_Number__c = '1111';
        testBranch.Branch_Mnemonic__c = 'U123';
        testBranch.Branch_Location__c = 'Birmingham';
        insert(testBranch);
        
        Teller_Depository__c testTellerDepository = new Teller_Depository__c();        
        testTellerDepository.Branch__c = testBranch.Id;
        testTellerDepository.Currency__c = 'GBP';
        testTellerDepository.Status__c = 'Closed';
        testTellerDepository.Storage_Type__c = 'Till';
        insert(testTellerDepository);
        
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.EBS_ID__c = 'ebsId';
        acc.BillingCity = 'abc';
        acc.BillingStreet= 'xyz';
        acc.BillingPostalCode = '5000001';
        acc.Date_of_Birth__c = date.today();
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name = 'Prospect/Customer' LIMIT 1];
        acc.RecordTypeId=rt.Id;
        
        insert acc;
        Teller_Function_Root__c tfr=new Teller_Function_Root__c();
        tfr.Name='tftest';
        insert tfr;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User us = new User(Alias = 'standt', Email='standarduser@testorgARB.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgARB.com');
        insert us;
        
        User me = new User();
        me.id = UserInfo.getUserId();
        me.Teller_Branch_Number__c = '1111';
        me.ManagerId = us.id;
        update me;
        
        User u = [select Id, Name, UserRole.Id, UserRole.Name from User where Id=:UserInfo.getUserId()];
        Teller_Role__c tell = new Teller_Role__c(Name=u.UserRole.Name,User_Role__c=u.UserRole.Id);
        insert tell;
        Teller_Function__c tf = new Teller_Function__c(Name='customers',Teller_Function_Root__C=tfr.Id);
        insert tf;
        Teller_Function__c tf1 = new Teller_Function__c(Name='Account Settings',Teller_Function_Root__C=tfr.Id);
        insert tf1;
        Teller_Function__c tf2 = new Teller_Function__c(Name='Teller Activities',Teller_Function_Root__C=tfr.Id);
        insert tf2;
        
        
        Teller_Access__c ta = new Teller_Access__c();
        ta.Name='tatest';
        ta.Teller_Function__c=tf.Id;
        ta.Teller_Role__c=tell.Id;
        insert ta;
        Teller_Access__c ta1 = new Teller_Access__c(Name='tatest1',Teller_Function__c=tf1.Id,Teller_Role__c=tell.Id);
        insert ta1;
        Teller_Access__c ta2 = new Teller_Access__c(Name='tatest2',Teller_Function__c=tf2.Id,Teller_Role__c=tell.Id);
        insert ta2;
        recordType business = [select id from recordType where developername='Business_account'];
        
        
        Debug__c log = new Debug__c();
        Web_Integration_Log__c wlog = new Web_Integration_Log__c();
        wlog.request_output__c = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><OperationResponse xmlns="http://IBB.SalesForce.OCA.Additional"><AdditionalInformationResponse><MessageType>EBSAdditionalInfoUpdate</MessageType><MessageID>a0oL00000009A7nIAE</MessageID><Status>S</Status><ErrorMessage /><WarningMessage /></AdditionalInformationResponse></OperationResponse></soap:Body></soap:Envelope>';
        wlog.Request_Action__c = 'EBSAdditionalInfoUpdate';
        
        
        Opportunity opp = new Opportunity();
        opp.name = 'unit test';
        opp.StageName = 'closed/won';
        opp.CloseDate = date.today();
        
        
        insert opp;
        log.Opportunity__c = opp.id;
        insert log;
        
        wlog.OpportunityId__c = opp.id;
        insert wlog;
        XML_Message__c sData = new XML_Message__c();
        sData.Active__c = true;
        sData.Buffered__c = false;
        sData.Element_Name__c = 'OpenCustomerAccount';
        sData.Name='MaintainCustomerDetails';
        sData.Service_Name_Element__c= 'SalesForceOpenCustomerAccountBatch';
        
        sData.Type__c='Request';
        
        insert sData;
        
        
    }
    
    @isTest
    public static void testTellerCore(){
        Web_Integration_Log__c wlog=[select id from Web_Integration_Log__c Limit 1];
        Account acc=[select id,Phone, Home_Telephone_No__c, PersonMobilePhone, PersonEmail, Contact_s_telephone_number__c, Business_email_address__c,recordtypeId from Account Limit 1];
        String accountId;
        test.starttest();
        Teller_AccountFunctions.TellerInfo tInfo =  Teller_Core_Controller.GetTellerInfo();
        Teller_AccountFunctions.MenuItems tmenuItems = Teller_Core_Controller.GetPermittedMenuItems();
        
        String weblogId =  Teller_Core_Controller.CreateWebLog( accountId);
        String logId = Teller_Core_Controller.CreateWebLog(acc.Id, false);
        Teller_FindCustomer_Controller.CustomerData  tfcus = Teller_Core_Controller.FindCustomer('test');
        Teller_Mandates_Controller.MandateSignatories tman = Teller_Core_Controller.LoadSignatories('1234');
        Teller_CustomerDetailsController.CustomerDetails tcus = Teller_Core_Controller.GetCustomerDetails(acc.id);
        List<Teller_CustomerDetailsController.Alert> talert = Teller_Core_Controller.GetCustomerAlerts(acc.id) ; 
        
        Teller_Data.GenericResponse tgen = Teller_Core_Controller.UpdateCustomerDetails(acc);
        Teller_Data.GenericResponse tres= Teller_Core_Controller.UpdateCustomerDetailsInEBS(acc,wlog.Id);
        Teller_Core_Controller.SubmitViewingReason(acc.Id,'test','test');
        Teller_Core_Controller.ShowPromptForReason(acc.Id);
        Teller_Core_Controller.SaveCustomerImages('ebsId', 'Photo', 'imgBase64Binary');
        ComponentData cd=Teller_Core_Controller.DenominationsChange(new Teller_Denominations(),new Teller_Denominations());
        
        test.stoptest();
    }
    
    
    @isTest
    public static void TellerCore(){
        Test.startTest();
        Teller_Depository__c td = Teller_Core_Controller.GetTellerTillDetails();
        Teller_Depository__c tdepo = [select id from Teller_Depository__c Limit 1];
        Account acc=[select id,Phone, Home_Telephone_No__c, PersonMobilePhone, PersonEmail, Contact_s_telephone_number__c, Business_email_address__c,recordtypeId from Account Limit 1];
        Teller_Data.GenericResponse dgen= Teller_Core_Controller.UpdateMarketingPreferences(acc.id,false,false,false,false,false,false,false);
        Teller_AccountFunctions.AccountDetails tacc=Teller_Core_Controller.GetAccountDetailsWithReasonCheck(acc.id,'ebsId');
        Teller_Core_Controller.GetMiniStatementPrintTemplate();
        Teller_Function_Overrides.ApprovalDisplayFlags tflag= Teller_Core_Controller.ApproveTransaction('123','test','test');
        Teller_Function_Overrides.ApprovalDisplayFlags tapp= Teller_Core_Controller.DeclineTransaction('234','test','test');
        Teller_Function_Overrides.ApprovalDisplayFlags tdis = Teller_Core_Controller.SendTransactionToHost('456');
        Teller_Denominations tdem=Teller_Core_Controller.TillManagement_LoadDenominations();
        Teller_Denominations tdeno=Teller_Core_Controller.TillManagement_LoadDenominationsForCurrency('test');
        Teller_Denominations tden= Teller_Core_Controller.TillManagement_LoadDenominationsForTill(null);
        
        List<Teller_TillController.Till> lstill=Teller_Core_Controller.GetOpenBranchTills(false,false);
        List<Teller_TillController.Till> lst=Teller_Core_Controller.GetClosedBranchTills();
        try{
            Teller_TillController.BranchCurrencies tbranch= Teller_Core_Controller.ReconcileBranch();
        }catch(Exception e){
            
        }
        try{
            Teller_Denominations tds=Teller_Core_Controller.TillManagement_LoadCurrencyDenominationsForVault('test');
        }catch(Exception e){
            
        }
        try{
            Teller_Denominations tdenom =Teller_Core_Controller.TillManagement_LoadDenominationsForVault();
        }catch(Exception e){
            
        }
        try{
            Teller_AccountFunctions.AccountTransactionHistory tacct= Teller_Core_Controller.GetTransactionHistory(acc.id,'23-07-2021','22-06-2022');
        }catch(Exception e){
            
        }
        try{
            Teller_Mandates_Controller.DeleteMandateResponse tdel =Teller_Core_Controller.DeleteMandate('test');
        }catch(Exception e){
            
        }
        try{
            Teller_Mandates_Controller.MandateSignatories tman=Teller_Core_Controller.LoadMandatesAndSignatories('test');
        }catch(Exception e){
            
        }
        
        Test.stopTest();
    }
    @isTest
    public static void Tellerthirdsegment(){
        test.startTest();
        try{
            Account acc=[select id,Phone, Home_Telephone_No__c, PersonMobilePhone, PersonEmail, Contact_s_telephone_number__c, Business_email_address__c,recordtypeId from Account Limit 1];
            Teller_AccountFunctions.AccountCurrencies taccount= Teller_Core_Controller.GetAccountCurrencies(new List<String>{acc.id});
        }catch(Exception e){
            
        }
        
        try{ComponentData  var1=Teller_Core_Controller.AcceptVaultTransfer(new Teller_TillController.Transfers());}catch(Exception e){}
        try{Teller_Function_Controller.FunctionPageDefinitionData  var2=Teller_Core_Controller.LoadFunctionPageDefinitionData( 'TellerFunctionId',  'accountNo', new Teller_AccountFunctions.AccountDetailItem());}catch(Exception e){} 
        try{Teller_Function_Controller.FunctionPageData  var3=Teller_Core_Controller.LoadFunctionPageData( 'TellerFunctionId',  'accountNo', new Teller_AccountFunctions.AccountDetailItem());}catch(Exception e){}
        try{Teller_Function_Controller.FunctionPageData  var4=Teller_Core_Controller.LoadFunctionPageDataByTransactionId( 'TransactionId');}catch(Exception e){}
        try{Teller_Denominations  var5=Teller_Core_Controller.LoadDenominations( 'depositoryId',  'ccyOfTransaction');}catch(Exception e){}
        try{Teller_Function_Controller.FunctionPageData  var6=Teller_Core_Controller.ProcessStage(new Teller_Function_Controller.FunctionPageData(),  'stageId');}catch(Exception e){}
        try{Teller_Function_Controller.FunctionPageData  var7=Teller_Core_Controller.CreateTransactionRecord(new Teller_Function_Controller.FunctionPageData());}catch(Exception e){}
        try{ComponentData  var8=Teller_Core_Controller.CheckDenominations(new Teller_Function_Controller.FunctionPageData());}catch(Exception e){}
        try{ComponentData  var9=Teller_Core_Controller.CheckFXDenominations(new Teller_Function_Controller.FunctionPageData() );}catch(Exception e){}
        try{ComponentData  var10=Teller_Core_Controller.CancelTellerTransaction( 'TransactionId');}catch(Exception e){}
        try{Teller_Core_Controller.UpdateTellerTransactionPrintedReciept( 'TransactionId',  'PrintedReciept');}catch(Exception e){}
        try{string  var11=Teller_Core_Controller.GetFunctionPrintTemplate( 'FunctionId',  'PrintTemplateType');}catch(Exception e){}
        try{Teller_Function_Controller.FunctionPageData  var12=Teller_Core_Controller.CalculateFXAmounts( 1.1,  'depositCCY',  0.2,  'withdrawalCCY',  'branchNo');}catch(Exception e){}
        try{Teller_Reporting.SearchCriteria  var13=Teller_Core_Controller.InitialiseSearchCriteria(1 , 1 );}catch(Exception e){}
        try{Teller_Reporting.TellerActivtyFilterLists  var14=Teller_Core_Controller.InitialiseFilterLists();}catch(Exception e){}
        try{List<Teller_Activity_Audit__c>  var15=Teller_Core_Controller.GetTellerActivityAudit(new Teller_Reporting.SearchCriteria());}catch(Exception e){}
        try{List<Teller_Activity_Audit__c>  var16=Teller_Core_Controller.GetCurrentTellerActivityForToday();}catch(Exception e){}
        try{Teller_Reporting.ActivityDetails  var17=Teller_Core_Controller.GetActivityItem( 'activityType',  'referenceId');}catch(Exception e){}
        try{String var18 = Teller_Core_Controller.GetActivityAuditPrintTemplate();}catch(Exception e){}
        try{List<Teller_Activity_Audit__c>  var19=Teller_Core_Controller.GetSubmittedForAuthorisationForAccount( 'debitAccount');}catch(Exception e){}
        try{Teller_Integration_Data.DealDepositInfo  var20=Teller_Core_Controller.GetDealDepositInfo( 'DealAccount');}catch(Exception e){}
        try{Teller_Integration_Data.DealFinanceInfoAccount  var21=Teller_Core_Controller.GetDealFinanceInfo( 'DealAccount');}catch(Exception e){}
        try{DigitalBanking.CustomerUserInfoResponse  var22=Teller_Core_Controller.GetUserInfo( 'accountNo');}catch(Exception e){}
        try{DigitalBanking.IFMPaymentResponse  var23=Teller_Core_Controller.GetIFMTransactions( 'accountNo',  'fromDate',  'toDate');}catch(Exception e){}
        test.stopTest();
    }
    @isTest
    public static void tellerFourthSeg()
    {
        Test.startTest();
        Teller_Core_Controller cor = new Teller_Core_Controller();
        cor.getUserThumbPhoto();
        
        
        
        try{Teller_Function_Controller.FunctionPageData var1=Teller_Core_Controller.CheckMandates(new Teller_Function_Controller.FunctionPageData());}catch(Exception e){}
        try{Teller_Mandate_Controller.Mandate var2=Teller_Core_Controller.LoadMandateItems(new Teller_Mandate_Controller.LoadMandateItemsRequest());}catch(Exception e){}
        try{Teller_Mandate_Controller.SaveMandateItemsResponse var3 =Teller_Core_Controller.SaveMandateItems(new Teller_Mandate_Controller.SaveMandateItemsRequest());}catch(Exception e){}
        try{Teller_Signatory_Controller.SignatoryGroups var4=Teller_Core_Controller.LoadSignatoriesAndGroups( 'accountNo');}catch(Exception e){}
        try{Teller_Signatory_Controller.SaveSignatoriesResponse var5=Teller_Core_Controller.SaveSignatories(new List<Teller_Mandates_Controller.Signatory> ());}catch(Exception e){}
        try{Teller_Function_Overrides.Limits var6=Teller_Core_Controller.LoadLimits(new Teller_Function_Controller.FunctionPageData());}catch(Exception e){}
        try{Teller_Data.GenericResponse var7=Teller_Core_Controller.PasswordVerification( 'userName',  'password');}catch(Exception e){}
        try{ComponentData var11=Teller_Core_Controller.BalanceTill(new Teller_Denominations());}catch(Exception e){}
        try{ComponentData var11=Teller_Core_Controller.BalanceVault(new Teller_Denominations(), new Teller_Function_Overrides.VaultAuthorisors());}catch(Exception e){}
        try{ComponentData var11=Teller_Core_Controller.TillTransferOut( 'transferToTillId', new Teller_Denominations() );}catch(Exception e){}
        try{ComponentData var11=Teller_Core_Controller.VaultTransferOut( 'transferToTillId',  'userPassword', new Teller_Denominations() );}catch(Exception e){}
        try{Teller_TillController.Transfers var12=Teller_Core_Controller.GetTillTransfers();}catch(Exception e){}
        try{ComponentData var11=Teller_Core_Controller.AcceptTillTransfer(new Teller_TillController.Transfers());}catch(Exception e){}
        try{Teller_Function_Overrides.TillAuthorisors var13=Teller_Core_Controller.GetManagerAuthorisors();}catch(Exception e){}
        try{string var14=Teller_Core_Controller.GetFunctionPrintTemplate( 'FunctionId',  'PrintTemplateType');}catch(Exception e){}
        Test.stopTest();
    }    
    @isTest
    public static void testFXRates(){
        
        test.startTest();
        
        try{
            Teller_Function_Controller.FXRates tfrates=Teller_Core_Controller.GetFXRates(); 
        }  catch(exception e){
            
        }                     
        
        
        test.stoptest();
    }
    @isTest
    public static void testTransfer(){
        test.startTest();
        try{
            Teller_TillController.Transfers tt=Teller_Core_Controller.GetVaultTransfers();
        }
        catch(exception e){
            
        }
        test.stopTest();
    }
    @isTest
    public static void testVaultAuthorisors(){
        test.startTest();
        try{
            Teller_Function_Overrides.VaultAuthorisors tva=Teller_Core_Controller.GetVaultBalanceAuthorisors();
        }
        catch(exception e){
            
        }
        test.stopTest();
    }
    @istest
    public static void testDealFinanceInfo(){
        test.startTest();
        try{
            Teller_Integration_Data.DealFinanceInfoAccount tdeal= Teller_Core_Controller.GetDealFinanceInfo('test');
        }
        catch(exception e){
            
        }
        test.stopTest();
    }
    @istest
    public static void testCustomerUserInfo(){
        Account acc=[select id,Phone, Home_Telephone_No__c, PersonMobilePhone, PersonEmail, Contact_s_telephone_number__c, Business_email_address__c,recordtypeId from Account Limit 1];
        test.startTest();
        try{
            DigitalBanking.CustomerUserInfoResponse dbinfo = Teller_Core_Controller.OnlineBankingFunction(acc.id,'test');
        }
        catch(exception e){
            
        }
        test.stopTest();
    }
    @istest
    public static void testOpenTill(){
        test.startTest();
        try{
            ComponentData comp=Teller_Core_Controller.OpenTill('test');
        }
        catch(exception e){
            
        }
        test.stopTest();
    } 
    @istest
    public static void testFXCurrency(){
        test.startTest();
        try{
            List<Teller_Function_Controller.FXCurrency> fun=Teller_Core_Controller.GetCurrencies();
        }
        catch(exception e){
            
        }
        test.stopTest();
    }
}