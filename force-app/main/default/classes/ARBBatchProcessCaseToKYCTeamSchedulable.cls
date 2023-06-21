/*******************************************************************
* @Class Name      : ARBBatchProcessCaseToKYCTeamSchedulable
* @Author          : RAGESH G
* @Created Date    : 08 February 2022
* @description     : This Schedulable Batch Apex class is used to create KYC cases automatically in the system.
                     Batch will be scheduled to run at every day 06:55 AM  BST ( So that cases will be created at 7:00 AM )
* @JIRA            : SFD-271

  LOG   DATE        Author  UserStory           COMMENT      
* 001   08/02/2022  RG                       First Commit
********************************************************************/

global class ARBBatchProcessCaseToKYCTeamSchedulable implements Schedulable {
    
    /*
     * @Purpose - Implementation execute method of Schedulable apex, ARBBatchProcessCaseToKYCTeam process.
     * @Params  - SchedulableContext sc 
     * @return  - void 
     */
    global void execute(SchedulableContext sc) {
        
        Date todaysDate = System.today ();
        System.debug ('isWorkingDay' + ARBCommonUtils.isWorkingDay( todaysDate ));
        ARBBatchProcessCaseToKYCTeam arbKycBatch = new ARBBatchProcessCaseToKYCTeam ( todaysDate );
        // SFD-271 - DML issue changing the batch size to 1 from 200
        if ( Test.isRunningTest() )
        	Database.executeBatch ( arbKycBatch , 200);
        else 
        	Database.executeBatch ( arbKycBatch , 1);
    }
 }