@isTest
public class CaseInformationClassTest {
    
	static testMethod void AccountSetrvicesRecordTypeTest() 
	{
		
		Case testcase = new Case();
        testcase.Subject='Testing';
        testCase.Description='Testing';
		insert testcase;
        
        system.debug(testcase);
		
		PageReference pageRef = Page.Close_Case;
        
		Test.StartTest(); 
        Test.setCurrentPage(pageRef);
		ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(testcase);
		ApexPages.currentPage().getParameters().put('id',testcase.id);
			CaseInformationClass  obj = new CaseInformationClass(sc);
			id currentRecordId = obj.currentRecordId;
        	String closeCaseFieldSet = obj.closeCaseFieldSet;
        Test.stopTest();
    }
    static testMethod void ITRequestRecordTypeTest(){
        Case testCase = new Case();
        testCase.Subject='Testing2';
        testCase.Description='Testting2';
        testCase.RecordTypeId='012D0000000QWmDIAW';
        testcase.Explain11__c='Test';
        insert testcase;
        
        system.debug(testcase);
		
		PageReference pageRef = Page.Close_Case;
        
		Test.StartTest(); 
        Test.setCurrentPage(pageRef);
		ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(testcase);
		ApexPages.currentPage().getParameters().put('id',testcase.id);
			CaseInformationClass  obj = new CaseInformationClass(sc);
			id currentRecordId = obj.currentRecordId;
        	String closeCaseFieldSet = obj.closeCaseFieldSet;
        Test.stopTest();
        
    }
			
}