import { LightningElement,api ,track} from 'lwc';
import wrap from '@salesforce/apex/HPPEventMenuController_Lightning.getConstructor';
import complete from '@salesforce/apex/HPPEventMenuController_Lightning.CompleteE';

export default class BaaMenuCmp extends LightningElement {
  
    @track Events;
    @track EventLogs;
    @track menuwrap;
    collapseOne =true;
    collapseTwo =false;
    collapseThree=false;
    rewindurl = '';
    
    @api 
    getMenuParameters(eventId,oppid,directorid){
        wrap({eventId :eventId, Opp_Id :oppid, Director_Id:directorid})
        .then(result=>{
            this.menuwrap = result;
            this.Events = result.Events;
            this.rewindurl = '/apex/HPPManualRollback_lightning?oppid='+oppid;
            this.EventLogs = result.EventLogs;
        })
        .catch(error=>{
            console.log(error);
        });

    }

    onHoverElement(event){
        let evenId = event.target.id;
        if(this.template.querySelector('[data-id="' + evenId.substring(0,18) + '"]'))
        this.template.querySelector('[data-id="' + evenId.substring(0,18) + '"]').classList.remove('hide');

    }
    onFocusElementOut(event){
        let evenId = event.target.id;
        if(this.template.querySelector('[data-id="' + evenId.substring(0,18) + '"]'))
        this.template.querySelector('[data-id="' +evenId.substring(0,18)  + '"]').classList.add('hide');
    }
    onCollapseOne(){
        this.collapseOne =!this.collapseOne;
        this.collapseTwo = false;
        this.collapseThree = false;

    }
    onCollapseTwo(){
        this.collapseOne =false;
        this.collapseTwo = !this.collapseTwo;
        this.collapseThree = false;
    }
    onCollapseThree(){
        this.collapseOne =false;
        this.collapseTwo = false;
        this.collapseThree = !this.collapseThree;
    }
    CompleteE(){
        console.log(JSON.stringify(this.menuwrap));
        complete({wrap:this.menuwrap}).then(result =>{
            console.log(result);
            window.location.href = result;
        }).catch(error =>{
            console.log(error);
        });
    }
}