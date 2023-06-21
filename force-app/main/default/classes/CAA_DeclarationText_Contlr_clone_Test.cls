@isTest
public class CAA_DeclarationText_Contlr_clone_Test {
 
    Private  static testmethod void getCAA_DeclarationText_Test(){
        Test.startTest();
        Map<String, Boolean> productMap =CAA_DeclarationText_Controller_clone.getCAA_DeclarationText('DIRECT SAVINGS ACCOUNT');
        System.assertEquals(true, productMap.get('showDirectSavingsAccountTC'));
        System.assertEquals(false, productMap.get('showYPSATC'));
        Test.stopTest();
    }
}