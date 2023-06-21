/*******************************************************************
* @Class Name      : ARBBatchProcessSendEveryDaySaverTest
* @Author          : RAGESH G
* @Created Date    : 10 August 2022
* @description     : This test class for the Apex class is used send EveryDaySaver Report ARBBatchProcessSendEveryDaySaver
* @JIRA            : 

  LOG   DATE        Author  UserStory           COMMENT      
* 001   10/08/2022  RG                       First Commit
********************************************************************/

@isTest
public class ARBBatchProcessSendEveryDaySaverTest {    
    @isTest(SeeAllData='true')
    public static void testReport(){

       // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        String CRON_EXP = '0 6 * * * ?';
         
        Test.startTest();
         
            String jobId = System.schedule('FTD CFH Email', CRON_EXP, new ARBBatchProcessSendEveryDaySaver('EveryDaySaver'));
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
         
        Test.stopTest();
         
    }
}