import { LightningElement,api,track } from 'lwc';
import {getParameters} from 'c/caaUtility';
import wrapper from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.getWrapper';
import loadOpp from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.getBAA_SelfCert_Controller_Lightning';
import GetApplicantData from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.GetApplicant';
import GetApplicantPersons from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.GetApplicants';
import SaveCombined from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.CombinedSave';
import Save from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.Save';
import SaveControllingPersons from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.SaveControllingPersons';
import SaveNonAppControllingPersons from '@salesforce/apex/BAA_SelfCert_Controller_Lightning.SaveNonAppControllingPersons';
import PCA_ADDRESS from '@salesforce/resourceUrl/AddressJS';
import {loadScript} from 'lightning/platformResourceLoader';

export default class BaaSelfCertification extends LightningElement {
    @track BaseOpportunity;
    @api eventId;
    @api oppId;
    @api PCA_key;
    parameters;
    @track wrap;
    showHeader =false;
    timerid;
    @track sections ={
        section1 :true,
        section2 :false,
        section3 :false,
        section4 :false,
        section5 :false,
        reset(){
            this.section1 =false;
            this.section2 =false;
            this.section3 =false;
            this.section4 =false;
            this.section5 =false;  
        }
    };
       // CurrentStage = 0;
        
        Data = null;
        ControllingPersonsData = null;
		ControllingOtherPersonsData = null;
        CountryCode = null;
        PCA_key = '';
        TinCount = 0;
        ShowSection4 = false;
        showBusy = false;

        IsSaved = false;
        ReadyForCompletion = false;
        error;
        PrimaryControllingPerson = null;
        ApplicantControllingPersons = [];
        ControllingPersonAddedCount = 0;

    connectedCallback(){
        
        this.parameters = getParameters();
        this.eventId = this.parameters.id;
        this.oppId = this.parameters.oppId;
        this.showBusy = true;
        Promise.all([
            loadScript(this, PCA_ADDRESS), // address script
        ])
        .then(() => {
            wrapper({evnId:this.eventId,opportId:this.oppId}).then(result=>{
                this.wrap = result;
                this.BaseOpportunity= result.BaseOpportunity;
                this.template.querySelector('c-baa-header-cmp').showHeaderComp(false, result.BaseOpportunity);
                this.template.querySelector('c-baa-menu-cmp').getMenuParameters(this.eventId , result.BaseOpportunity.Id,result.BaseOpportunity.ProductEventDirector__c);
                this.OnInit(this.PCA_key);
                this.ShowSection4 = this.displaySection4();
                this.showBusy = false;
            }).catch(error =>{
                this.error = error;
                console.log(error);
            });
        })
        .catch(error => {
            this.error = error;
            console.log(' scripts failed' + error);
        });
    }
    onComplete(){
        console.log(JSON.stringify(this.wrap));
        complete({wrap:this.wrap}).then(result =>{
            console.log(result);
            window.location.href = result;
        }).catch(error =>{
            console.log(error);
        });
    }
    onChangeStage(event){
        let active = this.getKeyByValue(this.sections,true);
        this.template.querySelector('.'+active).classList.remove('active');
        this.sections.reset();
        this.sections[event.target.dataset.id] = true;
        this.template.querySelector('.'+event.target.dataset.id).classList.add('active');
        if(this.timerid){
            clearTimeout(this.timerid);
            this.timerid = setTimeout (()=>{this.setChildData(this.Data);},100);
        }else
            this.timerid = setTimeout (()=>{this.setChildData(this.Data);},100);

    }
    getKeyByValue(object, value) {
        return Object.keys(object).find(key => object[key] === value);
      }
    

    displaySection4 (){
        if(this.Data) {
            if (this.Data.Applicant.Entity_Type_c == 'Financial Institution' && this.Data.Applicant.Financial_Institution_Type_c == 'Investment entity: An investment entity located in a non-participating jurisdiction and managed by another FI') {
                return true;
            }

            if (this.Data.Applicant.Entity_Type_c == 'Non Financial Entity' && this.Data.Applicant.Non_Financial_Entity_Type_c == 'Passive') {
                return true;
            }
        }
        return false;
    }

    OnInit  (pca_key) {
        this.showBusy = true;
        
        //this.CurrentStage = 1;
        console.log( pca_key);

        GetApplicantData({eventId:this.eventId})
            .then(result => {
                    console.log('data Section');
                    console.log(result);
                    this.Data = result;
                    this.InitActiveStatuses();

                    this.TinCount = this.InitTin(2) ? 1 : this.TinCount;
                    this.TinCount = this.InitTin(3) ? 2 : this.TinCount;
                    this.TinCount = this.InitTin(4) ? 3 : this.TinCount;
                    this.TinCount = this.InitTin(5) ? 4 : this.TinCount;
                    this.setChildData(this.Data);
                    this.showBusy = false;
                },
                function (error) {
                    console.log(error);
                    this.showBusy = false;
                }
            );

        setTimeout(() => {
            this.InitPCA();
        }, 1000);
    }
    setChildData(Data){

        if(this.sections.section1)
        this.template.querySelector('c-baa-self-cert-section1-cmp').setData(Data);
        else if(this.sections.section2)
        this.template.querySelector('c-baa-self-cert-section2-cmp').setData(Data);
        else if(this.sections.section3)
        this.template.querySelector('c-baa-self-cert-section3-cmp').setData(Data);
        else if(this.sections.section4)
        this.template.querySelector('c-baa-self-cert-section4-cmp').setData(Data);
        else if(this.sections.section5)
        this.template.querySelector('c-baa-self-cert-section5-cmp').setData(Data);
            
        
    }
    InitStage1CountryCodes  () {
        if (this.Data.Applicant.TradingAddressCountry_c != '') {
            this.CountryCode = this.GetCountryCode(this.Data.Applicant.TradingAddressCountry_c, this.Data.CountryCodes);
        } else if (this.Data.Applicant.CorrespondenceAddressCountry_c != '') {
            this.CountryCode = this.GetCountryCode(this.Data.Applicant.CorrespondenceAddressCountry_c, this.Data.CountryCodes);
        }
    }

    InitPCA () {
        var options = {
            key: this.PCA_key
        }

        var fieldsTrading = [{
            element: "streetTrading",
            field: "Line1"
        }, {
            element: "cityTrading",
            field: "City",
            mode: pca.fieldMode.POPULATE
        }, {
            element: "postcodeTrading",
            field: "PostalCode"
        }, {
            element: "countryTrading",
            field: "CountryName",
            mode: pca.fieldMode.COUNTRY
        }];

        var fieldsCorrespondance = [{
            element: "streetCsp",
            field: "Line1"
        }, {
            element: "cityCsp",
            field: "City",
            mode: pca.fieldMode.POPULATE
        }, {
            element: "postcodeCsp",
            field: "PostalCode"
        }, {
            element: "countryCsp",
            field: "CountryName",
            mode: pca.fieldMode.COUNTRY
        }];

        this.addressTradingControl = new pca.Address(fieldsTrading, options);
        this.addressCspControl = new pca.Address(fieldsCorrespondance, options);
    }

    InitActiveStatuses () {
        if (this.Data.Applicant.Active_Statuses_c != undefined || this.Data.Applicant.Active_Statuses_c != null) {
            var splits = this.Data.Applicant.Active_Statuses_c.split(';');
            if (splits != null && splits.length > 0) {
                splits.forEach((s) => {
                    var found = this.Data.ActiveStatuses.find((item) => {
                        return item.Value == s;
                    });

                    if (found != null) {
                        found.checked = true;
                    }
                });
            }
        }
    }

    InitControllingPersons  () {
        this.ControllingPersonAddedCount=0;
        if (this.ControllingPersonsData == null) {
            GetApplicantPersons({eventId:this.eventId})
                .then(result => {
                        this.ControllingPersonsData = result;
                        this.InitControllingPersonsData();
                    },
                    function (error) {
                        console.log(error);
                    }
                );
        }
    }

   

   InitControllingPersonsData () {
        
        if (this.ControllingPersonsData.length > 0) {
            this.ApplicantControllingPersons = [];

            for (i = 0; i < this.ControllingPersonsData.length; i++) {
                if(this.ControllingPersonsData[i].Added){
                    this.ApplicantControllingPersons.push(this.ControllingPersonsData[i]);
                }
            }
            this.ControllingPersonAddedCount+=this.ApplicantControllingPersons.length;
            console.log('this.ControllingPersonsData:'+JSON.stringify(this.ControllingPersonsData));
            console.log('this.ApplicantControllingPersons:'+JSON.stringify(this.ApplicantControllingPersons));

        }
        
    }

 
    

    

    GetCountryCode(countryName, countryCodes) {
        if (countryName != '') {
            var found = countryCodes.find((item) => {
                return item.Value == countryName;
            });

            if (found !== null || found !== undefined) {
                return found;
            } else {
                return null;
            }
        }
    }

   UpdateActionStatus () {
        var result = '';
        this.Data.ActiveStatuses.forEach((s) => {
            if (s.checked) {
                result += s.Value + ';'
            }
        });

        this.Data.Applicant.Active_Statuses_c = result;
    }

    ShowComplete (section1Valid, section2Valid, section3Valid, section4Valid, section5Valid) {            
       var result = (section1Valid && section2Valid && section3Valid && section5Valid && (this.ShowSection4 == false || (this.displaySection4() && section4Valid)));
       if(result) 
       {
           this.ReadyForCompletion = true;
       }
    }

    OnSave (section1Valid, section2Valid, section3Valid, section4Valid, section5Valid) {
        console.log('Before Save..');
        this.ErrorMessage = null;
        this.ErrorAction = null;

        console.log(JSON.stringify(this.ControllingPersonsData));
        console.log(JSON.stringify(this.ControllingOtherPersonsData));
        console.log(JSON.stringify(this.OtherControllingPersons));
        this.showBusy = true;
        this.ShowComplete(section1Valid, section2Valid, section3Valid, section4Valid, section5Valid);
        this.UpdateActionStatus();

        this.RemoveUnwantedTINData(this.ControllingPersonsData);
        console.log('After removal of unwanted items..');
        console.log(JSON.stringify(this.ControllingPersonsData));
        console.log(JSON.stringify(this.OtherControllingPersons));

        SaveCombined({eventId:this.eventId,applicant:this.Data.Applicant,persons:this.ControllingPersonsData, otherPersons:this.OtherControllingPersons})
            .then(result => {

                if(this.ReadyForCompletion) {
                    this.IsSaved = true;
                }

                if(result){
                    this.OtherControllingPersons = result;
                }

                this.showBusy = false;
            },function (error) {

                this.ErrorMessage = error.message;
                this.ErrorAction = error.action + ':' + error.method;

                console.log(error);
                this.showBusy = false;
            })


        
    }

    AddControllingPerson(person) {
        if(person!=undefined)
        {
            person.Added = true;
            this.ControllingPersonAddedCount += 1;
        }
        else
        {
            var num = this.OtherControllingPersons.length;
            var other = { Firstname:"",Lastname:"", Added:true, Applicant_Number_c:num+6, isApplicant:false };
            this.OtherControllingPersons.push(other);
            this.ControllingPersonAddedCount += 1;
        }
        
        
    }

    removeTin(personList,tin,index)
    {



        var tinData;

        if(personList){
            tinData = personList[index];
        }else{
            tinData = this.Data.Applicant;
        }



        switch(tin)
        {
            case 1:
                tinData.TIN_2_Check_c='';
                tinData.TIN_2_c='';
                tinData.TIN2_Country_Tax_Residence_c='';
                tinData.TIN_2_reason_code_c='';
                tinData.TIN_2_reason_B_explanation_c='';

            break;
            case 2:
                tinData.TIN_3_Check_c='';
                tinData.TIN_3_c='';
                tinData.TIN3_Country_Tax_Residence_c='';
                tinData.TIN_3_reason_code_c='';
                tinData.TIN_3_reason_B_explanation_c='';

            break;
            case 3:
                tinData.TIN_4_Check_c='';
                tinData.TIN_4_c='';
                tinData.TIN4_Country_Tax_Residence_c='';
                tinData.TIN_4_reason_code_c='';
                tinData.TIN_4_reason_B_explanation_c='';

            break;
            case 4:
                tinData.TIN_5_Check_c='';
                tinData.TIN_5_c='';
                tinData.TIN5_Country_Tax_Residence_c='';
                tinData.TIN_5_reason_code_c='';
                tinData.TIN_5_reason_B_explanation_c='';

            break;

        }
        
    }

    RemoveUnwantedTINData(personList){
        for(i=0;i<personList.length;i++)
        {
            /* START: Remove any unwanted answers before saving */
            if(personList[i].TIN_1_Check_c)
            {
                if(personList[i].TIN_1_Check_c=='Yes')
                {
                    personList[i].TIN_1_reason_code_c='';
                    personList[i].TIN_1_reason_B_explanation_c='';
                }
                else
                {
                    personList[i].TIN_1_c='';
                }
            }

            if(personList[i].TIN_2_Check_c)
            {
                if(personList[i].TIN_2_Check_c=='Yes')
                {
                    personList[i].TIN_2_reason_code_c='';
                    personList[i].TIN_2_reason_B_explanation_c='';
                }
                else
                {
                    personList[i].TIN_2_c='';
                }
            }

            if(personList[i].TIN_3_Check_c)
            {
                if(personList[i].TIN_3_Check_c=='Yes')
                {
                    personList[i].TIN_3_reason_code_c='';
                    personList[i].TIN_3_reason_B_explanation_c='';
                }
                else
                {
                    personList[i].TIN_3_c='';
                }
            }

            if(personList[i].TIN_4_Check_c)
            {
                if(personList[i].TIN_4_Check_c=='Yes')
                {
                    personList[i].TIN_4_reason_code_c='';
                    personList[i].TIN_4_reason_B_explanation_c='';
                }
                else
                {
                    personList[i].TIN_4_c='';
                }
            }

            if(personList[i].TIN_5_Check_c)
            {	
                if( personList[i].TIN_5_Check_c=='Yes')
                {
                    personList[i].TIN_5_reason_code_c='';
                    personList[i].TIN_5_reason_B_explanation_c='';
                }
                else
                {
                    personList[i].TIN_5_c='';
                }
            }
            /* END: Remove any unwanted answers before saving */
        }
        
    }





   

    InitTin (index) {
        var result = false;
        if (this.Data.Applicant['TIN_' + index + '_Check_c'] != undefined &&
            this.Data.Applicant['TIN_' + index + '_Check_c'] != null &&
            this.Data.Applicant['TIN_' + index + '_Check_c'] != '') {
            result = true;
        }

        if (!result &&
            this.Data.Applicant['TIN' + index + '_Country_Tax_Residence_c'] != undefined &&
            this.Data.Applicant['TIN' + index + '_Country_Tax_Residence_c'] != null &&
            this.Data.Applicant['TIN' + index + '_Country_Tax_Residence_c'] != '') {
            result = true;
        }

        if (!result &&
            this.Data.Applicant['TIN_' + index + '_c'] != undefined &&
            this.Data.Applicant['TIN_' + index + '_c'] != null &&
            this.Data.Applicant['TIN_' + index + '_c'] != '') {
            result = true;
        }

        return result;
    }

    TinNumberChanged(model, index) {
        var property = 'TIN_'+index+'_c';
        if(model.Applicant[property] == undefined || model.Applicant[property] == 'null') {
            model.Applicant[property] = null;
        }
    }
}