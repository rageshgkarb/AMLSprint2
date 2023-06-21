import { LightningElement , track , api, wire} from 'lwc';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_Mandates_Lightning.getWrapper';
import getSetup from '@salesforce/apex/BAA_Mandates_Lightning.getSetup';
import LoadMandatesAndSignatories from '@salesforce/apex/BAA_Mandates_Lightning.LoadMandatesAndSignatories';
import LoadSignatoriesAndGroups from '@salesforce/apex/BAA_Mandates_Lightning.LoadSignatoriesAndGroups';
import LoadMandateItems from '@salesforce/apex/BAA_Mandates_Lightning.LoadMandateItems';
import SaveMandateItems from '@salesforce/apex/BAA_Mandates_Lightning.SaveMandateItems';
import SaveSignatories from '@salesforce/apex/BAA_Mandates_Lightning.SaveSignatories';
import DeleteMandate from '@salesforce/apex/BAA_Mandates_Lightning.DeleteMandate';
import Complete from '@salesforce/apex/BAA_Mandates_Lightning.Complete';

export default class BaaMandates extends LightningElement {
    @track sigreq=false;
    @track siggrpreq=false;
    @track relreq=false;
    @track relnoformdatareq =false;
    @track nofromdatareq=false;
    @track limitreq=false;
    @track loading =false;
    @track BaseOpportunity;
    @api eventId;
    @api oppId;
    parameters;
    @track wrap;
    showHeader =false;
    @track SignatoryTypes=[];
    @track SignatoryGroupTypes=[];
    @track RelationshipTypes=[];
    opp;
    errormsg;
    accountNumber;
    IsCompleted;
    SelectedMandateId;
    @track response;
    @track responseMandate;
    @track MandateItems;
    @track mandates;
    @track nofromgroup;
    SignatoryList;
    _CurrentView;

    @track mandateRuleForm ={};

    set CurrentView(value){
        this._CurrentView=value;
        switch(value) {
            case "AccountEdit":
                this.LoadSignatoriesAndGroups();
              break;
            case "Edit":
                this.LoadMandateItems();
              break;
            case "NewMandate":
                this.SelectedMandateId = undefined;
                this.CurrentView = "Edit";
              break;
            case "View":
                this.LoadMandatesAndSignatories();
              break;
          }
    }

    get CurrentView(){
        return this._CurrentView;
    }

    get view(){
        if(this.CurrentView === 'View')return true;
        else return false;
    }
    get edit(){
        if(this.CurrentView === 'Edit')return true;
        else return false;
    }
    get AccountEdit(){
        if(this.CurrentView === 'AccountEdit') return true;
        else return false;
    }
    get signatory(){
        if(this.mandateRuleForm.ruleType === 'signatory') return true;
        else return false;
    }
    get relationship(){
        if(this.mandateRuleForm.ruleType === 'relationship') return true;
        else return false
    }
    get signatoryGroup(){
        if(this.mandateRuleForm.ruleType === 'signatoryGroup') return true;
        else return false
    }

    LoadSignatoriesAndGroups(){
        this.loading=true;
        LoadSignatoriesAndGroups({accountNo : this.accountNumber})
        .then( result => {
            this.response = JSON.parse(result);
            this.SignatoryList= this.response.SignatoryList;

            for (let index = 0; index < this.SignatoryList.length; index++) {
                const element = this.SignatoryList[index];
                console.log(JSON.stringify(element));
                let siggrp=[];
                for (let i = 0; i < this.response.SignatoryGroupList.length; i++) {
                    const ele = this.response.SignatoryGroupList[i];
                    if(element.SignatoryGroup == ele.Value){
                        siggrp.push({Label : ele.Label , Value : ele.Value ,selected : true});
                    }else{
                        siggrp.push({Label : ele.Label , Value : ele.Value ,selected : false});
                    }
                }
                element.SignatoryGroupList=siggrp;
            }
            /*
            
            for (let index = 0; index < this.SignatoryList.length; index++) {
                const element = array[index];
                let siggrp=[];
                for (let i = 0; i < this.response.SignatoryGroupList.length; i++) {
                    const ele = this.response.SignatoryGroupList[i];
                    if(element.SignatoryGroup == ele.Value){
                        siggrp.push({Label : ele.Label , Value : ele.Value ,selected : true});
                    }else{
                        siggrp.push({Label : ele.Label , Value : ele.Value ,selected : false});
                    }
                }
                element.SignatoryGroupList=siggrp;
            }
            */
            console.log('LoadSignatoriesAndGroups : '+JSON.stringify(JSON.parse(result)))
            this.loading=false;
        })
        .catch( error => {
            this.errormsg = error;
            alert(error.body.message)
            console.log('LoadSignatoriesAndGroups error : '+JSON.stringify(error))
            this.loading=false;
        })
    }
    LoadMandateItems(){
        this.mandateRuleForm = {};
        this.mandateRuleForm.ruleType = "signatoryGroup";
        this.mandateRuleForm.signatory = "";
        this.mandateRuleForm.signatoryGroup = "";
        this.mandateRuleForm.relationshiptype = "";

        this.mandateRuleForm.nofromgroup = "";
        this.responseMandate = null;

        let request = {MandateId: this.SelectedMandateId, AccountWithIBBId: this.response.AccountWithIBBId};
        //let request = {MandateId: this.SelectedMandateId, AccountWithIBBId: null};
        console.log('request : '+request.AccountWithIBBId);
        this.loading=true;
        LoadMandateItems({mid : this.SelectedMandateId , ibbacc :  this.response.AccountWithIBBId}) 
        .then( result => {
            this.responseMandate = JSON.parse(result);
            this.MandateItems = this.responseMandate.MandateItems;
            this.SignatoryTypes=[];
            this.SignatoryGroupTypes=[];
            this.RelationshipTypes=[];

            for (let index = 0; index < this.responseMandate.SignatoryTypes.length; index++) {
                const item = this.responseMandate.SignatoryTypes[index]; 
                this.SignatoryTypes.push({Label : item.Label , Value : item.Value , selected : false})
            }
            for (let index = 0; index < this.responseMandate.SignatoryGroupTypes.length; index++) {
                const item = this.responseMandate.SignatoryGroupTypes[index]; 
                this.SignatoryGroupTypes.push({Label : item.Label , Value : item.Value , selected : false})
            }
            for (let index = 0; index < this.responseMandate.RelationshipTypes.length; index++) {
                const item = this.responseMandate.RelationshipTypes[index]; 
                this.RelationshipTypes.push({Label : item.Label , Value : item.Value , selected : false})
            }
            console.log('LoadMandateItems : '+JSON.stringify(JSON.parse(result)))
            this.loading=false;
        })
        .catch( error => {
            this.errormsg = error;
            this.loading=false;
            console.log('LoadMandateItems error : '+error.body.message);
            
        })
    }
    LoadMandatesAndSignatories(){
        console.log('account number : '+this.accountNumber);
        LoadMandatesAndSignatories({findText : this.accountNumber})
        .then( result => {
            this.loading=false;
            this.response = JSON.parse(result);
            this.mandates = this.response.mandates;
            for (let index = 0; index < this.mandates.length; index++) {
                this.mandates[index].MandateLimit=this.mandates[index].MandateLimit.toFixed(2);
            }
            console.log('LoadMandatesAndSignatories : '+JSON.stringify(JSON.parse(result)))
        })
        .catch( error => {
            this.errormsg = error;
            //this.loading=false;
            console.log('LoadMandatesAndSignatories error : '+JSON.stringify(error))
            
        })
    }
    
    connectedCallback(){
        this.loading=true;
        this.parameters = getParameters();
        console.log('parameter : '+JSON.stringify(this.parameters));
        this.eventId = this.parameters.id;
        this.oppId = this.parameters.oppId;
        console.log('EventID : '+this.eventId);
        //console.log('Current View : '+this.CurrentView)

        wrapper({evnId:this.eventId,opportId:this.oppId}).then(result=>{
            console.log('Wrapper : '+JSON.stringify(result));
            this.wrap = result;
            this.IsCompleted=this.wrap.IsCompleted;
            this.BaseOpportunity= result.BaseOpportunity;
            this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
            //this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
            //this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
            getSetup({opp : this.wrap.opportunityId}).then(result => {
                this.opp=result;
                console.log('opp : '+JSON.stringify(result));
                this.accountNumber=result.Account_with_IBB__r.Name;
                //this.accountNumber= result.Account_With_IBB__r.Name;
                this.CurrentView = 'View';
                console.log('Debug');
            })
            .catch(error =>{
                console.log('get setup error : '+JSON.stringify(error));
                //this.errormsg = error.body.message;
                this.loading=false;
            })
        }).catch(error =>{
            console.log(' wrapper error : '+JSON.stringify(error));
            this.loading=false;
            //this.errormsg = error.body.message;
        });
    }
    updateSigGrp(){
        this.CurrentView ='AccountEdit'
    }
    onComplete(){
        this.loading=true;
        Complete({wrap : this.wrap}).then(result =>{
            console.log(result);
            window.location.href = result;
            this.loading=false;
        }).catch(error =>{
            console.log(error);
            this.loading=false;
        });
    }
    GotoMandateEdit(event){
        this.SelectedMandateId = event.target.dataset.id;
        this.CurrentView='Edit';
    }
    DeleteMandate(event){
        let mandateId = event.target.dataset.id;
        this.loading=true;
        DeleteMandate({mandateId : mandateId})
        .then( result =>{
            console.log('delete result : '+JSON.stringify(result))
            this.LoadMandatesAndSignatories();
            this.loading=false;
        })
        .catch( error =>{
            console.log('delete error : '+JSON.stringify(error))
            this.errormsg=error;
            this.loading=false;
        })
    }
    newMandate(){
        this.CurrentView='NewMandate';
    }
    SaveMandateRule(){
        let request = {
            MandateId : this.responseMandate.MandateId,
            AccountWithIBBId : this.response.AccountWithIBBId,
            MandateLimit : this.responseMandate.MandateLimit,
            MandateItems : new Array()
        };
        console.log(JSON.stringify(request));
        
        let mandateError = false;
        //let mandateErrorMessage = '';

        if ((request.MandateLimit == null) || (request.MandateLimit == '')){
            mandateError=true;
            this.showError('.limit','limit')
            //mandateErrorMessage='Mandate Limit not set';
        }
        else if (this.MandateItems.length < 1){
            mandateError=true;
            alert('No mandate items have been selected');
        }
        
        if (!mandateError){
            for( let i = 0; i < this.MandateItems.length; i++ ) {

                let mandateItem = {
                    Signatory : this.MandateItems[i].Signatory,
                    SignatoryGroup : this.MandateItems[i].SignatoryGroup,
                    RelationshipType : this.MandateItems[i].RelationshipType,
                    NoFromGroup : this.MandateItems[i].NoFromGroup
                };
                
               request.MandateItems[request.MandateItems.length] = mandateItem;
            }
            //this.ShowDocumentLoad('Please wait', 'Saving Mandate Item');
            let req = JSON.stringify(request) 
            this.loading=true;
            SaveMandateItems({request : req })
            .then( result => {
                //this.HideDocumentLoad();
                this.CurrentView = 'View';
                this.loading=false;

                this.SignatoryTypes=[];
                 this.SignatoryGroupTypes=[];
                this.RelationshipTypes=[];
                this.nofromgroup='';
                this.limitreq=false;

            })
            .catch( error => {
                //this.HideDocumentLoad();
                alert('ERROR: '+JSON.stringify(error.body.message));
                this.loading=false;
            })
            
        }
    }
    handleChange(event){
        let name= event.target.name;
        let value= event.target.value;
        let dataId=event.target.dataset.id;
        let classList = event.target.classList;
        let label=event.target.label;
        
        console.log('Label : '+ label);
        console.log('dataId : '+dataId);    
        console.log('Value : '+value);
        console.log('Name : '+name);
        console.log('Classes : '+JSON.stringify(classList))
        console.log('required : '+event.target.required)

        if(dataId === 'MandateLimitid') this.responseMandate.MandateLimit=value;
        else if(name === 'MandateRuleType'){
            this.mandateRuleForm.ruleType= value;
            this.hideReq();
        }
        else if(dataId === 'signatoryInput'){
            let sig={"Value": value,"Label": label }
            for (let index = 0; index < this.SignatoryTypes.length; index++) {
                if(this.SignatoryTypes[index].Value === value){
                    sig.Label=this.SignatoryTypes[index].Label;
                    this.SignatoryTypes[index].selected = true;
                }
                
            }
            
            this.mandateRuleForm.signatory = sig;
        }
        else if(dataId === 'signatoryGroupInput'){
            let sig={"Value": value,"Label": label }
            for (let index = 0; index < this.SignatoryGroupTypes.length; index++) {
                if(this.SignatoryGroupTypes[index].Value === value){
                    sig.Label=this.SignatoryGroupTypes[index].Label;
                    this.SignatoryGroupTypes[index].selected = true;
                }
                
            }
            console.log('value : '+sig.Value+'  Label : '+sig.Label);
            this.mandateRuleForm.signatoryGroup = sig;
        }
        else if(dataId ===  'noFromGroupInput'){
            this.mandateRuleForm.nofromgroup = value;
            this.nofromgroup=value;
        }
        else if(dataId === 'relationshipTypeInput'){
            let re={"Value": value,"Label": label }
            for (let index = 0; index < this.RelationshipTypes.length; index++) {
                if(this.RelationshipTypes[index].Value === value){
                    re.Label=this.RelationshipTypes[index].Label;
                    this.RelationshipTypes[index].selected = true;
                }
                
            }
            console.log('value : '+re.Value+'  Label : '+re.Label);
            this.mandateRuleForm.relationshiptype = re;

        }
        else if(classList.contains('siggrplist')){
            this.response.SignatoryList[dataId].SignatoryGroup = value;
            
        }
    }
    AddMandateRule(){
        if( this.mandateRuleForm.ruleType == 'signatory')
        {
            if ((this.mandateRuleForm.signatory.Value == null) || (this.mandateRuleForm.signatory.Value == '')){
                this.showError('.signatory','sig')
                //alert(limit.required)
            }
            else
            {
                this.hideError('.signatory','sig')
                this.MandateItems.push({
                    'SignatoryId' : this.mandateRuleForm.signatory.Value,
                    'Signatory' : this.mandateRuleForm.signatory.Label
                });
            }
        }
        else if ( this.mandateRuleForm.ruleType == 'signatoryGroup')
        {
            if ((this.mandateRuleForm.signatoryGroup.Value == null) || (this.mandateRuleForm.signatoryGroup.Value == '')){
                //alert('No signatory group selected');
                this.showError('.signatorygrp','siggrp')
            }
            else if ((this.mandateRuleForm.nofromgroup == null) || (this.mandateRuleForm.nofromgroup == '')){
                //alert('No numbers from group selected');
                this.showError('.nofromdata','nofromdata')
            }
            else
            {
                this.hideError('.signatorygrp','siggrp')
                this.hideError('.nofromdata','nofromdata')
                this.responseMandate.MandateItems.push({
                    'SignatoryGroup' :  this.mandateRuleForm.signatoryGroup.Value,
                    'NoFromGroup' : this.mandateRuleForm.nofromgroup
                });
            }
        }
        else if ( this.mandateRuleForm.ruleType == 'relationship')
        {
            if ((this.mandateRuleForm.relationshiptype.Value == null) || (this.mandateRuleForm.relationshiptype.Value == '')){
                this.showError('.relationship','rel')
            }
            else if ((this.mandateRuleForm.nofromgroup == null) || (this.mandateRuleForm.nofromgroup == '')){
                //alert('No numbers from group selected');
                this.showError('.relnofromdata','relnodata')
            }
            else
            {
                this.hideError('.relationship','rel')
                this.hideError('.relnofromdata','relnodata')
                this.responseMandate.MandateItems.push({
                    'RelationshipType' :  this.mandateRuleForm.relationshiptype.Value,
                    'NoFromGroup' : this.mandateRuleForm.nofromgroup
                });
            }
        }

    }

    RemoveMandateRule(event){
        let index=event.target.dataset.id;
        if (index === -1) {
            alert("Failed to remove Mandate");
        }
        else {
            this.MandateItems.splice(index, 1);
        }
    }

    SaveSignatories(){
        let req= JSON.stringify(this.response.SignatoryList);
        this.loading=true;
        SaveSignatories({request : req})
        .then(result => {
            this.response = result;
            this.CurrentView = 'View';
            this.loading=false;
        })
        .catch( error => {
            //this.HideDocumentLoad();
            alert(error.message);
            this.loading=false;
        })
    }
    save(event){
        let dataId=event.target.dataset.id;
        location.reload();
    }

    cancel(){
        this.CurrentView = 'View';
    }

    showError(className, place ){
        let ele = this.template.querySelector(className);
    
        if(ele.required){
            if(ele.value == '' || ele.value == null){
                ele.style.borderColor = 'red';
                ele.style.borderStyle = 'solid';
                ele.style.borderWidth = '3px';
            }
            switch (place) {
                case 'limit':
                    this.limitreq=true;
                    break;
                case 'sig':
                    this.sigreq=true;
                    break;
                case 'siggrp':
                    this.siggrpreq=true;
                    break;
                case 'rel':
                    this.relreq = true;
                    break;
                case 'relnodata':
                    this.relnoformdatareq=true;
                    break;
                case 'nofromdata':
                    this.nofromdatareq=true;
                    break;
            }
        }
    }

    hideError(className, place ){
        let ele = this.template.querySelector(className);
        if(ele.required){
            ele.style.border= '1px solid #ccc';
            switch (place) {
                case 'limit':
                    this.limitreq=false;
                    break;
                case 'sig':
                    this.sigreq=false;
                    break;
                case 'siggrp':
                    this.siggrpreq=false;
                    break;
                case 'rel':
                    this.relreq = false;
                    break;
                case 'relnodata':
                    this.relnoformdatareq=false;
                    break;
                case 'nofromdata':
                    this.nofromdatareq=false;
                    break;
            }
        }
    }

    hideReq(){
        this.sigreq=false;
        this.siggrpreq=false;
        this.relreq = false;
        this.relnoformdatareq=false;
        this.nofromdatareq=false;
    }
    
}