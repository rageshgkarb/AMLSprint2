import { api, LightningElement, track } from 'lwc';
import  BAA_TCS from '@salesforce/resourceUrl/BAA_TCs_Lft';
import  BAA_Tariff_List from '@salesforce/resourceUrl/BAA_Tariff_List';
import  BAA_Proof_Of_Identity from '@salesforce/resourceUrl/BAA_Proof_Of_Identity';
//import Product_Doc from '@salesforce/resourceUrl/BAA_TCs_Lft';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.getWrapper';
import Complete from '@salesforce/apex/BAA_Agree_TC_Controller_Lightning.Complete';


export default class BaaTcTerms extends LightningElement {
    // @api productDoc;
    // @track productDocFlag;
    
    @track BaseOpportunity;
    @api eventId;
    @api oppId;
    parameters;
    @track wrap;
    showHeader =false;

    // productDoc;
    baaTCS;
    baaTariffList;
    baaProofOfIndentity;
    isAgree;
    showBusy=true;

    isAgreedCheck(event)
    {
        console.log(event.target.checked);
        this.isAgree = event.target.checked;
        
    }
    
    connectedCallback()
    {
        
        // this.productDocFlag = this.productDoc;
        // this.productDoc = Product_Doc;
        
        this.baaTCS = BAA_TCS;
        this.baaProofOfIndentity = BAA_Proof_Of_Identity;
        this.baaTariffList = BAA_Tariff_List;

        this.parameters = getParameters();
        console.log(this.parameters);
        this.eventId = this.parameters.id;
        this.oppId = this.parameters.oppId;
        console.log(this.eventId);

        wrapper({evnId:this.eventId,opportId:this.oppId}).then(result=>{
            console.log(result);
            this.wrap = result;
            this.BaseOpportunity= result.BaseOpportunity;
            this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
            this.showBusy = false;
        }).catch(error =>{
            console.log(error);
        });
        
    }
    
    onComplete(event)
    {   
        event.preventDefault();
        if(this.isAgree){
            //console.log('before call' + JSON.stringify(this.wrap));
            this.showBusy=true;
            Complete({wrap:this.wrap}).then(result =>{
                //console.log('complete check',result);
                if(result)
                window.location.href = result;
                this.showBusy=false;
            }).catch(error =>{
                console.log('complete failed'+ JSON.stringify(error));
            });
            //console.log('after call');
        }else{
            window.scrollTo(0,0);
        }
        
        
    }
}