import { LightningElement } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import Bootstrap_3_2_0 from '@salesforce/resourceUrl/Bootstrap_3_2_0';
import FontAwesome_4_5_0 from '@salesforce/resourceUrl/FontAwesome_4_5_0';
export default class caaNextStepsFooter extends LightningElement {

 connectedCallback(){
       
        Promise.all([
           
            loadScript(this, Bootstrap_3_2_0 +'/js/bootstrap.min.js'), // CSS File
            loadStyle(this, Bootstrap_3_2_0 +'/css/bootstrap.min.css'), // CSS File
            loadStyle(this, Bootstrap_3_2_0 +'/css/bootstrap_spacelab.min.css'), // CSS File
            loadStyle(this, FontAwesome_4_5_0 +'/css/font-awesome.min.css'), // CSS File
        ])
 }
}