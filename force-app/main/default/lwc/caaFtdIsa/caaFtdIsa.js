import { LightningElement ,api,wire} from 'lwc';
import {LoadShow,LoadHide,getParameters} from 'c/caaUtility';
import { MessageContext } from 'lightning/messageService';
import serviceFTDISA from '@salesforce/apex/CAA_Product_Detail_Controller_lightning.FTDISA';

export default class CaaFtdIsa extends LightningElement {
    @wire(MessageContext)
    messageContext;
Product={};
@api
EventLogId;

parameters;
isMaturity =false;
isMaturityExternal = false;
isMaturityExisting =false;
isErrorMessage = false;
isProfit =false;
isProfitExternal = false;
isProfitExisitng = false;
isCompleteButton = false;

connectedCallback() {
    //code
    this.parameters = getParameters();
    this.EventLogId = this.parameters.id;
    console.log(this.EventLogId);
}

onWhatToDoWithProfit(event){
 
    this.Product.WhatToDoWithProfit = event.target.value;
    if(this.Product.WhatToDoWithProfit == 'invest' || this.Product.WhatToDoWithProfit =='quarterly' || this.Product.OptionsOnMaturity == 'retained'){
        this.isMaturity =true;
        this.isProfit =false;
    }
    if(this.Product.WhatToDoWithProfit =='quarterly' || this.Product.OptionsOnMaturity == 'external'){
        this.isProfit = true;
       
    }
    this.isCompleteButton = this.ShowCompleteButton();
}
onMaturityTransferToType(event){
    this.Product.MaturityTransferToType =event.target.value;
    this.isMaturityExisting =false;
    this.isMaturityExternal = false;
    if(this.Product.MaturityTransferToType == 'external'){
        this.isMaturityExternal = true;
    }
    if(this.Product.MaturityTransferToType == 'existing'){
        this.isMaturityExisting =true;
    }
 this.isCompleteButton = this.ShowCompleteButton();

}
onMaturityTranferToInternal(event){
    this.Product.MaturityTransferToInternalAccount = event.target.value;
    this.isCompleteButton = this.ShowCompleteButton();
}
onProfitTransferToType(event){
    this.Product.ProfitTransferToType = event.target.value;
    this.isProfitExternal = false;
    this.isProfitExisitng = false;
    if(this.Product.ProfitTransferToType == 'external'){
        this.isProfitExternal = true;
    }
    if(this.Product.ProfitTransferToType == 'existing'){
        this.isProfitExisitng = true;
    }
      
    this.isCompleteButton = this.ShowCompleteButton();
    
}

onProfitTransferToExternalAccountName(event){
    this.Product.ProfitTransferToExternalAccountName = event.target.value;
    this.isCompleteButton = this.ShowCompleteButton();
   
}
onProfitTransferToExternalAccount(event){
    this.Product.ProfitTransferToExternalAccount = event.target.value;
    this.isCompleteButton = this.ShowCompleteButton();
}
onProfitTransferToExternalSortCode(event){
    this.Product.ProfitTransferToExternalSortCode = event.target.value;
    this.isCompleteButton = this.ShowCompleteButton();
}
onProfitTransferToInternalAccount(event){
    this.Product.ProfitTransferToInternalAccount = event.target.value;
    this.isCompleteButton = this.ShowCompleteButton();
    
    
}

onMaturityTransferToExternalAccountName(event){
    this.Product.MaturityTransferToExternalAccountName = event.target.value;
    this.isCompleteButton = this.ShowCompleteButton();
}
onMaturityTransferToExternalAccount(event){
    this.Product.MaturityTransferToExternalAccount = event.target.value;
    this.isCompleteButton = this.ShowCompleteButton();
}
onMaturityTransferToExternalSortCode(event){
    this.Product.MaturityTransferToExternalSortCode = event.target.value;
    this.isCompleteButton = this.ShowCompleteButton();
}
      Complete(){
        if(!this.EventLogId) return null;                
        LoadShow('Processing...',this.messageContext);
        
        serviceFTDISA({eventLogId : this.EventLogId,data: this.Product})
        .then(result=>{
                console.log(JSON.stringify(result));
                if(result.Success)
                {
                    this.SuccessMessage = 'Completed';
                    if(result.URL)
                    {
                        console.log(result.URL.FormatURL());
                        window.location.href = result.URL.FormatURL();
                    }
                    else
                    {                                
                      console.log('else part LoadHide'); 
                      LoadHide(false,this.messageContext);
                    } 
                }
                else
                {
                    console.log('Result not success Load hide'); 
                    LoadHide(false,this.messageContext);
                    this.ErrorMessage = JSON.stringify(result.Error);
                    this.isErrorMessage = true;
                }
            }).catch(error =>{
               this.ErrorMessage = JSON.stringify(error);
               this.isErrorMessage = true;
               console.log('JS Catch Load Hide' + JSON.stringify(error)); 
               LoadHide(false,this.messageContext);
           }
           );
    }


    ShowCompleteButton(){

    if(!this.Product || !this.Product.WhatToDoWithProfit) return false;
	if(this.Product.WhatToDoWithProfit == 'invest') return this.MaturityValid();

	if(this.Product.WhatToDoWithProfit == 'quarterly') return this.MaturityValid() && this.ProfitValid();
     
  	return true; 
    }

    MaturityValid(){	

	if(!this.Product.MaturityTransferToType) return false;
	
	if(this.Product.MaturityTransferToType =='existingIsa') return true;
	
	if(this.Product.MaturityTransferToType == 'existing'){
	    if(!this.Product.MaturityTransferToInternalAccount || 
        this.Product.MaturityTransferToInternalAccount.toString().length != 8) return false;
	}

	if(this.Product.MaturityTransferToType == 'external'){
	    if(!this.Product.MaturityTransferToExternalAccount || !this.Product.MaturityTransferToExternalSortCode) return false;
	    if(this.Product.MaturityTransferToExternalAccount.toString().length != 8 || this.Product.MaturityTransferToExternalSortCode.toString().length != 6) return false;
	}
	return true;
	
	
    }

    ProfitValid(){

	if(!this.Product.ProfitTransferToType) return false;

	if(this.Product.ProfitTransferToType =='existingISA') return true;
	
	if(this.Product.ProfitTransferToType == 'existing'){
	    if(!this.Product.ProfitTransferToInternalAccount || this.Product.ProfitTransferToInternalAccount.toString().length != 8) return false;
	}

	if(this.Product.ProfitTransferToType == 'external'){
	    if(!this.Product.ProfitTransferToExternalAccount || !this.Product.ProfitTransferToExternalSortCode) return false;
	    if(this.Product.ProfitTransferToExternalAccount.toString().length != 8 || this.Product.ProfitTransferToExternalSortCode.toString().length != 6) return false;
	}
	return true;
    }

}