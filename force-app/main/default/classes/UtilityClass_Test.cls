/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 
 2012-01-25 jba/dm - create
 */
@isTest
private class UtilityClass_Test
{    
    public class MyException extends Exception {}
    
    private void Tests1(UtilityClass ut)
    {   
         Web_Integration_Log__c wil;    
         UtilityClass.webLogsToUpsert = new List<Web_Integration_Log__c>();
         wil = new Web_Integration_Log__c();
         UtilityClass.webLogsToUpsert.add(wil);
         UtilityClass.upsertWebLogs();
         
         wil = UtilityClass.createIntegrationLog('inType', 'inAction');
         wil = UtilityClass.createIntegrationLog('Request', 'Request');
         wil = UtilityClass.createIntegrationLog('Response', 'Response');
         
         wil = UtilityClass.getIntegrationLog( (String)wil.Id );
         
         Exception e = new MyException();
         wil = UtilityClass.logSystemError('Account', e, 'extraInfo');
        
        String inXml = '<SalesForceAddNewCustomerBatch><BatchMessageID>aa6a17fd-0ae7-44a3-9a23-b5b5080171fc</BatchMessageID><AddNewCustomerAllInformation><MessageID>iUID-2012-01-12-11.54.20.762-054578</MessageID><MessageType>CustomerDetails</MessageType><CustomerType>Individuals</CustomerType><CustNo>400010</CustNo><SFDCID /><ReplicationType>*UPDATE</ReplicationType><CustomerStatus>Normal</CustomerStatus><CustomerDefaultBranch>Edgware Road - London</CustomerDefaultBranch><CustName>MR Omar A Fadlalla</CustName><CustomerSurName>Fadlalla</CustomerSurName><CustDateOfBirth>1968-11-10</CustDateOfBirth><CustomerGender>Male</CustomerGender><CustomerMotherFamilyName>ALJACK</CustomerMotherFamilyName><CustomerSchoolName>ALGADEEMA</CustomerSchoolName><MaritalStatus>Married</MaritalStatus><CustomerDefaultShortName>FADLALLA OA</CustomerDefaultShortName><DefaultTaxRef /><AccountOfficer>None</AccountOfficer><CountryOfResidence>United Kingdom</CountryOfResidence><ParentCountry>Sudan</ParentCountry><CustomerIDEvidence>Current signed passport</CustomerIDEvidence><EvidenceOfAddress>Bank Statement LT 3 Months</EvidenceOfAddress><CustomerDocSerialNo>094325836</CustomerDocSerialNo><DocumentIssueDate>2004-01-21</DocumentIssueDate><NetMonthlyIncome>00002000</NetMonthlyIncome><TotalIncomeBeforeTax>00024000</TotalIncomeBeforeTax><R105Received /><R85Received /><PreferredContactMethod /><DateMovedToCurrentAddress>2005-10-01</DateMovedToCurrentAddress><MarketingConsent /><DateMovedToPrevAddress>2000-02-01</DateMovedToPrevAddress><DateEmploymentCommenced>2009-04-23</DateEmploymentCommenced><CurrentBankDateAcctOpened>2004-03-01</CurrentBankDateAcctOpened><CustomerFirstName>Omar</CustomerFirstName><CustomerMiddleName>Alsayeid</CustomerMiddleName><CustomerPreviousName /><CountryOfBirth>SUDAN</CountryOfBirth><TownOfBirth>ALHASAHISA</TownOfBirth>   <PrevAddrHouseNo>48</PrevAddrHouseNo><PrevStreet>48, The Beckers</PrevStreet><PrevDistrict>Rectory Road</PrevDistrict><PrevCity>London</PrevCity><PrevCounty /><PrevCountry /><PrevPCode>N167QX</PrevPCode><PreviousResidencyYears /><PreviousResidencyMonths /><PrevPrevAddrHouseNo /><PrevPrevStreet /><PrevPrevDistrict /><PrevPrevCity /><PrevPrevCounty /><PrevPrevCountry /><PrevPrevPCode /><PrevPrevResidencyYears /><PrevPrevResidencyMonths /><EmployerName>Denis Carter</EmployerName><EmployerAddrLine1>Starcliff House</EmployerAddrLine1><EmployerHouseNo /><EmployerStreet>Starcliff Road</EmployerStreet><EmployerDistrict>London</EmployerDistrict><EmployerCity /><EmployerCounty /><EmployerCountry /><EmployerPCode /><EmployerNatureOfBusiness /><MobNo>07908-262781</MobNo><WorkTelNo /><PrivateEmail /><WorkEmail /><HomeDetails>Tenant Unfurnished</HomeDetails><PropertyEstimatedValue>00000000</PropertyEstimatedValue><CurrentMortgageOutstanding>00000000</CurrentMortgageOutstanding><NameOfTheLender /><EmploymentType>Self employed professional</EmploymentType><EmploymentStatus>Not given</EmploymentStatus><PremierStatus>None</PremierStatus><Occupation /><NoOfChildren /><CurrentBankDetailsKeepOpen>Y</CurrentBankDetailsKeepOpen><CurrentBankDateAcctNo>10211123</CurrentBankDateAcctNo><CurrentBankSortCode>160058</CurrentBankSortCode><DebitCard>Y</DebitCard><AmericanExpress /><DinersCard /><MasterCard /><VisaCard /><StoreCard>Y</StoreCard><CurrentBankDetailsName>RBS</CurrentBankDetailsName><CorrespondenceAllAccounts /><IVRNominatedAccountNumber /><IVRNominatedSortCode /><IVRNominatedPaymentRef /><CustSalutation>MR</CustSalutation><HouseNo>MR Omar A Fadlalla</HouseNo><Street>39, Catherine House</Street><District>Whitmore Estate</District><City>London</City><County /><Country /><PostCode>N15PB</PostCode><TelNo>0207-6131158</TelNo><InternetEnabled>Y</InternetEnabled><HaveYouEverBeenBankrupt /><CountryOfPassportIssue /><AnyCCJ /><VisaExpiryDate /><HowDidYouHearAboutIBB>Word of mouth</HowDidYouHearAboutIBB><EBSID>400010</EBSID><DateCustomerAdded /><DateOfLastCustomerTrans /><DateLastMaint /></AddNewCustomerAllInformation></SalesForceAddNewCustomerBatch>';
        XML_Message__c xmlMessage = new XML_Message__c();
        xmlMessage.Name = 'ReplicateNewCustomer';
        xmlMessage.Element_Name__c = 'ReplicateCustomerAccount';
        xmlMessage.Element_Namespace__c = '';
        xmlMessage.Service_Name_Element__c = 'MCD';
        xmlMessage.Service_Namespace__c = 'http://www.islamic-bank.com/MaintainCustomerDetails';
        xmlMessage.Active__c = true;
        xmlMessage.Type__c = 'Inbound';
        insert xmlMessage;
        ARBTestUtils.insertNewTag((String)xmlMessage.Id, 'CustNo', 'EBS ID', 'EBS_ID__c',
                                        1, 'String');
        ARBTestUtils.insertNewTag((String)xmlMessage.Id, 'SFDCID', 'SFDC_ID', 'SFDC_ID__c',
                                      2, 'String');
         
         List<XML_Message__c> curRecordList = [Select Name From XML_Message__c  WHERE Active__c = true];
         system.debug('curRecordList' + curRecordList);
         UtilityClass.cloneXMLMessage( curRecordList[0].Name, 'NEWNAME' );
         
         
         List<XML_Message_Tag__c> tagList = [select Id, Message_Order__c from XML_Message_Tag__c where 
                                            Message_Order__c >= 0
                                            Order By Message_Order__c ASC];
         UtilityClass.insertNewTag((String)xmlMessage.Id, 'inTagName', 'inFieldLabel', 'inAPIName',
                                        0, 'inDataType');
         UtilityClass.insertNewTag((String)xmlMessage.Id, 'inTagName', 'inFieldLabel', 'inAPIName',
                                        1990, 'inDataType');
    }   
    
    private UtilityClass commonstuff()
    { 
        UtilityClass ut = new UtilityClass();
        
        return ut;
    }
    
    static testMethod void testOne()
    {
        UtilityClass_Test testable = new UtilityClass_Test();        
        UtilityClass ut = testable.commonstuff();        
        testable.Tests1(ut);
    }
    static testMethod void testPicklistValues () {
        Account acc = new Account ();
        UtilityClass.getPicklistValues (acc,'Industry');
    }
    static testMethod void testSendEmail () {
        List < String > recipients = new List < String > {'testing@yest.com'};
        UtilityClass.SendEmail(recipients, 'Test EMail', 'emailbody');
    }
    
}