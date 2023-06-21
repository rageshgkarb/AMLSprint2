import { LightningElement,api, track } from 'lwc';

export default class BaaSelfCertcTinCmp extends LightningElement {

    // <apex:attribute name="TinIndex" type="String" required="true" description="" />
    // <apex:attribute name="model" type="string" required="true" description="" />
    // <apex:attribute name="form" type="string" required="true" description="" />
    // <apex:attribute name="identifier" type="string" required="false" description="" default="" />
    // <apex:attribute name="CountryTaxResidencyPropertyName" type="String" description="" required="true" />
    // <apex:attribute name="HasTinPropertyName" type="String" description="" required="true" />
    // <apex:attribute name="TinReasonCodePropertyName" type="String" description="" required="true" />
    // <apex:attribute name="TinReasonBPropertyName" type="String" description="" required="true" />
    // <apex:attribute name="TinPropertyName" type="String" description="" required="true" />
    // <apex:attribute name="RequiredRuleCtryTaxRes" type="String" description="" required="true" />
    // <apex:attribute name="hideUSQuestion" type="Boolean" default="true" description=""/>

    
    @api model;
    @api hideusquestion ;
    @api form;
    @api tinindex;
    @api identifier='';
    @api countrytaxresidencypropertyname;
    @api hastinpropertyname;
    @api tinreasoncodepropertyname;
    @api tinreasonbpropertyname;
    @api tinpropertyname;
    @api requiredrulectrytaxres;
    @track Data;
    @api getdata;

    @api
    setModelData(Data){
        
        this.Data =Data;
    }
    
}