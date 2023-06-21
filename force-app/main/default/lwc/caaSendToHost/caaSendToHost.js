import {LightningElement,api,track,wire} from 'lwc';
import getHostVal from "@salesforce/apex/CAA_Core_Controller_Lightning.GetHostData";
import ebsCall from "@salesforce/apex/CAA_Core_Controller_Lightning.CallEBS";
import { MessageContext } from 'lightning/messageService';
import {LoadShow,LoadHide} from 'c/caaUtility';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import JQuery from '@salesforce/resourceUrl/JQuery';
import Bootstrap_3_2_0 from '@salesforce/resourceUrl/Bootstrap_3_2_0';
import FontAwesome_4_5_0 from '@salesforce/resourceUrl/FontAwesome_4_5_0';
import Angular_1_4_11 from '@salesforce/resourceUrl/Angular_1_4_11';
import CAA_Includes from '@salesforce/resourceUrl/CAA_Includes';

export default class CaaSendToHost extends LightningElement {
    @api EventLogId;@api IsANC;@api SessionId;@api isABranchVar;@api IsCurrentAccount;@api titleText;
    @track Checklist={};
    @track IsABranch;
    @track Data={};
    @track HideButton = false;
    @track showdetails = false;
    @wire(MessageContext)
    messageContext;
    connectedCallback(){
        console.log('**SessionId*',this.SessionId);
        console.log('**EventLogId*',this.EventLogId);
        console.log('**IsANC*',this.IsANC);
        console.log('**IsANC*',this.isABranch);
        this.IsABranch = this.isABranchVar;
        console.log('**isABranch*',this.IsABranch);

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

        this.getHost();
    }

    toggleDetails(){
        this.showdetails = !this.showdetails;
    }
    

    checklistChanges(event){
        console.log('NAme:',event.target.name);
        this.Checklist[event.target.name] = event.target.checked;
        console.log('Value',this.Checklist[event.target.name]);
    }
    getHost(){
        LoadShow('',this.messageContext);
        getHostVal({eventLogId:this.EventLogId})
        .then((result) => {
            if(result.Success)
            {
                this.Data = result.Data;
                if(result.URL){
                    window.location.href = result.URL;
                    return;
                        
                }              
                               
            

            /*if($scope.Data && $scope.Data.ProductName){
                $scope.Data.ProductName	= $scope.Data.ProductName.replace("&#39;","'");
                $scope.Data.ProductName	= $scope.Data.ProductName.replace("&amp;","&");
            }*/

            }
            LoadHide('',this.messageContext);
            //serviceApplication.LoadHide(false); 
                //serviceApplication.LoadHide(false);                 
        })
        .catch((error) => {
            console.log('Error', error);
            LoadHide('',this.messageContext);
            //serviceApplication.LoadHide(false);
        });
    }

    CallEBS(){
        console.log('**Ebs MEthods**',this.EventLogId,'--',this.IsANC);
        if(!this.EventLogId) return null;
        //serviceApplication.LoadShow('Sending to host..');
        LoadShow('Sending to host..',this.messageContext);
        ebsCall({eventLogId:this.EventLogId,sessionId:this.SessionId,data:this.Data})
        .then((result) => {
            if(result.Success){
                this.Data = result.Data;
                console.log('result:',result);
                if(result.URL)
                {                   
                    window.location.href = result.URL;
                    return;
                }   
                if(this.IsANC && result.Items && result.Items[0].EBSId)
                {
                    this.HideButton = true;
                } 
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

    get isFormValid(){
        if(!this.IsABranch) return true;

        if(this.IsABranch){
            if(this.Checklist.Hand_out_Introductory_Leaflets_c && this.Checklist.Purpose_of_Account_Account_T_Cs_c && this.Checklist.Paying_in_book_c 
                && this.Checklist.Statements_c && this.Checklist.Telephone_Banking_c && this.Checklist.Online_Banking_c && this.Checklist.Tariff_List_c){
                    if(this.IsCurrentAccount){
                        if(this.Checklist.Counter_Fee_Current_Account_Only_c && this.Checklist.Debit_Card_Current_Account_Only_c && this.Checklist.PIN_Current_Account_Only_c
                            && this.Checklist.Chequebook_Current_Account_Only_c){
                                return true;
                        }else{
                            return false;   
                        }
                    }else{
                        return true;
                    }
                }else{
                    return false;
                }

        }else{
            return true;
        }
    }


    get showApplicant(){
        return this.Data.Items && this.Data.Items.length > 1 && !this.Data.IsFTD;
    }


}