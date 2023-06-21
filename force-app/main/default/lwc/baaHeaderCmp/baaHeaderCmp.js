import { LightningElement,api,track } from 'lwc';
import rewind from '@salesforce/apex/HPPCAA_SummaryController_Lightning.getLatestRewind';

export default class BaaHeaderCmp extends LightningElement {

    title;
    hide =true;
    isOppAvailable = false;
    @track opp;
    @track LatestRewind;
    showheader =false;

    @api
    showHeaderComp(hide,opp){
        this.opp= opp;
        this.hide = hide;
        console.log(JSON.stringify(this.opp));
        if(this.opp && !hide){
            this.isOppAvailable =true;
        }
        
        rewind({opp : this.opp})
        .then(result=>{
            console.log('rewind');
            console.log(result);
            this.LatestRewind = result;
        }).catch(error=>{
            console.log(error);
        });

        this.showheader =true;
       
    }
    navigateTorewind(){
        window.location.href = '/lightning/r/Event_Rewind__c/'+ this.LatestRewind.Id +'/view';
    }
}