import {
    LightningElement,
    api
} from 'lwc';
export default class CaaInputError extends LightningElement {
    @api field;
    @api ermaxlength;
    @api erminlength;
    @api errequired;
    @api eremail;

    isRequired = false;
    isMinLength = false;
    isMaxLength = false;
    isEmail = false;

    @api fieldValue;

    @api
    validateInputField(fieldValue) {
            this.isRequired = false;
            this.isMinLength = false;
            this.isMaxLength = false;
            this.isEmail = false;
        if (this.errequired &&(!fieldValue ||  fieldValue == null || fieldValue.length === 0 )) {
           
                this.isRequired = true;
                return true;
            
        } else if (this.ermaxlength && (!fieldValue || fieldValue.length > this.ermaxlength)) {
            
                this.isMaxLength = true;
                return true;
            
        } else if (this.erminlength && (!fieldValue || fieldValue.length < this.erminlength)) {
     
                this.isMinLength = true;
                return true;
            
        }
        else if (this.eremail && !fieldValue || fieldValue.match(
                /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
              )) {
                
                this.isEmail = true;
                return true;
            }
            

            return false;
        
    }

}