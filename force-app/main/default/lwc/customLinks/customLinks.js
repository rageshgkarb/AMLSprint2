import { LightningElement } from 'lwc';

export default class CustomLinks extends LightningElement {
    goToContactCentre(){
        window.open("https://alrayanbank.my.salesforce.com/00U/c?cType=1&cal=Contact+Centre+Sales&cal_lkid=02320000000Nv8f&cal_lkold=Contact+Centre+Sales&cal_lspf=1&md0=2010&md1=11", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToREATDiary(){
        window.open("https://alrayanbank.my.salesforce.com/00U/c?cType=1&cal=REAT&cal_lkid=0233z0000064trY&cal_lkold=REAT&cal_lspf=1&md0=2019&md3=93", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }
    goToREATCollections()
    {
        window.open("https://alrayanbank.my.salesforce.com/00U/c?cType=1&cal=REAT+Collections&cal_lkid=0233z0000064trY&cal_lkold=REAT&cal_lspf=1&md0={!YEAR(TODAY())}&md1={!MONTH(TODAY())-1", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    }

}