import {LightningElement, track, api}from 'lwc';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_WelcomeLetterController_Ltng.getWrapper';
import CreateDoc from '@salesforce/apex/BAA_WelcomeLetterController_Ltng.CreateDoc';
import complete from '@salesforce/apex/BAA_WelcomeLetterController_Ltng.complete';
export default class BaaWelcomeLetterlwc extends LightningElement {
    @track wrap
    @api EventId;
    @api oppId;
	parameters;
	isLoading = false;
	WelcomeLetterLink;
	checkboxone;
	checkboxtwo;
	connectedCallback() {
		console.log('eventId', this.EventId);
		console.log('oppId', this.oppId);
		wrapper({
			evnId: this.EventId,
			opportId: this.oppId
		}).then(result => {
			//  console.log(result.WelcomeLetterCreated);
			this.wrap = result;
			this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
			this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.EventId, result.BaseOpportunity.Id, result.BaseOpportunity.ProductEventDirector__c);
			//  console.log('wrap',this.wrap);
		}).catch(error => {
			console.log(error);
		});
	}
	CreateDoc() {
		if(this.checkboxone && this.checkboxtwo) {
			this.isLoading = true;
			CreateDoc({
				opp: this.oppId,
				imageSetUp: this.checkboxone,
				authLevelSetup: this.checkboxtwo
			}).then(result => {
				if(result) {
					this.WelcomeLetterLink = result;
					this.isLoading = false;
				} else {
					this.isLoading = false;
					console.log('Welcome letter link not found');
				}
			}).catch(error => {
				console.log(error);
				this.isLoading = false;
			});
		} else {
			alert('Please check all boxes if you want to proceed');
		}
	}
	onComplete() {
		this.isLoading = true;
		console.log(JSON.stringify(this.wrap));
		complete({
			wrap: this.wrap
		}).then(result => {
			this.isLoading = false;
			console.log(result);
			window.location.href = result;
		}).catch(error => {
			console.log(error);
			this.isLoading = false;
		});
	}
	handleChange1(event) {
		this.checkboxone = event.target.checked;
		console.log(this.checkboxone);
	}
	handleChange2(event) {
		this.checkboxtwo = event.target.checked;
		console.log(this.checkboxtwo);
	}
}