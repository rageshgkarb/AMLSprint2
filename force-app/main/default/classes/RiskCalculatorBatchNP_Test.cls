/**
* @author Avinash
* @date 27-09-2022
* @description Test class created to test RiskCalculatorBatch class
*/
@isTest
public class RiskCalculatorBatchNP_Test {

    private static String RiskHistory_Source_Batch = 'Batch';
    private static String RiskHistory_Source_Trigger = 'Trigger';

    private static void setupData()
    {
        Account acc = RiskCalculator_NP_Test.setupAccount('', 'United Kingdom', 'United Kingdom', 'Club, Association or Community', 'No True Match', 'Limited Company', 'No UBO or Significant Controller met face to face', 
                                        'No true match identified', 'No true match identified', 'No true match identified',
                                        'Account funded from a bank account in the UK','1 layer of ownership or less','Over 3 years','Under £2.5m','No True Match', 'Corporate');
        Opportunity opp1 = RiskCalculator_NP_Test.setupOpportunity(acc.Id, 'Completed', '120 Day Notice Savings Account', null, 'Cash Deposit');
        RiskCalculator_NP_Test.setupCustomerAccount('120 Day Notice Savings Account', acc.Id, true, '123451');  
        Account_with_IBB__c awi1 = RiskCalculator_NP_Test.setupCustomerAccount('Current Account', acc.Id, true, '123461');
        Account_with_IBB__c awi2 = RiskCalculator_NP_Test.setupCustomerAccount('Current Account', acc.Id, true, '123462');
        Account_with_IBB__c awi3 = RiskCalculator_NP_Test.setupCustomerAccount('Wakala Account', acc.Id, true, '123463');

        RiskCalculator_NP_Test.setupAssetRelationship(acc.Id, awi1.Id, true, true);
        RiskCalculator_NP_Test.setupAssetRelationship(acc.Id, awi2.Id, true, true);
        RiskCalculator_NP_Test.setupAssetRelationship(acc.Id, awi3.Id, true, true); 
    }

    private static TestMethod void noAccountsToRecalculate_shouldNotRecalculate()
    {
        Test.startTest();
            setupData();

            RiskCalculatorBatchNP obj = new RiskCalculatorBatchNP();
            DataBase.executeBatch(obj);
        Test.stopTest();

        //List<Risk_Score_History__c> riskHistories = RiskCalculator_Test.getRiskHistories();
        //system.assertEquals(0, riskHistories.size());
    }

    private static TestMethod void settingUpSchedule_shouldSchedule()
    {
        Test.startTest();
            setupData();
            
            string cronExpr = '0 40 8 * * ?';
            string jobId = system.schedule('Risk Calculator Batch', '0 40 8 * * ?', new RiskCalculatorBatchNP());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
            //Verify batch runs successfully 
            System.assertEquals(cronExpr , ct.CronExpression);
        Test.stopTest();
    }
}