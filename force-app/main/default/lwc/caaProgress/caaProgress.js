import { LightningElement,api } from 'lwc';
export default class CaaProgress extends LightningElement {
@api
stage = "1";

    renderedCallback() {
        var txt = 'stage-progress-'+this.stage;
        this.template.querySelector('[data-id="'+txt+'"]').className = 'your-progress-active';
    }
}