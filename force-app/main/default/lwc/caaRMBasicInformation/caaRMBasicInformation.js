import {LightningElement,track,wire,api} from "lwc";

export default class CaaRMBasicInformation extends LightningElement {
    @api ypsa
    @api currentaccount
    @api ftd
    @api model
    @api isguest
    @api applicantindex
    @api applicant;
    @api valuefromparent;
    @track app={};
    @track showHideApplicant = true;
    @track  SerialNo = new Map([
        [0, 'One'],
        [1, 'Two'],
        [2, 'Three'],
        [3, 'Four'],
        [4, 'Five'],
        
      ]);
      @track headerId = 'heading';
      @track firstHeading = '';
      @track applicantHeading = 'Applicant ';
      @track fields = ['Country_of_Expected_Transactions_Credits_c','Country_of_Expected_Transactions_Debits_c','Currencies_of_Expected_Transactions_c','Source_of_Wealth_c'];
      
      connectedCallback(){
        //this.headerId = this.headerId+this.index.get(this.applicantindex);
        this.headerId = this.headerId+this.applicantindex;
        this.firstHeading = this.applicantindex === 0 ? "Young Person" : "Guardian " + this.applicantindex;
        this.applicantHeading = this.applicantHeading + this.SerialNo.get(this.applicantindex);
        this.app = JSON.stringify(this.applicant);
        this.app = JSON.parse(this.app);
        console.log('applicant',this.app['EDD_Data_Missing']);
        console.log('datafromparent:',this.valuefromparent);
        this.valuefromparent = JSON.stringify(this.valuefromparent);
        this.valuefromparent = JSON.parse(this.valuefromparent);
        this.updateDropdownSelected('Country_of_Expected_Transactions_Credits_c','CountryOfExpCredits');
        this.updateDropdownSelected('Country_of_Expected_Transactions_Debits_c','CountryOfExpDebits');
        this.updateDropdownSelected('Currencies_of_Expected_Transactions_c','CurrenciesOfExpDenomination');
        this.updateDropdownSelected('Source_of_Wealth_c','SourceOfWealth');

        
      }

      onchangeDropDown(event){
        console.log('Name:',event.target.name);
        console.log('Value:',event.target.value);
        console.log('id:',event.target.id);
        this.app[event.target.name] = event.target.value;
        var inputValue = event.target.value;
        const listIndex = event.target.id.substring(0, event.target.id.indexOf('-'));
        this.updateDropdownSelected(event.target.name,listIndex);
        this.template.querySelectorAll('c-caa-input-error').forEach(element => {

            
            const elementid = element.id.substring(0, element.id.indexOf('-'));
            
            if(elementid ==event.target.name){
                console.log('Element ID',elementid+'event.target.name',event.target.name);
                element.validateInputField(inputValue);   
            }
            //element.saveSection(this.formId,this.formName);
         });
        //console.log('temp:',this.template.querySelector('c-caa-input-error-cmp[data-id="'+event.target.name+'"]').validateInputField(inputValue));//.validateInputField(inputValue);
        const lwcEvent= new CustomEvent('valuechange', {
            detail:{app:this.app, index :this.applicantindex} 
           });
          this.dispatchEvent(lwcEvent);
    }

      updateDropdownSelected(fieldApi,dropDownName){
        for(var i=0;i<this.valuefromparent[dropDownName].length;i++){
            if(this.app[fieldApi] == this.valuefromparent[dropDownName][i].Key){
                this.valuefromparent[dropDownName][i].selected = true;    
            }else{
                this.valuefromparent[dropDownName][i].selected = false;  
            }
        }
      }

    @api
    validateInputs() {
        this.template.querySelectorAll('c-caa-input-error').forEach(element => {
            
            for(var i=0;i<this.fields.length;i++){
                let fieldApi = this.fields[i];
                console.log('Input Validate:',this.app[fieldApi]);
                let elementid = element.id.substring(0, element.id.indexOf('-'));
                console.log('elementid:',elementid);
                if(elementid == this.fields[i]){
                    element.validateInputField(this.app[fieldApi]);
                }
            }
                
            //element.validateInputField(inputValue);   
            
            
         });
        if(this.app.Country_of_Expected_Transactions_Credits_c && this.app.Country_of_Expected_Transactions_Debits_c && this.app.Currencies_of_Expected_Transactions_c && this.app.Source_of_Wealth_c){
            return true;
        }else{
            return false;
        }    
        
    }

    hideApplicant(){
        this.showHideApplicant = !this.showHideApplicant;
    }
    
   
}