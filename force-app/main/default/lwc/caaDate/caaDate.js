import { LightningElement, api,track } from 'lwc';

export default class CaaDate extends LightningElement {



@api numyears; 
req;
@api showhelp;
@api helptext;
index;
@api model={};
@api field;
@api title;
@track sc;
required;
day;
month ;
monthalpha;
year;
days;
daysSM;
months;
monthsSM;
years; 
yearsSM; 
@api dob;          
@track domFieldNames={};
isDatevalid=true;

    connectedCallback(){
       
       this.domFieldNames.dateFieldDay = this.model[this.field]+'_Day';
        this.domFieldNames.dateFieldDay1 = this.model[this.field]+ '_Day1';
        this.domFieldNames.dateFieldMonth = this.model[this.field]+ '_Month';
        this.domFieldNames.dateFieldMonth1 = this.model[this.field]+ '_Month1';
        this.domFieldNames.dateFieldYear = this.model[this.field]+ '_Year';
        this.domFieldNames.dateFieldYear1 = this.model[this.field]+ '_Year1';
        
        this.init(this.model,this.field,this.req,this.numyears);
    }
    
  
   
            init(scop,field, required,years) {
                this.sc = scop;
                this.field = field;                                
		        this.required = required;
                if(this.sc){
                this.day= this.sc.Day;
                this.month = this.sc.Month ;
                this.year= this.sc.Year;
       
                }
             
		this.days = [];
		this.days.push({"key":"", "value":"Please select"});
		for(var i = 1 ; i <= 31; i++)
			this.days.push({"key":i.toString(), "value":i.toString()});


		this.daysSM=[];
		this.daysSM.push({"key":"", "value":"DD"});
		for(var i = 1 ; i <= 31; i++)
			this.daysSM.push({"key":i.toString(), "value":i.toString()});


		this.months = [
					{"key":"", "value":"Please select"},
					{"key":"1", "value":"January"},
					{"key":"2", "value":"February"},
					{"key":"3", "value":"March"},
					{"key":"4", "value":"April"},
					{"key":"5", "value":"May"},
					{"key":"6", "value":"June"},
					{"key":"7", "value":"July"},
					{"key":"8", "value":"August"},
					{"key":"9", "value":"September"},
					{"key":"10", "value":"October"},
					{"key":"11", "value":"November"},
					{"key":"12", "value":"December"}					
				];
		this.monthsSM = [
					{"key":"", "value":"MM"},
					{"key":"1", "value":"Jan"},
					{"key":"2", "value":"Feb"},
					{"key":"3", "value":"Mar"},
					{"key":"4", "value":"Apr"},
					{"key":"5", "value":"May"},
					{"key":"6", "value":"Jun"},
					{"key":"7", "value":"Jul"},
					{"key":"8", "value":"Aug"},
					{"key":"9", "value":"Sep"},
					{"key":"10", "value":"Oct"},
					{"key":"11", "value":"Nov"},
					{"key":"12", "value":"Dec"}					
				];

		this.years = [];
		this.years.push({"key":"", "value":"Please select"});
		
		
		var currentYear = new Date().getFullYear();		
		console.log('100'+currentYear);
       
		if(years > 0)
		{
			//PYFIX
          
			years++;
			//PYFIX : 03-01-2017: Added -1 to show previous year
			for(var i = currentYear-1; i < currentYear + parseInt(years); i++)
				this.years.push({"key":i.toString(), "value":i.toString()});
			
		}
		else
		{
         

			for(var i = currentYear; i > currentYear + parseInt(years); i--)
				this.years.push({"key":i.toString(), "value":i.toString()});
                console.log('11550'+this.years);    
		}

		console.log(this.years);
		
		this.yearsSM = [];
		this.yearsSM.push({"key":"", "value":"YY"});
		var currentYear = new Date().getFullYear();		
		
		if(years > 0)
		{
			for(var i = currentYear - 1; i < currentYear + parseInt(years); i++)
				this.yearsSM.push({"key":i.toString(), "value":i.toString()});
			
		}
		else
		{
			for(var i = currentYear; i > currentYear + parseInt(years); i--)
				this.yearsSM.push({"key":i.toString(), "value":i.toString()});
		}

             
            };              
            
            IsInValid(){
            
                if(!this.year || !this.month || !this.day || this.day == 0 || this.month == 0 || this.year == 0)
			    return false;
                let m = parseInt(this.months.find(item => item.key === this.month ).value, 10);
                let d = parseInt(this.day, 10);
                let y = parseInt(this.year, 10);    
                 console.log('m d y'+m+d+y);   
                let date = new Date(y,m-1,d);
                console.log(date); 
                if (date.getFullYear() == y && date.getMonth() + 1 == m && date.getDate() == d) {
                    return false;
                } else {
                    return true;
                }      
            }
            ondayChange(event) {
                this.day = event.target.value;
             
                this.sc['Day'] = this.day;    
                 if( this.month == 'Please select')
                this.domFieldNames.isdateFieldDayError = true;
                else
                this.domFieldNames.isdateFieldDayError = false; 
              this.handleDateEvent();
       
                this.isDatevalid = this.IsInValid();
            }
            onday1Change(event) {
        
                this.day = event.target.value;
   
                this.sc['Day'] = this.day; 
                
                if( this.month == 'Please select')
                this.domFieldNames.isdateFieldDay1Error = true;
                else
                this.domFieldNames.isdateFieldDay1Error = false;
                
       this.handleDateEvent();
                this.isDatevalid = this.IsInValid();
            }
            onMonthChange(event) {
        
                this.month = this.months.find(item => item.value === event.target.value).key;
             
                console.log('Check0'+this.month);
              
                if( this.month == 'Please select')
                this.domFieldNames.dateFieldMonthError = true;
                else
                this.domFieldNames.dateFieldMonthError = false;
               console.log(this.sc);
             
                this.sc['Month']= this.month;
               this.handleDateEvent();
                this.isDatevalid = this.IsInValid();
            }
            onMonth1Change(event) {
        
                this.month = this.monthsSM.find(item => item.value === event.target.value).key;
              
                this.sc['Month']= this.month;

                if( this.month == 'Please select')
                this.domFieldNames.dateFieldMonth1Error = true;
                else
                this.domFieldNames.dateFieldMonth1Error = false;
         this.handleDateEvent();
                this.isDatevalid = this.IsInValid();
            }
            onYearChange(event) {
              
                console.log(this.year);
                this.year = event.target.value;
                
       
                this.sc['Year'] = this.year; 
                    if( this.month == 'Please select')
                this.domFieldNames.dateFieldYearError = true;
                else
                this.domFieldNames.dateFieldYearError = false;
           this.handleDateEvent();
                this.isDatevalid = this.IsInValid();
        
            }
            onYear1Change(event) {
        
                this.year = event.target.value;
                console.log(this.year);
           
                this.sc['Year'] = this.year; 
                if( this.month == 'Please select')
                this.domFieldNames.dateFieldYear1Error = true;
                else
                this.domFieldNames.dateFieldYear1Error = false;
            
               this.handleDateEvent();
                this.isDatevalid = this.IsInValid();
        
            }

            handleDateEvent(){
                console.log('line2'+JSON.stringify(this.sc));
         const myDemoEvent = new CustomEvent('demoevent',{
         detail:this.sc
        
        });
        
        this.dispatchEvent(myDemoEvent);
               
            }
       @api completeCheckValues()
{
 this.isDatevalid = this.IsInValid();
}           
    
      
}