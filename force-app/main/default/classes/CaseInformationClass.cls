public class CaseInformationClass {
    
	public String currentRecordId {get;set;}
	public String parameterValue {get;set;}
   	public String closeCaseFieldSet {get;set;}
    public String recordtype {get;set;}
    public List<String> standardCloseCase=new List<String>{'Account Services','Collections','Complaint','Contact Customer','Credit',
                                                           'Customer Services','Deceased Estate','FCU Case','Finance','Payments Processing',
                                                           'Refund','Standard'};
    public List<String> itRequest = new List<String>{'IT Change Requests'};
    public List<String> itCloseCase = new List<String>{'IT Standard','IT System Access'};

 
    public CaseInformationClass(ApexPages.StandardController controller) {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        parameterValue = ApexPages.CurrentPage().getparameters().get('nameParam');
        id userid= UserInfo.getUserId();
        User u = [select id , Profile.Name from User where Id = : userId];
        Case myCase=[select id, RecordType.Name ,RecordTypeId from Case where Id = : currentRecordId ];
        recordtype = mycase.RecordTypeId;
             
        if(standardCloseCase.contains(mycase.RecordType.Name)){
            if(u.Profile.Name == 'Minimum Access - Salesforce'){
                 closeCaseFieldSet='Close_Case';
            }else{
                 closeCaseFieldSet='Standard_Close_Case';
            }
           
        }else if(itRequest.contains(mycase.RecordType.Name)){
            closeCaseFieldSet='IT_Request';
        }else if(itCloseCase.contains(mycase.RecordType.Name)){
            if(u.Profile.Name == 'Minimum Access - Salesforce'){
                 closeCaseFieldSet='Close_Case';
            }else{
                 closeCaseFieldSet='IT_Close_Case';
            }
        }else{
            closeCaseFieldSet='Close_Case';
        } 
            
    }
}