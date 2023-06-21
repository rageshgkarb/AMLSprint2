import {LightningElement, api,track}from 'lwc';
import {ShowToastEvent}from 'lightning/platformShowToastEvent';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.getWrapper';
import SubmitToDe from "@salesforce/apex/BAA_Application_Signed_Controller_Ltng.SubmitToDe";
import complete from "@salesforce/apex/BAA_Application_Signed_Controller_Ltng.complete";
export default class BaaApplicationSignedLwc extends LightningElement {
  @api EventId;
  @api oppId;
  @api acc;
 
  parameters;
    @track wrap;
  
	responseMessage;
	isLoading = false;
	discmpevent = true;
	connectedCallback() {
		console.log('EventId@@@', this.EventId);
		console.log('oppIdd@@@', this.oppId);
		console.log('acc@@@', this.acc);
		// this.completeEvent();
		wrapper({
			evnId: this.EventId,
			opportId: this.oppId
		}).then(result => {
			console.log(result);
			 this.wrap = result;
			//  this.BaseOpportunity= result.BaseOpportunity;
			this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
			this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.EventId, result.BaseOpportunity.Id, result.BaseOpportunity.ProductEventDirector__c);
		}).catch(error => {
			console.log(error);
		});
	}



	SubmitToDe() {
		this.isLoading = true;
		SubmitToDe({
			eventId: this.EventId
		}).then((result) => {
			console.log('@resSub', result);
			if(result.isError) {
				this.isLoading = false;
				//   alert(result.message);
				this.responseMessage = result.message;
			} else {
				this.isLoading = false;
				//  alert(result.message);
				this.responseMessage = result.message;
				this.discmpevent = false;
			}
		}).catch((error) => {
			this.isLoading = false;
			alert('Unknow Error');
			console.log('err', error);
			/*  this.dispatchEvent(
			    new ShowToastEvent({
			      title: "Error",
			      message: "Loading Failed. Please try again later.",
			      variant: "error",
			      mode: "dismissable"
			    })
			  ); */
			// this.closeQuickAction();
			//return false;
		});
	}




/*
	 completeEvent() {
		this.isLoading = true;
		completeEvent({
			eventId: this.EventId,
			oppId: this.oppId,
			Acc: this.acc
		}).then((result) => {
			if(result) {
				if(result.isCreateEvent) {
					window.location.href = result.NextEventUrl;
				} else {
					alert('Error in creating event, Please try again');
				}
			}
		}).catch((error) => {
			console.log('Error in complete', error);
		});
	}  */

	 onComplete(){
		 this.isLoading = true;
		 console.log('wrap', this.wrap);
        console.log(JSON.stringify(this.wrap));
        complete({wrap:this.wrap}).then(result =>{
			this.isLoading = false;
            console.log(result);
            window.location.href = result;
        }).catch(error =>{
			this.isLoading = false;
            console.log(error);
        });
    }
        
    
}