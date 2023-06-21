/*******************************************************************
* @Class Name      : ARBBatchUpdateShareTypeSchedulable
* @Author          : RAGESH G
* @Created Date    : 28 July 2022
* @description      : 
* @JIRA            : 

  LOG   DATE        Author  UserStory         COMMENT      
* 001   27/06/2022  RG                       First Commit
********************************************************************/

global class ARBBatchUpdateShareTypeSchedulable implements Schedulable {
  
    String soql;Integer size;
    /*
     * @Purpose - Implementation execute method of Schedulable apex, ARBBatchUpdateCustomerImage process.
     * @Params  - SchedulableContext sc 
     * @return  - void 
     */
    global ARBBatchUpdateShareTypeSchedulable ( String soql, Integer size ) {
        this.soql = soql;
        this.size = size;
    }
    global void execute(System.SchedulableContext sc ) {
        
        ARBBatchUpdateShareType arbBatch = new ARBBatchUpdateShareType ( soql );
        Database.executeBatch ( arbBatch , size);
    }
 }