import { LightningElement,track,wire,api} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import {LoadShow,LoadHide,getParameters} from 'c/caaUtility'; 
import { MessageContext } from 'lightning/messageService'; 
import NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id'; //this is how you will retreive the USER ID of current in user.
import CreateANC from '@salesforce/apex/CAA_Core_Controller_Lightning.CreateANC';
import ANCSetup from '@salesforce/apex/CAA_Core_Controller_Lightning.ANCSetup';
export default class CaaANC extends LightningElement {
get options() {
    return [
        {
            Name: 'HPP',
            Id: 'ANC-HPP',
        },
        {
            Name: 'Current Account',
            Id: 'ANC-Current',
        },
        {
            Name: 'Saving Account',
            Id: 'ANC-Saving',
        }
    ];
}

@track error ;
@track name;
@wire(MessageContext)
    messageContext;

@wire(getRecord, {recordId: USER_ID,fields: [NAME_FIELD]}) 
wireuser({error, data})
{
    if (error){
        this.error = error ; 
    } else if (data){
        this.name = data.fields.Name.value;
    }
}
@track value;
Accountid;
Firstname;
Lastname;
EBSId;
DEType;
AncFirstName;
AncLastName;
AncEbsId;
@track isButtonDisplay=false;

@api accountid;
    
    async connectedCallback(){
       
        ANCSetup({paramAccountId:this.accountid})
        .then(result=>{
            console.log('checkresult'+JSON.stringify(result));
          
         console.log('check'+(this.accountid));
          
         console.log('this.accountid Line'+JSON.stringify(this.accountid));
         this.AccountId = this.accountid;
         this.Firstname = result.AncFirstName;
         this.LastName = result.AncLastName;
         this.EBSId = result.AncEbsId;
         
        }).catch(error=>{
            this.result=error;
            console.log('error'+JSON.stringify(error));
        });
    }
    onDEType(event) {
       this.DEType= event.target.value;
      if(this.DEType && !this.EBSId){
       this.isButtonDisplay=true;
       if(this.DEType != 'select')
       this.template.querySelector('.optionhide').style.display = "none";
      }
      else{
            this.isButtonDisplay=false;
      }

    }

    Create(){
             
            LoadShow('Processing...',this.messageContext);
			CreateANC({ancType:this.DEType,Id:this.Accountid})
                .then(result=>{
                    console.log('line 70'+JSON.stringify(result));	
				if(result.URL){
                    console.log(result.URL.FormatURL());//$window.location.href = result.URL.FormatURL();
					window.location.href = result.URL.FormatURL();
				}
                else{
                    console.log('else part LoadHide'); //-- serviceApplication.LoadHide(false);
                    LoadHide(false,this.messageContext);
                }
			
             }).catch(error =>{
                     //serviceApplication.LoadHide(false);  
                     this.ErrorMessage = error;
                     console.log('JS Catch Load Hide' + JSON.stringify(error)); //---serviceApplication.LoadHide(false);
                     LoadHide(false,this.messageContext);
                }); 
		}	

    
     
           

}