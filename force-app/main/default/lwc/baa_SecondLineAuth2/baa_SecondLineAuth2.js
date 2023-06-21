import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr_Ltng.getWrapper';
import LoadEvent from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr2_ltng.LoadEvent';
import complete from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr_Ltng.Complete';
import Setup from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr2_ltng.Setup';
import Authorise from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr2_ltng.Authorise'; 
import FurtherInformation from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr2_ltng.FurtherInformation';
import Decline from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr2_ltng.Decline';
import Save from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr2_ltng.Save';
import DeleteFI from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr2_ltng.DeleteFI';
import AddCase from '@salesforce/apex/BAA_SecondLineAuthorisationCntlr2_ltng.AddCase';

export default class Baa_SecondLineAuth extends NavigationMixin(LightningElement) {

    //@api EventId;@api SessionId; 
    
    @track BaseOpportunity;
    @api eventId; @api SessionId;
    @api oppId;
    parameters;
    @track wrap;
    showHeader =false;
    baseOppId;
    isCompleted;
    FiCases;
    updatedCases;
    IsDecline;
   
    connectedCallback(){
        //ng-init="OnInit('{!$Setup.pca__PostcodeAnywhereSettings__c.pca__Key__c}')"
        this.parameters = getParameters();
        console.log(this.parameters);
        this.eventId = this.parameters.id;
        this.oppId = this.parameters.oppId;
        this.isCompleted=false;
        this.IsDecline=false;
        console.log(this.eventId);

        wrapper({evnId:this.eventId,opportId:this.oppId}).then(result=>{
            console.log(result);
            this.wrap = result;
            this.BaseOpportunity= result.BaseOpportunity;
            this.baseOppId=this.BaseOpportunity.Id;
            this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
            this.getLoadEvent();
            this.getCasesOnLoad();
            console.log('result ***** IsCompleted js',this.isCompleted);
                console.log('result IsDecline js',this.IsDecline);
        }).catch(error =>{
            console.log(error);
        });
       
    }


    getLoadEvent(){
        console.log('this.eventId##'+this.eventId);
        LoadEvent({eventId:this.eventId})
        .then((result) => {
            this.isCompleted=result;
            console.log('result ***** js',JSON.stringify (result));
            console.log('result *****## js',this.isCompleted);
               
    })
    .catch((error) => {
        console.log('Error', error);
    });
    }


    onComplete(){
        console.log('this.eventId'+this.eventId);
        console.log('opportId:this.oppId'+this.baseOppId);
        complete({evnId:this.eventId,opportId:this.baseOppId}).then(result =>{
            console.log(result);
            window.location.href = result;
        }).catch(error =>{
            console.log(error);
        });
    }

    getCasesOnLoad(){
        console.log('this.baseOppId##'+this.baseOppId);
        Setup({OppId:this.baseOppId})
        .then((result) => {
            console.log('result ***** js',JSON.stringify (result));
            console.log('result ***** js',result);
            this.FiCases=JSON.parse(result);
            console.log('result this.FiCases***** js',JSON.stringify (this.FiCases));
            console.log('result this.FiCases***** js',this.FiCases);
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }

   getAuthorised(){
    console.log('this.baseOppId##'+this.baseOppId);
    Authorise({OppId:this.baseOppId})
    .then((result) => {
        console.log('result ### js',JSON.stringify (result));
        if(result){
            this.onComplete();
        }    
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }

    saveFurtherInformation(){
        console.log('this.baseOppId##'+this.baseOppId);
        FurtherInformation({OppId:this.baseOppId,
                            cases: JSON.stringify(this.FiCases)})
        .then((result) => {
            console.log('result saveFurtherInformation## js',result);
            if(result){
                location.reload();
            }    
            })
            .catch((error) => {
                console.log('Error', error);
            });
        }
    
        saveDecline(){
        console.log('this.baseOppId##'+this.baseOppId);
        Decline({OppId:this.baseOppId })
        .then((result) => {
            console.log('result saveDecline## js',result);
            if(result){
                this.IsDecline=result;
                //location.reload();
            }    
            })
            .catch((error) => {
                console.log('Error', error);
            });
        }
        
        SaveRecords(){
            console.log('FiCases##'+ this.FiCases);
            Save({cases: JSON.stringify(this.FiCases) })
            .then((result) => {
                console.log('result SaveRecords## js',result);
                if(result){
                    location.reload();
                }
                })
                .catch((error) => {
                    console.log('Error', error);
                });
            }

    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }
    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
        this.SaveRecords();
        //location.reload();
    }

    viewRecord(event) {
        // Navigate to Account record page
        console.log('nevigate', event.target.value);
        window.location.href = '/'+ event.target.value;
    }

    handleInputChange(event) {
        console.log('onsuccess event event save cases',event.target.value);
        console.log('onsuccesslet index =', event.target.dataset.index);
        this.FiCases[event.target.dataset.index].Further_Information=event.target.value;
        console.log('updated list', this.FiCases);
        //console.log('handleInputChange test',this.FiCases);
        //location.reload();
    }
    handleAppCommentChange(event) {
        console.log('onsuccess event event save cases',event.target.value);
        console.log('onsuccesslet index =', event.target.dataset.index);
        this.FiCases[event.target.dataset.index].Underwriter_Comments=event.target.value;
        console.log('updated list', this.FiCases);
        //console.log('handleInputChange test',this.FiCases);
        //location.reload();
    }
    get Further_Info_SatisfiedPick() {
        return [
            { label: '--None--', value: '' },
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
    }
    handlePickListChange(event){
        this.FiCases[event.target.dataset.index].Further_Info_Satisfied=event.detail.value; 
        console.log('updated pick list', event.detail.value);
       
    }

    deleteCase(event){
        console.log('Delete case', this.FiCases[event.target.dataset.index].ID);
        DeleteFI({caseId: this.FiCases[event.target.dataset.index].ID })
        .then((result) => {
              this.getCasesOnLoad();
            })
            .catch((error) => {
                console.log('Error', error);
            });
    }
    AddNewCase(){
        console.log('create case');
        AddCase({OppId: this.baseOppId,
                 cases: JSON.stringify(this.FiCases)})
        .then((result) => {
              this.getCasesOnLoad();
            })
            .catch((error) => {
                console.log('Error', error);
            });
    }

}