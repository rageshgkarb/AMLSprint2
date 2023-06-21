import {LightningElement ,api,track} from 'lwc';
import  GetDocumentData from '@salesforce/apex/CAA_Core_Controller_Lightning.GetDocumentData';
import CreateDocument  from '@salesforce/apex/CAA_Core_Controller_Lightning.CreateDocument';


export default class CaaNextStepDocuments extends LightningElement {
    @api eventlogid;
    @api sessionid;
    @api IsGuest = false;
    @api stage;
     ShowFSCSDoc = false;
     ShowR85Documents = false;
    @track documents;

    ErrorMessage;

    
    

    
    CreateDocuments(docItem){
        if(!this.eventlogid || !docItem || !docItem.SettingId) return null;  
        docItem.Generating = true;
        CreateDocument({eventLogId:this.eventlogid,sessionId: this.sessionid,settingId: docItem.SettingId})
            .then(result=>{
    docItem.Generating = false;
                if(result.Success)
                {
        docItem.Complete = result.Data.Docs[0].Complete;
        docItem.AttachmentId = result.Data.Docs[0].AttachmentId;
        docItem.URL = result.Data.Docs[0].URL.FormatURL();
                }
                else
                {
        this.ErrorMessage = result.Error;
                }
            }).catch(error => {
                this.ErrorMessage = error;
            });
          
    }


    GetDocumentData(){
        if(!this.eventlogid) return null;                
        
        GetDocumentData({eventLogId: this.eventlogid, sessionId: this.sessionid, stage: this.stage} )
        .then(result =>{
                if(result.Success)
                {
                    
        this.documents = result.Data.Docs;
        
        this.documents.forEach(docs => { 
           
                if(docs.Complete != true)
                this.CreateDocuments(docs);

            if(docs.URL)
            docs.URL = docs.URL.FormatURL();
        });

                }
                else
                {
                 this.ErrorMessage = result.Error;
                }
            }).catch(error =>{
                this.ErrorMessage = error;
            }
           );
    }




    connectedCallback() {

        this.GetDocumentData();
    }

    




     
    
   



}