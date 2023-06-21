public class MMR_FF_Income extends MMR_PageControllerBase
{
    //Public Opportunity Opp{get;set;}
    Public List<Account> Accs{get;set;}
    
    public PageReference Setup()
    {
        Accs = new List<Account>();
        for(String accid : lstAccountIds )
        {
            String soql = LiabilitiesHelperFunctions.SoqlQuery('MMR_FF_Income') + ' from account where id = \'' + accid + '\''  ;
            Account a = DataBase.Query(soql);
            Accs.add(a);
            
            //Case - 01938975 ;Satrt
            //case 02035951 - Changes to overseas policy;Start
            if(bopp.Interested_in__c == 'Home Purchase Plan Premier'){
                if(bopp.Accountid == a.id){
                a.Is_the_customer_an_expat__c = bopp.Ex_Pat__c;
                }else{
                    if(String.isblank(a.Is_the_customer_an_expat__c))
                        a.Is_the_customer_an_expat__c = 'No';
                }  
            }
            //case 02035951 - Changes to overseas policy;End
            //Case - 01938975 :End       
        }
        return null;
    }
    
    public PageReference Save()
    {
        SaveData();
        //Case - 01938975 :Start
        if(bopp.Interested_in__c == 'Home Purchase Plan Premier'){
            for(Account acc:Accs){
                if(acc.Is_the_customer_an_expat__c == null || acc.Is_the_customer_an_expat__c == ''){
                  apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'Please select: Is the customer an expat'));
                  return null;
                }
            }
        }
        //Case - 01938975 :End
        return null;
    }
    
    private void SaveData(){
        //update opp;
        update accs;
    }
    
    
    public PageReference Next()
    {
        
        SaveData();
        //Case - 01938975 :Start
        if(bopp.Interested_in__c == 'Home Purchase Plan Premier'){
             for(Account acc:Accs){
                if(acc.Is_the_customer_an_expat__c == null || acc.Is_the_customer_an_expat__c == ''){
                  apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'Please select: Is the customer an expat'));
                  return null;
                }
            }
        }
        //Case - 01938975 :End
        return new PageReference('/apex/MMR_FF_Financial?id=' + eventid);
    }
    //Method used in Lightnihng
     public PageReference NextPage()
    {
        
        SaveData();
        //Case - 01938975 :Start
        if(bopp.Interested_in__c == 'Home Purchase Plan Premier'){
             for(Account acc:Accs){
                if(acc.Is_the_customer_an_expat__c == null || acc.Is_the_customer_an_expat__c == ''){
                  apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'Please select: Is the customer an expat'));
                  return null;
                }
            }
        }
        //Case - 01938975 :End
        return new PageReference('/apex/MMR_FF_Financial_Lightning?id=' + eventid);
    }
    public PageReference Prev()
    {
        SaveData();
        return new PageReference('/apex/MMR_FF_Ownership?id=' + eventid);
    }
    //Method used in Lightning
      public PageReference Previous()
    {
        SaveData();
        return new PageReference('/apex/MMR_FF_Ownership_Lightning?id=' + eventid);
    }
}