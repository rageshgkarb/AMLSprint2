import { LightningElement ,wire} from 'lwc';
import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import SPINNER_CHANNEL from '@salesforce/messageChannel/Spinner__c';
export default class CaaMessageBroker extends LightningElement {

    state =false;
    message = '';
    subscription = null;

    @wire(MessageContext)
    messageContext;

    
connectedCallback(){
    if (this.subscription) {
        return;
    }
    this.subscription = subscribe(
        this.messageContext,
        SPINNER_CHANNEL, ( message ) => {
            this.handleMessage( message );
        },
        {scope: APPLICATION_SCOPE});

}
handleMessage(payload){
    this.message = payload.message;
    this.state = payload.state;
}
}