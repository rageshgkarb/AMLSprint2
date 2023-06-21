/*  Class Name  : OpportunityTriggerService
    Description : Helper/Service class for OpportunityTrigger
    Modifications
    DevName      UserStory       Modified date       Description             
    Sunny        SLM-124         06/05/2022          Refactoring/Merging the trigger     */

public class OpportunityTriggerService {

    public static Map<Id, IBB_Product__c> productMap = OpportunityTriggerMethods.productMap;


    //Funtion to update/set eligibility and seller for opportunity records
    public static void UpdateEligibility_updateSeller_BeforeTrigger(list<Opportunity> lstnewOppos, map<Id,Opportunity> oldmap, String EventType){
		
		list<opportunity> sellerUpdateList = new list<opportunity>();
        Map <String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        List<Holiday> holidayList = SoqlHelper.getHolidays ();
        
       
        for (Opportunity opp : lstnewOppos)
        {     
            
            opp.IsEligibleReason__c =  OpportunityTriggerMethods.UpdateEligibility(opp);   
            if(opp.IsEligibleReason__c == '')
            {               
                opp.IsEligible__c = 'Yes';
            }
            else
            {
                opp.IsEligible__c = 'No';
            } 
            dateTime startDate = EventType=='isInsert'?system.now():opp.createdDate;
            
			if(EventType=='isInsert' || (EventType=='isUpdate' && (opp.X1st_Care_Call__c != oldMap.get(opp.id).X1st_Care_Call__c || opp.X2nd_Care_Call__c  != oldMap.get(opp.id).X2nd_Care_Call__c  || opp.X3rd_Care_Call__c != oldMap.get(opp.id).X3rd_Care_Call__c ))){
            
                opp.X1st_Care_Call__c = date_Utility.addDaysExcludingWeekendsHolidays(startDate,10,holidayList);
                opp.X2nd_Care_Call__c = date_Utility.addDaysExcludingWeekendsHolidays(startDate,20,holidayList);
                opp.X3rd_Care_Call__c = date_Utility.addDaysExcludingWeekendsHolidays(startDate,30,holidayList);
            } 
            
            
            if(EventType=='isInsert'){
                try{
                    Id liabilitiesRecordId = recordTypes.get('Liabilities Opportunities').getRecordTypeId();
                    Id caaEligibleRecordId = recordTypes.get('CAA Eligibility').getRecordTypeId();
            
                    
                    if(opp.RecordTypeId == liabilitiesRecordId || opp.RecordTypeId == caaEligibleRecordId ){
                        sellerUpdateList.add(opp);        
                    }
                }catch(exception e){}      
            }                  
        }  
        if(sellerUpdateList.size() > 0){
            OpportunityTriggerMethods.updateSellerRoundRobin(sellerUpdateList);
        }
        
	}

    //function to populate Payment info and update the printing status
    public static void PopPaymentInfo_updatePrintingStatus_BeforeUpdate(list<Opportunity> lstnewOppos, map<Id,Opportunity> oldmap){
        
        Map<Id, List<DSX_Document_Link__c>> mapOppDsxDoc = new Map<Id, List<DSX_Document_Link__c>>(); //map opportunity id to the related list of DSX_Document_Link__c

        Set<Id> setOppIds = new Set<Id>();	
        for (Opportunity oppti : lstnewOppos) {
            setOppIds.add(oppti.id);
        }

        List<DSX_Document_Link__c> listAllDsxDocs = new List<DSX_Document_Link__c>([SELECT Document_Name__c, Document_Status__c, Opportunity__c
                                                FROM DSX_Document_Link__c
                                                WHERE Opportunity__c IN : setOppIds
                                                AND Document_Status__c != 'VERIFIED']);
        if(listAllDsxDocs.size()>0){
            for(DSX_Document_Link__c doc : listAllDsxDocs){
                if(!mapOppDsxDoc.containsKey(doc.Opportunity__c)){
                    List<DSX_Document_Link__c> listDsxDocsForOpp = new List<DSX_Document_Link__c>();
                    listDsxDocsForOpp.add(doc);
                    mapOppDsxDoc.put(doc.Opportunity__c,listDsxDocsForOpp);
                }
                else{
                    mapOppDsxDoc.get(doc.Opportunity__c).add(doc);
                }
            }
        }                                        
        
        set<String> settypes = new set<String>();
        List<Account_Reference_Information__c> ariList = new List<Account_Reference_Information__c>();
        map<String, List<Account_Reference_Information__c> > mapTyepLstARI = new map<String, List<Account_Reference_Information__c> >();
        list<Web_Integration_Log__c> lstWebForms = new list<Web_Integration_Log__c>();

        for(Opportunity opp : lstnewOppos){
            if(opp.Payment_Type_List__c != null){
                settypes.add(opp.Payment_Type_List__c);
            }
        }
        ariList = [Select Payment_Type__c, Id, ISO_Currency_Code__c, 
                    IBB_Debit_Account_Number__c, IBB_Credit_Account_Number__c, 
                    Debit_Transaction_Code__c, Credit_Transaction_Code__c, Credit_Transaction_Narritive__c, 
                    Debit_Transaction_Narritive__c From Account_Reference_Information__c a 
                    where Payment_Type__c in: settypes];
        for(Account_Reference_Information__c objARI : ariList){
            if(mapTyepLstARI.containsKey(objARI.Payment_Type__c)){
                mapTyepLstARI.get(objARI.Payment_Type__c).add(objARI);
            }else{
                mapTyepLstARI.put(objARI.Payment_Type__c, new list<Account_Reference_Information__c>{objARI});
            }
        }

        for (Opportunity opp : lstnewOppos)
            {
                IBB_Product__c ibbproduct = productMap.get(opp.IBB_Product__c);
                if ('CLOSED WON'.equalsIgnoreCase(opp.StageName)){
                    if (!'FIXED TERM SAVINGS ACCOUNT'.equalsIgnoreCase(ibbproduct.Type_of_Product__c) && !opp.From_Upload__c){
                        //OpportunityTriggerMethods.populatePaymentInformation(opp);  
                        Web_Integration_Log__c objwIL = OpportunityTriggerMethods.populatePaymentInformationbulk(opp, mapTyepLstARI.get(opp.Payment_Type__c));
                        if(objwIL != null){
                            lstWebForms.add(objwIL);
                        }
                    }
                }

                /* C0728 */
                //system.debug ( 'In C0728 ' );
                Map <String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
                Id hppRecordId = recordTypes.get('HPP Opportunities').getRecordTypeId();
                Id hppCAARecordId = recordTypes.get('HPP CAA').getRecordTypeId(); //C0728
                Id liabilitiesRecordId = recordTypes.get('Liabilities Opportunities').getRecordTypeId();
                
                //system.debug ( 'hpprecordid ' + hpprecordid + ' - opp.RecordId ' + opp.RecordTypeId);
                
                //case: 01893749 and 01831495; Printing status is not displaying; Start
                //system.debug('oldmap.get(opp.Id).stagename'+oldmap.get(opp.Id).stagename);
                if(opp.RecordTypeId == liabilitiesRecordId && opp.stagename != oldmap.get(opp.Id).stagename && 'Next Steps'.equalsIgnoreCase(opp.StageName)){
                   // system.debug('Entering update priting status loop');
                    OpportunityTriggerMethods.updatePrintingStatus(opp);
                } 
                //case: 01893749 and 01831495; Printing status is not displaying; End
                
                if (opp.RecordTypeId == hppCAARecordId)
                {
                    //system.debug ( 'In C0728 ibb product ' + ibbproduct);
                    
                    if (ibbproduct != null )
                    {
                        //IBB_Product_Set__c productSet = [SELECT DSX_Documents_Expected__c
                            //                          FROM IBB_Product_Set__c

                        //system.debug ( 'In C0728 DSX_Docs A ' + opp.DSX_Documents_Expected__c);
                        if (String.IsBlank(opp.DSX_Documents_Expected__c))
                        {
                            //system.debug ( 'In C0728 DSX_Docs B ' + ibbproduct.ibb_product_set__r.DSX_Documents_Expected__c);
                            opp.DSX_Documents_Expected__c = ibbproduct.ibb_product_set__r.DSX_Documents_Expected__c;
                            //system.debug ( 'In C0728 DSX_Docs C ' + opp.DSX_Documents_Expected__c);
                            List<string> expDocs = opp.DSX_Documents_Expected__c.Split(';');
                            List<string> outstandingDocs = new List<string>();
                            List<string> receivedDocs = new List<string>();
                            /*
                            List<DSX_Document_Link__c> dsxDocs = [SELECT Document_Name__c 
                                                                        , Document_Status__c // C0741
                                                    FROM DSX_Document_Link__c
                                                    WHERE Opportunity__c = :opp.id
                                                    AND Document_Status__c != 'VERIFIED'];
                            */
                            Map<string, DSX_Document_Link__c> dsxMap = new Map<string, DSX_Document_Link__c>();
                            
                            //List<string> recDocs = new List<string> ();
                            //List<string> outDocs = new List<string> ();

                            if (mapOppDsxDoc.containsKey(opp.id))
                            {
                                for (DSX_Document_Link__c dsx : mapOppDsxDoc.get(opp.id) )
                                {
                                    dsxMap.put (dsx.Document_Name__c, dsx);
                                }

                                string osDocs = '';
                                string recDocs = '';
                                integer i = 0;  //C0741
                                for (string s : expDocs)
                                {
                                    outstandingDocs.Add(s); //C0741
                                    DSX_Document_Link__c dsxDoc = dsxMap.get (s);
                                    if (dsxDoc != null)
                                    {
                                        if (dsxDoc.Document_Status__c == 'Received')
                                        {
                                            receivedDocs.Add(s);
                                            
                                        }
                                        
                                        //C0741
                                        if (dsxDoc.Document_Status__c == 'Verified' )
                                        {
                                            outstandingDocs.Remove (i);
                                        }
                                        // C0741
                                        //system.debug ( 's A ' + s );
                                        // C0741 outstandingDocs.Add(s);
                                        //system.debug ( 'Outstanding docs A ' + outstandingDocs);
                                        //osDocs = String.isBlank(osDocs) ? s  : osDocs + ';' + s;
                                    }
                                    i++;
                                }

                                if ( outstandingDocs.Size() > 0 )
                                {
                                    outstandingDocs.Sort();
                                    for ( string st : outstandingDocs)
                                    {
                                        //system.debug ( 'st B ' + st);
                                        osDocs = String.isBlank(osDocs) ? st  : osDocs + ';' + st;
                                        //system.debug ( 'OsDocs B ' + osDocs );
                                    }
                                }

                                if ( receivedDocs.Size() > 0)
                                {
                                    receivedDocs.Sort();
                                    for ( string st : receivedDocs)
                                    {
                                        recDocs = String.isBlank(recDocs) ? st  : recDocs + ';' + st;
                                    }
                                }

                                

                                if (!String.IsBlank(osDocs))
                                {
                                    opp.DSX_Documents_Outstanding__c = osDocs;
                                }

                                if (!String.IsBlank(recDocs))
                                {
                                    opp.DSX_Documents_Received__c = recDocs;
                                }
                                else
                                {
                                    opp.DSX_Documents_Received__c = null;
                                }
                            }
                            else
                            {
                                string osDocs = '';
                                for (string s : expDocs)
                                {
                                    //system.debug ( 's D ' + s );
                                    //osDocs = String.isBlank(osDocs) ? s  : osDocs + ';' + s;
                                    //system.debug ( 'OsDocs D ' + osDocs );
                                    outstandingDocs.Add(s);
                                    
                                }

                                outstandingDocs.Sort();
                                for ( string st : outstandingDocs)
                                {
                                    osDocs = String.isBlank(osDocs) ? st  : osDocs + ';' + st;
                                }
                                opp.DSX_Documents_Outstanding__c = osDocs;
                                opp.DSX_Documents_Received__c = null;
                            }
                            
                            //integer i = 1/0;
                            //update opp;
                        }
                    }
                }
                /* C0728 */   
            }   

            try {
                insert lstWebForms;  
            }catch (Exception e){
                System.debug('*** -- Error in inserting Web Log for AddJournalEntry -- ***');
                System.debug('*** -- ' + e + ' at line ' + e.getLineNumber() + ' -- ***');
            }
    }

	
    //Create RLA Account OR send Payment Message
    public static void CreateRLAAccount_sendPaymentMsg_AfterUpdate(list<Opportunity> lstnewOppos){
        Map <String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
            Id hppRecordId = recordTypes.get('HPP Opportunities').getRecordTypeId();
            
            Id liabilitiesRecordId = recordTypes.get('Liabilities Opportunities').getRecordTypeId();
            for (Opportunity opp : lstnewOppos){
                
                IBB_Product__c ibbProduct = productMap.get(opp.IBB_Product__c);

                if (opp.RecordTypeId == hppRecordId){
                    if ('HPP Completed (WON)'.equalsIgnoreCase(opp.StageName))
                    {
                        OpportunityTriggerMethods.createRLAAccount(opp.Id); 
                    }

                    
                    
                }
                else if (opp.RecordTypeId == liabilitiesRecordId)
                {
                    if ('CLOSED WON'.equalsIgnoreCase(opp.StageName))
                    {
                        //system.debug ('Trigger what is the product type ' + ibbProduct.Type_of_Product__c);
                        if (!'FIXED TERM SAVINGS ACCOUNT'.equalsIgnoreCase(ibbProduct.Type_of_Product__c) &&  !'12 Month Fixed Term Deposit ISA'.equalsIgnoreCase(ibbProduct.Type_of_Product__c))
                        {
                            if (!'CASH'.equalsIgnoreCase(opp.Payment_Type_List__c) && !opp.From_Upload__c)
                            {
                                OpportunityTriggerMethods.sendPaymentMessage(opp.Id);
                            }
                        }   
                    }
                }

                
            }
    }
    
    /*
    //for debugging purpose
    public static void PrintIfInsertSuccess(list<Opportunity> lstnewOppos){
        
        system.debug('OPPORTUNITY INSERT OCCURRED! ');
        for ( Opportunity opp : lstnewOppos )
        {           
            system.debug('NAME='+opp.Name+' STAGE='+opp.StageName);
        }
    }
    */

}