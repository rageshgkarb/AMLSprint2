/**
* @author Gurdeep Singh
* @date 16-12-2018
*
* @group Risk Calculator Batch
*
* @description Batch job to recalculate the risk scores of all customers using the new RiskCalculator class
*/
global class RiskCalculatorBatchNP implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful, Schedulable
{
    private integer BatchSize = 100;

    // **************************************
    // ************ Constructor *************
    // **************************************
    public RiskCalculatorBatchNP() {

    }

    // ***********************************************
    // ************* Schedule Bit    *****************
    // ***********************************************
    global void execute(SchedulableContext sc)
    {        
        RiskCalculatorBatchNP batch = new RiskCalculatorBatchNP();
        database.executebatch(batch, BatchSize);

    } // end scheduled class

    // **************************************
    // ************ START       *************
    // **************************************
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('RiskCalculatorBatchNP.start() Entry');

        String query = 'Select Id From Account Where Negative_News_Screening__c!= \'\' and Previously_Exited_or_Declined__c != \'\' and Source_of_Funds__c != \'\' and Layers_of_Ownership__c != \'\' and ';
        query += ' Length_of_Establishment__c != \'\' and Balance_Sheet_000s__c != \'\' and Nature_of_Business_NPAA__c != \'\' and Organisation_type__c != \'\' and Face_to_face_Contact__c != \'\' and Organisation_Domicile__c != \'\' and High_risk_prohibited_sanctioned_countr__c != \'\' and HR_Prohibited_sanctioned_COR_for_UBOs_I__c != \'\' and Sanctioned_Individual_Check__c != \'\' and Politically_Exposed_Company__c !=\'\'';
        system.debug('query::' + query);
        
        return Database.getQueryLocator(query);
    }


    // **************************************
    // ************ Execute     *************
    // **************************************
    global void execute(Database.BatchableContext BC, List<Account> accountList) {
        system.debug('RiskCalculatorBatchNP.execute() Entry');
        system.debug('accountList: ' + accountList);

        List<Account> accountListToUpdate = RiskCalculator_NP.CalculateRiskScores(accountList);

        update accountListToUpdate;
    }

    // **************************************
    // ************ FINISH      *************
    // **************************************
    global void finish(Database.BatchableContext BC){
        system.debug('RiskCalculatorBatchNP.finish() Entry');
    }
}