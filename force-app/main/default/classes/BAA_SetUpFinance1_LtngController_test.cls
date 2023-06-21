@isTest
public class BAA_SetUpFinance1_LtngController_test {
     @TestSetup
    static void testData(){
        NPAA_TestSetupData.dataSetup();
        List<BAADecisionEngineMatrix__c> DEmatrixList=new List<BAADecisionEngineMatrix__c>();
        BAADecisionEngineMatrix__c DEmatrix=new BAADecisionEngineMatrix__c();
        DEmatrix.Name='test';
        DEmatrix.EntityType__c='Shareholder';
        DEmatrix.ProductCategory__c='test';
        DEmatrix.DoAML__c=true;
        DEmatrix.DoCredit__c=true;
        DEmatrix.DoSanction__c=true;
        DEmatrix.DoSetUp__c=true;
        DEmatrixList.add(DEmatrix);
        
        BAADecisionEngineMatrix__c DEmatrix2=new BAADecisionEngineMatrix__c();
        DEmatrix2.Name='test2';
        DEmatrix2.EntityType__c='Signatory';
        DEmatrix2.ProductCategory__c='test';
        DEmatrix2.DoAML__c=true;
        DEmatrix2.DoCredit__c=true;
        DEmatrix2.DoSanction__c=true;
        DEmatrix2.DoSetUp__c=true;
        DEmatrixList.add(DEmatrix2);
        
        insert DEmatrixList;
        
    }
    /* @isTest
    static void getWrapperTest(){
        EventLog__c el = [select id from EventLog__c limit 1];
        NPAABaseEventController.Wrapper  wrap = BAA_SetUpFinance1_LightningController.getWrapper(el.id,null);
        system.debug('wrap='+wrap);
        system.debug('wrap='+wrap.Prod);
        system.assert(wrap != null);
    }*/
    
    @isTest
    static void testMethods(){
		EventLog__c el = [select id from EventLog__c limit 1];
        test.startTest();
        NPAABaseEventController.Wrapper  wrap = BAA_SetUpFinance1_LightningController.getWrapper(el.id,null);
        IBB_Product__c Prod=wrap.Prod;
        String opportId=wrap.BaseOpportunity.Id;
        
        BAA_SetUpFinance1_LightningController.detailWrap dW=BAA_SetUpFinance1_LightningController.getDetails(Prod,opportId);
        test.stopTest();
        system.assert(dW != null);
		        
    }
    
    

}