import getCollectionLettersURL from '@salesforce/apex/URLClassLWC.getCollectionLettersURL';
import { api, LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';



export default class RedirectToCollectionsLetters extends LightningElement {
    get recordId(){
        return this.recordId;
    }

    @api
    set recordId(value){
        this.dispatchEvent(new CloseActionScreenEvent());
        getCollectionLettersURL({accId : value})
        .then((result)=>{
            window.open(result, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
        }).catch((error)=>{
            alert("ERROR"+JSON.stringify(error))
        })
       
    } 
    
    
}