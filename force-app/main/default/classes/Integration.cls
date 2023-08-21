public class Integration {
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
                
                
               /*
                 String instanceUrl = (String) jsonMap.get('instance_url');
                String id = (String) jsonMap.get('id');
                String tokenType = (String) jsonMap.get('token_type');
                String issuedAt = (String) jsonMap.get('issued_at');
                String signature = (String) jsonMap.get('signature'); 
*/
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
        public static List<AccountRecord> makeCallout() {
            
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
        
        // Set request parameters using setParams method
       /*
        Map<String, String> params = new Map<String, String>();
        params.put('param1', 'value1');
        params.put('param2', 'value2');
        setParams(request, params);
		*/
        // Create the HTTP instance
        Http http = new Http();
            
        //::: List to store AccountRecord object
        List<AccountRecord> records = new List<AccountRecord>();
        
        try {
            // Execute the HTTP request
            HttpResponse response = http.send(request);

            // Process the response
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                system.debug('::: (makeCallout) Response : '+responseBody);
                
                //::: List to store AccountRecord object
              //  List<AccountRecord> records = new List<AccountRecord>();
                //::: Change Json into Map
                Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                system.debug('::: (makeCallout) Map ParsedJson : '+parsedJson);
                List<Object> recordsJson = (List<Object>) parsedJson.get('records');
                system.debug('::: (makeCallout) List recordsJson : '+recordsJson);
        		//List<String> accountIdSet = new List<String>();   getAccountRecords()
        		List<Account> accList = new List<Account>();
                for (Object recordJson : recordsJson) {
                    Map<String, Object> recordMap = (Map<String, Object>) recordJson;
                   // accountIdSet.add((String) recordMap.get('Id'));   getAccountRecords()
                    AccountRecord record = new AccountRecord();
                 
                    record.Id = (String) recordMap.get('Id');
                    record.Name = (String) recordMap.get('Name');
                    //Map<String, Object> attributesMap = (Map<String, Object>) recordMap.get('attributes');
                    //record.attributes = new Attributes();
                    //record.attributes.type = (String) attributesMap.get('type');
                    //record.attributes.url = (String) attributesMap.get('url');
                    records.add(record);
                    
                    Account acc = new Account();
                    acc.Id = (String) recordMap.get('Id');
                    acc.Name = (String) recordMap.get('Name');
                    accList.add(acc);
                    
                }
                system.debug('records '+records);
                system.debug('::: accList records '+accList);
                //List<Account> accounts = getAccountRecords(accountIdSet);
                
                //system.debug('accounts '+accounts);
                
                // Handle the response as needed
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
            
            return records;
    }
    
  /*  public static List<Account> getAccountRecords(List<String> accountIds) {
        List<Account> accountRecords = new List<Account>();

        String accountIdsString = '\'' +String.join(accountIds, '\',\'')+ '\'';
        //String endpoint = 'https://nespon70-dev-ed.develop.my.salesforce.com/services/data/v54.0/sobjects/Account/(' + accountIdsString+')';
		String endpoint ='https://nespon70-dev-ed.develop.my.salesforce.com/services/data/v54.0/query/?q=SELECT+Id,Name+FROM+Account+Where+id+IN+('+accountIdsString+')';
        system.debug(endpoint);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        String auth = returnAccessToken();
        request.setHeader('Authorization', 'Bearer ' +auth );
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = new Http().send(request);
        system.debug('res '+response);
        if (response.getStatusCode() == 200) {
            system.debug('asdasdsadasd '+response.getBody());
            accountRecords = (List<Account>) JSON.deserialize(response.getBody(), List<Account>.class);
        }

        return accountRecords;
    }
  */

    
    public class AccountRecord {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Name { get; set; }
       // @AuraEnabled public Attributes attributes { get; set; }
    }

   /*
    public class Attributes {
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public String url { get; set; }
    }
*/
       
}