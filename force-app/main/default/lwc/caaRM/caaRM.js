import {LightningElement,track,wire,api} from "lwc";
import getApplicantDetails from "@salesforce/apex/CAA_Core_Controller_Lightning.GetRMApplicantData";
import completeEventController from "@salesforce/apex/CAA_Core_Controller_Lightning.CompleteRM";
import callRMController from "@salesforce/apex/CAA_Core_Controller_Lightning.CallRM";
import callEbsController from "@salesforce/apex/CAA_Core_Controller_Lightning.CallEBSDE";
import CompleteExternalController from "@salesforce/apex/CAA_Core_Controller_Lightning.CompleteExternal";
import {LoadShow,LoadHide} from 'c/caaUtility';
import { MessageContext } from 'lightning/messageService';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import JQuery from '@salesforce/resourceUrl/JQuery';
import Bootstrap_3_2_0 from '@salesforce/resourceUrl/Bootstrap_3_2_0';
import FontAwesome_4_5_0 from '@salesforce/resourceUrl/FontAwesome_4_5_0';
import Angular_1_4_11 from '@salesforce/resourceUrl/Angular_1_4_11';
import CAA_Includes from '@salesforce/resourceUrl/CAA_Includes';
export default class CaaRM extends LightningElement {
    @api EventLogId;@api SessionId;@api YPSA;@api isRMT;
    @api isABranch;@api isEDD;@api canEDD;@api IsCurrentAccount;
    @track Data={};
    @track ManagerAuthorisors={};
    @track isBranch = false;
    @track RMAlertText='';
    @track isFCU;
    @track Submitted = false;
    @track Duplicates = false;
    @track isBranchA;

    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        LoadShow('',this.messageContext);
        this.isBranchA = this.isABranch;
        this.myConstructor();
         Promise.all([
             loadScript(this, JQuery), // jquery script
             loadScript(this, Bootstrap_3_2_0 +'/js/bootstrap.min.js'), // CSS File
             loadScript(this, Angular_1_4_11 + '/angular.min.js'), // angular js file
             loadScript(this, Angular_1_4_11 + '/angular-animate.min.js'),  // angular js file
             loadScript(this, Angular_1_4_11 + '/angular-sanitize.min.js'),  // angular js file
            
             loadStyle(this, Bootstrap_3_2_0 +'/css/bootstrap.min.css'), // CSS File
             loadStyle(this, Bootstrap_3_2_0 +'/css/bootstrap_spacelab.min.css'), // CSS File
             loadStyle(this, FontAwesome_4_5_0 +'/css/font-awesome.min.css'), // CSS File
             loadStyle(this, CAA_Includes +'/css/css.css'), // CSS File
             loadStyle(this, CAA_Includes +'/css/wait.css'), // CSS File
             loadStyle(this, CAA_Includes +'/css/structure.css'), // CSS File
             
             
         ])
         .then(() => { 
             this.error = undefined;
             // Call back function if scripts loaded successfully
             alert ('all scripts loaded successfully');
             
         })
         .catch(error => {
             this.error = error;
             console.log (' scripts failed' + error);
         });
    }
    myConstructor(){
        this.callApplicantsData();         
    }

    callApplicantsData(){
       
        getApplicantDetails({logId:this.EventLogId,sessionId:this.SessionId})
        .then((result) => {
                console.log('*****',result.Data);
                
                this.Data= result.Data;   
                LoadHide('',this.messageContext);            
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }

    adhocEdd(){
        this.isEDD = true;
        this.canEDD = false;
    }

    isValid(){
        let returnVal = true;

        for(var i=0;i<this.Data.Applicants.length;i++){
            
            var app= this.Data.Applicants[i];
            if(app.EDD_Data_Missing){
                if(app.Country_of_Expected_Transactions_Credits_c && app.Country_of_Expected_Transactions_Debits_c && app.Currencies_of_Expected_Transactions_c && app.Source_of_Wealth_c){
                    this.Data.Applicants[i].Valid = true;
                }else{
                    this.Data.Applicants[i].Valid = false;
                }  
                this.template.querySelectorAll('c-caa-r-m-basic-information').forEach(element => {            
                    if(!element.validateInputs()){
                        console.log('Invalid Form');
                        returnVal = false;
                    }
                });  
            }else{
                this.Data.Applicants[i].Valid = true;    
            }
        }
        
        
        
        console.log('Invalid Form Should not come here');
        return returnVal;   
    }
    handleValueFromApp(event){
        const app = event.detail.app;
        const indexVal = event.detail.index;
        this.Data.Applicants[indexVal] = app;
        console.log('ValueUpdate FRom Child:',event.detail.app,'Index',indexVal);
        console.log('Parent Value without change',this.Data.Applicants[indexVal]);
    }

    CompleteEvent(data,sessionid,approvalUser){
        
        completeEventController({data:data,sessionId:sessionid})
        .then((result) => {
            if(result.Success)
                {
                    if(result.URL && this.isABranch && this.isBranch && approvalUser!='')
                    {
                        window.location.href = result.URL.FormatURL();
                        return;
                    }
                    LoadHide('',this.messageContext); 
                    
                    //serviceApplication.LoadHide(false);
                    //$rootScope.PleaseWaitAddOn = 'This may take up to a minute';
                    //serviceApplication.LoadShow('RM...');
                    LoadShow('This may take up to a minute',this.messageContext);
                    this.RMCall(this.EventLogId,this.SessionId,(this.isRMT || this.isEDD || this.canEDD),this.isABranch)

                    this.Duplicates = result.HasDuplicates;
                }
        })
        .catch((error) => {
            console.log('Error in complete', error);
            //serviceApplication.LoadHide(false);
            LoadHide('',this.messageContext); 
        });

    }

    RMCall(EventLogId,SessionId,high,branch){
        callRMController({eventLogId:EventLogId,sessionId:SessionId,isHigh:high,isABranch:branch})
        .then((result) => {
            this.canEDD = result.isEDD;
            if((!result.isRMT || result.isFCU) || (result.isRMT && this.isRMT))
            {
                if(result.URL || result.CallEBS)
                {
                    if(result.CallEBS)
                    {
                        this.CallEBS();
                    }
                    else
                    {
                    window.location.href = result.URL.FormatURL();
                        return;
                    }
                }
                else
                {
                    if(result.isFCU)
                    {
                       this.isFCU = true;
                       this.RMAlertText = 'We are currently processing your application, you will be contacted shortly';
                       this.isBranch = false;
                    }
                    else
                    {
                        this.isFCU = false;
                        if(result.isRMT && result.isEDD)
                        {
                            this.isBranch = true;
                            if(result.ManagerAuthorisors)
                            {
                                this.ManagerAuthorisors =  result.ManagerAuthorisors;
                                this.ManagerAuthorisors.selectedAuthorisor = '';
                                this.ManagerAuthorisors.selectedAuthorisor.Verified = false;
                            }
                        }
                    }
                }
            }
            else
            {
                this.isRMT = true;
            }
            //$rootScope.PleaseWaitAddOn = '';
            //serviceApplication.LoadHide(false);
            LoadHide('',this.messageContext); 
        })
        .catch((error) => {
            console.log('Error in complete', error);
            LoadHide('',this.messageContext); 
        });
    }

    CallEBSDE(){
       
        callEbsController({logId:this.EventLogId,sessionId:this.SessionId})
        .then((result) => {
            if(result.Success){
                if(result.Data){
                    if(result.Data.Complete){
                       this.CompleteExternal();
                        return;
                    }
                    else{
                        this.Error = ' ';						
                    }

                    if(result.Data.NextEventUrl){
                        window.location.href = result.Data.NextEventUrl;
                    }
                }

                if(result.URL){
                    window.location.href = result.URL;
                }                             
            }
            else
            {
                this.Error = ' ';
            }
            LoadHide('',this.messageContext); 
            //serviceApplication.LoadHide(false);               
        })
        .catch((error) => {
            console.log('Error', error);
            //serviceApplication.LoadHide(false);
            LoadHide('',this.messageContext); 
        });
    }

    CallEBS(){
        if(!this.EventLogId) return null;        
        //serviceApplication.LoadShow('RM...');
        this.CallEBSDE(this.EventLogId,this.SessionId);       
    }

    CompleteExternalMethod(){
       
        CompleteExternalController({eventLogId:this.EventLogId,sessionId:this.SessionId})
        .then((result) => {
            if(result.Success  && result.Data && result.Data.NextEventUrl)
                {
                    window.location.href = result.Data.NextEventUrl;
                    return;
                }
                else
                {
                    this.Error = ' ';
                }
                    
                //serviceApplication.LoadHide(false);                 
        })
        .catch((error) => {
            console.log('Error', error);
            LoadHide('',this.messageContext); 
            //serviceApplication.LoadHide(false);
        });
    }

    CompleteExternal(){
        if(!this.EventLogId) return null;                    
        this.CompleteExternalMethod();        
    }

    Complete(){
        LoadShow('',this.messageContext);
        this.Submitted = true;
        
        if(!this.isValid()) 
            return;
        
        console.log('Dont Come',this.isValid());
        if(this.YPSA && thid.Data.Applicants.length < 2) 
            return;

        
        var approvalUser = '';
        if(this.ManagerAuthorisors && this.ManagerAuthorisors.selectedAuthorisor && this.ManagerAuthorisors.selectedAuthorisor.Verified)
        {
            approvalUser=this.ManagerAuthorisors.selectedAuthorisor.AuthorisorId; 
        }
    
        var data = {'Applicants' : this.Data.Applicants, 'EventLogId' :this.EventLogId, 'Campaign' : this.Data.Campaign, 'PaperStatements' :this.Data.PaperStatements, 'ApprovalUser' : approvalUser, 'isEDD' :this.isEDD }
    
        //serviceApplication.LoadShow('Saving...');
        this.CompleteEvent(data,this.SessionId,approvalUser);
        LoadHide('',this.messageContext); 
    }

    get HideComplete(){
        if(this.isFCU) return true;

        if(this.isBranch && !(this.ManagerAuthorisors && this.ManagerAuthorisors.selectedAuthorisor && this.ManagerAuthorisors.selectedAuthorisor.Verified)){
            return true;
        }
        
        if(!this.Data || !this.Data.Applicants) return false;

        for(var i = 0; i < this.Data.Applicants.length;i++){
            if(this.Data.Applicants[i].Correct == 'No') return true;
        }
        return false;
    }
    get hideBranch(){
        return !!this.IsABranch && !this.isBranch;
    }
    get model(){
        return this.Data && this.Data.Applicants && this.Data.Applicants.length>0 ?this.Data.Applicants[0]:'';
    }
}