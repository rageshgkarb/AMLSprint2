import { LightningElement, api, track } from 'lwc';
import fetchEventDetails from "@salesforce/apex/BAA_Applicant_Complete_Ltng_Controller.fetchEventDetails";
import fetchWrapper from '@salesforce/apex/BAA_Applicant_Complete_Ltng_Controller.getWrapper';
import Complete from '@salesforce/apex/BAA_Applicant_Complete_Ltng_Controller.Complete';

export default class BaaApplicantCompleteCmp extends LightningElement {

    showCompleteButton = false;isCompleted = false;
    @api eventId; @api opportunityId;showNavigationCmp = false;
    showLoadingSpinner = false;

    @track baseOppId;@track wrap;@track baseOpportunity;
    
    connectedCallback () {
        //value={opp.General_comments_box__c}

        fetchEventDetails({
            eventId :this.eventId
            }).then(result=>{

            if (result ) {
                console.log ('result', JSON.stringify (result));  
                this.showNavigationCmp = true;
                if ( result.Opportunity__c ) {
                    this.opportunityId = result.Opportunity__c;
                } 
                if ( result.Event__c) {
                   // this.eventRecordId = result.Event__c;
                }
                if ( result.EventStatus__c !='Open') {
                    this.isCompleted = true;
                }                         
            }else{
                console.log('fetch Event details Failed '); 
            }
            }).catch(error =>{
            console.log('fetch Account details failed '+ JSON.stringify(error)); 
        }
        );

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

    handleCompleteButton () {
        var generalComment = '';
        if ( this.template.querySelector ('[data-id="generalcommentsfield"]') ) {
            generalComment = this.template.querySelector ('[data-id="generalcommentsfield"]').value;
        }
        
        
        this.showLoadingSpinner = true;
        console.log(JSON.stringify(this.wrap));
			Complete({evnId:this.eventId,opportId:this.opportunityId, comment:generalComment}).then(result =>{
				console.log(result);
                this.showLoadingSpinner = false;
				window.location.href = result;
			}).catch(error =>{
				console.log(error);
			});
    }
}