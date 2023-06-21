({
	doInit : function(component, event, helper) {
        helper.getApplicantList(component, event, helper);
	},
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    iAgreeClicked: function(component, event, helper) {
        var allClicked=  helper.iAgreeClicked(component, event, helper);
        component.set("v.allClicked",allClicked);
    },
    getServiceData: function(component, event, helper) {
        helper.getServiceData(component, event, helper);
    },
     
    
})