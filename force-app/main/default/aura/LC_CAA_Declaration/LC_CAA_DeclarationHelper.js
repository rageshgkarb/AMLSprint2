({
    iAgreeClicked : function(cmp, event, helper) {
        var totalApplicant = cmp.get('v.applicantNames').length;
        var applicant1AgreeSet = new Set();
        var applicant2AgreeSet = new Set();
        var applicant3AgreeSet = new Set();
        var applicant4AgreeSet = new Set();
        var clickedButton=event.getSource().get("v.name");
        
        var lastChar = clickedButton.substr(clickedButton.length - 1);
        var secondLast = clickedButton.substr(clickedButton.length - 2,1);
        var applicantNum = parseInt(lastChar);
        var sectionNum = parseInt(secondLast);
        var appJsonList = [];
        appJsonList = cmp.get('v.applicantJsonList');
        console.log('Section:'+sectionNum);
        console.log('applicantNum:'+applicantNum);
        console.log('appJsonList:'+appJsonList.length);
        for(let i=0;i<appJsonList.length;i++){
            console.log(' appJsonList sectionNum:'+ appJsonList[i].section);
            console.log(' appJsonList applicantNum:'+ appJsonList[i].appNum);
            if(appJsonList[i].section == sectionNum && appJsonList[i].appNum == applicantNum ){
                appJsonList[i].displayButton = true;
                console.log('applicantNum:'+ appJsonList[i]);
            }
        }
        cmp.set('v.applicantJsonList',appJsonList);    
        
        if(clickedButton=='Section10' || clickedButton=='Section20' || clickedButton=='Section30' || clickedButton=='Section40'){
            if(cmp.get('v.applicant1AgreeSet')){
                for (let item of cmp.get('v.applicant1AgreeSet')){
                    applicant1AgreeSet.add(item);
                }
            }
            applicant1AgreeSet.add(clickedButton);
            cmp.set('v.applicant1AgreeSet',applicant1AgreeSet);
             
        }
        if(clickedButton=='Section11' || clickedButton=='Section21' || clickedButton=='Section31' || clickedButton=='Section41' ){
            if(cmp.get('v.applicant2AgreeSet')){
                for (let item of cmp.get('v.applicant2AgreeSet')){
                    applicant2AgreeSet.add(item);
                }
            }
            applicant2AgreeSet.add(clickedButton);
            cmp.set('v.applicant2AgreeSet',applicant2AgreeSet);
        }
        if(clickedButton=='Section12' || clickedButton=='Section22' || clickedButton=='Section32' || clickedButton=='Section42'){
            if(cmp.get('v.applicant3AgreeSet')){
                for (let item of cmp.get('v.applicant3AgreeSet')){
                    applicant3AgreeSet.add(item);
                }
            }
            applicant3AgreeSet.add(clickedButton);
            cmp.set('v.applicant3AgreeSet',applicant3AgreeSet);
        }
        if(clickedButton=='Section13' || clickedButton=='Section23' || clickedButton=='Section33' || clickedButton=='Section43'){
            if(cmp.get('v.applicant4AgreeSet')){
                for (let item of cmp.get('v.applicant4AgreeSet')){
                    applicant4AgreeSet.add(item);
                }
            }
            applicant4AgreeSet.add(clickedButton);
            cmp.set('v.applicant4AgreeSet',applicant4AgreeSet);
        }
        
        var allClicked = true;
        var showApplicant1 = cmp.get('v.isISA') != true &&  cmp.get('v.isYPSA') != true;
        
        for(var i =0; i < totalApplicant; i++){
            if(i==0) {
                if(totalApplicant>=1 && cmp.get('v.applicant1AgreeSet') && cmp.get('v.applicant1AgreeSet').size>0){
                    if(showApplicant1){  
                        if(cmp.get('v.applicant1AgreeSet').has('Section10') != true){return false;}
                    }
                    if(cmp.get('v.isYPSA') != true) {
                        if (cmp.get('v.applicant1AgreeSet').has('Section20') != true) {
                            return false;
                        }
                        if (cmp.get('v.applicant1AgreeSet').has('Section30') != true) {
                            return false;
                        }
                        if (cmp.get('v.applicant1AgreeSet').has('Section40') != true) {
                            return false;
                        }
                    }
                }else{
                    return false;
                }
                
            }
            if(i==1) {
                if (totalApplicant>=2 && cmp.get('v.applicant2AgreeSet') && cmp.get('v.applicant2AgreeSet').size>0){
                    if(showApplicant1){
                        if (cmp.get('v.applicant2AgreeSet').has('Section11') != true) {return false;}
                    }
                    if(cmp.get('v.applicant2AgreeSet').has('Section21') != true){return false;}
                    if(cmp.get('v.applicant2AgreeSet').has('Section31') != true){return false;}
                    if(cmp.get('v.applicant2AgreeSet').has('Section41') != true){return false;}
                }else{
                    return false; 
                }
                     
            }
            if(i==2) {
                if (totalApplicant>=3 && cmp.get('v.applicant3AgreeSet') && cmp.get('v.applicant3AgreeSet').size>0){
                    if(showApplicant1){
                        if (cmp.get('v.applicant3AgreeSet').has('Section12') != true) {
                            return false;
                        }
                    }
                    if(cmp.get('v.applicant3AgreeSet').has('Section22') != true){return false;}
                    if(cmp.get('v.applicant3AgreeSet').has('Section32') != true){return false;}
                    if(cmp.get('v.applicant3AgreeSet').has('Section42') != true){return false;}
                }else{
                    return false; 
                }
                
            }
            if(i==3) {
                if (totalApplicant==4 && cmp.get('v.applicant4AgreeSet') && cmp.get('v.applicant4AgreeSet').size>0){
                    if(showApplicant1){
                        if (cmp.get('v.applicant4AgreeSet').has('Section13') != true) {
                            return false;
                        }
                    }
                    if(cmp.get('v.applicant4AgreeSet').has('Section23') != true){return false;}
                    if(cmp.get('v.applicant4AgreeSet').has('Section33') != true){return false;}
                    if(cmp.get('v.applicant4AgreeSet').has('Section43') != true){return false;}
                }else{
                    return false;   
                }
            }
        }
        return allClicked;
        
        
    },
    getServiceData:function(component, event, helper){
        component.set('v.Loading',true);
        var num =component.get('v.applicantNames').length;
        var declarations = [];
        for(var i =0; i < num; i++){
            var declaration = {};
            
            if(i==0){declaration.capacity = null;}
            if(i==1){declaration.capacity = null;}
            if(i==2){declaration.capacity = null;}
            if(i==3){declaration.capacity = null;}
            declarations.push(declaration);
        }
         var action  = component.get("c.CallDe");
        action.setParams({
            "eventLogId": component.get('v.EventLogId'),
            "sessionId" :component.get('v.SessionId'),
            "declaration" :declarations
        });
        action.setCallback(this,function (response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result URL##'+result.URL);
                console.log('result Error##'+result.Error);
                console.log('result Decision##'+result.Decision);
                if(result.Success){
                    component.set('v.Data',result);
                    component.set('v.Loading',false);
                    if(result.URL && !result.CallEBS){
                         window.location.href = result.URL;
                    }else{
                        if(result.CallEBS){
                            component.set('v.Loading',true);
                            this.CompleteSummaryExternal(component, event, helper);
                            component.set('v.Loading',false);
                        }
                    }
                }else{
                    component.set('v.Loading',false);
                    component.set('v.Error',result.Error);
                    component.set('v.Data',result);
                    component.set('v.Decision',result.Decision);
                    
                }
                
            }
        });
        $A.enqueueAction(action);
    },
     CompleteSummaryExternal:function(component, event, helper){
        var action  = component.get("c.CompleteSummaryExternal");
        action.setParams({
            "eventLogId": component.get('v.EventLogId'),
            "sessionId" :component.get('v.SessionId'),
        });
        action.setCallback(this,function (response){
            var state = response.getState();
            console.log('state##',state);
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                //component.set('v.serviceResponse',result);
                if(result.Data && !result.Data.NextEventUrl){
                    window.location.href = result.Data.NextEventUrl;
                    return;
                }else{
                    component.set('v.Error',' ');
                }
            }
        });
        $A.enqueueAction(action);
    },
    getApplicantList:function(component, event, helper){
        var action  = component.get("c.getApplicantList");
        var app=component.get('v.applicantNamesListStr');
        console.log('app : ',app);
        action.setParams({
            "appNames": app
        });
        action.setCallback(this,function (response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.applicantNames',result);
                var applicantNamesList = response.getReturnValue();
                var applicantJsonListvar = [];
                for (let j = 1; j <=4; j++) {             
                  
                    for (var i = 0; i < applicantNamesList.length; i++) {
                      
                      applicantJsonListvar.push({
                        section:j,
                        appNum :i,
                        app: applicantNamesList[i],
                        displayButton:false
                      });
                    }
                }
                console.log('applicantJsonListvar:',applicantJsonListvar);
    			component.set("v.applicantJsonList", applicantJsonListvar); 
               
    		
                
            }
        });
        $A.enqueueAction(action);
    }
})