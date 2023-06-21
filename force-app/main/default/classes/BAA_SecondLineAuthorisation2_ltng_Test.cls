/*******************************************************************
* @Class Name      : BAA_SecondLineAuthorisation2_ltng_Test
* @Author          : Amey Kashetwar
* @Created Date    : 9 June 2022
* @description     : This apex test class for BAA_SecondLineAuthorisationCntlr2_ltng
* @JIRA            : SLM-191

  LOG     DATE        Author  UserStory         COMMENT      
* 001   9/06/2022      Amey    SLM-191         First Commit
********************************************************************/
@isTest
public class BAA_SecondLineAuthorisation2_ltng_Test {
    @testSetup static void setup() {
        NPAA_TestSetupData.dataSetup();
    }  
    
    @isTest static void LoadEvent_test() {
        Opportunity opp =[Select id from Opportunity where stagename = 'Open'];
        EventLog__c log=[Select id from EventLog__c where Opportunity__c =: opp.Id];
        
        Test.startTest();
        BAA_SecondLineAuthorisationCntlr2_ltng.LoadEvent(log.id);
        Test.stopTest();
    }   
    @isTest static void Setup_test() {
        Opportunity opp =[Select id,Name from Opportunity where stagename = 'Open'];
        EventLog__c log=[Select id from EventLog__c where Opportunity__c =: opp.Id];
        RecordType recTypeCase = [select id from recordType where  sobjectType='case' and DeveloperName = 'Further_Information' limit 1];
        Test.startTest();
        Case c = new Case();
        c.recordTypeid = recTypeCase.id ;
        c.Further_Information__c = 'Enter Information';
        c.Opportunity__c = opp.id;
        c.Subject = 'Further information for ' + opp.Name;
        c.Description = c.Subject;
        c.Priority = 'Medium';
        c.Status = 'Open';
        c.Origin = 'Salesforce';
        c.Pre_or_Post_Case__c='PRE';
        c.Further_Info_Satisfied__c = 'No';
        insert c;
        BAA_SecondLineAuthorisationCntlr2_ltng.Setup(opp.id);
        Test.stopTest();
    }
    
    @isTest static void Authorise_test() {
        Opportunity opp =[Select id,Name from Opportunity where stagename = 'Open'];
        
        Test.startTest();
        BAA_SecondLineAuthorisationCntlr2_ltng.Authorise(opp.id);
        Test.stopTest();
        
    }
    
     @isTest static void Decline_test() {
        Opportunity opp =[Select id,Name from Opportunity where stagename = 'Open'];
        
        Test.startTest();
        BAA_SecondLineAuthorisationCntlr2_ltng.Decline(opp.id);
        Test.stopTest();
    }
    
     @isTest static void FurtherInformation_test() {
        Opportunity opp =[Select id,Name from Opportunity where stagename = 'Open'];
        RecordType recTypeCase = [select id from recordType where  sobjectType='case' and DeveloperName = 'Further_Information' limit 1];
        
        Case c = new Case();
        c.recordTypeid = recTypeCase.id ;
        c.Further_Information__c = 'Enter Information';
        c.Opportunity__c = opp.id;
        c.Subject = 'Further information for ' + opp.Name;
        c.Description = c.Subject;
        c.Priority = 'Medium';
        c.Status = 'Open';
        c.Origin = 'Salesforce';
        c.Pre_or_Post_Case__c='PRE';
        c.Further_Info_Satisfied__c = 'No';
        insert c;
        Test.startTest(); 
        String FiCases=BAA_SecondLineAuthorisationCntlr2_ltng.Setup(opp.id);
        BAA_SecondLineAuthorisationCntlr2_ltng.FurtherInformation(opp.id,FiCases); 
        Test.stopTest();
    }
    
    @isTest static void AddCase_test() {
        Opportunity opp =[Select id,Name from Opportunity where stagename = 'Open'];
        RecordType recTypeCase = [select id from recordType where  sobjectType='case' and DeveloperName = 'Further_Information' limit 1];
        
        Case c = new Case();
        c.recordTypeid = recTypeCase.id ;
        c.Further_Information__c = 'Enter Information';
        c.Opportunity__c = opp.id;
        c.Subject = 'Further information for ' + opp.Name;
        c.Description = c.Subject;
        c.Priority = 'Medium';
        c.Status = 'Open';
        c.Origin = 'Salesforce';
        c.Pre_or_Post_Case__c='PRE';
        c.Further_Info_Satisfied__c = 'No';
        insert c;
        Test.startTest(); 
        String FiCases=BAA_SecondLineAuthorisationCntlr2_ltng.Setup(opp.id);
        BAA_SecondLineAuthorisationCntlr2_ltng.AddCase(opp.id,FiCases); 
        Test.stopTest();
    }
    @isTest static void Save_test() {
        Opportunity opp =[Select id,Name from Opportunity where stagename = 'Open'];
        RecordType recTypeCase = [select id from recordType where  sobjectType='case' and DeveloperName = 'Further_Information' limit 1];
        
        Case c = new Case();
        c.recordTypeid = recTypeCase.id ;
        c.Further_Information__c = 'Enter Information';
        c.Opportunity__c = opp.id;
        c.Subject = 'Further information for ' + opp.Name;
        c.Description = c.Subject;
        c.Priority = 'Medium';
        c.Status = 'Open';
        c.Origin = 'Salesforce';
        c.Pre_or_Post_Case__c='PRE';
        c.Further_Info_Satisfied__c = 'No';
        insert c;
        Test.startTest(); 
        String FiCases=BAA_SecondLineAuthorisationCntlr2_ltng.Setup(opp.id);
        BAA_SecondLineAuthorisationCntlr2_ltng.Save(FiCases); 
        BAA_SecondLineAuthorisationCntlr2_ltng.DeleteFI(c.id);
        Test.stopTest();
    }
}