import { api, LightningElement,track,wire } from 'lwc';

import EligibilitySetup from '@salesforce/apex/CAA_Core_Controller_Lightning.EligibilitySetup';
import Titles from '@salesforce/apex/CAA_Core_Controller_Lightning.Titles';
import Campaigns from '@salesforce/apex/CAA_Core_Controller_Lightning.Campaigns';
import getInterestedIn from '@salesforce/apex/CAA_Core_Controller_Lightning.InterestedIn';
import Eligibility from '@salesforce/apex/CAA_Core_Controller_Lightning.Eligibility';
import {LoadShow,LoadHide,getParameters} from 'c/caaUtility'; 
import { MessageContext } from 'lightning/messageService';  

export default class CaaEligibility extends LightningElement {
   
   @wire(MessageContext)
    messageContext;

    @api
    accountid;
    webFormDataId;
    isErrorMessage= false;
    isAccountIdAvailable = false;
    isDuplicate = false;
    errequired;
    FirstName;
    LastName;
    Salutation;
    Email;
    PreferedContact;
    Postcode;
    WebFormDataId;
    DOB;
    Titles;
    InterestedInList;
    EligibilityAccDate;
    ErrorMessage;
    @track oppId;
    isSuccess = false;
   @track Data ={};   
   DDOB; 

@api dob;

    @track index;
    @track CampaignList=[];
    
    async connectedCallback(){
        console.log("caaftd Lwc Comp Loaded");
        console.log('this.accountid Line no: 36'+JSON.stringify(this.Data));
            

            Titles()
            .then(result=>{
                console.log('this.accountid Line no: 54'+JSON.stringify(result));
                this.Titles = result;
            }).catch(error=>{
                this.result=error;
                console.log(JSON.stringify(error));
                });
            
            Campaigns()
            .then(result=>{
                console.log('this.accountid Line no: 64'+JSON.stringify(result));
                var arr = [];
                arr.push({key:'', value:''});
                for(var i=0;i<result.length;i++){
                    arr.push({key:result[i].Id, value:result[i].Name});
                }
                console.log('arr'+arr);
                this.CampaignList = arr;
                console.log('**CampaignList*',JSON.stringify(this.CampaignList));
            }).catch(error=>{
                this.result=error;
                console.log(JSON.stringify(error));
            });

            getInterestedIn()
            .then(result=>{
                console.log('this.accountid Line no: 83'+JSON.stringify(result));
                this.InterestedInList = result;
            }).catch(error=>{
                this.result=error;
                console.log(JSON.stringify(error));
                });
                EligibilitySetup({paramAccountId:this.accountid,webFormDataId:this.webFormDataId})
                .then(result=>{

                console.log('this.accountid Line no: 42'+JSON.stringify(result));
                if(result && this.accountid != null || this.accountid != ''){
                    
                    this.isAccountIdAvailable = true;
                    this.Data.AccountId = this.accountid;
                    this.Data.FirstName = result.FirstName;
                    this.Data.LastName = result.LastName;
                    this.Data.Salutation = result.Salutation;
                    this.Data.Email = result.Email;
                    this.Data.PreferedContact = result.PreferedContact;
                    this.Data.Postcode = result.Postcode;
                    this.Data.WebFormDataId = result.WebFormDataId;
                    this.DDOB = result.EligibilityAccDate;
                   
                } 
                }).catch(error=>{
                this.result=error;
              
                console.log(JSON.stringify(error));
                });
    }
 
    
    onDataChange(event){
            console.log( event.target);
            console.log('event.target.value 103: '+event.target.value);
            this.Data[event.target.name] = event.target.value;
            console.log('Data: 110'+JSON.stringify(this.Data));
            var inputValue = event.target.value;
            this.template.querySelectorAll('c-caa-input-error').forEach(element => {

            
            const elementid = element.id.substring(0, element.id.indexOf('-'));
            
            if(elementid ==event.target.name){
                console.log('Element ID',elementid+'event.target.name',event.target.name);
                element.validateInputField(inputValue);   
            }
            if(elementid == 'Salutation'){
                  element.validateInputField(this.Data.Salutation);   
            }
             });           
    }

    checkValues(){
                this.template.querySelectorAll('c-caa-input-error').forEach(element => {

            
                const elementid = element.id.substring(0, element.id.indexOf('-'));
            
                console.log('128'+this.Data);
                console.log('Element ID',elementid+'event.target.name',this.Data[elementid]);
                element.validateInputField(this.Data[elementid]);   
            

             });
           this.template.querySelector('c-caa-date').completeCheckValues();  
    }

  
    onCampaignChange(event){
        console.log('event.target.value 103: '+event.target.value);
        this.Data.Campaign = event.target.value;
        console.log('Data: 104'+JSON.stringify(this.Data));
    }

    onInterestedInChange(event){
        console.log('event.target.value 103: '+event.target.value);
        this.Data.InterestedIn = event.target.value;
        console.log('Data: 110'+JSON.stringify(this.Data));
    }
    handlechange(event){
    

this.Data.DOB=event.detail;
console.log('Birth'+JSON.stringify(this.Data.DOB));
console.log('Birth'+JSON.stringify(this.Data));
    }
   
     navigateToOpporrtunity(event){
        window.location.href = '/lightning/r/Opportunity/'+ this.oppId +'/view';
}
    Save()
		{
            if( this.Data.FirstName  &&  this.Data.LastName  && this.Data.Salutation ){
         

            LoadShow('Processing...',this.messageContext);
            
			Eligibility({data : this.Data})
            .then(result=>{
                this.isDuplicate = false;
                this.isErrorMessage = false;
                this.result=result;
                this.oppId = result.OpportunityId;
                this.isCompleted = true;
                this.isSuccess = result.Success;
                console.log(this.result);
                if(! result.Success )
                {

                    this.isErrorMessage=true;
                    if(result.Error && result.Error.includes('Duplicate'))
                    {
                      
                       this.isErrorMessage = false;
                       this.isDuplicate = true;

                    }
                    else if(result.Error && result.Error.includes('FIELD_CUSTOM_VALIDATION_EXCEPTION') && result.Error.includes( 'Data Validation Error:'))
                    {
                      
                       this.ErrorMessage = result.Error.split( 'Data Validation Error:')[1];
                    }
                    else if(result.Error && result.Error.includes('INVALID_EMAIL_ADDRESS') && result.Error.includes( 'Email address:'))
                    {
                      
                       this.ErrorMessage = result.Error.split( 'Email address:')[1];
                    }
                    else{

                        this.ErrorMessage = result.Error;
                    }
                    window.scrollTo(0,0);
                }
				LoadHide(false,this.messageContext); 
                console.log('this.accountid Line no: 112'+JSON.stringify(result));
            }).catch(error=>{
              
                
                 this.result=error;
                 alert('errorrrrr'+JSON.stringify(error));
                 this.ErrorMessage = JSON.stringify(error);
                 this.isErrorMessage = true;
                 LoadHide(false,this.messageContext); 
            });
            }
            else{
                this.checkValues();
            }

           
		}
      



}