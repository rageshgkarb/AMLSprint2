import { LightningElement,track,api,wire } from 'lwc';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_SetUpFinance1_LightningController.getWrapper';
import getDetails from '@salesforce/apex/BAA_SetUpFinance1_LightningController.getDetails';
import ContinueToEBS from '@salesforce/apex/BAA_SetUpFinance1_LightningController.ContinueToEBS';
export default class BAA_SetUpFinance1Lwc extends LightningElement {
 @track BaseOpportunity;
    @api eventId;
    @api oppId;
    parameters;
    @track wrap;
    @track prod;
    baseOppId;
    detailWrap;
    thePrimeApp;
    theSecondaryAccountHolders;
    validBool=true;
    Relationships;

     connectedCallback(){
        //ng-init="OnInit('{!$Setup.pca__PostcodeAnywhereSettings__c.pca__Key__c}')"
        this.parameters = getParameters();
        console.log("parameters="+JSON.stringify( this.parameters));
        this.eventId = this.parameters.id;
        this.oppId = this.parameters.oppId;
        console.log(this.eventId);
                     console.log("oppID="+this.oppId);

        wrapper({evnId:this.eventId,opportId:this.oppId}).then(result=>{
            console.log("wrapper result="+JSON.stringify(result));
            this.wrap = result;
            this.prod=this.wrap.Prod;
           // this.IsCompleted=this.wrap.IsCompleted;
            this.BaseOpportunity= result.BaseOpportunity;
           // this.Account=result.Accounts;
           this.baseOppId=this.BaseOpportunity.Id;
           console.log('baseopp=',result.BaseOpportunity);
             console.log("callin cgd");
            this.callgetDetails();
            this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
        }).catch(error =>{
            console.log(error);
        });

        
        
        console.log('end ccb');
    }

    callgetDetails(){
                console.log('in cgd');
        getDetails({Prod:this.prod,opportId:this.baseOppId})
        .then(result=>{
            this.detailWrap=result;
            console.log('detailWrap=',JSON.stringify(this.detailWrap));
            this.thePrimeApp=this.detailWrap.thePrimaryApplicant.Prospect_Customer__r.Name;
            console.log('thePrimeApp=',this.detailWrap.thePrimaryApplicant.Prospect_Customer__r.Name);
            this.theSecondaryAccountHolders=this.detailWrap.theSecondaryAccountHolders;
            console.log('theSecondaryAccountHolders=',this.theSecondaryAccountHolders);
            this.Relationships=this.detailWrap.getRelationships;
            console.log('Relationships=',this.Relationships);
        }).catch(error=>{
            console.log('error=',JSON.stringify(error));
        });
    }

    handleRelationshipChange(event){
        let id=event.target.dataset.opid;
        console.log('id=',id);
        console.log(event.target.value);
        this.theSecondaryAccountHolders.forEach(item => {
            if(item.Id==id){
                item.Relationship_To_Primary_Applicant1__c=event.target.value;
                console.log('item.Relationship_To_Primary_Applicant1__c=',item.Relationship_To_Primary_Applicant1__c);
            }
        });
        
       console.log(window.location.origin);
    }

    handleSaveClick(event){
       // event.preventDefault();   
       this.validBool=true;
        console.log(event.detail.fields)
       
        
        
   }
    handleSuccess(){
        console.log('in success');
        if(this.theSecondaryAccountHolders){
            this.theSecondaryAccountHolders.forEach(item => {
                console.log('item.Relationship_To_Primary_Applicant1__c=',item.Relationship_To_Primary_Applicant1__c)
                    if(item.Relationship_To_Primary_Applicant1__c==undefined||item.Relationship_To_Primary_Applicant1__c==' '){
                        console.log('in if');
                        this.validBool=false;
                    
                        let inputText=this.template.querySelector("."+item.Id);
                            inputText.setCustomValidity( "This field is required/mandatory" );
                            console.log(inputText.checkValidity());
                            inputText.reportValidity();
                    }
                });
        }
        if(this.validBool==true){
            ContinueToEBS({theSecondaryAccountHolders:this.theSecondaryAccountHolders})
            .then(result=>{
                 window.location.href=window.location.origin+"/apex/BAA_SetUpFinance2?oppId="+this.baseOppId;
            }).catch(error=>{
                console.log('error=',error);
            })
        }
    }


}