import { LightningElement, api } from 'lwc';
export default class TooltipUtility extends LightningElement {
@api
helptext;
isHelpTextShow = false;

    onHelpText(){
        this.isHelpTextShow = !this.isHelpTextShow;
    }
}