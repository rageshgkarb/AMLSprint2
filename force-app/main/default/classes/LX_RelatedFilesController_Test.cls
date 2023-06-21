/* Class Name : LX_RelatedFilesController_Test
Description : Test class for LX_RelatedFilesController 
Modifications:Newly created class
DevName UserStory  Description
Amey    SLM-047    Opportunity oneview enable in lightning */

@isTest
private class LX_RelatedFilesController_Test {
    //private Opportunity opp;
    //private Account acc;
    
    @testSetup static void methodName() {
        Account acc = new Account();        
        acc.FirstName = 'Applicant Account';
        acc.LastName = 'Applicant Account new';
        acc.Title_Other__c = 'xyz';        
        insert acc;
       
        Opportunity opp = new Opportunity();    
        opp.Name = 'Test Data';
        opp.StageName = 'Test STage';
        opp.CloseDate = date.today();
        //opp.IBB_Product__c = prod.Id;
        //opp.Payment_Type__c = ari.Payment_Type__c;  
        //opp.Payment_Type_List__c = ari.Payment_Type__c; 
        opp.AccountId = acc.Id; 
        opp.Profit_Paid_To__c = 'Existing IBB Account';
        //opp.Account_with_IBB__c = awi.Id;   
        opp.Credit_or_debit__c = 'CREDIT';
        insert opp;
        
        ContentNote con = new ContentNote();
        con.Title='Test note';
        con.Content=Blob.valueOf('test note body');
        insert con;
        ContentDocument cd=[select id from ContentDocument where id=:con.Id];
        ContentDocumentLink cdl=new ContentDocumentLink();
        cdl.ContentDocumentId=cd.id;
        cdl.LinkedEntityId=opp.Id;
        cdl.ShareType='V';
        cdl.Visibility='AllUsers';
        insert cdl;
    }
    
    
    static testMethod void getRelatedDocs_test() {
        List<ContentNote> cnList= new  List<ContentNote>();
        LX_RelatedFilesController.noteWrap wrap= new LX_RelatedFilesController.noteWrap();
        Opportunity opp = [select id,Name from Opportunity where Credit_or_debit__c = 'CREDIT'];
        System.debug('opp'+opp);
        Test.startTest();
        cnList=LX_RelatedFilesController.getRelatedDocs(opp.Id);
        LX_RelatedFilesController.getRelatedContentDocs(opp.Id);
        wrap=LX_RelatedFilesController.getContentNote(cnList[0].Id);
        LX_RelatedFilesController.getDocURL(cnList[0].Id);
        LX_RelatedFilesController.updateNotes(cnList[0].Id, 'Update from test', 'Update body');
        LX_RelatedFilesController.deleteDoc(cnList[0].Id);
        Test.stopTest();
    }
    
    static testMethod void createRecord_test() {
        ContentNote con = new ContentNote();
        con.Title='Test note from method';
        con.Content=Blob.valueOf('test note body from method');
        insert con;
        Opportunity opp = [select id,Name from Opportunity where Credit_or_debit__c = 'CREDIT'];
        //Blob docBody=;
        String base64Data=EncodingUtil.base64Encode(Blob.valueof('This from test class'));
        Test.startTest();
        LX_RelatedFilesController.createRecord(con, opp.Id);
        LX_RelatedFilesController.SaveFile(opp.Id,'Test File',base64Data,'Text');
        Test.stopTest();
    }
}