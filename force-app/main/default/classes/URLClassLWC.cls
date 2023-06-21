/*
 * Class Name : URLClassLWC
* Author : Abhishek Paliwal
* Description : created to get URL for LWC
* Modified By : Abhishek Paliwal
*
*/
public class URLClassLWC {
    

    @AuraEnabled(Cacheable=true)
    public static String getCollectionLettersURL(String accId){
        Account acc =[SELECT id,Partner_server_URL__c from Account where id= : accId];
        String serverURL = acc.Partner_server_URL__c ;
        //String sessionId =UserInfo.getSessionId();
        String sessionId =  LexSessionController.fetchUserSessionId();
        String url='https://composer.congamerge.com?sessionId='+sessionId+'&serverUrl='+serverURL+'&id='+accId+'&Reportid=00OD0000005qxeM?pv0='+accId+'&templategroup=collections';
        return url;
    }
    @AuraEnabled(Cacheable=true)
    public static String getFCUURL(String accId){
        Account acc =[SELECT id,Partner_server_URL__c from Account where id= : accId];
        String serverURL = acc.Partner_server_URL__c ;
        //String sessionId =UserInfo.getSessionId();
        String sessionId =  LexSessionController.fetchUserSessionId();
        String url='/apex/Docugen?sessionId='+sessionID+'&serverUrl='+serverURL+'&id='+accId+'&TemplateGroup=FCU';
        System.debug('URL : '+url);
        return url;
    }
    @AuraEnabled(Cacheable=true)
    public static String getMergeDocumentURL(String accId){
        Account acc =[SELECT id,Partner_server_URL__c from Account where id= : accId];
        String serverURL = acc.Partner_server_URL__c ; 
        //String sessionId =UserInfo.getSessionId();
        String sessionId =  LexSessionController.fetchUserSessionId();
        String url='/apex/Docugen?sessionId='+sessionId+'&serverUrl='+serverURL+'&id='+accId+'&TemplateGroup=HardToken';
        return url;
    }
    @AuraEnabled(Cacheable=true)
    public static String getDSXRecordURL(String accId){
        Account acc =[SELECT id,EBS_ID__c from Account where id= : accId];
        return 'http://dsxlive1/DSXSearchDisplay/Default.aspx?template=All Docs by Customer&Customer Number='+acc.EBS_ID__c;
    }
    
    @AuraEnabled(Cacheable=true)
    public static String getKYCLettreURL(String accId){
        Account acc =[SELECT id,Partner_server_URL__c from Account where id= : accId];
        String serverURL = acc.Partner_server_URL__c ; 
        //String sessionId =UserInfo.getSessionId();
        String sessionId =  LexSessionController.fetchUserSessionId();
        String url = '/apex/Docugen?sessionId='+sessionId+'&serverUrl='+serverURL+'&id='+accId+'&q1=[Acc]a5a3z000000ZHB3&q2=[AccA]a5a3z000000ZHB8&TemplateGroup=KYCLetters';
        //String url='/apex/Docugen?sessionId='+sessionId+'&serverUrl='+serverURL+'&id='+accId+'&TemplateGroup=HardToken';
        return url;
    }
    
}