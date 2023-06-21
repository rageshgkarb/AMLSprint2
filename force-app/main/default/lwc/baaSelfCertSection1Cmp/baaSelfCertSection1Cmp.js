import { LightningElement,api } from 'lwc';

export default class BaaSelfCertSection1Cmp extends LightningElement {

    @api Data={};
    @api Applicant={};
    hidecomp =false;
    showComp =false;
    onInputChange(event){
        this.Data.Applicant[event.target.dataset.id] = event.target.value;
        console.log(JSON.stringify(this.Data.Applicant));
    }
    @api
    setData(Data){
        this.Data = Data;
        this.showComp =true;
    }
}