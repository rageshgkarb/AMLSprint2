({
    getRelatedDocuments : function(component, event) {
        console.log('rec ###',component.get("v.objectRecordId"));
        component.set('v.showAll', false); 
        var action = component.get("c.getRelatedDocs");
        action.setParams({
            recordId : component.get("v.objectRecordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //var AllNotesList = [];
            var notesList = [];
            if(state === "SUCCESS"){
                component.set('v.allNotes', response.getReturnValue());
                if(component.get('v.allNotes').length>5){
                    for (var i = 0; i < 5; i++) {
                        notesList.push(component.get('v.allNotes')[i]);
                    }
                    component.set('v.cdList', notesList); 
                }else{
                    component.set('v.cdList', component.get('v.allNotes')); 
                }
                
                //component.set('v.cdList', response.getReturnValue());
            }else if(state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
    getRelatedContentDocuments : function(component, event) {
        console.log('rec ###',component.get("v.objectRecordId"));
        component.set('v.showAllFiles', false); 
        var action = component.get("c.getRelatedContentDocs");
        action.setParams({
            recordId : component.get("v.objectRecordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //var AllNotesList = [];
            var docList = [];
            if(state === "SUCCESS"){
                component.set('v.allDocumentList', response.getReturnValue());
                if(component.get('v.allDocumentList').length>5){
                    for (var i = 0; i < 5; i++) {
                        docList.push(component.get('v.allDocumentList')[i]);
                    }
                    component.set('v.documentList', docList); 
                }else{
                    component.set('v.documentList', component.get('v.allDocumentList')); 
                }
                
                //component.set('v.cdList', response.getReturnValue());
            }else if(state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
     
    deleteDocument : function(component, event, docId) {
        var action = component.get("c.deleteDoc");
        action.setParams({
            docId : docId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                this.getRelatedDocuments(component, event);
                this.getRelatedContentDocuments(component, event);
            }else if(state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
     
    openEditmodal: function(component,event,docId) {
        var action = component.get("c.getContentNote");
        action.setParams({
            recordId : docId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.noteWrap', response.getReturnValue());
                component.set('v.contentString', component.get('v.noteWrap').content);
                var cmpTarget = component.find('ModalboxEdit');
                var cmpBack = component.find('ModalbackdropEdit');
                $A.util.addClass(cmpTarget, 'slds-fade-in-open');
                $A.util.addClass(cmpBack, 'slds-backdrop--open');
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
    updateContentNotes: function(component,event,helper) {
        component.set('v.noteWrap.content',component.get('v.contentString'))
        console.log("contentString: ",component.get('v.contentString'));
        console.log("content id: ",component.get('v.noteWrap').cNote.Id);
        var action = component.get("c.updateNotes");
        action.setParams({
            noteId : component.get('v.noteWrap').cNote.Id,
            noteTitle : component.get('v.noteWrap').cNote.Title,
            noteContent: component.get('v.contentString'),
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                this.getRelatedDocuments(component, event);
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);  
    },
    
   
    closeModal:function(component,event,helper){   
        var cmpTargetedit = component.find('ModalboxEdit');
        var cmpBackedit = component.find('ModalbackdropEdit');
        $A.util.removeClass(cmpBackedit,'slds-backdrop--open');
        $A.util.removeClass(cmpTargetedit, 'slds-fade-in-open'); 
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        
    },
    
    
    
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 4500000,      //Chunk Max size 750Kb 
     
    uploadHelper: function(component, event) {
        var fileInput = component.find("fuploader").get("v.files");
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        console.log('file.size'+file.size);
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
           
            alert('File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + 'Selected file size: ' + file.size);
            return;
        }
         
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
             
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
           self.uploadProcess(component, event, file, fileContents);
        });
         
        objFileReader.readAsDataURL(file);
    },
     
    uploadProcess: function(component, event, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, event, file, fileContents, startPosition, endPosition, '');
    },
     
    uploadInChunk: function(component, event, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'SaveFile'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.SaveFile");
        action.setParams({
            parentId: component.get("v.objectRecordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, event, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    this.getRelatedContentDocuments(component, event);
                    alert('File has been uploaded successfully');
                   
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    
    downloadDocument : function(component, event, docId) {
        var action = component.get("c.getDocURL");
        action.setParams({
            docId : docId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                window.location.href =response.getReturnValue();
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
   
})