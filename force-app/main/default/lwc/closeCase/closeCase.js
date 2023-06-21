import { api, LightningElement, track, wire } from 'lwc';
import retrieveCaseFields from '@salesforce/apex/CloseCaseController.retrieveCaseFields';
import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

export default class CloseCase extends NavigationMixin(LightningElement) {
    inputFields;
    error;
    status;
    errormsg;
    @track options=[];
    @track statusList=[];
    @api recordId;
    @track loading = false;
    @api fieldSet;
    @api recordtype;
    	

@wire(getPicklistValuesByRecordType, { objectApiName: 'Case', recordTypeId: '$recordtype' })
locationLeadProviderListValues({error, data}) {
if(data) {

this.statusList = data.picklistFieldValues.Status.values;
    let picklist=[]

 for (let i = 0; i < this.statusList.length; i++) {
    if(this.statusList[i].attributes.closed === true){
           // picklist.push(JSON.stringify(this.statusList[1]));
            picklist.push({label: this.statusList[i].label , value: this.statusList[i].label})
    }
}
this.options=picklist;
}
else if(error) {
console.log('error =====> '+JSON.stringify(error));
}
}


    @wire(retrieveCaseFields,{FieldSetName : '$fieldSet'})
    wireFieldSets({error , data}){
        if(data){
            this.inputFields=data;
        }
        if(error) error=error;

    }
    handleChange(event){
        this.status = event.detail.value;
    }
    handleSubmit(event){
        event.preventDefault();
         
        const fields = event.detail.fields;
        if(this.status !== undefined){
            console.log(JSON.stringify(fields))
            fields.Status = this.status;
            this.loading=true;
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }
        else{
            this.loading=false;
            this.errormsg="Please Select Status"
        }
    }

    handleError(event){
        this.loading=false;
    }

    handleSuccess(){
        window.open("/"+this.recordId , '_self');
        this.loading=false;
    }
    cancel(){
        window.open("/"+this.recordId , '_self')
    }

 
}