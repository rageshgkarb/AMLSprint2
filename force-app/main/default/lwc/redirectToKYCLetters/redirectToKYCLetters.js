import { api, LightningElement, wire } from 'lwc';
 import getKYCLettreURL from '@salesforce/apex/URLClassLWC.getKYCLettreURL';
 import { CloseActionScreenEvent } from 'lightning/actions';

export default class RedirectToKYCLetters extends LightningElement {
    @api recordId;
    @wire(getKYCLettreURL,{accId: '$recordId'})accounts({data,error}){
        if(data){
            this.dispatchEvent(new CloseActionScreenEvent());
            window.open(data, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
        }else if(error){
            alert(JSON.stringify(error))
        }
    }
}