@isTest
public class BAA_SubmissonResults_LtngController_test {
    @TestSetup
    static void testData(){
        NPAA_TestSetupData.dataSetup();
    }
    
     @isTest
    static void getWrapperTest(){
        EventLog__c el = [select id from EventLog__c limit 1];
        NPAABaseEventController.Wrapper  wrap = BAA_SubmissonResults_LightningController.getWrapper(el.id,null);
        system.debug('wrap='+wrap);
        system.debug('wrap='+wrap.BaseOpportunity);
        system.assert(wrap != null);
    }
     @isTest
    static void testAllMethods(){
        EventLog__c el = [select id from EventLog__c limit 1];
        NPAABaseEventController.Wrapper  wrap = BAA_SubmissonResults_LightningController.getWrapper(el.id,null);
        system.debug('wrap='+wrap);
        system.debug('wrap='+wrap.BaseOpportunity);
        system.assert(wrap != null);
        case cs=new case();
        cs.Opportunity__c=wrap.BaseOpportunity.Id;
        cs.ContactId=wrap.Accounts[0].PersonContactId;
        cs.Subject='test';
        cs.Description='test';
        cs.referral_decision__c='declined';
        cs.Status='Pending';
        insert cs;
        test.startTest();
        BAA_SubmissonResults_LightningController.details detWrap=BAA_SubmissonResults_LightningController.getDetails(wrap.Accounts,wrap.BaseOpportunity.Id);
        system.debug('detWrap='+detWrap);
        BAA_SubmissonResults_LightningController.SaveCase(detWrap,wrap.BaseOpportunity,wrap.BaseOpportunity.Id);
        List<String> lststr=BAA_SubmissonResults_LightningController.allAccepted(detWrap.containsUSPerson,wrap.BaseOpportunity.Id);
        Boolean bool=BAA_SubmissonResults_LightningController.checkUSPersonsSignedForm(wrap.BaseOpportunity.Id);
        string str=BAA_SubmissonResults_LightningController.complete(wrap,true);
        test.stopTest();
        system.assert(detWrap != null);
        system.assert(lststr != null);
        system.assert(bool!=null);
    }
    

}