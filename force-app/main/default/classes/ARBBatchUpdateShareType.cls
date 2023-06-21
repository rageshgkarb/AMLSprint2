global class ARBBatchUpdateShareType implements Database.Batchable<sObject>,Database.Stateful {
   
    String recordSoql = '';
    global ARBBatchUpdateShareType ( String query ) 
    {
        this.recordSoql = query;
    }
        global List<ContentDocumentLink> start(Database.BatchableContext BC) {

            System.debug(' query ' + this.recordSoql);
            
            return Database.query(recordSoql);
        }

        global void execute(Database.BatchableContext BC, List<ContentDocumentLink> contentDocumentLinkList) {
			List < ContentDocumentLink > contentDocList = new List < ContentDocumentLink > ();

            for ( ContentDocumentLink contentDocLink :contentDocumentLinkList) {
	
				contentDocLink.ShareType ='I';
				contentDocList.add ( contentDocLink );
				
			}
                Database.update (contentDocList );
        }   

        global void finish(Database.BatchableContext BC) {
        }
    }