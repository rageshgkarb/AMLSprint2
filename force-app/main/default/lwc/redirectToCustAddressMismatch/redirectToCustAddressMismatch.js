import { api, LightningElement, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class RedirectToCustAddressMismatch extends LightningElement {
    get recordId(){
        return this.recordId;
    }

    @api
    set recordId(value){
        this.dispatchEvent(new CloseActionScreenEvent());
        window.open("http://appsrv03:8080//Default.aspx?id="+value, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    } 
}