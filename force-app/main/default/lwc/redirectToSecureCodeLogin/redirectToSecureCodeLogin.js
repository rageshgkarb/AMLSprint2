import { api, LightningElement, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class RedirectToSecureCodeLogin extends LightningElement {
    get recordId(){
        return this.recordId;
    }

    @api
    set recordId(value){
        this.dispatchEvent(new CloseActionScreenEvent());
        window.open("https://secure5.arcot.com/vpas/admin/adminlogin.jsp?bank=MTLIBB001", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
}