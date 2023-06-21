@isTest
public class OpportunityTriggerAddTest {
	
    
    static testmethod void testOne ()
	{
		
        
        IBB_Product_Set__c prodset = new IBB_Product_Set__c();
		prodset.name = 'foo';
        /////////
        prodset.DSX_Documents_Expected__c='HPP-2 YEARS SA302';
		insert prodset;

		IBB_Product__c prod = new IBB_Product__c ();
		prod.name = 'foo';
		prod.Type_of_Product__c = 'FIXED TERM SAVINGS ACCOUNT';
		prod.IBB_Product_Set__c = prodset.Id;
		insert prod;
		
		Opportunity opp = new Opportunity();
		opp.Name = 'TEST NAME';
        opp.CloseDate = Date.today();
        opp.StageName = 'CLOSED WON';
		opp.IBB_Product__c = prod.Id;
		
		insert opp;
        ///////////
        Map <String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id hppCAARecordId = recordTypes.get('HPP CAA').getRecordTypeId(); //C0728
        //Id liabilitiesRecordId = recordTypes.get('Liabilities Opportunities').getRecordTypeId();
        
        DSX_Document_Link__c dsxDoc = new DSX_Document_Link__c();
        dsxDoc.Document_Name__c='HPP-2 YEARS SA302';
        dsxDoc.Document_Status__c='Received';
        dsxDoc.Opportunity__c= opp.Id;
        insert dsxDoc;
        
        DSX_Document_Link__c dsxDoc2 = new DSX_Document_Link__c();
        dsxDoc2.Document_Name__c='HPP-ACCOUNTANTS LETTER';
        dsxDoc2.Document_Status__c='Received';
        dsxDoc2.Opportunity__c= opp.Id;
        insert dsxDoc2;
       
        opp.Name = 'Test again';
        opp.RecordTypeId = hppCAARecordId;
        opp.DSX_Documents_Expected__c='';
        update opp;   
	///////////

	}
    
    static testmethod void testTwo ()
    {
        IBB_Product_Set__c prodset = new IBB_Product_Set__c();
		prodset.name = 'foo';
        /////////
        prodset.DSX_Documents_Expected__c='HPP-2 YEARS SA302';
		insert prodset;

		IBB_Product__c prod = new IBB_Product__c ();
		prod.name = 'foo';
		prod.Type_of_Product__c = 'FIXED TERM SAVINGS ACCOUNT';
		prod.IBB_Product_Set__c = prodset.Id;
		insert prod;
		
		Opportunity opp = new Opportunity();
		opp.Name = 'TEST NAME';
        opp.CloseDate = Date.today();
        opp.StageName = 'CLOSED WON';
		opp.IBB_Product__c = prod.Id;
		
		insert opp;
        ///////////
        Map <String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id hppCAARecordId = recordTypes.get('HPP CAA').getRecordTypeId(); //C0728
        //Id liabilitiesRecordId = recordTypes.get('Liabilities Opportunities').getRecordTypeId();
        
        DSX_Document_Link__c dsxDoc = new DSX_Document_Link__c();
        dsxDoc.Document_Name__c='HPP-2 YEARS SA302';
        dsxDoc.Document_Status__c='VERIFIED';
        dsxDoc.Opportunity__c= opp.Id;
        insert dsxDoc;
        /*
        DSX_Document_Link__c dsxDoc2 = new DSX_Document_Link__c();
        dsxDoc2.Document_Name__c='HPP-ACCOUNTANTS LETTER';
        dsxDoc2.Document_Status__c='Received';
        dsxDoc2.Opportunity__c= opp.Id;
        insert dsxDoc2;
       */
        opp.Name = 'Test again';
        opp.RecordTypeId = hppCAARecordId;
        opp.DSX_Documents_Expected__c='';
        update opp;   
    }
}