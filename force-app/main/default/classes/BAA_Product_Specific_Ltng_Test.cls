@isTest
public class BAA_Product_Specific_Ltng_Test {
    
    @TestSetup
    static void testData(){
        NPAA_TestSetupData.dataSetup();
    }
     @isTest
    static void getWrapperTest(){
        EventLog__c el = [select id from EventLog__c limit 1];
        NPAABaseEventController.Wrapper  wrap = BAA_Product_Specific_Ltng_Controller.getWrapper(el.id,null);
        system.debug('wrap='+wrap);
        system.debug('wrap='+wrap.BaseOpportunity);
        system.assert(wrap != null);
    }
    
     @isTest
    static void fetchOppTest(){
        EventLog__c el = [select id from EventLog__c limit 1];
        NPAABaseEventController.Wrapper  wrap = BAA_Product_Specific_Ltng_Controller.getWrapper(el.id,null);
        system.debug('wrap='+wrap);
        system.debug('wrap='+wrap.BaseOpportunity);
        Opportunity opp=BAA_Product_Specific_Ltng_Controller.fetchOpportunityDetails(wrap.BaseOpportunity.Id);
        system.debug('opp='+opp);
        system.assert(opp != null);
    }
    
     @isTest
    static void fetchApplicantListtest(){
        EventLog__c el = [select id from EventLog__c limit 1];
        NPAABaseEventController.Wrapper  wrap = BAA_Product_Specific_Ltng_Controller.getWrapper(el.id,null);
        system.debug('wrap='+wrap);
        system.debug('wrap='+wrap.BaseOpportunity);
		List<BAA_Product_Specific_Ltng_Controller.ApplicantWrapper> awrap= BAA_Product_Specific_Ltng_Controller.fetchApplicantList(wrap.BaseOpportunity.Id);
        system.debug('awrap='+awrap);
        BAA_Product_Specific_Ltng_Controller.ProductSpecificOppWrapper proOppWrap= new  BAA_Product_Specific_Ltng_Controller.ProductSpecificOppWrapper();
        proOppWrap.opportunityId=wrap.BaseOpportunity.Id;
        proOppWrap.mandateSignField='Any one signature';
        proOppWrap.mandateCmpsignfield='No';
        String jsonproOppWrap=JSON.serialize(proOppWrap);
        String jsonaWrap=JSON.serialize(awrap);
       	BAA_Product_Specific_Ltng_Controller.ProductSpecificResultWrapper psrw= BAA_Product_Specific_Ltng_Controller.handleSaveApplicant(jsonproOppWrap,jsonaWrap);
        system.assert(awrap!= null);
        system.assert(psrw!=null);
       	
    }
	
}