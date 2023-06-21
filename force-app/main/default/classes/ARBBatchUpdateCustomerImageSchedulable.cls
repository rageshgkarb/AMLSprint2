/*******************************************************************
* @Class Name      : ARBBatchUpdateCustomerImageSchedulable
* @Author          : RAGESH G
* @Created Date    : 27 June 2022
* @description 	   : 
* @JIRA            : 

  LOG   DATE        Author  UserStory       	COMMENT      
* 001   27/06/2022  RG                       First Commit
********************************************************************/

global class ARBBatchUpdateCustomerImageSchedulable implements Schedulable {
	
    String soql;Integer size;
    /*
     * @Purpose - Implementation execute method of Schedulable apex, ARBBatchUpdateCustomerImage process.
     * @Params  - SchedulableContext sc 
     * @return  - void 
     */
    global ARBBatchUpdateCustomerImageSchedulable ( String soql, Integer size ) {
        this.soql = soql;
        this.size = size;
    }
    global void execute(System.SchedulableContext sc ) {
        
        ARBBatchUpdateCustomerImage arbBatch = new ARBBatchUpdateCustomerImage ( soql );
        Database.executeBatch ( arbBatch , size);
    }
 }