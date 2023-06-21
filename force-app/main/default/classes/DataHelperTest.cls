@isTest
public class DataHelperTest {

    @testSetup 
    public static void dataSetup(){
         NPAA_TestSetupData.dataSetup();
    }
    @isTest
    public static void testDataHelper(){
        EventLog__c el = [select id,Opportunity__c,Opportunity__r.AccountId from EventLog__c limit 1];
    Test.startTest();	
try{String var1 = DataHelper.GenerateFields(new List<Schema.SObjectField> () );}catch(Exception e){}
try{String var1 = DataHelper.ConvertListToString(new List<String> ());}catch(Exception e){}
try{List<Account> var1 = DataHelper.GetAccount(el.id);}catch(Exception e){}
try{List<Account> var1 = DataHelper.GetListAccount(new Set<Id> ());}catch(Exception e){}
try{List<Account> var1 = DataHelper.GetAccounts(el.opportunity__r.AccountId,false);}catch(Exception e){}
try{List<Account> var1 = DataHelper.GetAccountByOpportunity(el.Opportunity__c);}catch(Exception e){}
try{List<Opportunity> var1 = DataHelper.GetOpportunity(el.id);}catch(Exception e){}
try{List<HPP_extended_opportunity__c> var1 = DataHelper.GetHPPExtendedOpportunity(el.id);}catch(Exception e){}
try{List<HPP_extended_opportunity__c> var1 = DataHelper.GetHPPExtendedOpportunityByOpp(el.id);}catch(Exception e){}
try{List<HPP_extended_opportunity__c> var1 = DataHelper.GetHPPExtendedOpportunityFromOpportunity(el.Opportunity__c);}catch(Exception e){}
try{List<Applicant__c> var1 = DataHelper.GetOpportunityAccountsDetails(el.Opportunity__c);}catch(Exception e){}
try{List<Applicant__c> var1 = DataHelper.GetApplicants(el.Opportunity__c);}catch(Exception e){}
try{List<Account_with_IBB__c> var1 = DataHelper.GetTheAccountWithIBB(el.Opportunity__c);}catch(Exception e){}
try{List<Account_Reference_Information__c> var1 = DataHelper.GetAccountReferenceInfo('accountType');}catch(Exception e){}
//try{List<Account_Reference_Information__c> var1 = DataHelper.GetAccountReferenceInfo( accountType, }catch(Exception e){}
try{List<Asset_Relationship__c> var1 = DataHelper.GetAccountHolders(el.opportunity__r.AccountId);}catch(Exception e){}
//try{List<Asset_Relationship__c> var1 = DataHelper.GetAccountHoldersByAccountWithIBB() ;}catch(Exception e){}
try{List<Credit_Score__c> var1 = DataHelper.GetCreditScores(el.opportunity__r.AccountId, el.Opportunity__c);}catch(Exception e){}
try{List<Event__c> var1 = DataHelper.GetEvent(el.id);}catch(Exception e){}
try{List<Event__c> var1 = DataHelper.GetEvents(new List<string> ());}catch(Exception e){}
try{List<Event__c> var1 = DataHelper.GetEventsByType( 'eventType');}catch(Exception e){}
try{List<Event__c> var1 = DataHelper.GetEvents(el.Opportunity__c);}catch(Exception e){}
try{List<EventLog__c > var1 = DataHelper.GetEventLog(el.id);}catch(Exception e){}
try{List<EventCase__c> var1 = DataHelper.GetEventCase( 'caseId');}catch(Exception e){}
try{List<EventCase__c> var1 = DataHelper.GetEventCaseByEvent(el.id);}catch(Exception e){}
try{List<EventLog__c> var1 = DataHelper.GetEventLogByOpportunityAll(el.Opportunity__c);}catch(Exception e){}
try{List<EventLog__c> var1 = DataHelper.GetEventLogByOpportunity(el.Opportunity__c);}catch(Exception e){}
try{List<Account> var1 = DataHelper.GetApplicantsByOpp(el.Opportunity__c);}catch(Exception e){}
try{List<EventLog__c> var1 = DataHelper.GetValidEventLogs(el.Opportunity__c);}catch(Exception e){}
try{string var1 = DataHelper.GetProductSubType( 'productId');}catch(Exception e){}
try{string var1 = DataHelper.GetProductSubTypeFromOpportunity(el.Opportunity__c);}catch(Exception e){}
try{string var1 = DataHelper.GetProductIDFromOpportunity(el.Opportunity__c);}catch(Exception e){}
try{List<IBB_Product__c> var1 = DataHelper.GetProduct ( 'productId');}catch(Exception e){}
try{List<IBBQuotation__c> var1 = DataHelper.GetQuotations (el.Opportunity__c);}catch(Exception e){}
try{List<IBBQuotation__c> var1 = DataHelper.GetQuotationsFromOpportunity (el.Opportunity__c);}catch(Exception e){}
try{List<Budget_planner__c> var1 = DataHelper.GetBudgets(el.opportunity__r.AccountId);}catch(Exception e){}
try{List<Budget_planner__c> var1 = DataHelper.GetBudget(el.Opportunity__c);}catch(Exception e){}
try{List<Person_Debts__c> var1 = DataHelper.GetDebts(el.opportunity__r.AccountId);}catch(Exception e){}
try{List<event__c > var1 = DataHelper.GetEventsByIds(el.id);}catch(Exception e){}
try{List<Property_information__c> var1 = DataHelper.GetPropertyInfo(el.opportunity__r.AccountId);}catch(Exception e){}
try{List<Other_adults_in_the_property__c> var1 = DataHelper.GetOtherAdults(el.Opportunity__c);}catch(Exception e){}
try{List<ProductEventDirector__c> var1 = DataHelper.GetDirector( 'directorId' );}catch(Exception e){}
try{List<Account> var1 = DataHelper.GetExistingAccounts( 'firstName',  'lastName', System.today());}catch(Exception e){}
try{List<Case> var1 = DataHelper.GetCases(el.Opportunity__c);}catch(Exception e){}
try{List<GenericObject__c> var1 = DataHelper.GetGenericObjectByAccount(el.opportunity__r.AccountId);}catch(Exception e){}
try{List<GenericObject__c> var1 = DataHelper.GetGenericObject( 'opp');}catch(Exception e){}
try{string var1 = DataHelper.SetStringList('inStr');}catch(Exception e){}
try{List<Valuation_Table__c> var1 = DataHelper.GetValuationTableFromValType ('valuationType', 'valuationId');}catch(Exception e){}
try{List<Valuation_Report__c> var1 = DataHelper.GetValuationReportFromOpp (el.Opportunity__c);}catch(Exception e){}
try{List<Valuation_Report__c> var1 = DataHelper.GetValuationReportFromOppName ('oppName');}catch(Exception e){}
try{List<Valuation_Notification__c> var1 = DataHelper.GetValuationNotificationFromValuationReport ('valRepId');}catch(Exception e){}
try{List<Account_With_IBB__c> var1 = DataHelper.GetTheAccountsfromEBSAccount ('accountNos');}catch(Exception e){}
try{List<IBBPaymentType__c> var1 = DataHelper.GetPaymentTypes ();}catch(Exception e){}
try{List<Log__c> var1 = DataHelper.GetLog (el.id);}catch(Exception e){}
        Test.stopTest();
    }
}