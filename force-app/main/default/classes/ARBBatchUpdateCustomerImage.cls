global class ARBBatchUpdateCustomerImage implements Database.Batchable<sObject>,Database.Stateful {
   
    String recordSoql = '';
    global ARBBatchUpdateCustomerImage ( String query ) 
    {
        this.recordSoql = query;
    }
        global List<Customer_Image__c> start(Database.BatchableContext BC) {

            System.debug(' query ' + this.recordSoql);
            
            return Database.query(recordSoql);
        }

        global void execute(Database.BatchableContext BC, List<Customer_Image__c> customerImageCurrentList) {
            Map < Id, Customer_Image__c > customerImageMap = new Map < Id, Customer_Image__c > ();
            Set < Id > contentDocIdSet = new Set < Id > (); 
            for ( Customer_Image__c attachData : customerImageCurrentList) {
                customerImageMap.put ( attachData.Id, attachData);
                contentDocIdSet.add ( attachData.Id );
            
                }

                 System.debug ('contentDocIdSet' + contentDocIdSet);

                 Map < String, String > customerImageFileMap = new Map < String, String > ();
                 for ( ContentVersion cv : [SELECT Id,Title,ContentDocumentId,FirstPublishLocationId From ContentVersion WHERE FirstPublishLocationId IN: contentDocIdSet] ) {
                    
                    customerImageFileMap.put ( ''+cv.FirstPublishLocationId, ''+cv.Id);
                 }
                 
                 System.debug ('customerImageFileMap' + customerImageFileMap);




                 
                 List < Customer_Image__c > customerImageList = new List < Customer_Image__c > ();
                 for ( Customer_Image__c custImage : customerImageCurrentList) {
                    
                    custImage.Image_Id__c = customerImageFileMap.get ( custImage.Id );
                    customerImageList.add ( custImage );
                 }  
                 
                 System.debug ('customerImageList' + customerImageList.size () );
                System.debug ('customerImageList' + customerImageList [0]);
                CustomerImages.runCustomerImagesflag = false;
                update customerImageList;
                //Database.update (customerImageList );
        }   

        global void finish(Database.BatchableContext BC) {
            CustomerImages.runCustomerImagesflag = true;
        }
    }