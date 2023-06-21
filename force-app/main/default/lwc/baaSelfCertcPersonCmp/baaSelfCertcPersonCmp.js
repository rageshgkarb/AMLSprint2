import { LightningElement } from 'lwc';

export default class BaaSelfCertcPersonCmp extends LightningElement {

    CPTinCount = 0;
    Initialised = false;
    PersonData = null;
    SelectedCountryCode = null;
    SelectedDateOfBirth = null;
    TinAddButtonLabel = 'Add more Tax Residency details for a Controlling Person';
    ControllingPersonHeader= 'Controlling Person ';
    ShowPersonDetails =false;
    model;
    modellist;
    form;
    index;

     
    InitPersonPCA(model, applicantNumber) {

        console.log('InitPersonPCA:model='+JSON.stringify(model)+'\n applicantNumber='+applicantNumber);
        this.PersonData = model;

        var options = {
            key: this.PCA_key
        }

        var fieldsBilling = [{
            element: "streetBilling" + applicantNumber,
            field: "Line1"
        }, {
            element: "cityBilling" + applicantNumber,
            field: "City",
            mode: pca.fieldMode.POPULATE
        }, {
            element: "postcodeBilling" + applicantNumber,
            field: "PostalCode",
        }, {
            element: "countryBilling" + applicantNumber,
            field: "CountryName",
            mode: pca.fieldMode.COUNTRY
        }];

        var fieldsMailing = [{
            element: "streetMailing" + applicantNumber,
            field: "Line1"
        }, {
            element: "cityMailing" + applicantNumber,
            field: "City",
            mode: pca.fieldMode.POPULATE
        }, {
            element: "postcodeMailing" + applicantNumber,
            field: "PostalCode"
        }, {
            element: "countryMailing" + applicantNumber,
            field: "CountryName",
            mode: pca.fieldMode.COUNTRY
        }];

        setTimeout(() => {
            this.addressBillingControl = new pca.Address(fieldsBilling, options);
            this.addressMailingControl = new pca.Address(fieldsMailing, options);

            this.addressBillingControl.listen("populate", function (address, variations) {
                this.PersonData.BillingCity = address.City;
                this.PersonData.BillingPostalCode = address.PostalCode;
                this.PersonData.BillingStreet = address.Line1;
                this.$apply();
            });

            this.addressMailingControl.listen("populate", function (address, variations) {
                this.PersonData.PersonMailingCity = address.City;
                this.PersonData.PersonMailingPostalCode = address.PostalCode;
                this.PersonData.PersonMailingStreet = address.Line1;
                this.$apply();
            });

        }, 100);

        this.SelectedCountryCode = this.GetCountryCode(this.Data.CountryCodes, null, this.PersonData.CountryCode_c);

        if (this.PersonData.Date_of_Birth_c != undefined && this.PersonData.Date_of_Birth_c != null && this.PersonData.Date_of_Birth_c != '') {
            var dob = new Date(model.Date_of_Birth_c);
            this.SelectedDateOfBirth = dob;
            this.PersonData.Date_of_Birth_c = dob.getFullYear() + '-' + (dob.getMonth() + 1) + '-' + dob.getDate();
        }

        this.CPTinCount = this.InitTin(2) ? 1 : this.CPTinCount;
        this.CPTinCount = this.InitTin(3) ? 2 : this.CPTinCount;
        this.CPTinCount = this.InitTin(4) ? 3 : this.CPTinCount;
        this.CPTinCount = this.InitTin(5) ? 4 : this.CPTinCount;
        this.CPTinCount = this.InitTin(6) ? 5 : this.CPTinCount;
        this.CPTinCount = this.InitTin(7) ? 6 : this.CPTinCount;
        this.CPTinCount = this.InitTin(8) ? 7 : this.CPTinCount;
        this.CPTinCount = this.InitTin(9) ? 8 : this.CPTinCount;
        this.CPTinCount = this.InitTin(10) ? 9 : this.CPTinCount;
        this.CPTinCount = this.InitTin(11) ? 10 : this.CPTinCount;
    }

    InitTin (index) {
        var result = false;
        if (this.PersonData['TIN_' + index + '_Check_c'] != undefined &&
            this.PersonData['TIN_' + index + '_Check_c'] != null &&
            this.PersonData['TIN_' + index + '_Check_c'] != '') {
            result = true;
        }

        if (!result &&
            this.PersonData['TIN' + index + '_Country_Tax_Residence_c'] != undefined &&
            this.PersonData['TIN' + index + '_Country_Tax_Residence_c'] != null &&
            this.PersonData['TIN' + index + '_Country_Tax_Residence_c'] != '') {
            result = true;
        }

        if (!result &&
            this.PersonData['TIN_' + index + '_c'] != undefined &&
            this.PersonData['TIN_' + index + '_c'] != null &&
            this.PersonData['TIN_' + index + '_c'] != '') {
            result = true;
        }

        return result;
    }

    TinNumberChanged (model, index) {
        var property = 'TIN_'+index+'_c';
        if(model[property] == undefined || model[property] == 'null') {
            model[property] = null;
        }
    }

    DOBChanged  (date, model) {
        if (date != undefined && date != null) {
            model.Date_of_Birth_c = date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear();
        }
    }

    BillingCountryChanged  (model) {
        var code = this.GetCountryCode(this.Data.CountryCodes, model.BillingCountry, null);
        this.SelectedCountryCode = code;
        model.CountryCode_c = code.Key;
    }

   MailingCountryChanged  (model) {
        var code = this.GetCountryCode(this.Data.CountryCodes, model.PersonMailingCountry, null);
        this.SelectedCountryCode = code;
        model.CountryCode_c = code.Key;
    }

    GetCountryCode (countryCodes, countryName, countryCode) {
        var found = null;

        if (countryName != null && countryName != '') {
            var found = countryCodes.find((item) => {
                return item.Value == countryName;
            });
        }

        if (found == null && countryCode != undefined && countryCode != null && countryCode != '') {
            var found = countryCodes.find((item) => {
                return item.Key == countryCode;
            });
        }

        if (found !== null || found !== undefined) {
            return found;
        } else {
            return null;
        }

    }

    CountryCodeChanged (model, countryCode) {
        model.CountryCode_c = countryCode.Key
    }

    UnCheckConsentNone (model){
        model.consentNone = false;
        if(!model.consentEmail && !model.consentMail && !model.consentPhone && !model.consentSMS && !model.consentNewsletter){
            model.IsMarketPrefSelected = false;
        }else{
            model.IsMarketPrefSelected = true;
        }
    }

    checkNoContact (model)
    {
        if(model.consentNone)
        {
            model.IsMarketPrefSelected = true;//C0737 
            model.consentEmail = false;
            model.consentMail = false;
            model.consentPhone = false;
            model.consentSMS = false;
            model.consentNewsletter = false;
        }else{//C0737 Start 
            if(!model.consentEmail && !model.consentMail && !model.consentPhone && !model.consentSMS && !model.consentNewsletter){
                model.IsMarketPrefSelected = false;
            }else{
                model.IsMarketPrefSelected = true;
            }
            //C0737 End 
        }
    }
}