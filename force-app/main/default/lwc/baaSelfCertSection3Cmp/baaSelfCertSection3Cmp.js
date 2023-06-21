import { LightningElement,api } from 'lwc';

export default class BaaSelfCertSection3Cmp extends LightningElement {
    @api 
    Data ={};
    showComp;
    isNonFinancial =false;
    @api
    setData(Data){
        this.Data = Data;
        this.showComp =true;
        
        if(Data.Applicant.Entity_Type_c == 'Non Financial Entity')
        this.isNonFinancial =true;
    }
}