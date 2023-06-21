@IsTest
public class CloseCaseControllerTest {
	
    static testMethod void testController()
	{
        List<CloseCaseController.FieldWrapper> wrapper=CloseCaseController.retrieveCaseFields('Close_Case');
        system.assert(wrapper.size()>0);
    }
}