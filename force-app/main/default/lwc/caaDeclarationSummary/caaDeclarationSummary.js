import { LightningElement, api ,wire } from 'lwc';

import serviceDeclarationSummary from '@salesforce/apex/CAA_Core_Controller_Lightning.CompleteSummary';  
import getDeclarationSummary from '@salesforce/apex/CAA_Core_Controller_Lightning.get_Declaration_Summary';  
import {LoadShow,LoadHide,getParameters} from 'c/caaUtility'; 
import { MessageContext } from 'lightning/messageService';  
export default class CaaDeclarationSummary extends LightningElement {

@wire(MessageContext)
    messageContext;

error;
parameters = {};
@api Cases;
isErrorMessage= false;
@api EventLogId;
@api SessionId;
@api IsGuest;
@api DeResponse;
@api AllowComplete;
@api ibbProductName;
@api OppLibRef;
@api Product;

logId;

connectedCallback() {
            
    console.log(this.AllowComplete);
    console.log(this.EventLogId);
    this.logId = this.EventLogId;
    console.log(this.Cases);

    getDeclarationSummary({logId:this.EventLogId,extId:this.extId})
            .then(result=>{
                   this.Cases= result.Cases; 
                    
                }).catch(error =>{
                    this.ErrorMessage = JSON.stringify(error);
                    this.isErrorMessage = true;
                 
                });
                console.log(this.Cases);
     
        
}

navigateToCase(event){
        window.open('/lightning/r/Case/'+ event.target.name +'/view');
}

CompleteSummary(){
    
            if(!this.EventLogId) return null;
            LoadShow('Processing...',this.messageContext);

            serviceDeclarationSummary({eventLogId:this.EventLogId})
            .then(result=>{
                    
                    if(result.Success)
                    {
                        if(result.URL)
                        {
                            window.location.href = result.URL.FormatURL();
                           
                        }
                        else
                        {                                
             LoadHide(false,this.messageContext); 
                        } 
                    }
                    else
                    {
             LoadHide(false,this.messageContext); 
                    }
                }).catch(error =>{
                    this.ErrorMessage = JSON.stringify(error);
               this.isErrorMessage = true;
                 LoadHide(false,this.messageContext); 
                });
        }

        get isResponse() {
            if(this.DeResponse=='SYSTEMERROR' || this.DeResponse == 'ADDRESSMISMATCH' || this.DeResponse == 'REFER' || this.DeResponse == 'ERROR' || this.DeResponse == 'FCU' || this.DeResponse == 'SUCCESS')
                return true;
            else
                return false;
        }
            get isDecline() {
            if(this.DeResponse == 'DECLINE')
                return true;
            else
                return false;
        }
        get isDOCS() {
            if(this.DeResponse == 'DOCS')
                return true;
            else
                return false;
        }
        get isSIG() {
            if(this.DeResponse == 'SIG')
                return true;
            else
                return false;
        }
        
        
}