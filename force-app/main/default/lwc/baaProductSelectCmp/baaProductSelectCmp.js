import { LightningElement, track, api, wire } from 'lwc';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import GetProductSuitability from '@salesforce/apex/BAA_ProductSelect_Controller.GetProductSuitability';
import fetchCampaignList from '@salesforce/apex/BAA_ProductSelect_Controller_Lightning.fetchCampaignList';
import createApplication from '@salesforce/apex/BAA_ProductSelect_Controller_Lightning.createApplication';
import fetchExistingAccountDetails from '@salesforce/apex/BAA_ProductSelect_Controller_Lightning.fetchExistingAccountDetails';
import GetSettings from '@salesforce/apex/BAA_ProductSelect_Controller.GetSettings';
import {fetchQueryParameters} from 'c/hppUtility';
import {LoadShow,LoadHide} from 'c/caaUtility';
import { MessageContext } from 'lightning/messageService';
import { NavigationMixin } from 'lightning/navigation';




export default class BaaProductSelectCmp extends LightningElement {
    @track organisationTypeList=[];@track organisationSubList=[];@track businessTypeList=[];@track accessList=[];
    @track productList=[];@track settingsList=[];@track validProductList=[];@track filteredProductList =[];
    @track campaignList=[];@track howDidHearList = [];
    @track accountTypeList = ['-- Please Select --','Current Account','Savings Account'];
    noneOptionValue = '--None--';
    depositValue ;
    selectedOrgType;selectedBusinessType;selectedOrgSubType;selectedAccountType;selectedAccessType;
    selectedProductItem;selectedCampaign;selectedHowHear;selectedOrgName;

    isErrorMessage = false;validationMessage = ''; showLoadingSpinner;

    // existing account id 
    accountId;

    // default values

    defaultOrgType;defaultOrgSubType;defaultBusinessType;

    @wire(MessageContext)
    messageContext;

    @wire(getPicklistValuesByRecordType, { objectApiName: 'Account', recordTypeId: '012000000000000AAA' })
    fetchPicklist({error,data}){
        
        if(data && data.picklistFieldValues){
            let optionsValue = {}
            optionsValue["label"] = "--None--";
            optionsValue["value"] = "--None--";
            this.organisationTypeList.push(optionsValue);
            
            data.picklistFieldValues["Organisation_type__c"].values.forEach(optionData => {
                if ( optionData.value == this.defaultOrgType) {
                    this.organisationTypeList.push({label : optionData.label, value : optionData.value,
                        selected:true});
                } else {
                    this.organisationTypeList.push({label : optionData.label, value : optionData.value,
                        selected:false});
                }
                
            });

            this.businessTypeList.push(optionsValue);
            data.picklistFieldValues["Business_Type__c"].values.forEach(optionData => {
                if ( optionData.value == this.defaultBusinessType) {
                    this.businessTypeList.push({label : optionData.label, value : optionData.value,
                        selected:true});
                } else {
                    this.businessTypeList.push({label : optionData.label, value : optionData.value,
                        selected:false});
                }
            });
            this.dependentPicklist = data.picklistFieldValues["Organisation_sub_type__c"];
            let controllerValues = this.dependentPicklist.controllerValues;

            this.dependentPicklist.values.forEach(depVal => {
                depVal.validFor.forEach(depKey =>{
                    

                    if ( this.defaultOrgSubType == depKey ) {
                        this.organisationSubList.push( 
                            {label : depVal.label, value : depVal.value,
                                selected:true}
                                 );
                    } else {
                        if ( this.defaultOrgType ) {
                            let controllerValues = this.dependentPicklist.controllerValues;

                            console.log ('controllerValues' + controllerValues);
                            if(depKey === controllerValues[this.defaultOrgType]){
                                this.dependentDisabled = false;
                                this.showdependent = true;
                                this.organisationSubList.push({label : depVal.label, value : depVal.value, selected:false});
                            }
                        }
                        
                    }
                });
                 
            });
            this.showOrgTypeList = true;
            console.log(' organisation type '+JSON.stringify( this.organisationTypeList));
        }
        else if(error) {
            console.log('errorin organisation type '+JSON.stringify(error));
        }

        if ( this.defaultOrgType ) {

        }
    }

    @wire(getPicklistValuesByRecordType, { objectApiName: 'Opportunity', recordTypeId: '012D0000000QnZz' })
    fetchOppPicklist({error,data}){
        
        if(data && data.picklistFieldValues){
            let optionsValue = {}
            optionsValue["label"] = "--None--";
            optionsValue["value"] = "--None--";
            this.howDidHearList.push(optionsValue);
            
            data.picklistFieldValues["How_did_you_hear_about_IBB__c"].values.forEach(optionData => {
                this.howDidHearList.push({label : optionData.label, value : optionData.value});
            });

            
        }
        else if(error) {
            console.log('error in How_did_you_hear_about_IBB__c '+JSON.stringify(error));
        }
    }

    connectedCallback  () {

        GetProductSuitability()
        .then(result=>{
           
                if (result ) {
                   this.productList = result;
                    console.log ('this.productList', JSON.stringify (this.productList));
                }else{
                    console.log('fetch productList failed '); 
                }
            }).catch(error =>{
			   console.log('fetch productList failed '+ JSON.stringify(error)); 
           }
           );

        GetSettings()
        .then(result=>{
           
                if (result ) {
                   this.settingsList = result;
                    console.log ('this.settingsList', JSON.stringify (this.settingsList));
                }else{
                    console.log('fetch settingsList failed '); 
                }
            }).catch(error =>{
			   console.log('fetch settingsList failed '+ JSON.stringify(error)); 
           }
           );

           fetchCampaignList()
        .then(result=>{
           
                if (result ) {
                   this.campaignList = result;
                   for ( var i = 0; i< result.length ; i++ ) {
                       this.campaignList[i].Name = result[i].Name;
                       this.campaignList[i].Id = result[i].Id;
                   }
                    console.log ('this.campaignList', JSON.stringify (this.campaignList));
                }else{
                    console.log('fetch campaignList failed '); 
                }
            }).catch(error =>{
			   console.log('fetch campaignList failed '+ JSON.stringify(error)); 
           }
           );           

           let urlParams = fetchQueryParameters();
            
           if ( urlParams['AccountId']) {
               this.accountId =  urlParams['AccountId'];
                        fetchExistingAccountDetails({
                            accountId :this.accountId
                        }).then(result=>{
                
                        if (result ) {
                            console.log ('result', JSON.stringify (result));
                            if (result.Name ) {
                                this.template.querySelector ('[data-id="orgnamefield"]').value = result.Name;
                                this.selectedOrgName = this.template.querySelector ('[data-id="orgnamefield"]').value;
                            }
                            if (result.Organisation_type__c ) {
                                let orgTypeValue = result.Organisation_type__c;
                                this.defaultOrgType = orgTypeValue;
                                this.selectedOrgType = orgTypeValue;
                            }
                            if (result.Organisation_sub_type__c ) {
                                let orgSubTypeValue = result.Organisation_sub_type__c;
                                this.defaultOrgSubType = orgSubTypeValue;
                                this.selectedOrgSubType = orgSubTypeValue;
                            }
                            if (result.Business_Type__c ) {
                                let businessTypeValue = result.Business_Type__c;
                                this.defaultBusinessType = businessTypeValue;
                                this.selectedBusinessType = businessTypeValue;
                            }
                            
                        }else{
                            console.log('fetch Account details failed '); 
                        }
                    }).catch(error =>{
                    console.log('fetch Account details failed '+ JSON.stringify(error)); 
                    }
                );

           }
          


    }

    handleOrganisationTypeChange(event){
        
        this.validProductList = [];
        this.organisationSubList=[];
        this.showdependent = false;
        const selectedVal = event.target.value;
        console.log ('selectedVal' + selectedVal);
        this.selectedOrgType = selectedVal;
        if ( this.selectedOrgType == '--None--') {
            this.validProductList = [];
        }
        this.selectedOrgSubType = "--None--";
        this.organisationSubList.push({label : "--None--", value : "--None--"})
        let controllerValues = this.dependentPicklist.controllerValues;
        console.log ('controllerValues' + controllerValues);
        this.dependentPicklist.values.forEach(depVal => {
            depVal.validFor.forEach(depKey =>{
                console.log ('depKey' + selectedVal);
                console.log ('selected' + controllerValues[selectedVal]);
                if(depKey === controllerValues[selectedVal]){
                    this.dependentDisabled = false;
                    this.showdependent = true;
                    this.organisationSubList.push({label : depVal.label, value : depVal.value});
                    
                }
            });
             
        });
        const subtype = this.template.querySelector('[data-id="organisationsubfield"]');
        subtype.selectedIndex = [...subtype.options].findIndex(option => option.value === '--None--');
        this.filteredProductList =[];
        this.processValidProductList();
        if(this.depositValue){
            this.template.querySelector('[data-id="depositfield"]').value = '';
        }
        
    }
   

    processValidProductList () {
       console.log('productList' + JSON.stringify(this.productList)); 
        let validProduct = this.productList.filter((x)=>{
            
            if( this.selectedAccountType && this.selectedAccountType.toLowerCase().includes(x.Category) && 
                x.Access == this.selectedAccessType)
            return true;
            else
            return false;
        });

        if(!validProduct) return [];


        this.validProductList = [];
        for(let i = 0; i < validProduct.length; i++){
            var id = validProduct[i].SuitId;
            
            for(let s = 0; s < this.settingsList.length; s++)
            {
                var setting = this.settingsList[s];
            
                if(setting.Suitability_Id__c == id && setting.Organisation_Type__c == this.selectedOrgType){
                    if ( validProduct[i].MinDeposit > 0) {
                        validProduct[i].showCurrency = '£'+validProduct[i].MinDeposit;
                    } else {
                        validProduct[i].showCurrency = 0;
                    }
                    this.validProductList.push(validProduct[i]);
                }
                
            }
        }
        console.log('this.validProductList' + this.validProductList); 
    }

    handleOrgSubTypeChange ( event ) {
        this.selectedOrgSubType = event.target.value;
        if(this.depositValue){
            this.template.querySelector('[data-id="depositfield"]').value = '';
        }
    }

    handleBusinessTypeChange  ( event ) {
        this.selectedBusinessType = event.target.value;
    }

    handleAccountTypeChange  ( event ) {
        this.filteredProductList =[];
        this.validProductList = [];
        this.accessList = [];
        this.accessList.push ('-- Please Select --');
        this.selectedAccountType = event.target.value;
        if ( !(this.selectedAccountType == '-- Please Select --')) {
            if ( this.selectedAccountType =='Current Account') {
                this.accessList.push ('Instant');
            } else if (this.selectedAccountType =='Savings Account') {
                this.accessList.push ('Instant');
                this.accessList.push ('Notice');
            }
            this.processValidProductList ();
            if(this.depositValue){
                this.template.querySelector('[data-id="depositfield"]').value = '';
                
            }
        } else {
            this.accessList = [];
        }
        
    }

    handleDepositChange ( event ) {
        
        this.depositValue = event.target.value;        
	   this.populateProductName(this.depositValue);
        console.log ('this.validProductList' + this.filteredProductList);
    }
    populateProductName(depositVal){
        this.filteredProductList = [];
        this.filteredProductList.push ('-- Please Select --');
        console.log('pop prod name'+JSON.stringify(this.validProductList));
        for(var i = 0; i < this.validProductList.length; i++){
            if (this.template.querySelector('[data-id="' + this.validProductList[i].Name + '"]')) {
                if ( Math.round(this.validProductList[i].MinDeposit * 100) > Math.round(depositVal * 100)) {
                    this.template.querySelector('[data-id="' + this.validProductList[i].Name + '"]').classList.add('redStyleClass');
                } else {
                    this.template.querySelector('[data-id="' + this.validProductList[i].Name + '"]').classList.remove('redStyleClass');
                        for(var s = 0; s < this.settingsList.length; s++){
                            var setting = this.settingsList[s];
                        
                            if(setting.Suitability_Id__c == this.validProductList[i].SuitId && setting.Organisation_Type__c == this.selectedOrgType){
                                if ( this.validProductList[i].MinDeposit > 0) {
                                    this.validProductList[i].showCurrency = '£'+this.validProductList[i].MinDeposit;
                                } else {
                                    this.validProductList[i].showCurrency = 0;
                                }
                                this.filteredProductList.push(this.validProductList[i]);
                            }
                            
                    }
                    
                }    
            }
                    
        }
    }

    handleOrgNameChange ( event ) {
        if ( this.template.querySelector('[data-id="orgnamefield"]') ) {
            this.selectedOrgName =this.template.querySelector('[data-id="orgnamefield"]').value;
        }
    }

    handleAccessChange  ( event ) {
        this.selectedAccessType = event.target.value;
        console.log ('this.selectedAccessType' + this.selectedAccessType);
        if ( this.selectedAccessType == '-- Please Select --') {
            this.accessList.push ('');
        } else {
            this.processValidProductList ();
            console.log('access deposit'+this.depositValue);
            if(this.depositValue){
                this.filteredProductList = [];
                this.template.querySelector('[data-id="depositfield"]').value = '';
            }
        }

        
    }

    handleProductSelection ( event ) {
        if ( event.target.value != '-- Please Select --') {
            this.selectedProductItem = event.target.value;
            console.log ('this.selectedProductItem' + this.selectedProductItem);
        }
        
    }

    get showProductTable () {
        return (this.selectedAccessType && this.selectedAccountType );
    }

    

    handleCampaignSelection ( event ) {
        if ( event.target.value != '--None--') {
            this.selectedCampaign = event.target.value;
            console.log ('this.selectedCampaign' + this.selectedCampaign);
        }
        
    }

    handleHowHearSelection ( event ) {
        if ( event.target.value != '--None--') {
            this.selectedHowHear = event.target.value;
            console.log ('this.selectedCampaign' + this.selectedHowHear);
        }
        
    }
    get showNextButton () {        
        return (this.selectedProductItem && this.selectedOrgType && this.selectedCampaign && this.selectedHowHear && 
            this.selectedOrgName);
    }

    // handle next button - form submission for the application creation 
    handleNextButton () {
        
        this.showLoadingSpinner = true;
        let npaaInputObj = {};
        
          if ( this.accountId ) {
            npaaInputObj.existingAccountId = ''+this.accountId;
          }
          
          npaaInputObj.selectedOrgType = ''+this.selectedOrgType;
          npaaInputObj.selectedBusinessType = ''+this.selectedBusinessType;
          npaaInputObj.selectedOrgSubType = ''+this.selectedOrgSubType;
          npaaInputObj.selectedAccountType = ''+this.selectedAccountType;
          npaaInputObj.selectedAccessType = ''+this.selectedAccessType;
          npaaInputObj.selectedProductItem = ''+this.selectedProductItem;
          npaaInputObj.selectedCampaign = ''+this.selectedCampaign;
          npaaInputObj.selectedHowHear = ''+this.selectedHowHear;
          npaaInputObj.selectedOrgName = ''+this.selectedOrgName;
		  
		  
          //let npaaInputJson = JSON.parse (npaaInputObj);
         
         createApplication({
                    wrapperObj :JSON.stringify ( npaaInputObj )
                })
                .then(result=>{
        
                if (result ) {
                    console.log('NPAA App result from apex  ', JSON.stringify(result));
                    console.log('result.pageMessage  ', result.pageMessage);

                    if ( result.pageMessage != null) {
                       
                        this.isErrorMessage = true;
                        this.validationMessage = result.pageMessage;
                    }

                    if ( result ) {
                        this.showLoadingSpinner = false;
                        if ( result.Applicant.Opportunity__c ) {
                             var oppId = result.Applicant.Opportunity__c
                             window.location = '/apex/HPPEventRedirect?oppid=' + oppId;
                        }
                           
                    }
                }
        
                else{
                    console.log('Result not success Load hide'); 
                
                }
                }).catch(error =>{
					this.ErrorMessage = JSON.stringify(error);        
                }
                );
                
    }
}