import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import Lightning_Banner_Header from '@salesforce/label/c.Lightning_Banner_Header';


export default class UtilityBar extends NavigationMixin(LightningElement) {
    bannerHeader=Lightning_Banner_Header
    goToUserGuide(){
        window.open("https://islamicbank.sharepoint.com/sites/OnePlace/SitePages/Salesforce-Upgrade.aspx?OR=Teams-HL&CT=1650905697467&params=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyNy8yMjA0MDExMTQwOSJ9", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToNotices(){
        window.open("https://alrayanbank.my.salesforce.com/?ec=302&startURL=%2Fa4X%2Fo", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToOnlineTraining(){
        //alert("Under Construction");
        window.open("https://protect-eu.mimecast.com/s/DPCmCnxvmuK0Povi9g9Fa?domain=alrayanbank.lms.accessacloud.com", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToRespond() {
        window.open("https://alrayanbank.respond.apteancloud.com/Respond/", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    gotToCustomerCAA() {
        window.open("/apex/CAA_Product_Screen_Lightning?id=" + Id, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }

    goToPeopleHR() {
        window.open("https://alrayanbank.peoplehr.net/", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToCustomerNPAA() {
        window.open("/apex/BAA_ProductSelect_Lightning", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToMMR_Eligibility() {
        window.open("/apex/MMR_Eligibility_Lightning", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToNewCustomer() {
        window.open("/apex/CAA_ANC_Lightning", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToEngage() {

        window.open("/apex/teller_core#/home", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToCustomerLiabilitiesEligibility(){
        
        window.open("/apex/CAA_Eligibility_Lightning?id="+Id, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }

    goToOutlook(){
        
        window.open("https://login.microsoftonline.com/", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }

    goToKeesing(){
        window.open("/apex/Keesing?id="+Id, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }

    goToDirectory(){
        window.open("https://alrayanbank.my.salesforce.com/", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }

    goToFIS(){
        
        window.open("https://cortex-dpp.fisglobal.com:12001/panorama-IBB/login.jsp", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }

    goToPortal(){
        window.open("/apex/IBBPortalLink?id="+Id, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }

    goToCampaignDataCollection(){
        
        window.open("/apex/landing_page", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
  
}