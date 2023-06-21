import { LightningElement, track, api, wire } from 'lwc';
import fetchApplicantList from "@salesforce/apex/BAA_Applicant_Nav_Ltng_Controller.fetchApplicantList"


export default class BaaApplicantsNav extends LightningElement {


    @api eventId;@api opportunityId;
    @track applicantList = [];

    applicantCompletePageUrl;applicantPageUrl;
    connectedCallback () {

        this.applicantCompletePageUrl = '/apex/BAA_Applicant_Complete_Lightning?id='+this.eventId;
        this.applicantPageUrl = '/apex/BAA_Applicants_Lightning?id='+this.eventId;
//String opportunityId, String accountId, String eventId


        fetchApplicantList({
            opportunityId: this.opportunityId,
            accountId :'',
            eventId :this.eventId
            }).then(result=>{

            if (result ) {
                console.log ('this.applicantList result', JSON.stringify (result));   
                if ( result) {
                    this.applicantList = result;
                }                         
            }else{
                console.log('fetch Event details Failed '); 
            }
            }).catch(error =>{
            console.log('fetch Account details failed '+ JSON.stringify(error)); 
        }
        );

    }

}