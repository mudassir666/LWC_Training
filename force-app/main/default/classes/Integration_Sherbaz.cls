public class Integration_Sherbaz {

    //::: This method used for returning access token
    @AuraEnabled
    public static String returnAccessToken() {
        // Define the HTTP request
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://nespon70-dev-ed.develop.my.salesforce.com/services/oauth2/token?username=integration.mudassir666666666@outlook.com&password=Ashar123.74ox9IqnHS2cj5TDcStBu5kIj&grant_type=password&client_id=3MVG9wt4IL4O5wvLb0w8Y1Pfh6FwHKm1FDUARjHKjAyV1Rs2znVOhh4vsInFafWVCEYiSidVVN3_uEiacMpes&client_secret=31F49B9CE48E422EDF6A8FB19E5E4E3CE80FC3A39991C1389B77179961F3D6CD');
        request.setMethod('POST');
        
        // Create the HTTP instance
        Http http = new Http();
        String accessToken;
        
        try {
            // Execute the HTTP request
            HttpResponse response = http.send(request);
            
            // Process the response
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                system.debug('::: (returnAccessToken) Response : '+responseBody);
                
                //::: storing the response body into the jsonString 
                String jsonString = responseBody;
                
                //::: converting json into the map
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
                
                // Access individual values from the map
                accessToken = (String) jsonMap.get('access_token');
                system.debug('::: (returnAccessToken) accessToken : '+accessToken);
                

                // Handle the response as needed
            } else {
                // Handle error response
                String errorMessage = 'HTTP request failed with status code: ' + response.getStatusCode();
                // Handle error scenario
                system.debug('::: (returnAccessToken) Error : '+errorMessage);
            }
        } catch (Exception ex) {
            // Handle exception scenario
            String errorMessage = 'An exception occurred during the HTTP callout: ' + ex.getMessage();
            system.debug('::: (returnAccessToken) Catch Error : '+errorMessage);
        }
        
        return accessToken;
    }
    
    
    
    
        //::: This method used for getting all the account records by setting bearer token into the header by call accessToken Method
        @AuraEnabled
        public static List<Map<String,String>> makeCallout() {
            
        // Define the HTTP request
        HttpRequest request = new HttpRequest();
            
        //::: setting the endpoint by giving query to get accounts    
        request.setEndpoint('https://nespon70-dev-ed.develop.my.salesforce.com/services/data/v54.0/query/?q=SELECT+Id,Name+FROM+Account');
        request.setMethod('GET');
            
         // Set any additional headers if needed
         
         //::: getting the token by calling method and passing it into the Authorization Header
         String auth = returnAccessToken();
         request.setHeader('Authorization', 'Bearer ' +auth );
         request.setHeader('Content-Type', 'application/json');
        
      
        // Create the HTTP instance
        Http http = new Http();
            
        //::: List to store AccountRecord object
        List<Map<String,String>> finalResponse = new List<Map<String,String>>();
        try {
            // Execute the HTTP request
            HttpResponse response = http.send(request);

            // Process the response
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                system.debug('::: (makeCallout) Response : '+responseBody);
                
                
                //::: Change Json into Map
                Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                //system.debug('::: (makeCallout) Map ParsedJson : '+parsedJson);
                List<Object> recordsJson = (List<Object>) parsedJson.get('records');
                //system.debug('::: (makeCallout) List recordsJson : '+recordsJson);
        		
                for (Object recordJson : recordsJson) {
                    Map<String, Object> recordMap = (Map<String, Object>) recordJson;
                    
                   	Map<String,String> singleRecord = new Map<String,String>(); 
                    singleRecord.put('Id',(String) recordMap.get('Id'));
                    singleRecord.put('Name',(String) recordMap.get('Name'));
                    finalResponse.add(singleRecord);
                   
                    
                }
                
               	System.debug(':::: finalResponse: ' + finalResponse);
            } else {
                // Handle error response
                String errorMessage = 'HTTP request failed with status code: ' + response.getStatusCode();
                system.debug('::: makeCallout() Error'+errorMessage);
                // Handle error scenario
            }
        } catch (Exception ex) {
            // Handle exception scenario
            String errorMessage = 'An exception occurred during the HTTP callout: ' + ex.getMessage();
             system.debug('::: makeCallout() Catch Error'+errorMessage);
        }
            
            
            return finalResponse;
    }
        
    public class AccountRecord {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Name { get; set; }
       
    }
       
}