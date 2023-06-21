import { LightningElement,api,track } from 'lwc';
import GetOtherPersons from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.GetControllingPersons';

export default class BaaSelfCertSection4Cmp extends LightningElement {
    person;
    @api Data ={};
    showComp;
    @api eventid;
    @track ControllingPersonsData;
    @track ControllingOtherPersonsData;
    HasUnAddedControllingPersonsBoolean =false;
    @track OtherControllingPersons;
    ControllingPersonAddedCount;


    @api
    setData(Data){
        console.log('section4 set data');
        this.Data = Data;
        this.showComp =true;
    }
    connectedCallback(){
        this.InitOtherControllingPersons();
        this.HasUnAddedControllingPersonsBoolean = this.HasUnAddedControllingPersons();
    }
    InitOtherControllingPersons () {
        if (this.ControllingOtherPersonsData == null) {
            GetOtherPersons({eventId:this.eventid})
                .then(result => {
                    console.log(result);
                        this.ControllingOtherPersonsData = result;
                        this.InitOtherControllingPersonsData();
                    },
                    function (error) {
                        console.log(error);
                    }
                );
        }
    }
    HasUnAddedControllingPersons() {
        if(this.ControllingPersonAddedCount > 9) 
        {
            return false;
        }
        else
        {
            return true;
        }
        
      
    }

    InitOtherControllingPersonsData () {
        this.OtherControllingPersons = [];
        
        if (this.ControllingOtherPersonsData.length > 0) {
            for (i = 0; i < this.ControllingOtherPersonsData.length; i++) {
                if(this.ControllingOtherPersonsData[i].Added){
                    this.OtherControllingPersons.push(this.ControllingOtherPersonsData[i]);
                }
            }
            this.ControllingPersonAddedCount+=this.ControllingOtherPersonsData.length;
            console.log('this.ControllingOtherPersonsData:'+JSON.stringify(this.ControllingOtherPersonsData));
            console.log('this.OtherControllingPersons:'+JSON.stringify(this.OtherControllingPersons));
        }
    }
}