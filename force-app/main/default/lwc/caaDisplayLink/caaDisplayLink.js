import { LightningElement,track,api } from 'lwc';

export default class CaaDisplayLink extends LightningElement {
    @api nameOftheLink;
    @api base;
    @api concatenateValue;
    @track displayName;
    @track baseURL;
    @track params;
    @track urlDisplay;

    connectedCallback(){
        this.urlDisplay = this.base+this.concatenateValue;
        this.displayName = this.nameOftheLink;
    }
}