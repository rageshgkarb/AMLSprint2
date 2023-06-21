({
	doInit : function(component, event, helper) {
		var action  = component.get("c.getCAA_DeclarationText");
        action.setParams({
            "ibbProductName": component.get("v.ibbProductName")
        });
        action.setCallback(this,function (response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var retValue = response.getReturnValue();
                component.set('v.productTypeMap',retValue);
                //console.log(retValue.get['showYPSATC']);
            }
        });
        $A.enqueueAction(action);
    }
})