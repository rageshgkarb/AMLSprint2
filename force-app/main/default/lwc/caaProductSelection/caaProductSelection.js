import {
    LightningElement,
    track,
    wire,
    api
  } from "lwc";
  
    //import getSetupDate from "@salesforce/apex/CAA_Core_Controller_Lightning.Product_Screen_Init";
    //import getYspa from "@salesforce/apex/CAA_Core_Controller_Lightning.isYPSAAccount";
    import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
    import { MessageContext } from 'lightning/messageService';
    import {LoadShow,LoadHide} from 'c/caaUtility';
    import JQuery from '@salesforce/resourceUrl/JQuery';
    import Bootstrap_3_2_0 from '@salesforce/resourceUrl/Bootstrap_3_2_0';
    import FontAwesome_4_5_0 from '@salesforce/resourceUrl/FontAwesome_4_5_0';
    import Angular_1_4_11 from '@salesforce/resourceUrl/Angular_1_4_11';
    import CAA_Includes from '@salesforce/resourceUrl/CAA_Includes';

    
    import getProductDetails from "@salesforce/apex/CAA_Core_Controller_Lightning.GetProductSuitability";
    import getSourceOfFunds from "@salesforce/apex/CAA_Core_Controller_Lightning.getLoadSourceofFundPickLists";
    import productSelectedMethod from "@salesforce/apex/CAA_Core_Controller_Lightning.ProductSelected";
  

export default class Caa_Product_Selection extends LightningElement {
    @api gaCampaignSource;@api gaCampaignMedium;@api gaCampaignTerm;@api gaCampaignContent;@api gaCampaignName;@api accountid;@api m_AccountId;@api isYPSA;
    @api gaUniqueID;@api ProductType;@api ProductAccess;@api externalAccountId;@api internalAccountId;@api oppId;@api applicationId;@api valuePass;
    @api IsGuest;@api showProduct;//Case - 02071241 ;to show the product for customer
    @api JsonMap;
    @track IsGuestUser;
    @track JsonMapForNoticeProduct;
    @track ShowNoticeProduct = false;
    @track ShowProductForCustomer = false;//Case - 02071241 ;to show the product for customer
    @track Marketing={Source:''};
    @track Data={};
    @track SelectErrors = [];
    @track accountTypeCheck = {current:false,savings:false,taxfree:false};
    @track AccessCheck = {fixed:false,instant:false,notice:false};//Case - 02071241;to show the product for customer
    @track ErrorMessage;
    @track Access;
    @track Product = {
        ShowTransfer: true,
        ShowRegularPayment: true,
        Name: 'Some Product'
    };
    @track accountValAvailable = false;
    @track isExistingCustomer = false;
    @track ExistingCustomer;
    @track savingOrTax = false;
    @track firstTimeLoad = true;
    @track consentMail; @track consentPhone; @track consentSMS; @track consentEmail;@track consentNewsletter;@track consentNone;
    ShowInternalHeader = false;
    @track IsExternalCAA = false;
    @track displayMarketingDetails = false;
    @track isYPSAAccount = false;
    @track SourceofFundsList=[];
    @track filteredProducts = [];

    @track IsMarketPrefSelectedDisplay = false;
    @wire(MessageContext)
    messageContext;
    connectedCallback(){
        LoadShow('',this.messageContext);
        this.myConstructor();
        Promise.all([
            loadScript(this, JQuery), // jquery script
            loadScript(this, Bootstrap_3_2_0 +'/js/bootstrap.min.js'), // CSS File
            loadScript(this, Angular_1_4_11 + '/angular.min.js'), // angular js file
            loadScript(this, Angular_1_4_11 + '/angular-animate.min.js'),  // angular js file
            loadScript(this, Angular_1_4_11 + '/angular-sanitize.min.js'),  // angular js file
           
            loadStyle(this, Bootstrap_3_2_0 +'/css/bootstrap.min.css'), // CSS File
            loadStyle(this, Bootstrap_3_2_0 +'/css/bootstrap_spacelab.min.css'), // CSS File
            loadStyle(this, FontAwesome_4_5_0 +'/css/font-awesome.min.css'), // CSS File
            loadStyle(this, CAA_Includes +'/css/css.css'), // CSS File
            loadStyle(this, CAA_Includes +'/css/wait.css'), // CSS File
            loadStyle(this, CAA_Includes +'/css/structure.css'), // CSS File
            
            
        ])
        .then(() => { 
            this.error = undefined;
            // Call back function if scripts loaded successfully
            alert ('all scripts loaded successfully');
            
        })
        .catch(error => {
            this.error = error;
            console.log (' scripts failed' + error);
        });

        
   }
   
  
    
    showSuccessMessage() { // call back method 
       this.successMessage = 'Scripts are loaded successfully!!';
       alert( successMessage );
    }

    myConstructor() {
        //this.isLoading = true;
        //console.log('***Inside contructor Product*'+this.GetProductSuitability());
        //this.callActionMethod();
        this.GetProductSuitability();
        this.fetchSourceOfFunds();
        this.Marketing.Source=this.gaCampaignSource;
        this.Marketing.Medium=this.gaCampaignMedium ;
        this.Marketing.Term=this.gaCampaignTerm;
        this.Marketing.Content=this.gaCampaignContent;
        this.Marketing.Name=this.gaCampaignName;
        this.Marketing.ID=this.gaUniqueID;
        this.AccountType=this.ProductType;
        this.Access=this.ProductAccess;
        this.Data.AccountId=this.accountid;
        this.IsGuestUser = this.IsGuest;
        this.ShowProductForCustomer = this.showProduct;//Case - 02071241 ;to show the product for customer
        console.log('this.ShowProductForCustomer'+this.ShowProductForCustomer);
        this.JsonMapForNoticeProduct = this.JsonMap;
        console.log('this.JsonMapForNoticeProduct'+this.JsonMapForNoticeProduct);
        if(this.accountid){
            this.accountValAvailable = true;
        }
        this.Data.OpportunityId=this.oppId;
        this.SessionId='';
        this.ExistingCustomer= this.accountid || this.oppId?'':'No';
        //this.callYspa();
        if(this.ExistingCustomer != 'No'){
            //this.isExistingCustomer = true;
            this.firstTimeLoad = false;
        }
        this.isYPSAAccount = this.isYPSA != 'no'?true:false;
        this.Data.Preferred_start_date_c = {Day:'0', Month:'0', Year:'0'};
        this.Data.Last_Payment_Date_c = {Day:'0', Month:'0', Year:'0'};
        this.Data.Payment_Frequency_c = '0';
        this.Data.Direct_debit_date_day_c ='0';
        this.consentMail=false; this.consentPhone=false;  this.consentSMS=false; this.consentEmail =false;this.consentNewsletter =false;this.consentNone =false;
        //this.ImageClass = this.ImageClassValue()+' bann';
        //this.Data.Over16 = 'no';
        if(window.location.href.indexOf("islamic-bank") > -1){
			this.IsExternalCAA = true;
		}
        
    }

    /*callActionMethod() {
        getSetupDate({externalAccount:this.externalAccountId,internalAccount:this.internalAccountId,opp:this.oppId,application:this.applicationId})
        .then((result) => {
            console.log('result', JSON.stringify(result));
            
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }*/

    callYspa() {
        getYspa({accId:this.accountid})
        .then((result) => {
            console.log('result', JSON.stringify(result));
            var over16 = JSON.stringify(result);
            if(over16 != 'no'){
                this.isYPSAAccount = true;    
            }
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }

   ImageClassSM(){
        return this.ImageClass + '-sm';
    };
    
    get ImageClass(){
        
        if (this.AccountType == 'current') {
            return 'banner-current';
        }

        if (this.AccountType == 'taxfree') return 'banner-taxfree';

        if (this.AccountType == 'savings') {
            if (!this.Access) return 'banner';

            if (this.Data.Over16 && this.Data.Over16 == 'no' && (this.Access == 'notice' || this.Access == 'instant'))
                return 'banner-ypsa';

            if (this.Access == 'notice') return 'banner-notice';
            if (this.Access == 'instant') return 'banner-instant';
            if (this.Access == 'fixed') return 'banner-fixed';

        }
        
        return 'banner bann';
    }

    UnCheckConsentNone(event){
        var variableName= event.target.name;
        var varValue = event.target.checked;
        
        this.consentNone= false;
        
            if(variableName == 'consentEmail')
              this.consentEmail = varValue;
            else if(variableName == 'consentMail')
                this.consentMail = varValue;
            else if(variableName == 'consentPhone')
                this.consentPhone = varValue;
            else if(variableName == 'consentSMS')
                this.consentSMS = varValue;
            else if(variableName == 'consentNewsletter')
                this.consentNewsletter = varValue;
            
           
          console.log('---'+this.consentEmail);
        if(!this.consentEmail && !this.consentMail && !this.consentPhone && !this.consentSMS && !this.consentNewsletter){
            this.IsMarketPrefSelected= false;
            this.IsMarketPrefSelectedDisplay = true;
        }else{
            this.IsMarketPrefSelected= true;  
            this.IsMarketPrefSelectedDisplay = false;          
        }
    }

    ExistingCustomerOnchange(event){
        console.log('---'+event.target.value);
        this.ExistingCustomer  =  event.target.value;
        if(this.ExistingCustomer == 'Yes'){
            this.isExistingCustomer = true;
        }else{
            this.isExistingCustomer = false;
        }
        this.firstTimeLoad = false;
       
    }
    AccessOnchange(event){        
        this.Access  =  event.target.value;
        var arg = event.target.value;
        this.UncheckNaturePurpose(arg);    
        console.log('***'+this.Access+'----'+arg);   
        this.AccessCheck = {fixed:false,instant:false,notice:false};//Case - 02071241;to show the product for customer
        this.AccessCheck[this.Access] = true;
        console.log('***'+this.Access+'----'+this.AccessCheck[this.Access]);   
        //this.ImageClass = this.ImageClassValue();
        console.log('**suitability**'+ this.SuitableProducts());

    }
    

    ochangeAccountType(event){
        this.ShowNoticeProduct = false;

        console.log('***'+event.target.value+'---'+event.target.name);
        this.AccountType = event.target.value;
        var arg = event.target.name;
        this.UncheckNaturePurpose(arg);
        if(this.AccountType == 'savings' || this.AccountType =='taxfree')
            this.savingOrTax = true;
        else 
            this.savingOrTax = false;

        this.accountTypeCheck = {current:false,savings:false,taxfree:false};
        this.accountTypeCheck[this.AccountType] = true;
        if (this.AccountType == 'current') {
           this.Access = 'instant';
            // $scope.apply();
        }
        //this.ImageClass = this.ImageClassValue();

        for (var i=0; i<this.JsonMapForNoticeProduct.length; i++){
            console.log('for loop:'+this.JsonMapForNoticeProduct[i].Name);
            if(this.AccountType == this.JsonMapForNoticeProduct[i].Name){
                this.ShowNoticeProduct = true;
            }
         }
        console.log('this.ShowNoticeProduct: '+this.ShowNoticeProduct);

        console.log('**suitability**'+ this.SuitableProducts());
    }

    UncheckNaturePurpose(arg){
       
        if(arg != this.UncheckNaturePurposeVariable){
            if(arg == 'fixed' || arg == 'notice'){
                this.Data.Receive_Salary_Benefits = false;
            }
            this.Data.Pay_Bills_Expenses = false;
            this.Data.Domestic_Transfers_In_Out = false;
            this.Data.International_Transfer_In_Out = false;
        }
        this.UncheckNaturePurposeVariable = arg;
    }

    onchangePurpose(event){
        console.log('****'+event.target.value);
        this.Data[event.target.value] = true;
         console.log('****',this.Data);
    }
    onChangeNumberOfApplicants(event){
        console.log('****'+event.target.value);
        this.Data.NumberOfApplicants = event.target.value;
        this.getdisplaySelectErrors();
    }
    setAgeVal(event){

        this.Data.Over16 = event.target.value;
    }

    onchangeDataVal(event){
        console.log('****'+event.target.name+'---Vale:'+event.target.value);
        this.Data[event.target.name] = event.target.value;
        this.getdisplaySelectErrors();

    }
    onchangeSourceOfFunds(event){
        console.log('****'+event.target.name+'---Vale:'+event.target.value);
        this.Data.Source_of_Funds_c = event.target.value;
        this.getdisplaySelectErrors();
        
    }
    onChangeSelectProduct(event){
        console.log('Selected Product',JSON.stringify(event.target.value));
        for(var i=0;i<this.filteredProducts.length;i++){
            if(this.filteredProducts[i].Id == event.target.value){
                this.SelectedProduct = this.filteredProducts[i];    
            }
        }
        
        console.log('Selected Product',this.SelectedProduct.Name);
        this.getdisplaySelectErrors();
    }

  
    GetProductSuitability(){
        getProductDetails()
        .then((result) => {
            //console.log('***Inside Product*');
            console.log('result', JSON.stringify(result));
            this.products = result;
            for (var i = 0; i < this.products.length; i++) {
                this.products[i].Name = this.products[i].Name.replace("&#39;", "'");
                console.log('***Inside Product*'+this.products[i]);
            }
            //console.log('Products result:', result);
            LoadHide('',this.messageContext);
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }
    fetchSourceOfFunds(){
        getSourceOfFunds()
        .then((result) => {
            console.log('**SourceofFundsList*',this.SourceofFundsList);
            var arr = [];
            arr.push({key:'', value:''});
            for(var i=0;i<result.length;i++){
                arr.push({key:result[i], value:result[i]});
            }
            this.SourceofFundsList = arr;
            console.log('**SourceofFundsList*',this.SourceofFundsList);
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }

    get showAgeDetails(){

        if(!this.AccountType || this.AccountType == '' || (this.IsExternalCAA && this.AccountType == 'current')){
            return false;
        }
        return true;
    }
    get currentAccountDisplay(){
        if(this.IsExternalCAA && this.AccountType == 'current') return true;
        return false;       

    }
    get AccessCheckInstant(){
        if(this.Access == 'instant')return true;
        return false;
    }
    get accountTypeCheckCurrent(){
        if(this.AccountType == 'current')return true;
        return false;       
    }
    get suitabilityBoolean(){
        if(this.SuitableProducts() == 'yes')
            return true;
        return false;
    }
    get yspaVal(){
        if(this.Data.Over16 == 'yes')
            return true;
        
        return false;
    }
    get noyspaVal(){
        if(this.Data.Over16 == 'no')
            return true;

        return false;
    }

    
    SuitableProducts() {
        
        var suitableProds=[];
        /*var suitableProds= this.products.filter(
            Category=>Category.Category == this.AccountType,
            Access=>Access.Access == this.Access,
            Over16=>Over16.Over16 == this.Data.Over16
           
        );*/
        for (var i=0;i<this.products.length;i++) {
           
            if(this.products[i].Category == this.AccountType && (!this.Access || this.products[i].Access == this.Access) && (!this.Data.Over16 || this.products[i].Over16 == this.Data.Over16)){
                console.log('this.Data.Over16:'+this.Data.Over16+'***'+this.products[i].Over16)
                suitableProds.push(this.products[i]);                
            }
            // if condition not met return false
        }
        this.filteredProducts = suitableProds;
        console.log('suitableProds:',suitableProds)
        console.log('this.Access:',this.Access)
        
        
        if (suitableProds != null && suitableProds.length > 0) return 'yes';
            return 'no';
    }
    get displayProductError(){
        if(this.AccountType && (this.SuitableProducts() == 'no' && this.products) && (!this.IsExternalCAA || (this.IsExternalCAA && (this.AccountType == 'taxfree' || this.AccountType == 'savings')))){
            return true;
        }else return false;   
    }

    getdisplaySelectErrors(){
        
        if((this.IsProductValid() == false && this.SuitableProducts() == 'yes') && (!this.IsExternalCAA || (this.IsExternalCAA && (this.AccountType == 'taxfree' || this.AccountType == 'savings')))){
            this.displaySelectErrors = true;
            //return true;
        }else this.displaySelectErrors =  false;//return false;
        console.log('getdisplaySelectErrors:'+this.SelectedProduct+'=='+this.displayMarketingDetails);
        if(this.SelectedProduct)
        this.displayMarketingDetails = !this.displaySelectErrors;
        console.log('getdisplaySelectErrors:'+this.SelectedProduct+'=='+this.displayMarketingDetails);
    }
    get natureAndPurposeDisplay(){
        if(((this.Data.Over16=='yes' || this.Data.Over16=='no') && this.SuitableProducts() == 'yes' && this.AccountType != '' && !this.Data.Receive_Salary_Benefits && !this.Data.Pay_Bills_Expenses && !this.Data.Domestic_Transfers_In_Out && !this.Data.International_Transfer_In_Out && !this.Data.Cash_Deposit_In_Out && !this.Data.Saving_Goals) && (!this.IsExternalCAA || (this.IsExternalCAA && (this.AccountType == 'taxfree' || this.AccountType == 'savings'))))
            return true;
        return false;
    }

    get furtherDetailsCurrent(){
        
        if(!this.Data.Over16)
        return false;
        if(((this.Data.Over16=='yes' || this.Data.Over16=='no') && this.AccountType != '' && !this.Data.Receive_Salary_Benefits && !this.Data.Pay_Bills_Expenses && !this.Data.Domestic_Transfers_In_Out && !this.Data.International_Transfer_In_Out && !this.Data.Cash_Deposit_In_Out && !this.Data.Saving_Goals) || (this.IsExternalCAA && this.AccountType == 'current'))
            return false;
        return true;
    }


    IsProductValid(){       

        var SelectErrors = [];
        console.log('IsProductValid inside:',this.Data);
        console.log('IsProductValid inside:',this.SelectedProduct);
        if (!this.Data || !this.SelectedProduct)
            return null;

        var valid = true;

        if (!this.Data.Deposit || this.Data.Deposit == '') {
            valid = false;
            SelectErrors.push('The deposit is too low. The minimum deposit required to open this account is £' + this.SelectedProduct.MinDeposit + '.');
        }

        if (parseFloat(this.Data.Deposit) < parseFloat(this.SelectedProduct.MinDeposit)) {
            valid = false;
           SelectErrors.push('The deposit is too low. The minimum deposit required to open this account is £' + this.SelectedProduct.MinDeposit + '.');

        }

        if (parseFloat(this.Data.Deposit) > parseFloat(this.SelectedProduct.MaxDeposit)) {
            valid = false;
            SelectErrors.push('The deposit is too high.  The maximum deposit for this account is £' + this.SelectedProduct.MaxDeposit + '.');
        }

        if (!this.Data.NumberOfApplicants) {
            valid = false;
            SelectErrors.push('Please select the number of applicants');
        }

        if (parseFloat(this.Data.NumberOfApplicants) > parseFloat(this.SelectedProduct.MaxApplicants)) {
            valid = false;
            SelectErrors.push('You have selected too many applicants.  The maximum number of applicants for this account is ' + this.SelectedProduct.MaxApplicants + '.');
        }

        if (this.Data.Over16 == 'false' && this.SelectedProduct.MinAge == "16") {
            valid = false;
            SelectErrors.push('Not suitable for 16 or under');
        }

        if (this.Data.Over16 == 'true' && this.SelectedProduct.MaxAge == "16") {
            valid = false;
            SelectErrors.push('Not suitable for over 16');
        }

        if (this.Data.Source_of_Funds_c == '' || this.Data.Source_of_Funds_c == null) {
            valid = false;
            SelectErrors.push('Please select the Source Of Funds');				
        }


        this.SelectErrors =  SelectErrors;


        //$scope.$apply();  
        return valid;
    }

    checkNoContact(event){
        this.consentNone = event.target.checked;
        if(this.consentNone)
        {
            this.IsMarketPrefSelected= true;//C0737 
            this.consentEmail = false;
            this.consentMail = false;
            this.consentPhone = false;
            this.consentSMS = false;
            this.consentNewsletter = false;
            this.IsMarketPrefSelectedDisplay = false;
        }else{//C0737 Start
            if(!this.consentEmail && !this.consentMail&& !this.consentPhone && !this.consentSMS && !this.consentNewsletter){
                this.IsMarketPrefSelected= false;
            }else{
                this.IsMarketPrefSelected= true;
            }
        //C0737 End
        } 
    }

    callProductMethod(){
        console.log('this.Data.Preferred_start_date_c:',this.Data.Preferred_start_date_c);
        console.log('this.Data:',this.Data.Pay_Bills_Expenses);
        
        LoadShow('',this.messageContext);
        productSelectedMethod({data:this.Data, sessionId:this.sessionId, hasEmail:this.consentMail, hasMail:this.consentMail, hasPhone:this.consentPhone, hasSMS:this.consentSMS, hasNewsletter:this.consentNewsletter,hasNone:this.consentNone,Pay_Bills_Expenses:this.Data.Pay_Bills_Expenses,
                               Domestic_Transfers_In_Out:this.Data.Domestic_Transfers_In_Out,International_Transfer_In_Out:this.Data.International_Transfer_In_Out,Cash_Deposit_In_Out:this.Data.Cash_Deposit_In_Out,Saving_Goals:this.Data.Saving_Goals,Receive_Salary_Benefits:this.Data.Receive_Salary_Benefits})
        .then((result) => {
                console.log('*****',result);
                //var URL = result.URL.FormatURL();
                LoadHide('',this.messageContext);
                window.location.assign(result.URL);
                //window.location.href = URL.FormatURL();
            
        })
        .catch((error) => {
            console.log('Error', error);
        });
    }

    ProductSelected() {
        if(!this.consentEmail && !this.consentMail && !this.consentPhone && !this.consentSMS && !this.consentNewsletter && !this.consentNone){
            this.IsMarketPrefSelected= false;
            this.IsMarketPrefSelectedDisplay = true;
        return;
        }else{
            this.IsMarketPrefSelected= true;
            this.IsMarketPrefSelectedDisplay = false;
        }
         //C0737 End 
       this.Data.ProductId = this.SelectedProduct.Id;
       this.ErrorMessage = null;

        if (this.Access == 'fixed')
            this.Data.HasRegularPayment = 'no';
        
        this.callProductMethod();
    }

   /*ProductSelected() {
        //C0737 Start
        if(!this.consentEmail && !this.consentMail && !this.consentPhone && !this.consentSMS && !this.consentNewsletter && !this.consentNone){
            this.IsMarketPrefSelected= false;
        return;
        }else{
            this.IsMarketPrefSelected= true;
        }
        //C0737 End 
       this.Data.ProductId = this.SelectedProduct.Id;
       this.ErrorMessage = null;

        if (this.Access == 'fixed')
            this.Data.HasRegularPayment = 'no';

        serviceApplication.LoadShow('Processing...');
        // C0697
        serviceProductSelect.SendProductSelected($scope.Data, $scope.SessionId, $scope.consentEmail, $scope.consentMail, $scope.consentPhone, $scope.consentSMS, $scope.consentNewsletter, $scope.consentNone)
            .then(
                function (result) {
                    if (result.Success) {
                        $scope.URL = result.URL.FormatURL();
                        $window.location.href = $scope.URL.FormatURL();
                    } else {
                        $scope.ErrorMessage = result.Error;
                        serviceApplication.LoadHide(false);
                    }



                },
                function (error) {
                    serviceApplication.LoadHide(false);
                }
            );

    };*/

    


    

}