import { api, LightningElement, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class RedirectToIBBPortal extends LightningElement {
    get recordId(){
        return this.recordId;
    }

    @api
    set recordId(value){
        this.dispatchEvent(new CloseActionScreenEvent());
        window.open("http://biztsrv1:81/Login.aspx", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    } 
}