import { LightningElement ,wire} from 'lwc';
import { publish,MessageContext } from 'lightning/messageService';
import SPINNER_CHANNEL from '@salesforce/messageChannel/Spinner__c';

export default class CaaUtility extends LightningElement {
  
}

export function LoadShow(message,messageContext) {

 //con.load(message);
  console.log('sss');
   let payload = { message: message, state : true};
    console.log(messageContext);
    publish(messageContext, SPINNER_CHANNEL, payload);
  
}
export function LoadHide(message,messageContext) {
  let payload = { message: message, state : false};
  publish(messageContext, SPINNER_CHANNEL, payload);
}

export function  getParameters(){
        var params = {};
        var search = location.search.substring(1);
             if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => 
            {
                return key === "" ? value : decodeURIComponent(value)

            });
        }
         return params;
}