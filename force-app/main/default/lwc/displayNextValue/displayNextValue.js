import { LightningElement,track,api } from 'lwc';

export default class DisplayNextValue extends LightningElement {
    @api currentNum;
    @api displayVal;
    @api valueToAdd;
    @track displayValue='';
    connectedCallback(){
    
        var current = parseInt(this.currentNum);
        var toAdd = parseInt(this.valueToAdd);
        var sum = current + toAdd;
        console.log('currentNum',this.currentNum);
        console.log('this.valueToAdd',this.valueToAdd);
        this.displayValue = this.displayVal + sum;
    }
}