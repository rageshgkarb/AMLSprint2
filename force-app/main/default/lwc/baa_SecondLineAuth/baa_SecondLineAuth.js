import { LightningElement, api, wire, track } from 'lwc';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr_Ltng.getWrapper';
import LoadEvent from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr_Ltng.LoadEvent';
import complete from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr_Ltng.Complete';

export default class Baa_SecondLineAuth extends LightningElement {

    //@api EventId;@api SessionId; 
    baseOppId;
    @track BaseOpportunity;
    @api eventId; @api SessionId;
    @api oppId;
    parameters;
    @track wrap;
    showHeader =false;
    baseOppId;
    IsCompleted;

    connectedCallback(){
        //ng-init="OnInit('{!$Setup.pca__PostcodeAnywhereSettings__c.pca__Key__c}')"
        this.parameters = getParameters();
        console.log(this.parameters);
        this.eventId = this.parameters.id;
        this.oppId = this.parameters.oppId;
        this.IsCompleted=false;
        console.log(this.eventId);

        wrapper({evnId:this.eventId,opportId:this.oppId}).then(result=>{
            console.log(result);
            this.wrap = result;
            this.BaseOpportunity= result.BaseOpportunity;
            this.baseOppId=this.BaseOpportunity.Id;
            this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
            this.getLoadEvent();
        }).catch(error =>{
            console.log(error);
        });

        
    }
   
    getLoadEvent(){
        console.log('this.eventId##'+this.eventId);
        LoadEvent({eventId:this.eventId})
        .then((result) => {
            this.IsCompleted=result;
            console.log('result ***** js',JSON.stringify (result));
            console.log('result ***** js',result);
               
    })
    .catch((error) => {
        console.log('Error', error);
    });
    }


    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }
    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
        this.onComplete();
    }

    onComplete(){
        console.log('this.eventId'+this.eventId);
        console.log('opportId:this.oppId'+this.baseOppId);
        complete({evnId:this.eventId,opportId:this.baseOppId}).then(result =>{
            console.log(result);
            window.location.href = result;
        }).catch(error =>{
            console.log(error);
        });
    }
}