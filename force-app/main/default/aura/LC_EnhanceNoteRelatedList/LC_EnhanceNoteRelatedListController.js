({
    //Get Related Docs
    doInit : function(component, event, helper) {
        helper.getRelatedDocuments(component, event); 
        helper.getRelatedContentDocuments(component, event);
    },
    //Handle Selected Action
    handleSelectedAction: function(component, event, helper) {
        var docId = event.getSource().get("v.value");
        var selectedMenuValue = event.detail.menuItem.get("v.value");
        switch(selectedMenuValue) {
            case "Edit":
                helper.openEditmodal(component, event, docId);
                break;    
            case "Delete":
                helper.deleteDocument(component, event, docId);
                break;
        }
    },
    createNote : function(component, event, helper) {
        var contentNote = component.get("v.note");
        var action = component.get("c.createRecord");
        //Setting the Apex Parameter
        action.setParams({
            nt : contentNote,
            PrentId : component.get("v.objectRecordId")
        });
        action.setCallback(this,function(a){
            var state = a.getState();
             console.log('state###',state);
            if(state == "SUCCESS"){
                //Reset Form
                var contentNote = {'sobjectType': 'ContentNote',
                                    'Title': '',
                                    'Content': ''
                                   };
                //resetting the Values in the form
                component.set("v.note",contentNote);
                helper.getRelatedDocuments(component, event);
                helper.closeModal(component,event,helper);
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        $A.enqueueAction(action);
    },
    updateContentNotes : function(component,event,helper) {
        helper.updateContentNotes(component,event);
        helper.closeModal(component,event,helper);
    },
    openmodal: function(component,event,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
    closeModal:function(component,event,helper){    
        helper.closeModal(component,event,helper);
    },
    showAllNotes : function(component, event) {
        component.set('v.cdList', component.get('v.allNotes'));
        component.set('v.showAll', true);
    },
    showLessNotes : function(component, event) {
        var notesList = [];
        for (var i = 0; i < 5; i++) {
            notesList.push(component.get('v.allNotes')[i]);
        }
        component.set('v.cdList', notesList);
        component.set('v.showAll', false);
    },
    editNote: function(component, event, helper) {
        var index = event.getSource().get('v.value');
        var docId =component.get('v.allNotes')[index].Id;
        helper.openEditmodal(component, event, docId);
    },
    deleteNote: function(component, event, helper) {
        var index = event.getSource().get('v.value');
        var docId =component.get('v.allNotes')[index].Id;
        helper.deleteDocument(component, event, docId);
    },
    
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
        if (component.find("fuploader").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
    
    downloadDocument: function(component, event, helper) {
        var index = event.getSource().get('v.value');
        var docId =component.get('v.allDocumentList')[index].Id;
        helper.downloadDocument(component, event, docId);
    },
    deleteDocument: function(component, event, helper) {
        var index = event.getSource().get('v.value');
        var docId =component.get('v.allDocumentList')[index].Id;
        helper.deleteDocument(component, event, docId);
    },
    showAllFiles : function(component, event) {
        component.set('v.documentList', component.get('v.allDocumentList'));
        component.set('v.showAllFiles', true);
    },
    showLessfiles : function(component, event) {
        var filesList = [];
        for (var i = 0; i < 5; i++) {
            filesList.push(component.get('v.allNotes')[i]);
        }
        component.set('v.documentList', filesList);
        component.set('v.showAll', false);
    },
})