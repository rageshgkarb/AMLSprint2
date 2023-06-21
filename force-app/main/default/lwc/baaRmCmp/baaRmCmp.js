import { LightningElement, api, wire, track } from 'lwc';
import {getParameters} from 'c/caaUtility';
import uploadFile from "@salesforce/apex/BAA_RM_Controller_Lightning.uploadFile";
import getApplicantDetails from "@salesforce/apex/BAA_RM_Controller_Lightning.GetApplicantData";
import fetchBaseOpportunity from "@salesforce/apex/BAA_RM_Controller_Lightning.fetchBaseOpportunity";
import CompleteRM from "@salesforce/apex/BAA_RM_Controller_Lightning.CompleteRM";
import callRMController from "@salesforce/apex/BAA_RM_Controller_Lightning.CallRM";
import wrapper from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr_Ltng.getWrapper';
import LoadEvent from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr2_ltng.LoadEvent'
import IsABranch from '@salesforce/apex/BAA_RM_Controller_Lightning.IsABranch';
import complete from '@salesforce/apex/BAA_RM_Controller_Lightning.Complete';

export default class BaaRmCmp extends LightningElement {

    applicantName;showFurtherInfo;custAppFurtherInfo;showUploadStatus;showUplaodSuccessful;showUplaodInProgress;showUplaodRejected;
    @api recordId;opportunityId;rmfileupload;
    eventId;SessionId;isRMT;isEDD;canEDD;isBranch;
    @api isABranch;
    //baseOpportunity;
    @track Data={};
    fileData;
    isFCU;
    DisableControl;
    HideComplete; returnedStatus; message;
    @track BaseOpportunity;
   // @api eventId;
    @api oppId;
    parameters;
    @track wrap;
    showHeader =false
    PleaseWaitAddOn;
    RMAlertText;
    ErrorAlertText;
    waitEnable;
    waitMsg;

    connectedCallback () {
        this.waitEnable=true;
        this.parameters = getParameters();
        console.log(this.parameters);
        this.eventId = this.parameters.id;
        this.oppId = this.parameters.oppId;
        console.log(this.eventId);
        
        this.custAppFurtherInfo = '';//(isRMT && !isFCU) || isEDD
        this.returnedStatus = '';
        this.showUploadStatus = false;//{!RMStatus == 'Upload Required'}"
        this.showUplaodSuccessful = false;//RMStatus == 'Upload Successfully
        this.showUplaodInProgress = false;//RMStatus == 'In Progress'
        this.showUplaodRejected = false;//RMStatus == 'Rejected'
        this.forminValid=false;
        this.HideComplete=true;
        this.message='';
        this.waitMsg='Please Wait...'
        

        this.opportunityId = '';// assign opportunity id 
        this.isRMT=false;
        this.isEDD=false;
        this.canEDD=false;
        this.isVerified=false;
        this.isABranch=false//{!IsABranch},
        this.DisableControl=false//{!IsCompleted},

        wrapper({evnId:this.eventId,opportId:this.oppId}).then(result=>{
            console.log(result);
            this.wrap = result;
            this.BaseOpportunity= result.BaseOpportunity;
            this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
            this.getABranch();
            this.getLoadEvent();
            this.loadData();
            this.waitEnable=false;
        }).catch(error =>{
            console.log(error);
            this.waitEnable=false;
        });
            //loadScript(this, ibbstyle+'/kendo/jquery.min.js'), // jquery script
             
            console.log (' this.eventId##' + this.eventId);
            
    }

    completeEventController(){
       // if ( !(this.returnedStatus =='Upload Successfully' || this.returnedStatus =='Accepted')) {
      //      return;
      //  }
      this.waitEnable=true;
        let dataVar = {'Applicants' : this.Data.Applicants  , 'EventLogId' : this.eventId, 'ApprovalUser' : '',  'isEDD' : this.isEDD };
        CompleteRM({data:dataVar, sessionId:this.SessionId})
            .then((result) => {
                console.log('**result completeEventController***',JSON.stringify (result));

            if(result.Success)
            {
                if(result.URL && this.isABranch && this.isBranch)
                {
                    $window.location.href = result.URL.FormatURL();
                    return;
                }
                this.waitEnable=false;
                this.PleaseWaitAddOn='This may take up to 2 minutes';
                this.waitEnable=true;
            callRMController({eventLogId:this.eventId, sessionId:this.SessionId, isHigh:(this.isRMT || this.isEDD || this.canEDD), isABranch:this.isABranch})
                    .then((result) => {
                        console.log('result callRMControllerJs***** js',JSON.stringify (result));
                        this.canEDD = result.isEDD;
                        if((!result.isRMT || result.isFCU) || (result.isRMT && this.isRMT))
                        {
                            if(result.URL)
                            {
                                $window.location.href = result.URL.FormatURL();
                                return;
                            }
                            else{
                                if(result.isFCU)
                                {
                                    this.isFCU = true;
                                    this.RMAlertText = 'We are currently processing your application, you will be contacted shortly';
                                    this.isBranch = false;
                                    //this.completeRMProcess();
                                }
                                else{
                                   this.isFCU = false;
                                    if(result.isRMT && result.isEDD)
                                    {
                                        this.isBranch = true;
                                    }
                                    this.completeRMProcess();
                                }
                            }
                        }
                        else{
                            this.isRMT = true;
                        }
                        this.PleaseWaitAddOn='';
                        this.waitEnable=false;
                })
                .catch((error) => {
                    console.log('Error', error);
                    this.ErrorAlertText = 'An error has occured during processing, please try again and if you still get an error, please contact your system administrator';
                    this.waitEnable=false;
                });
            }
                
        })
        .catch((error) => {
            console.log('Error', error);
            this.ErrorAlertText = 'An error has occured during processing, please try again and if you still get an error, please contact your system administrator';
            this.waitEnable=false;
        });
        this.showUploadStatus = false;
            this.showUplaodSuccessful=false;
            this.showUplaodInProgress=false;
            this.showUplaodRejected=false;
    }
    completeRMProcess(){
        console.log('this.eventId'+this.eventId);
        console.log('opportId:this.oppId'+this.baseOppId);
        complete({evnId:this.eventId,opportId:this.opportunityId}).then(result =>{
            console.log(result);
            window.location.href = result;
        }).catch(error =>{
            console.log(error);
        });
    }
    getABranch(){
        IsABranch({ })
        .then((result) => {
                console.log('**IsABranch***',JSON.stringify (result));
                this.isABranch=result;
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }

    getLoadEvent(){
        console.log('this.eventId##'+this.eventId);
        LoadEvent({eventId:this.eventId})
        .then((result) => {
            this.DisableControl=result;
            console.log('result ***** js',JSON.stringify (result));
            console.log('result *****## js',this.DisableControl);
               
    })
    .catch((error) => {
        console.log('Error', error);
    });
    }

    loadData(){
        this.callApplicantsData();
             
    }

    callApplicantsData(){
       
        getApplicantDetails({logId:this.eventId})
        .then((result) => {
                console.log('*****',JSON.stringify (result));
                
                this.Data= result.Data;   
                this.showFurtherInfo = this.Data && (!this.isRMT || this.isABranch);
                this.applicantName = this.Data.Applicants[0].ContactName;
                this.getBaseOpportunity();   
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }

    getBaseOpportunity(){
        fetchBaseOpportunity({eventId:this.eventId})
    .then((result) => {
        if(result){
            console.log (' result oppty ' + JSON.stringify (result ));
            this.returnedStatus = result.RMStatus;
            this.opportunityId = result.oppty.Id;
            this.recordId = result.oppty.AccountId;
            console.log('returnedStatus#', this.returnedStatus);
            console.log('returnedStatus##', result.RMStatus);
            if ( this.returnedStatus =='Upload Required') {
                this.showUploadStatus = true;
                this.showUplaodSuccessful=false;
                this.showUplaodInProgress=false;
                this.showUplaodRejected=false;
            }    
            if ( this.returnedStatus =='Upload Successfully') {
                this.showUplaodSuccessful = true;
                this.showUploadStatus = false;
                this.showUplaodInProgress=false;
                this.showUplaodRejected=false;
            }
            if ( this.returnedStatus =='In Progress') {
                this.showUplaodInProgress = true;
                this.showUplaodSuccessful = false;
                this.showUploadStatus = false;
                this.showUplaodRejected=false;
            }
            if ( this.returnedStatus =='Rejected') {
                this.showUplaodRejected = true;
                this.showUplaodInProgress = false;
                this.showUplaodSuccessful = false;
                this.showUploadStatus = false;
            }
            if ( !(this.returnedStatus =='Upload Successfully' || this.returnedStatus =='Accepted')) {
                this.forminValid = true;
            }

           // this.callRMControllerJs();
          //  console.log('returnedStatus', this.returnedStatus);
            this.HideCompleteFun();
            console.log('HideComplete', this.HideComplete);
        }
    })
    .catch((error) => {
        console.log('Error in complete', error);
    });
    }

    /*callRMControllerJs(){
        callRMController({eventLogId:this.eventId, sessionId:this.SessionId, isHigh:(this.isRMT || this.isEDD || this.canEDD), isABranch:this.isABranch})
        .then((result) => {
            console.log('result callRMControllerJs***** js',JSON.stringify (result));
            this.isFCU=result.isFCU;
            this.isEDD=result.isEDD;
            this.isRMT=result.isRMT;
    })
    .catch((error) => {
        console.log('Error', error);
    });
    }*/

    HideCompleteFun(){
        if(this.isFCU) 
            this.HideComplete= true;

        if(this.DisableControl) 
            this.HideComplete= true;

        if(this.isABranch) 
            this.HideComplete= true;

        console.log('this.Data*****', this.Data);
        console.log('this.Data.Applicants*****', this.Data.Applicants);
        if(!this.Data || !this.Data.Applicants) 
            this.HideComplete= false;

        for(var i = 0; i < this.Data.Applicants.length;i++)
        {
            if(this.Data.Applicants[i].Correct == 'No') 
                this.HideComplete= true;
        }
        console.log('returnedStatus*****', this.returnedStatus);
        if(this.returnedStatus == 'Upload Successfully' || this.returnedStatus == 'Accepted'){
            this.HideComplete= false;
            this.showUploadStatus = false;
            this.showUplaodSuccessful=true;
            this.showUplaodInProgress=false;
            this.showUplaodRejected=false;
        }

        return true;
    }

    get acceptedFormats() {
        return ['.xlsm', '.png','.jpg','.jpeg'];
    }

    openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId,
                'opportunityId':this.opportunityId
            }
            console.log('file data '+this.fileData)
        }
        reader.readAsDataURL(file)
    }

    handleOnClick(event) {
        this.waitEnable=true;
        console.log('calling finish upload');
        this.message = '';
        if(this.fileData){
        const {base64, filename, recordId, opportunityId} = this.fileData
            uploadFile({ base64, filename, recordId, opportunityId }).then(result=>{
                this.fileData = null
                let title = '${filename} uploaded successfully!!';
                console.log (' result upload ' + JSON.stringify (result ));
                this.rmfileupload = result;
                this.waitEnable=false;
                if ( this.rmfileupload =='Upload Successfully' || this.returnedStatus == 'Accepted') {
                    this.showUplaodSuccessful = true;
                    this.showUploadStatus=false;
                    this.HideComplete= false;;
                }
                if ( this.rmfileupload =='In Progress') {
                    this.showUplaodInProgress = true;
                    this.showUploadStatus=false;
                }
                if ( this.rmfileupload =='Upload Required') {
                    this.showUploadStatus = true;
                }
                if ( this.showUploadStatus =='Rejected') {
                    this.showUplaodRejected = true;
                    this.showUploadStatus=false;
                }
                
                //this.getBaseOpportunity();
            })
        }else{
             this.message = 'Please upload a file';
        }
        
        
        /*insertAttachment({oppId:this.opportunityId})
        
        .then((result) => {
       
            console.log (' result upload ' + JSON.stringify (result ));
            this.rmfileupload = result;
            console.log('Success ');    
                
        })
        .catch((error) => {
            console.log('Error in complete', error);            
          
            alert(error.message);
        }); */

        
    }
    

}