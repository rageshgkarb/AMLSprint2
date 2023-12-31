public class MMR_FF_Addresses extends MMR_PageControllerBase
{
    public List<Account> Accs{get;set;}
    
    public PageReference Setup_Addresses()
    {  
        Accs = new List<Account>();
        for(String accid : lstAccountIds )
        {
            String soql = LiabilitiesHelperFunctions.SoqlQuery('MMR_FF_Addresses') + ' from account where id = \'' + accid + '\''  ;
            Account a = DataBase.Query(soql);
            Accs.add(a);
        }
        
        return null;
    }
    
    public PageReference Next()
    {
        update accs;
        return new PageReference('/apex/MMR_FF_Ownership?id=' + eventid);
    }
    
     public PageReference NextLightning()
    {
        update accs;
        return new PageReference('/apex/MMR_FF_Ownership_Lightning?id=' + eventid);
    }
    
    public PageReference Previous()
    {
        update accs;
        return new PageReference('/apex/MMR_FF_PersonalDetails?id=' + eventid);
    }
    
    public PageReference PreviousLightning()
    {
        update accs;
        return new PageReference('/apex/MMR_FF_PersonalDetails_lightning?id=' + eventid);
    }
        
    public PageReference Save()
    {
        //try
       // {
        //update num btl and num properties
                
        update Accs;
        
       // }
       // catch(Exception ex)
       // {
       //     throw ex;
       // }
        return null;
    }

}