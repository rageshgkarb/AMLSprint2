import { LightningElement, track, wire, api } from 'lwc';
import fetchOpportunityDetails from "@salesforce/apex/BAA_Product_Specific_Ltng_Controller.fetchOpportunityDetails";
import fetchApplicantList from "@salesforce/apex/BAA_Product_Specific_Ltng_Controller.fetchApplicantList";
import handleSaveApplicant from "@salesforce/apex/BAA_Product_Specific_Ltng_Controller.handleSaveApplicant";
import fetchWrapper from '@salesforce/apex/BAA_Product_Specific_Ltng_Controller.getWrapper';
import Complete from '@salesforce/apex/BAA_Product_Specific_Ltng_Controller.Complete';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';


export default class BaaProductSpecificCmp extends LightningElement {

    @api eventId;@api opportunityId; @track baseOpportunity;
    @track applicantList = []; @track mandateSignList=[]; @track mandateCompulSignList = [];@track accountList=[];

    @track baseOppId;@track wrap;@track currentOpportunity={};

    // Show hide attributes for Product Specific Page
    showCompulSign = false;showHowManyField= false;showCardSection = false;
    showLoadingSpinner = false;isErrorMessage= false;
    progress =10;disableCompleteButton = true;showSuccessMessage= false;

    // Selected attributes
    selectedAccount;selectedMandateCmpSign;selectedSignRequired;
    // default attributes for applicant
    defaultSignReq;defaultCmpSign;defaultAccount; defaultHowManySpec;defaultMandate;defaultMandateUnlimited;

    successMessage;

    
    

    connectedCallback () {
        console.log('this.opportunityId '+this.opportunityId);
        

        

        console.log ('this.accountList' + this.accountList);

        
        
        fetchWrapper({evnId:this.eventId,opportId:this.opportunityId}).then(result=>{
            console.log('fetching wrapper==> '+JSON.stringify(result));
            this.wrap = result;
            this.baseOpportunity= result.BaseOpportunity;
            this.baseOppId=this.baseOpportunity.Id;            
            this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
        }).catch(error =>{
            console.log(error);
        });

    }

    @wire(getPicklistValuesByRecordType, { objectApiName: 'Opportunity', recordTypeId: '012D0000000QnZz' })
    fetchOppPicklist({error,data}){
        
        if(data && data.picklistFieldValues){
            let optionsValue = {}
            optionsValue["label"] = "--None--";
            optionsValue["value"] = "--None--";
            this.mandateSignList.push(optionsValue);
            this.mandateCompulSignList.push ( optionsValue );
            console.log('this.baseOpportunity==> '+this.baseOpportunity);

            fetchOpportunityDetails({
                opportunityId: this.opportunityId
                }).then(result=>{
    
                if (result ) {
                    console.log ('this.oppty result', JSON.stringify (result));   
                    if ( result) {
                        this.defaultSignReq	= result.Mandate_Signature__c;
                        this.defaultHowManySpec	= result.Mandate_How_Many_Signatures__c;
                        this.defaultCmpSign	= result.Mandate_Compulsory_Signature__c;
                        this.defaultAccount =result.Mandate_Compulsory_Signature_Account__c;
    
                        console.log('this.defaultSignReq==> '+this.defaultSignReq);
                        console.log('this.defaultCmpSign==> '+this.defaultCmpSign);
                        console.log('this.defaultHowManySpec==> '+this.defaultHowManySpec);
                        console.log('this.defaultAccount==> '+this.defaultAccount);
                        console.log('inside wire this.defaultSignReq==> '+this.defaultSignReq);
                        console.log('inside wire this.defaultCmpSign==> '+this.defaultCmpSign);

                        if ( this.defaultSignReq ) {
                            if ( this.defaultSignReq == 'More than two signatures') {
                                this.showHowManyField = true;
                                
                            } else {
                                this.showHowManyField = false;
                            }
                            if ( this.defaultSignReq =='Any one signature' ) {
                                this.showCardSection = true;
                            } else {
                                this.showCardSection = false;
                            }
                    
                            this.selectedSignRequired = this.defaultSignReq;
                        }

                        if ( this.defaultCmpSign ) {
                            if ( this.defaultCmpSign == 'Yes') {
                                this.showCompulSign = true;
                            } else {
                                this.showCompulSign = false;
                            }
                            
                            this.selectedMandateCmpSign = this.defaultCmpSign;
                        }

                        fetchApplicantList({
                            opportunityId: this.opportunityId
                            }).then(result=>{
                
                            if (result ) {
                                console.log ('this.applicantList result', JSON.stringify (result));  
                                this.applicantList = result; 
                                if ( this.applicantList ) {
                                    for ( var i=0;i< this.applicantList.length;i++ ) {
                                        var appData = this.applicantList[i];
                                        
                                        if( this.defaultAccount ) {
                                            console.log('appData.accountId ' + appData.accountId); 
                                            console.log('this.defaultAccount ' + this.defaultAccount); 
                                            if ( appData.accountId == this.defaultAccount) {
                                                console.log('selected ' + appData.fullname); 
                                                this.accountList.push({label : appData.fullname, value : appData.accountId,
                                                    selected:true});
                                            } else {
                                                console.log('not selected ' + appData.fullname); 
                                                this.accountList.push({label : appData.fullname, value : appData.accountId,
                                                    selected:false});
                                            }
                                        }
                                        else {
                                            this.accountList.push({label : appData.fullname, value : appData.accountId,
                                                selected:false});
                                        }
                                        
                                    }
                                    
                                }
                                console.log('this.accountList ' + this.accountList); 
                                                   
                            }else{
                                console.log('fetch Event details Failed '); 
                            }
                            }).catch(error =>{
                            console.log('fetch Account details failed '+ JSON.stringify(error)); 
                        }
                
                        
                        );

                        

                        
           
            
            data.picklistFieldValues["Mandate_Signature__c"].values.forEach(optionData => {
                if ( optionData.value == this.defaultSignReq) {
                    this.mandateSignList.push({label : optionData.label, value : optionData.value,
                        selected:true});
                } else {
                    this.mandateSignList.push({label : optionData.label, value : optionData.value,
                        selected:false});
                }
            });
            data.picklistFieldValues["Mandate_Compulsory_Signature__c"].values.forEach(optionData => {
                //this.mandateCompulSignList.push({label : optionData.label, value : optionData.value});
                if ( optionData.value == this.defaultCmpSign) {
                    this.mandateCompulSignList.push({label : optionData.label, value : optionData.value,
                        selected:true});
                } else {
                    this.mandateCompulSignList.push({label : optionData.label, value : optionData.value,
                        selected:false});
                }
            });

            console.log(' this.mandateSignList '+JSON.stringify( this.mandateSignList));
            console.log(' this.mandateCompulSignList '+JSON.stringify( this.mandateCompulSignList));
                        
                    }                         
                }else{
                    console.log('fetch Event details Failed '); 
                }
                }).catch(error =>{
                console.log('fetch Account details failed '+ JSON.stringify(error)); 
            }
            );

        }
        else if(error) {
            console.log('error in Mandate_Signature__c '+JSON.stringify(error));
        }

        
        
    }
    
    renderedCallback() {
        console.log ('this.defaultHowManySpec' + this.defaultHowManySpec);
        if ( this.defaultHowManySpec ) {
            this.template.querySelector ('[data-id="howmanysignfield"]').value = this.defaultHowManySpec;
        }
    }

    handleMandateSelection ( event ) {
        var selectedVal = event.target.value;
        if ( selectedVal == 'More than two signatures') {
            this.showHowManyField = true;
        } else {
            this.showHowManyField = false;
        }
        if ( selectedVal =='Any one signature' ) {
            this.showCardSection = true;
        } else {
            this.showCardSection = false;
        }

        this.selectedSignRequired = selectedVal;

    }

    handleMandateCmpSelection ( event ) {
        var selectedVal = event.target.value;
        if ( selectedVal == 'Yes') {
            this.showCompulSign = true;
        } else {
            this.showCompulSign = false;
        }
        this.selectedMandateCmpSign = selectedVal;
    }

    handleSaveButton () {
        this.showLoadingSpinner = true;
        var mandatesignfield='';var howmanysignfield='';var mandateCmpsignfield='';var selectedaccountfield='';
        if ( this.template.querySelector ('[data-id="mandatesignfield"]') ) {
            mandatesignfield = this.template.querySelector ('[data-id="mandatesignfield"]').value;
        }
        if ( this.template.querySelector ('[data-id="howmanysignfield"]') ) {
            howmanysignfield = this.template.querySelector ('[data-id="howmanysignfield"]').value;
        }
        if ( this.template.querySelector ('[data-id="mandateCmpsignfield"]') ) {
            mandateCmpsignfield = this.template.querySelector ('[data-id="mandateCmpsignfield"]').value;
        }
        if ( this.template.querySelector ('[data-id="selectedaccountfield"]') ) {
            selectedaccountfield = this.template.querySelector ('[data-id="selectedaccountfield"]').value;
        }
        
        let applicantOppObj = {};        
        
        applicantOppObj.opportunityId = this.opportunityId;
        applicantOppObj.mandatesignfield = mandatesignfield;
        applicantOppObj.howmanysignfield = howmanysignfield;
        applicantOppObj.mandateCmpsignfield = mandateCmpsignfield;
        applicantOppObj.selectedaccountfield = selectedaccountfield;
        console.log ('applicantOppObj' + JSON.stringify ( this.applicantOppObj ));
        console.log ('Final JSON applicant list' + JSON.stringify ( this.applicantList ));
        // String opptyWrapper, String applicantWrapper
        handleSaveApplicant({
            opptyWrapper :JSON.stringify ( applicantOppObj ),
            applicantWrapper:JSON.stringify ( this.applicantList )
        })
        .then(result=>{

        if (result ) {
            console.log(' save applicant result from apex  ', JSON.stringify(result));
            if ( result.successMessage  ) {
                this.showSuccessMessage = true;
                this.successMessage = 'Details Saved Successfully, Please complete the event';
                this.progress = 100;
                this.showLoadingSpinner = false;
                this.disableCompleteButton = false;
            }
            
            if ( result.pageMessage ) {
                this.isErrorMessage = true;
                this.showLoadingSpinner = false;
                this.validationMessage = result.pageMessage;
            }

        }else{
            console.log('Result not success Load hide'); 
        
        }
        }).catch(error =>{
            this.ErrorMessage = JSON.stringify(error);
            this.isErrorMessage = true;

        }
        );


    }

    handleCompleteButton () {
        this.showLoadingSpinner = true;
        this.showSuccessMessage = false;
        console.log(JSON.stringify(this.wrap));
			Complete({evnId:this.eventId,opportId:this.opportunityId}).then(result =>{
				console.log(result);
                this.showLoadingSpinner = false;
				window.location.href = result;
			}).catch(error =>{
				console.log(error);
			});
    }

    handleAccountSelection ( event ) {
        var selectedAccount = event.target.value;
        if ( selectedAccount !='--None--') {
            this.selectedAccount = selectedAccount;
        }
    }

    handleHasMandateChange ( event ) {

        console.log(' selected value ',event.target.checked);
        console.log('selected index =', event.target.dataset.index);
        this.applicantList[event.target.dataset.index].HasMandate = event.target.checked;
        console.log('updated list', this.applicantList);

    }
    handleMandateLimitChange ( event ) {
        console.log(' selected value ',event.target.value);
        console.log('selected index =', event.target.dataset.index);
        this.applicantList[event.target.dataset.index].MandateLimit = event.target.value;
        console.log('updated list', this.applicantList);
        
    }
    handleMandateUnlimitedChange ( event ) {
        console.log(' selected value ',event.target.checked);
        console.log('selected index =', event.target.dataset.index);
        this.applicantList[event.target.dataset.index].MandateUnlimited = event.target.checked;
        console.log('updated list', this.applicantList);
        
    }
    handleHasCardChange ( event ) {
        console.log(' selected value ',event.target.checked);
        console.log('selected index =', event.target.dataset.index);
        this.applicantList[event.target.dataset.index].HasCard = event.target.checked;
        console.log('updated list', this.applicantList);
        
    }
    handleHasCardNameChange ( event ) {
        console.log(' selected value ',event.target.value);
        console.log('selected index =', event.target.dataset.index);
        this.applicantList[event.target.dataset.index].cardName = event.target.value;
        console.log('updated list', this.applicantList);
        
    }
}