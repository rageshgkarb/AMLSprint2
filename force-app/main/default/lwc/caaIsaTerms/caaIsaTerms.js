import { LightningElement, api,wire } from 'lwc';
import {LoadShow,LoadHide,getParameters} from 'c/caaUtility';
import { MessageContext } from 'lightning/messageService';
import serviceISATerms from '@salesforce/apex/CAA_Product_Detail_Controller_lightning.ISATerms';
import GET_ISAYEARS from '@salesforce/apex/CAA_Product_Detail_Controller_lightning.ISASetup';
export default class CaaIsaTerms extends LightningElement {
    @wire(MessageContext)
    messageContext;
@api
EventLogId;
Product={};
ISAYears;
isShowCompleteButton =false;
isExistingAlRayanIsa = false;
    connectedCallback() {
        this.parameters = getParameters();
        this.EventLogId = this.parameters.id;
        if(this.Product.ExistingAlRayanIsa == 'yes'){
            this.isExistingAlRayanIsa =true;
        }


        GET_ISAYEARS({eventLogId : this.EventLogId,data: this.Product})
    .then(result =>{
           let wrap = result;
           this.ISAYears = wrap.ISAYears; 
        
        }).catch(error => {
       
            this.ErrorMessage = error;
        });
    }
    onExistingAlRayanIsa(event){
        this.Product.ExistingAlRayanIsa = event.target.value;
        if(this.Product.ExistingAlRayanIsa == 'yes'){
            this.isExistingAlRayanIsa =true;
        }else{
            this.isExistingAlRayanIsa =false;
        }
        this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onISAYear(event){
        this.Product.ISAYear = event.target.value;
        this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onNi(event){
        this.Product.NI = event.target.value;
        this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onLinkedAccountNumber(event){
        this.Product.LinkedAccountNumber = event.target.value;
        this.isShowCompleteButton = this.ShowCompleteButton();
        this.template.querySelector('c-caa-input-error[data-id="isa-account"]').validateInputField(this.Product.LinkedAccountNumber);
        
    }
    onISA1Change(event){
     this.Product.ISA1 = event.target.checked;
     this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onISA2Change(event){
     this.Product.ISA2 = event.target.checked;
     this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onISA3Change(event){
     this.Product.ISA3 = event.target.checked;
     this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onISA4Change(event){
     this.Product.ISA4 = event.target.checked;
     this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onISA5Change(event){
     this.Product.ISA5 = event.target.checked;
     this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onISA6Change(event){
     this.Product.ISA6 = event.target.checked;
     this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onISA7Change(event){
     this.Product.ISA7 = event.target.checked;
     this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onISA8Change(event){
     this.Product.ISA8 = event.target.checked;
     this.isShowCompleteButton = this.ShowCompleteButton();
    }
    onLinkedSortCode(event){
        this.Product.LinkedSortCode = event.target.value;
        this.isShowCompleteButton = this.ShowCompleteButton();
        this.template.querySelector('c-caa-input-error[data-id="isa-sort"]').validateInputField(this.Product.LinkedSortCode);
    }
    
    CompleteISATerms(event){
        event.preventDefault();
       
    if(!this.EventLogId) return null;                
    LoadShow('Processing...',this.messageContext);
    serviceISATerms({eventLogId : this.EventLogId,data: this.Product})
    .then(result =>{
        console.log(result);
            if(result.Success)
            {
            this.SuccessMessage = 'Completed';
                if(result.URL)
                {
                    LoadHide(false,this.messageContext);
                    window.location.href = result.URL;
                    return;
                }
                else
                {                                

                } 
            }
            else
            {
        this.ErrorMessage = result.Error;
            }
        LoadHide(false,this.messageContext);
        }).catch(error => {
        LoadHide(false,this.messageContext);
            this.ErrorMessage = error;
        }
       );
}
ShowCompleteButton = function(){
     // myform.$valid
   
if(!this.Product || !this.Product.ISA1 || !this.Product.ISA2 || !this.Product.ISA3 || !this.Product.ISA4 || !this.Product.ISA5 || !this.Product.ISA6 || !this.Product.ISA7 || !this.Product.ISA8 || !this.Product.ISAYear || !this.Product.NI || !this.Product.LinkedAccountNumber || !this.Product.LinkedSortCode)
return false;

if(this.Product.LinkedAccountNumber.toString().length != 8 || this.Product.LinkedSortCode.toString().length != 6)
return false;

if (/^\s*[a-zA-Z]{2}(?:\s*\d\s*){6}[a-zA-Z]?\s*$/.test(this.Product.NI)) {
    return true;
}

return false; 

}



    
}