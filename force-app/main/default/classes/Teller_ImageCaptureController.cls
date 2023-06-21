public with sharing class Teller_ImageCaptureController {
    
    public String imageType { get; set; }
    public String imageBase64Binary { get; set; }
    
    private class ImageBlob {
        Blob Image;
    }
    
    public Boolean SaveImage(String ebsId, String imgType, String imgBase64Binary)
    {
        return SaveImageInternal(ebsId, imgType, imgBase64Binary);
    }
    
    private Boolean SaveImageInternal(String ebsId, String imgType, String imgBase64Binary)
    {
        system.debug('Teller_ImageCaptureController.SaveImage Entry');
        
        if (!String.isBlank(imgBase64Binary))
        {	
            system.debug('EBSID: ' + ebsId);
            system.debug('imageType: ' + imgType);
            
            List<Account> acc = [select Id from Account where EBS_ID__c=:ebsId];
            
            Customer_Image__c image = new Customer_Image__c(); // Create image object
            System.debug('Account Id: ' + acc.get(0).Id);
            
            image.Account__c = acc.get(0).Id;
            image.Added_By__c = UserInfo.getUserId();
            image.Added_Date__c = datetime.now();
            image.Status__c = 'Not Approved';
            image.Approved_By__c = null;
            image.Approved_Date__c = null;
            image.Image_Type__c = imgType;
            
            insert(image);  // insert Cosign_Image__c record           
            
            //String image64Text = imgBase64Binary;
            Blob imageBlobToSave = EncodingUtil.base64Decode(imgBase64Binary);
            
            ContentVersion cv = new ContentVersion();
            cv.ContentLocation = 'S';
            cv.PathOnClient ='myImage.png';
            cv.Title = 'myImage';
            cv.versiondata=imageBlobToSave;
            insert cv;
            
            string docID = cv.id;
            ContentVersion currentDoc = [SELECT ContentDocumentId from 
                                         ContentVersion  where id =:docID and isLatest =true];
            docID = currentDoc.ContentDocumentId;
            
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = currentDoc.ContentDocumentId;
            cdl.LinkedEntityId =image.id;
            insert cdl;
            
			image.Image_Id__c =  cv.Id;
            update(image);
            
            return true;
        }
        return false;
    }
    
    public PageReference SaveImage() {
        system.debug('Teller_ImageCaptureController.SaveImage Entry');
        
        if (!String.isBlank(imageBase64Binary))
        {
            String EBSId = apexpages.currentpage().getparameters().get('EBSId');
            String imageType = apexpages.currentpage().getparameters().get('Photo');
            system.debug('EBSID: ' + EBSId);
            system.debug('imageType: ' + imageType);
            
            if (imageType == 'Y')
            {
                imageType = 'Photo';
            }
            else
            {
                imageType = 'Signature';
            }
            
            List<Account> acc = [select Id from Account where EBS_ID__c=:EBSId];
            
            Customer_Image__c image = new Customer_Image__c(); // Create image object
            System.debug('Account Id: ' + acc.get(0).Id);
            
            image.Account__c = acc.get(0).Id;
            image.Added_By__c = UserInfo.getUserId();
            image.Added_Date__c = datetime.now();
            image.Status__c = 'Not Approved';
            image.Approved_By__c = null;
            image.Approved_Date__c = null;
            image.Image_Type__c = imageType;
            
            insert(image);  // insert Cosign_Image__c record
            
            
            String image64Text = '{"Image":"' + imageBase64Binary + '"}';
            ImageBlob imageBlobToSave = (ImageBlob) JSON.deserialize(image64Text, ImageBlob.class);
            
            // new code for Attachment
            
            ContentVersion cv = new ContentVersion();
            cv.ContentLocation = 'S';
            cv.PathOnClient ='myImage.jpg';
            cv.Title = 'myImage';
            cv.versiondata=imageBlobToSave.Image;
            insert cv;
            string docID = cv.id;
            ContentVersion currentDoc = [SELECT ContentDocumentId from 
                                         ContentVersion  where id =:docID AND isLatest =true];
            docID = currentDoc.ContentDocumentId;
            
            
            
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = currentDoc.ContentDocumentId;
            cdl.LinkedEntityId =image.id;
            insert cdl;
            
            
            image.Image_Id__c = cv.Id;
            update(image);
        }
        return null;
    }
}