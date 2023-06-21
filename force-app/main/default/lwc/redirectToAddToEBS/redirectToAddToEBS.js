import { LightningElement,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import USERID from '@salesforce/user/Id';

export default class RedirectToAddToEBS extends LightningElement {
    get recordId(){
        return this.recordId
    }

    @api
    set recordId(value){
        this.dispatchEvent(new CloseActionScreenEvent());
        window.open(`/apex/CAA_ANC_Lightning?userId=${USERID}&ExistingAccountId=`+value, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    } 
}