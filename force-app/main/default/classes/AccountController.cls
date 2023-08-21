public with sharing class AccountController {
    
    // Wrapper Class : to return multiple things
    public class wrapperResponse{
        @AuraEnabled public list<Account> accList {get;set;}
        @AuraEnabled public List<String> stateCodes {get;set;}
        
    }
    
    // To returen accountList and StateCodes, it takes parameters
    @AuraEnabled
    public static wrapperResponse getAccountList(String ownership, String industry, String noOfEmployees, String stateCode){
        
        wrapperResponse res = new wrapperResponse();
        
        // creating a query
        String queryString = 'Select Name, Id, Industry, Rating, Ownership, AnnualRevenue, CreatedDate, ShippingCity, ShippingCountry, ShippingState, ShippingStateCode, NumberOfEmployees From Account WHERE Name != null';
        
        if (ownership != null) {
            if(ownership == 'Public/Private'){
                queryString += ' AND (Ownership = \'Private\' OR Ownership = \'Public\') ';
            }else{
                queryString += ' AND Ownership = \'' + ownership + '\'';
            }
        }
        if (industry != null) {
            queryString += ' AND Industry = \'' + industry + '\'';
        }
        if (noOfEmployees != null){
            if(noOfEmployees == '<50'){
                queryString += ' AND NumberOfEmployees < 50';
            }
            else if(noOfEmployees == '>50 and <150'){
                queryString += ' AND NumberOfEmployees >50 and NumberOfEmployees <150';
            }
            else if(noOfEmployees == '>500 and <1500'){
                queryString += ' AND NumberOfEmployees >500 and NumberOfEmployees <1500';
            }
            else if(noOfEmployees == '>1500'){
                system.debug('Hello');
                queryString += ' AND NumberOfEmployees > 1500';
                system.debug('Hello 2');
            }
        }
        if (stateCode != null) {
            queryString += ' AND ShippingStateCode = \'' + stateCode + '\'';
        }
        
        System.debug(queryString);  
        
        // use to store a query 
        res.accList = Database.query(queryString);
        
        //////////////////////////////////////////////////////////////////////////////
        
        // To return statesCodes by performing some functions
        List<Schema.PicklistEntry> picklistEntries = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ShippingStateCode').getDescribe().getPicklistValues();
        List<String> states = new List<String>();
        for(Schema.PicklistEntry entry: picklistEntries) {
            states.add(entry.getValue());
        }
        
        // use to store a list of codes
        res.stateCodes = states;
        
        return res;
        
    }
    
    
    
    
    
    
    
    // To get StateCodes
    @AuraEnabled
    public static List<String> getStateCodes() {
        List<Schema.PicklistEntry> picklistEntries = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ShippingStateCode').getDescribe().getPicklistValues();
        List<String> states = new List<String>();
        for(Schema.PicklistEntry entry: picklistEntries) {
            states.add(entry.getValue());
        }
        return states;
        
        //  return [SELECT ShippingStateCode FROM Account WHERE ShippingCountryCode = 'US'];
    }
    
    /*
public static List<Account> getStateCodes() {
//List<Schema.PicklistEntry> picklistEntries = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ShippingStateCode').getDescribe().getPicklistValues();
// List<String> states = new List<String>();
// for(Schema.PicklistEntry entry: picklistEntries) {
//      states.add(entry.getValue());
//   }
//   return states;

return [SELECT ShippingStateCode FROM Account WHERE ShippingCountryCode = 'US'];
}
*/
    
    
    
    
    
    
    
    
    
    
    // Demo Dynamic Query
    public static void soqlDynamic(String industry, String type, String ownership){
        
        
        String queryString = 'SELECT Id, Name, Industry, Ownership, Type FROM Account WHERE Name != null';
        
        
        
        if (industry != null) {
            queryString += ' AND Industry = \'' + industry + '\'';
        }
        if (ownership != null) {
            if(ownership == 'Public/Private'){
                queryString += 'AND Ownership = \'Private\' Or Ownership = \'Public\'';
            }else{
                queryString += ' AND Ownership = \'' + ownership + '\'';
            }
        }
        if (type != null) {
            queryString += ' AND type = \'' + type + '\'';
        }
        
        
        
        System.debug(queryString);  // Outputs: SELECT Id, Name, Industry, Ownership, Rating FROM Account WHERE 1 = 1 AND Industry = 'Technology' AND Ownership = 'Private' AND Rating = 'Hot'
        
        List<Account> accounts = Database.query(queryString);
        
        System.debug('Size = '+accounts.size()); 
        
        for(Account a: accounts){
            System.debug('Name = '+a.Name+' || Type = '+a.Type+' || Ownership = '+a.Ownership);
        } 
        
    }
}

/*
Name
Id
Industry
Rating
Ownership
AnnualRevenue
CreatedDate
ShippingCity
ShippingCountry
ShippingState

public class DynamicQuery {

public static void soqlDynamicQuery(String industry, String type, String ownership, String active){
String query = 'select Name, Id, Industry, Rating, Ownership, AnnualRevenue, CreatedDate from Account where (industry=\''+industry+'\''+' OR'+ ' industry!=null)';

system.debug(query); 
List<Account> accList = database.query(query);
System.debug(accList); 

}
}
*/