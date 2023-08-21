public class DynamicQuery {
    /*
    public static void soqlDynamicQuery(String industry, String type, String ownership, String active){
        String query = 'select Name, Id, Industry, Type, Rating, Ownership, AnnualRevenue, CreatedDate from Account where (industry= \''+industry+'\' OR industry!=null) and (type= \''+type+ '\' OR type!=null) and (ownership= \''+ownership+ '\' OR ownership!=null) and (Active__c= \''+active+ '\' OR Active__c!=null)';
        List<Account> accList = database.query(query);
        
        System.debug('Size = '+accList.size()); 
        
        for(Account a: accList){
            System.debug('Name = '+a.Name+' And Type = '+a.Type);
        } 
        
        
    }
    */
    public static void soqlDynamic(String industry, String type, String ownership, String noOfEmployees, String state){

        
        String queryString = 'SELECT Id, Name, Industry, Ownership, NumberOfEmployees, Type, ShippingStateCode FROM Account WHERE Name != null';
        
        
        
        if (industry != null) {
            queryString += ' AND Industry = \'' + industry + '\'';
        }
        if (ownership != null) {
            queryString += ' AND Ownership = \'' + ownership + '\'';
        }
        if (type != null) {
            queryString += ' AND type = \'' + type + '\'';
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
        if (state != null) {
            queryString += ' AND ShippingStateCode = \'' + state + '\'';
        }
        
    
        System.debug(queryString);  // Outputs: SELECT Id, Name, Industry, Ownership, Rating FROM Account WHERE 1 = 1 AND Industry = 'Technology' AND Ownership = 'Private' AND Rating = 'Hot'

        List<Account> accounts = Database.query(queryString);
        
         System.debug('Size = '+accounts.size()); 
        
        for(Account a: accounts){
            System.debug('Name = '+a.Name+' || Type = '+a.Type+' || Ownership = '+a.Ownership+' || NumberOfEmployees = '+a.NumberOfEmployees +' || ShippingStateCode = '+a.ShippingStateCode );
        } 
        
    }
}