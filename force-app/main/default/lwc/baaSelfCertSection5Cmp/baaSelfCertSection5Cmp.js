import { LightningElement,api } from 'lwc';

export default class BaaSelfCertSection5Cmp extends LightningElement {
    @api 
    Data ={};
    showComp;
    @api
    setData(Data){
        this.Data = Data;
        this.showComp =true;
    }
}