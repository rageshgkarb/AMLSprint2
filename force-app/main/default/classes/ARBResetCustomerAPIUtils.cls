public with sharing class ARBResetCustomerAPIUtils {
    
    public static String buildResetRequestBody ( Account accountRecord ){
		String messageId = fetchUniqueMessageId ();
		String messageType = 'ResetDigitalUser';
		String sfdcId = accountRecord.SFDC_ID__c;
		String ebsId = accountRecord.EBS_ID__c;
        String sfdcUser = UserInfo.getUserName ();
		
        string xmlRequest = '<?xml version="1.0" encoding="utf-8"?>';
        xmlRequest = xmlRequest+ IBBXMLMethods.BuildEnvelope ('ResetDigitalUser',
                                                        'http://Bank.Service.Digital',
                                                        'req',
                                                        'http://Bank.Service.ResetDigitalUser',
                                                        messageType,
                                                        messageId);
               
       
        xmlRequest = xmlRequest + '<SFDCID>'+sfdcId+'</SFDCID>';
        xmlRequest = xmlRequest + '<EBSID>' + ebsId + '</EBSID>';
        xmlRequest = xmlRequest + '<SFDCUser>' + sfdcUser + '</SFDCUser>';
        xmlRequest = xmlRequest + '</req>';
        xmlRequest = xmlRequest + '</ResetDigitalUser>';
        xmlRequest = xmlRequest + '</soap:Body>\n';
        xmlRequest = xmlRequest + '</soap:Envelope>\n';
       
        system.debug ( 'This is the message ' + xmlRequest);

        //String xmlRequest = '<?xml version="1.0" encoding="utf-8"?> <soap:Envelope xmlns:xsi=http://www.w3.org/2001/XMLSchema-instance xmlns:xsd=http://www.w3.org/2001/XMLSchema xmlns:soap=http://schemas.xmlsoap.org/soap/envelope/> <soap:Body> <ResetDigitalUser "xmlns=http://Bank.Service.Digital"> <req xmlns=http://Bank.Service.ResetDigitalUser> <MessageID>9999999</MessageID> <MessageType>ResetUser</MessageType> <SFDCID>SFDC-0000544344</SFDCID> <EBSID></EBSID> <SFDCUser>Fu Manchu</SFDCUser> </req> </ResetDigitalUser> </soap:Body> </soap:Envelope>';
        return xmlRequest;
    }

    public static Map < String, String >  fetchBrokerAPIResponse ( Account accountRecord ) {
        Map < String, String > xmlResponseMap = new Map < String, String > ();
        String xmlRequest = buildResetRequestBody ( accountRecord );
        System.debug ('xmlRequest' + xmlRequest);

        HttpRequest req = new HttpRequest();
        Http h = new Http();
        HttpResponse res;
        
        Webservice_Setting__c ws = Webservice_Setting__c.getValues('HTTP Request Timeout');
        Integer httpTimeout = 30000;
        if (ws != null)
        {
            httpTimeout = Integer.valueOf(ws.Value__c);
        }
        
        ws = Webservice_Setting__c.getValues('Webservice Endpoint'); 
        String endPoint = 'http://80.194.71.201:80/InboundBrokerService/GenericInboundBroker.asmx';
        
        if (ws != null)
        {
            endPoint = ws.Value__c;
        }
        
        tempuriOrg.GenericInboundBrokerSoap giSoap = new tempuriOrg.GenericInboundBrokerSoap();
        giSoap.timeout_x = httpTimeout;
        giSoap.endpoint_x = endPoint;
            //This is the line that calls the WebService
        String theXMLResponse = giSoap.BrokerInboundRequest(xmlRequest);
        

        if ( theXMLResponse != null ) {
            system.debug ( 'the xml response ' + theXMLResponse);
            xmlResponseMap =  parseXMLResponse( theXMLResponse);

        }

        return xmlResponseMap;
    }

    public static Map<string, string> parseXMLResponse( String theXMLResponse)
    {
		
        Map<string, string> theResponseMap = new Map<string, string>();
        XmlStreamReader xsr = new XmlStreamReader(theXMLResponse);
        string theTag;
        string theValue;
        while (xsr.hasNext())
        {
              if (xsr.getEventType() == XmlTag.START_ELEMENT)
              {
                  if ('MESSAGEID'.EqualsIgnoreCase(xsr.getLocalName()))
                  {
                      theTag = xsr.getLocalName();
                      xsr.next();
                      if (xsr.isCharacters())
                      {
                          theResponseMap.put (theTag, xsr.getText());
                      }
                  }
                  else if ('RESPONSECODE'.EqualsIgnoreCase(xsr.getLocalName()))
                  {
                      theTag = xsr.getLocalName();
                      xsr.next();
                      if (xsr.isCharacters())
                      {
                          theResponseMap.put (theTag, xsr.getText());
                      }
                  }
                  else if ('RESPONSEMESSAGE'.EqualsIgnoreCase(xsr.getLocalName()))
                  {
                      theTag = xsr.getLocalName();
                      xsr.next();
                      if (xsr.isCharacters())
                      {
                          theResponseMap.put (theTag, xsr.getText());
                      }
                  }
              }
              xsr.next();
        }
        
   
        
        
        
        system.debug ( 'The ResponseMap ' + theResponseMap);  
        return theResponseMap;
    }

    public static String fetchUniqueMessageId(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug(guid);
        return guid;
    }
    
}