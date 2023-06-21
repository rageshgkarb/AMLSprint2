import getMergeDocumentURL from '@salesforce/apex/URLClassLWC.getMergeDocumentURL';
import { api, LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class RedirectToMergeDocument extends LightningElement {
    get recordId(){
        return this.recordId;
    }

    @api
    set recordId(value){
        this.dispatchEvent(new CloseActionScreenEvent());
        getMergeDocumentURL({accId : value})
        .then((result)=>{
            window.open(result, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
        }).catch((error)=>{
            alert("ERROR"+JSON.stringify(error))
        })
       
    } 
}