import { LightningElement, api, track, wire } from 'lwc';
import saveIsaTransfer from "@salesforce/apex/CAA_Core_Controller_Lightning.SaveISATransfer";
import CreateDocument from "@salesforce/apex/CAA_Core_Controller_Lightning.CreateDocument";
import ebsCall from "@salesforce/apex/CAA_Core_Controller_Lightning.CallEBS";
import { MessageContext } from 'lightning/messageService';
import { LoadShow, LoadHide } from 'c/caaUtility';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import JQuery from '@salesforce/resourceUrl/JQuery';
import Bootstrap_3_2_0 from '@salesforce/resourceUrl/Bootstrap_3_2_0';
import FontAwesome_4_5_0 from '@salesforce/resourceUrl/FontAwesome_4_5_0';
import Angular_1_4_11 from '@salesforce/resourceUrl/Angular_1_4_11';
import CAA_Includes from '@salesforce/resourceUrl/CAA_Includes';

export default class CaaIsaTransfer extends LightningElement {
    @api DocId;
    @api SessionId;
    @api EventLogId;
    @api isGuest;
    @track IsGuest;
    @track Submitted;

    @wire(MessageContext)
    messageContext;
    @track ISA = {};
    @track ShowDocScreen;
    @track DocComplete;
    @track urlForDownLoad;
    @track URL;
    @track DocGenerating;

    isTransferYes = false;
    isTransferYesAllClose =false;
    isTransferYesAllCloseNo =false;
    isTransferYesAllSubscribed = false;
    isNotSubscribedNoALLPart =false; 
    isIncludeSubscriptionEr =false;
    isTransferSubscriped =false;
    isCurrentYear=false;


    connectedCallback() {
        this.IsGuest = this.isGuest;
        this.setDefaultValue();

        Promise.all([
                loadScript(this, JQuery), // jquery script
                loadScript(this, Bootstrap_3_2_0 + '/js/bootstrap.min.js'), // CSS File
                loadScript(this, Angular_1_4_11 + '/angular.min.js'), // angular js file
                loadScript(this, Angular_1_4_11 + '/angular-animate.min.js'), // angular js file
                loadScript(this, Angular_1_4_11 + '/angular-sanitize.min.js'), // angular js file

                loadStyle(this, Bootstrap_3_2_0 + '/css/bootstrap.min.css'), // CSS File
                loadStyle(this, Bootstrap_3_2_0 + '/css/bootstrap_spacelab.min.css'), // CSS File
                loadStyle(this, FontAwesome_4_5_0 + '/css/font-awesome.min.css'), // CSS File
                loadStyle(this, CAA_Includes + '/css/css.css'), // CSS File
                loadStyle(this, CAA_Includes + '/css/wait.css'), // CSS File
                loadStyle(this, CAA_Includes + '/css/structure.css'), // CSS File


            ])
            .then(() => {
                this.error = undefined;
                // Call back function if scripts loaded successfully
                alert('all scripts loaded successfully');

            })
            .catch(error => {
                this.error = error;
                console.log(' scripts failed' + error);
            });

    }

    setDefaultValue() {
        this.ISA.Provider = null;
        this.ISA.SortCode = null;
        this.ISA.AccountNumber = null;
        this.ISA.RollNumber = null;
        this.ISA.TransferAmount = null;
        this.ISA.AllandClose = null;
        this.ISA.Part = null;
        this.ISA.Subscribed = null;
        this.ISA.IncludeSubscription = null;
        this.ISA.OnlyCurrentYear = null;
    }

    IsaChanges(event) {
        console.log('NAme:', event.target.name);
        console.log('Value', event.target.value);
        this.ISA[event.target.name] = event.target.value;

        //assign conditions
       
        this.isTransferYes = this.ISA.Transfer == 'yes' ? true : false;
        this.isTransferYesAllClose = this.ISA.Transfer == 'yes' && !this.ISA.AllandClose ?true :false;
        this.isTransferYesAllCloseNo =this.ISA.AllandClose=='no' && !this.ISA.Part ?true :false;
        this.isTransferYesAllSubscribed = this.ISA.AllandClose && !this.ISA.Subscribed ?true :false;
        this.isNotSubscribedNoALLPart = this.ISA.Subscribed == 'no' && this.ISA.AllandClose == 'no' && this.ISA.Part=='yes' ?true:false;
        this.isIncludeSubscriptionEr = !this.ISA.IncludeSubscription && this.ISA.Subscribed == 'yes' && this.ISA.AllandClose == 'no' && this.ISA.Part=='yes' ?true:false;
        this.isTransferSubscriped = !this.ISA.TransferAmount && !this.ISA.OnlyCurrentYear && this.ISA.Subscribed == 'yes' && this.ISA.AllandClose == 'no' && this.ISA.Part=='yes' ?true:false;
        this.isCurrentYear = !this.ISA.TransferAmount && !this.ISA.OnlyCurrentYear && this.ISA.Subscribed == 'yes' && this.ISA.AllandClose == 'no' && this.ISA.Part=='yes'?true:false;
        this.validate(event.target.name,event.target.value);
        
       

    }
    IsaCheckChange(event) {
        console.log('NAme:', event.target.name);
        console.log('Value', event.target.checked);
        this.ISA[event.target.name] = event.target.checked;
        this.ISA.TransferAmount = null;
        console.log('Value', this.ISA[event.target.name]);
    }
    submitted() {
        

        
        

        this.Submitted = true;
    }

    validate(name,value) {
        
        if (this.template.querySelector('c-caa-input-error[data-id="' + name + '"]')) {
            if (this.template.querySelector('c-caa-input-error[data-id="' + name + '"]').validateInputField(value)) {
                if (this.template.querySelector('[data-id="' + name + 'Class"]'));
                this.template.querySelector('[data-id="' + name + 'Class"]').classList.add('has-error');
                return true;
            } else {
                if (this.template.querySelector('[data-id="' + name + 'Class"]'));
                this.template.querySelector('[data-id="' + name + 'Class"]').classList.remove('has-error');
                return false;
            }
        }

        return false;
    }

    SaveISATerms(event) {
        /* perform form field validations */
        let validateFail =false;
        Object.keys(this.ISA).forEach(val =>{
              if(this.validate(val,this.ISA[val])){
                validateFail=true;
              }
            });

        if(validateFail)  return null;
                    
        var complete = false;
        complete = event.target.value;
        this.Submitted = true;
        if (!this.EventLogId) return null;

        if (!this.validate) return;

        if (!this.ISA.TransferAmount) {
            this.ISA.TransferAmount = null;
        }

        console.log('complete', complete);
        LoadShow('Saving...', this.messageContext);
        //serviceApplication.LoadShow('Saving...');

        this.callsaveIsaTransfer(complete)


    }

    callsaveIsaTransfer(iscomplete) {
        console.log('callsaveIsaTransfer', iscomplete);
        saveIsaTransfer({
                eventLogId: this.EventLogId,
                sessionId: this.SessionId,
                data: this.ISA,
                complete: iscomplete
            })
            .then((result) => {
                console.log('callsaveIsaTransfer result', result);
                if (result.Success) {
                    console.log('callsaveIsaTransfer iscomplete', iscomplete, iscomplete == true);
                    if (iscomplete == 'true') {
                        console.log('callsaveIsaTransfer iscomplete', iscomplete);
                        if (result.URL) {
                            console.log('callsaveIsaTransfer', result);
                            window.location.href = result.URL.FormatURL();
                            return;
                        }
                    } else {
                        console.log('callsaveIsaTransfer ShowDocScreen', result);
                        this.ShowDocScreen = true;
                        this.callCreateDocument();
                    }


                } else {
                    this.ErrorMessage = result.Error;
                    console.log('****Error:', result.Error);
                }
                LoadHide('', this.messageContext);

            })
            .catch((error) => {
                console.log('Error', error);
                this.ErrorMessage = error;
                LoadHide('', this.messageContext);

            });
    }
    callCreateDocument() {
        console.log('CreateDocument inside');
        if (!this.EventLogId || !this.DocId) return null;
        console.log('CreateDocument inside2');
        this.DocGenerating = true;
        LoadShow('Generating Document...', this.messageContext);

        CreateDocument({
                eventLogId: this.EventLogId,
                sessionId: this.SessionId,
                settingId: this.DocId
            })
            .then((result) => {
                console.log('CreateDocument inside promise', result);
                this.DocGenerating = false;
                if (result.Success) {
                    this.DocComplete = result.Data.Docs[0].Complete;
                    this.DocAttachmentId = result.Data.Docs[0].AttachmentId;
                    this.URL = result.Data.Docs[0].URL;
                    let url;
                    if(this.DocAttachmentId){
                        if(this.DocAttachmentId.startsWith("00P")|| this.DocAttachmentId.startsWith("015"))
                        url = '/servlet/servlet.FileDownload?file=' + this.DocAttachmentId;
                        else
                        url = '/sfc/servlet.shepherd/version/download/' + this.DocAttachmentId;
                    }

                    this.urlForDownLoad = url;
                } else {
                    this.ErrorMessage = result.Error;
                }

            })
            .catch((error) => {
                console.log('Error', error);
                this.ErrorMessage = error;
                LoadHide('', this.messageContext);

            });
    }
    get showTransferExisting() {
        return this.Submitted && !this.ISA.Transfer;
    }

    get showTransfer() {
        return this.ISA.Transfer == 'yes';
    }
    get showTransferno() {
        return this.ISA.Transfer == 'no';
    }
    get showPartCash() {
        return this.ISA.AllandClose == 'no'
    }
    get showHaveyousubscribed() {
        return this.ISA.AllandClose == 'yes' || (this.ISA.AllandClose == 'no' && this.ISA.Part == 'yes');
    }
    get showISAAmount() {
        return this.ISA.AllandClose == 'no' && this.ISA.Part == 'yes'
    }
    get showIsNotSubscribed() {
        return this.ISA.Subscribed == 'no';
    }

    get isOnlyCurrentYear() {
        return this.ISA.OnlyCurrentYear;
    }

    get transferAmount() {
        return this.ISA.TransferAmount;
    }
    get showCompleteYourApplication() {
        //return this.ISA.AllandClose=='no' && this.ISA.Part=='no'
        return this.ISA.Transfer == 'yes' && !(this.ISA.AllandClose == 'no' && this.ISA.Part == 'no');
    }
    get isaTransfer() {
        return this.ISA.Transfer;
    }
    get showSpinner() {
        return !this.DocComplete && this.DocGenerating;
    }
}