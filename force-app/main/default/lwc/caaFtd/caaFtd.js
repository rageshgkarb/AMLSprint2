import { LightningElement,track,api,wire } from 'lwc';
import {LoadShow,LoadHide,getParameters} from 'c/caaUtility';
import { MessageContext } from 'lightning/messageService';
    import ISASetup from '@salesforce/apex/CAA_Product_Detail_Controller_lightning.ISASetup';
    import FTD from '@salesforce/apex/CAA_Product_Detail_Controller_lightning.FTD';
    
export default class Caa_FTD extends LightningElement {
    Product={
        MaturityTransferToInternalAccount : '',
        MaturityTransferToExternalAccount : '',
        MaturityTransferToExternalSortCode : '',
        MaturityTransferToExternalAccountName : '',
        ProfitTransferToExternalAccountName : '',
        ProfitTransferToExternalAccount : '',
        ProfitTransferToExternalSortCode : '',
        ProfitTransferToInternalAccount : '',
        ProfitMaturityTransferToExternalAccountName : '',
        ProfitMaturityTransferToExternalAccount : '',
        ProfitMaturityTransferToExternalSortCode : '',
        ProfitMaturityTransferToInternalAccount :''
    };
    @api 
    EventlogId;
    extId;
    ISAYears;
    opp;
    ISAYears;
    TermMonths;
    LessThanOr12Months;
    isMaturity = false;
    isProfit = false;
    isProfitMaturity = false;
    MaturityTransferToType = '';
    MaturityTransferExisting =false;
    MaturityTransferExternal = false;
    ProfitTransferExisting = false;
    ProfitTransferExternal = false;
    ProfitMaturityTransferExternal = false;
    ProfitMaturityTransferExisting = false;
    isCompleteButton = false;
    isErrorMessage = false;
    ErrorMessage = '';
    showTemplate = false;
    @wire(MessageContext)
    messageContext;
    async connectedCallback(){
         
            console.log("caaftd Lwc Comp Loaded");
            this.getQueryParameters();
            ISASetup({EventLogId:this.EventlogId,extid:this.extId})
                .then(result=>{
                console.log('Line no: 20'+result); 
                this.showTemplate = true;
                let wrap = result;
                this.TermMonths = wrap.TermMonths;
                this.LessThanOr12Months = wrap.LessThanOr12Months;
                console.log('this.LessThanOr12Months: '+this.LessThanOr12Months);
                }).catch(error=>{
                this.result=error;
                console.log(JSON.stringify(error));
                });

            console.log('EventLogId 76'+this.EventlogId);
            
    }
    
    getQueryParameters(){

        var params = {};

        var search = location.search.substring(1);

             if (search) {

            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => 

            {
                return key === "" ? value : decodeURIComponent(value)

            });
            console.log(JSON.stringify(params));
            this.extId = params.extid;
            this.EventlogId = params.id;
            console.log('Event log ID 95:' +this.EventlogId );
            console.log('External ID 96: '+this.extid);
        
        }
    }

    onWhatToDoWithProfit(event){
        console.log(event.target.value);
        this.isMaturity =false;
        this.isProfit = false;
        this.isProfitMaturity = false;
        this.Product.WhatToDoWithProfit = event.target.value;
        if(this.Product.WhatToDoWithProfit == 'invest' || this.Product.WhatToDoWithProfit =='quarterly'){
            this.isMaturity =true;
        }
        if(this.Product.WhatToDoWithProfit =='quarterly'){
            this.isProfit = true;
            this.isMaturity = true;
        }
        
    }

    OptionsOnMaturity(event){
        console.log(event.target.value);
        this.isMaturity =false;
        this.isProfit = false;
        this.isProfitMaturity = false;
        this.Product.OptionsOnMaturity = event.target.value;
        if(this.Product.OptionsOnMaturity  == 'retained'){
            this.isMaturity =true;
        }
        if(this.Product.OptionsOnMaturity  == 'external'){
            this.isProfit = true;
        }
        if(this.Product.OptionsOnMaturity  =='internal'){
            this.isProfitMaturity = true;
        }
        this.isCompleteButton = this.ShowCompleteButton();
        console.log(this.isCompleteButton );
    }
    
    onMaturityProfitChange(event){
        this.Product[event.target.name] = event.target.value;
        console.log('this.Product.[this.event.name]'+this.Product[event.target.name]);
        this.isCompleteButton = this.ShowCompleteButton();
        console.log(this.isCompleteButton );
    }
    onMaturityTransferToType(event){
        this.MaturityTransferExisting =false;
        this.MaturityTransferExternal = false;
        this.isErrorMessage = false;
        this.Product.MaturityTransferToType =event.target.value;
        if(this.Product.MaturityTransferToType == 'existing'){
            this.MaturityTransferExisting =true;
        }
        if(this.Product.MaturityTransferToType == 'external'){
            this.MaturityTransferExternal = true;
        }
        this.isCompleteButton = this.ShowCompleteButton();
        console.log(this.isCompleteButton );
    }

    onProfitTransferToType(event){
        this.ProfitTransferExisting =false;
        this.ProfitTransferExternal = false;
        this.isErrorMessage = false;
        this.Product.ProfitTransferToType =event.target.value;
        if(this.Product.ProfitTransferToType == 'existing'){
            this.ProfitTransferExisting =true;
        }
        if(this.Product.ProfitTransferToType == 'external'){
            
            this.ProfitTransferExternal = true;
        }
    }

    onProfitMaturityTransferToType(event){
        this.ProfitMaturityTransferExternal = false;
        this.ProfitMaturityTransferExisting = false;
        this.isErrorMessage = false;
        this.Product.ProfitMaturityTransferToType =event.target.value;
        if(this.Product.ProfitMaturityTransferToType == 'existing'){
            this.ProfitMaturityTransferExisting =true;
        }
        if(this.Product.ProfitMaturityTransferToType == 'external'){    
            this.ProfitMaturityTransferExternal = true;
        }
    }

   

    ShowCompleteButton(){
		console.log('this.Product line 153: '+JSON.stringify(this.Product));
		if(!this.Product ||  (!this.Product.OptionsOnMaturity && !this.Product.WhatToDoWithProfit) ) return false;

		if(this.Product.WhatToDoWithProfit && this.Product.WhatToDoWithProfit=='invest') {
            console.log('line 157');
            return this.MaturityValid();
        }

		if(this.Product.WhatToDoWithProfit && this.Product.WhatToDoWithProfit=='quarterly') return this.MaturityValid() && this.ProfitValid();
		
		return true; 	
	}	

    MaturityValid(){
        
        console.log("MaturityValid");
        console.log('line 165:' +JSON.stringify(this.Product));
	if(!this.Product.MaturityTransferToType) return false;
	
	if(this.Product.MaturityTransferToType == 'existing'){
	    if(!this.Product.MaturityTransferToInternalAccount || 
        (this.Product.MaturityTransferToInternalAccount.toString().length != 8 && isNaN(this.Product.MaturityTransferToInternalAccount))) return false;
	}

	if(this.Product.MaturityTransferToType == 'external'){
        console.log('line 184: '+this.Product.MaturityTransferToExternalSortCode);
	    if(!this.Product.MaturityTransferToExternalAccount || !this.Product.MaturityTransferToExternalSortCode) return false;
	    if(this.Product.MaturityTransferToExternalAccount.toString().length != 8  || this.Product.MaturityTransferToExternalSortCode.toString().length != 6) return false;
	}
	return true;
    }

    ProfitValid(){
        console.log("ProfitValid");
    if(!this.Product.ProfitTransferToType) return false;

    if(this.Product.ProfitTransferToType == 'existing'){
        if(!this.Product.ProfitTransferToInternalAccount || this.Product.ProfitTransferToInternalAccount.toString().length != 8) return false;
    }

    if(this.Product.ProfitTransferToType == 'external'){
        if(!this.Product.ProfitTransferToExternalAccount || !this.Product.ProfitTransferToExternalSortCode) return false;
        if((this.Product.ProfitTransferToExternalAccount.toString().length != 8 && !isNaN(this.Product.ProfitTransferToExternalAccount))|| this.Product.ProfitTransferToExternalSortCode.toString().length != 6) return false;
    }
    return true;
    }

    Complete(){
        console.log('Entering into complete function');
        console.log('this.EventlogId 227: '+this.EventlogId);

        if(!this.EventlogId) return null;                
        // --serviceApplication.LoadShow('Processing...');
        LoadShow('Processing...',this.messageContext);
        
        FTD({eventLogId : this.EventlogId,data: this.Product})
        .then(result=>{
            console.log(JSON.stringify(result));
                if(result.Success)
                {
                    this.SuccessMessage = 'Completed';
                    if(result.URL)
                    {
                        console.log(result.URL.FormatURL());//$window.location.href = result.URL.FormatURL();
                        window.location.href = result.URL.FormatURL();
                    }
                    else
                    {                                
                        console.log('else part LoadHide'); //-- serviceApplication.LoadHide(false);
                        LoadHide(false,this.messageContext);
                    } 
                }
                else
                {
                    console.log('Result not success Load hide'); //---serviceApplication.LoadHide(false);
                    LoadHide(false,this.messageContext);
                this.ErrorMessage = result.Error;
                this.isErrorMessage = true;
                }
            }).catch(error =>{
                serviceApplication.LoadHide(false); 
                this.ErrorMessage = error;
                console.log('JS Catch Load Hide' + JSON.stringify(error)); //---serviceApplication.LoadHide(false);
                LoadHide(false,this.messageContext);
            }
           );
    }

}