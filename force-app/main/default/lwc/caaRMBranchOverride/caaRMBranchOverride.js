import { LightningElement,track,api,wire } from 'lwc';
import passwordVerify from "@salesforce/apex/CAA_RM_Controller.PasswordVerification";
import {LoadShow,LoadHide} from 'c/caaUtility';
import { MessageContext } from 'lightning/messageService';

export default class CaaRMBranchOverride extends LightningElement {
    @api model;
    @api ypsa;
    @api currentaccount;
    @api ftd; 
    @api isguest;
    @api mangerDetials;
    @api isBranch;
    @track ManagerAuthorisors={};

    @wire(MessageContext)
    messageContext;
    connectedCallback(){
        this.ManagerAuthorisors = this.mangerDetials;
    }

    updateClear(){
        this.ManagerAuthorisors.selectedAuthorisor='';
    }
    capturePassword(event){
        this.ManagerAuthorisors.selectedAuthorisor.Password = event.target.value;
    }

    

       
    passwordVerify(){
        let authorisor = this.ManagerAuthorisors.selectedAuthorisor;
        if(authorisor.Password == '' || authorisor.Password == null)
        {
            this.Response_StatusDescription = 'Password cannot be empty';
            return;
        }
        this.working = true;
        LoadShow('Verifying Password',this.messageContext);
        passwordVerify({userName:authorisor.Username, password:authorisor.Password})
        
        .then((result) => {
       
            console.log(JSON.stringify(result));
            if(result.Success == true)
            {
                authorisor.Verified = true;
            }
            else
            {
                authorisor.IncorrectPassword = true;
               this.Response_StatusDescription = 'Incorrect Password';
            }

            this.working = false;
                
            LoadHide('',this.messageContext);
        })
        .catch((error) => {
            console.log('Error in complete', error);
            //serviceApplication.LoadHide(false);
           this.Response_Success = false;
           this.working = false;
           this.Response_StatusDescription = error.message;
            
           
            alert(error.message);
            LoadHide('',this.messageContext); 
        }); 
    }

    onchangeDropDown(event){
        this.ManagerAuthorisors.selectedAuthorisor = event.target.value;
    }

    get disableAuthorized(){
        return this.ManagerAuthorisors.selectedAuthorisor!='';
    }

    get showIncorrectPassword(){
        return this.ManagerAuthorisors.selectedAuthorisor.IncorrectPassword==true;
    }
    get showClear(){
        return this.ManagerAuthorisors.selectedAuthorisor.Verified!=true;                                    

    }

    get showDetails(){
        return !!(this.isguest) && this.isBranch;
    }
    get showApproved(){
        return this.ManagerAuthorisors.Authorisors.length > 0;
    }
    get showVerified(){
        return this.ManagerAuthorisors.selectedAuthorisor.Verified==true;
    }

    get showPasswordSection(){
        return (this.ManagerAuthorisors.Authorisors.length > 0) && (this.ManagerAuthorisors.selectedAuthorisor!='') && (this.ManagerAuthorisors.selectedAuthorisor.Verified!=true);
    }

    get showPassword(){
        return this.ManagerAuthorisors.selectedAuthorisor!='';
    }

}