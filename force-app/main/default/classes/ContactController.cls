public with sharing class ContactController {
    
    public class response{
        @AuraEnabled public list<Contact> conList {get;set;}
        @AuraEnabled public integer count {get;set;}
        
    }
    
    
    
    @AuraEnabled
    public static response getContactList(String accountId){
        response res = new response();
        
        if(accountId != null){
            res.conList =  [
                Select Id, Name, Title, Phone, Email, Designation__c, Is_Primary_Contact__c, Area_of_Practice__c
                From Contact
                Where AccountId =: accountId
            ];  
        }
        else{
            res.conList = [Select id From Contact Where firstName = '666' ];
        }
        
        
        res.count  = res.conList.Size();
        //res.count  = [Select Count() From Contact Where Email != null Limit 10];
        
        return res;
    }
    
    @AuraEnabled
    Public static Contact createContact(Contact con){
        system.debug('Contact Object = '+con);
        
        Contact c = new Contact(LastName = con.LastName, FirstName = con.FirstName, Email = con.Email,
                                Phone = con.Phone, Designation__c = con.Designation__c, Is_Primary_Contact__c = con.Is_Primary_Contact__c,
                                Area_of_Practice__c = con.Area_of_Practice__c);
        /* c.LastName = con.LastName;
c.FirstName = con.FirstName;
c.Email = con.Email;
c.Phone = con.Phone;
c.Designation__c = con.Designation__c;
c.Is_Primary_Contact__c = con.Is_Primary_Contact__c;
c.Area_of_Practice__c = con.Area_of_Practice__c;
*/        
        system.debug('Contact Object = '+c);
        
        insert c;
        
        return [SELECT Id, Name FROM Contact WHERE Id =: c.Id];
    }

    ///////////////////////////////////////////////////////////////// for Contact Account
    @AuraEnabled
    Public static void createContactAccount(Contact con){
        system.debug('Contact Object = '+con);
        
        Contact c = new Contact(LastName = con.LastName, FirstName = con.FirstName, Email = con.Email,
                                Phone = con.Phone, Designation__c = con.Designation__c, Is_Primary_Contact__c = con.Is_Primary_Contact__c,
                                Area_of_Practice__c = con.Area_of_Practice__c, AccountId = con.AccountId);
        
        system.debug('Contact Account Id = '+c.AccountId);
        system.debug('Contact Object = '+c);
        
        insert c;
        
    }
}
/*
conEmail
conPhone
conDesignation
conDate
conCity
conAddress
conPostalCode
conIsPrimaryContact
conCountry
conAreaOfPractice
*/