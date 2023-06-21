import { LightningElement,track, wire,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi'
import USER_ID from '@salesforce/user/Id'; 
import PROFILE from '@salesforce/schema/User.Profile.Name';
import NAME_FIELD from '@salesforce/schema/User.Name'

export default class NavigateToAccountEdit extends NavigationMixin(LightningElement) {
    @track error ;
    @api recordId;
    show=false;

     @wire(getRecord, {
         recordId: USER_ID,
         fields: [NAME_FIELD,PROFILE]
     }) wireuser({
         error,
         data
     }) {
         if (error) {
            this.error = error ; 
         } else if (data) {
                const profileName= data.fields.Profile.value.fields.Name.value;
                if(profileName !== 'External Flow & IFM Partner User'){
                    //redirect to edit page
                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: this.recordId,
                                actionName: 'edit'
                            },
                            state: {
                                nooverride : 'true'
                            }
                        });   
                        //window.open("/"+this.recordId, "_self")   
                }
                else { this.show=true}
         }
     }
 }