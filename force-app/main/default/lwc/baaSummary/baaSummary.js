import { LightningElement,api,track } from 'lwc';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_SummaryController_Lightning.getWrapper';
import summaryDetails from '@salesforce/apex/BAA_SummaryController_Lightning.summaryDetails';

export default class BaaSummary extends LightningElement {
    @track BaseOpportunity;
    @api eventId;
    @api oppId;
    parameters;
    @track wrap;
    @track initWrapper={};
    @track showApplicationForm;
    @track showWelcomeLetter;
    @track completed = false;
    connectedCallback(){
        //ng-init="OnInit('{!$Setup.pca__PostcodeAnywhereSettings__c.pca__Key__c}')"
        this.parameters = getParameters();
        console.log(this.parameters);
        this.eventId = this.parameters.id;
        this.oppId = this.parameters.oppId;
        console.log(this.eventId);
    
        wrapper({evnId:this.eventId,opportId:this.oppId})
        .then(result=>{
            console.log('Result on line 23:'+result);
            this.wrap = result;
            this.BaseOpportunity= result.BaseOpportunity;
            console.log('this.BaseOpportunity '+JSON.stringify(this.BaseOpportunity));
            console.log('result.opportunityId: '+result.opportunityId)
            this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);  
            this.summaryDetails(); 
        }).catch(error =>{
            console.log('Line 31: '+error);
        });
        
    }

    summaryDetails(){
        console.log('Line 33: '+JSON.stringify(this.wrap));
        summaryDetails({wrap:this.wrap}).then(result =>{
            console.log(JSON.stringify(this.wrap));
            console.log(result);
            this.initWrapper = result;
            if(this.initWrapper.ApplicationForm != null){
                this.showApplicationForm = true;
            }
            if(this.initWrapper.WelcomeLetter != null){
                this.showWelcomeLetter = true;
            }
            this.completed = true;
        }).catch(error =>{
            console.log('Line 45: '+JSON.stringify(this.error));
        });
    }
}