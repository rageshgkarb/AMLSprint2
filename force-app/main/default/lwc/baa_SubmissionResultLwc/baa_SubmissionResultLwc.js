import { LightningElement,track,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_SubmissonResults_LightningController.getWrapper';
import getDetails from '@salesforce/apex/BAA_SubmissonResults_LightningController.getDetails';
import getOpp from '@salesforce/apex/BAA_SubmissonResults_LightningController.getOpp';
import SaveCase from '@salesforce/apex/BAA_SubmissonResults_LightningController.SaveCase';
import allAccepted from '@salesforce/apex/BAA_SubmissonResults_LightningController.allAccepted'
import complete from '@salesforce/apex/BAA_SubmissonResults_LightningController.complete'
export default class Baa_SubmissionResultLwc extends NavigationMixin(LightningElement) {

 @track BaseOpportunity;
    @api eventId;
    @api oppId;
    parameters;
    @track wrap;
    baseOppId;
    clickSave=false;
    clickNext=false;
    showHeader =false;
    showError=false;
    saveCaseBool=false;
    showSpinner=false;
     Account;
     detailWrap;
     data;
     opp;
     caseNoList;
     IsCompleted;
    
      get Satisfiedoptions() {
        return [
            { label: 'No', value: 'No' },
            { label: 'Yes', value: 'Yes' },
            
        ];
    }

    connectedCallback(){
        //ng-init="OnInit('{!$Setup.pca__PostcodeAnywhereSettings__c.pca__Key__c}')"
        this.parameters = getParameters();
        console.log("parameters="+JSON.stringify( this.parameters));
        this.eventId = this.parameters.id;
        this.oppId = this.parameters.oppId;
        console.log(this.eventId);
                     console.log("oppID="+this.oppId);

        wrapper({evnId:this.eventId,opportId:this.oppId}).then(result=>{
            console.log("wrapper result="+JSON.stringify(result));
            this.wrap = result;
            this.IsCompleted=this.wrap.IsCompleted;
            this.BaseOpportunity= result.BaseOpportunity;
            this.baseOppId=this.BaseOpportunity.Id;
            this.Account=result.Accounts;
            this.Account.forEach(currentItem => {
                console.log("curr item= "+JSON.stringify(currentItem));
            });
             console.log("callin cgd");
            this.callgetDetails();
            this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
        }).catch(error =>{
            console.log(error);
        });

        
        
        console.log('end ccb');
    }
    callgetDetails(){
    getDetails({accounts:this.Account,opportId:this.baseOppId }) .then(result=>{
        this.data=result;
        this.detailWrap=result.detailList;
        console.log('Data', JSON.stringify(result));

      }) .catch (error=> {
         console.error('Error:', error);
      });
    getOpp({opportId:this.baseOppId}).then(result=>{
        this.opp=result;
         console.log('opp', JSON.stringify(this.opp));
    }).catch(error=>{
        console.log('Error:',error);
    });
    console.log('wrap.IsCompleted=', this.wrap.IsCompleted);
    }

   handleChange(event){
       this.saveCaseBool=false;
       //value=event.target.value;
       console.log('value='+ event.target.value);
       //name=event.target.name;
       console.log('name='+event.target.name);
       this.detailWrap.forEach(item=>{
           console.log('in dW');
           item.Cases.forEach(cas=>{
               if(cas.id==event.target.name){
                   console.log(cas.Satisfied);
                   cas.Satisfied=event.target.value;
                   console.log(cas.Satisfied);
                   return;
               }
           })
       });
   }

   handleCommentChange(event){
       this.saveCaseBool=false;
        console.log('name='+event.target.name);
       this.detailWrap.forEach(item=>{
           console.log('in dW');
           item.Cases.forEach(cas=>{
               if(cas.id==event.target.name){
                   console.log(cas.Comment);
                   cas.Comment=event.target.value;
                   console.log(cas.Comment);
                   return;
               }
           })
       });

   }

   handleCaseSummaryChange(event){
       this.saveCaseBool=false;
       this.opp.SellerBDM_Case_Summary__c=event.target.value;
       console.log('opp.SellerBDM_Case_Summary__c=', this.opp.SellerBDM_Case_Summary__c);
   }

   handleCompanyHouseCheckChange(event){
       this.saveCaseBool=false;
       this.opp.Company_House_Check__c=event.target.value;
       console.log('opp.Company_House_Check__c=', this.opp.Company_House_Check__c);
   }

   handleCheckCopyAttachedChange(event){
       this.saveCaseBool=false;
       this.opp.Co_Hse_Check_Copy_Attached__c=event.target.value;
       console.log('opp.Co_Hse_Check_Copy_Attached__c=', this.opp.Co_Hse_Check_Copy_Attached__c);
   }

   handleShowClick(event){
       try{
            console.log('in try ',event.target.title);
            let idx=event.target.title;
            let casidx=event.target.name;
              let recs =  JSON.parse( JSON.stringify( this.detailWrap ) );
              let currVal=recs[idx].Cases[casidx].ShowComment;
              console.log('currval=',currVal);
              recs[ idx ].Cases[casidx].ShowComment = !currVal;
              this.detailWrap=recs;
              console.log( 'After Change ' + this.detailWrap[ idx ].Cases[casidx].ShowComment);

      
       }catch(ex){console.log('error=',ex)};
   }

   handleSaveClick(event){
       event.preventDefault();
       this.clickSave=true;
        console.log('in handlesaveClick');
        //this.showSpinner=true;
        const fields = event.detail.fields;
        console.log('fields ',JSON.stringify(fields));
       // this.template.querySelector('lightning-record-edit-form').submit(fields);

      // if(!this.opp.Company_House_Check__c){
            /*  let inputText = this.template.querySelector( ".form-control1" );
            inputText.setCustomValidity( "This field is required/mandatory" );
            inputText.reportValidity();*/
     //  }else if(!this.opp.Co_Hse_Check_Copy_Attached__c){
          /* let inputText = this.template.querySelector( ".form-control2" );
            inputText.setCustomValidity( "This field is required/mandatory" );
            inputText.reportValidity();*/
     //  }else{ 
     //  this.data.detailList=this.detailWrap;
      /* setTimeout(() => {
        this.callSaveCase()
        }, 0);*/
     //  }
     //  this.callSaveCase();
      
   }
   handleCaseNoClick(event){
       console.log('window.location.origin=',window.location.origin);
          const recordId = event.target.dataset.casid;
         console.log('recordId=',recordId);
         //this.url=window.location.origin+"/"+recordId;
         window.location.href=window.location.origin+"/"+recordId;
        // window.location.assign('/'+recordId);
        
   }

   handleNextClick(event){
       this.clickNext=true;
        console.log('in handleClickNext');
        
     /*  let allAccept;
       console.log('in handleClickNext');
       allAccepted({containsUSPerson:this.data.containsUSPerson,oppid:this.oppId})
       .then(result=>{
           this.caseNoList=result;
           console.log('caseList=',this.caseNoList);
           if(!this.caseNoList.length)
           {    this.showError=false; 
                console.log('showError=',this.showError);
                allAccept=true;
                this.onComplete(allAccept);
            }
           else {
                    this.showError=true;
                    allAccept=false;
                }
            

       }).catch(error=>{
           console.log('error=',error);
       })*/
   }

   callSaveCase(){
        this.showSpinner=true;
        SaveCase({dtls:this.data,opp:this.opp,opportId:this.baseOppId})
       .then(result=>{
           console.log('updated');
           this.saveCaseBool=true;
           this.showSpinner=false;
           
       }).catch(error=>{
           console.log('error',error);
           this.showSpinner=false;
       });
   }

   callcomplete(allAccept){
       console.log(JSON.stringify(this.wrap));
       console.log('allAccept',allAccept);
        complete({wrap:this.wrap,allAccept:allAccept}).then(result =>{
            console.log(result);
            window.location.href = result;
            this.showSpinner=false;
        }).catch(error =>{
            console.log(error);
            this.showSpinner=false;
        });
   }

   callSaveCaseNext(allAccept){
       console.log('allAccept',allAccept);
        SaveCase({dtls:this.data,opp:this.opp,opportId:this.baseOppId})
       .then(result=>{
           console.log('updated');
           this.saveCaseBool=true;
           this.callcomplete(allAccept);
       }).catch(error=>{
           console.log('error',error);
           this.showSpinner=false;
       });
   }

    onComplete(allAccept){
        
        if(this.saveCaseBool==false){
             this.showSpinner=true;
            setTimeout(() => {
             this.callSaveCaseNext(allAccept);
            }, 0);
             //this.showSpinner=false;
        }
        else {
                this.callcomplete(allAccept);
               // this.showSpinner=false;
            }
        
    }
    handleKeyUp(event){
        event.currentTarget.reportValidity();
    }

    handleSuccess(event){
        this.showSpinner=true;
         console.log('in handleSuccess');
        if(this.clickSave==true){
            this.clickSave=false;
            console.log('in else Clicksave handleSuccess');
            this.data.detailList=this.detailWrap;
            //this.showSpinner=true;
             setTimeout(() => {
             this.callSaveCase();
            }, 0);
            this.showSpinner=false;
           // this.callSaveCase();
             
            
        }
        else if(this.clickNext==true){
                this.clickNext=false;
                let allAccept;
                console.log('in else ClickNext handleSuccess');
                allAccepted({containsUSPerson:this.data.containsUSPerson,oppid:this.baseOppId})
                .then(result=>{
                    this.caseNoList=result;
                    console.log('caseList=',this.caseNoList);
                    if(!this.caseNoList.length)
                    {    this.showError=false; 
                            console.log('showError=',this.showError);
                            allAccept=true;
                            this.onComplete(allAccept);
                        }
                    else {
                                this.showError=true;
                                allAccept=false;
                                this.showSpinner=false;
                            }
                        

                }).catch(error=>{
                    console.log('error=',error);
                    this.showSpinner=false;
                })
                
        }

    }

    handleError(){
        console.log('in handle Error');
        this.showSpinner=false;
    }

    handleNewWinOpen(){
        window.open('https://www.equifax.co.uk/equifax/commercial/', 
                    'newwindow', 
                    'width=600,height=500'); 
              return true;
    }
   
  
}