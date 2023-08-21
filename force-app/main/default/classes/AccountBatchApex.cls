global class AccountBatchApex implements Database.Batchable<sObject> {
    
   List<String> accountNames = new List<String>();

  /*  public AccountBatchApex() {
        accountNames = new List<String>();
    }
*/
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for the Account records
       
        return Database.getQueryLocator([SELECT Name FROM Account]);
    }

    global void execute(Database.BatchableContext bc, List<Account> accList) {
        // Process each Account record in the current batch
        for (Account acc : accList) {
            accountNames.add(acc.Name);
            // Print the Account name
            System.debug('Account Name: ' + acc.Name);
        }
    }

    global void finish(Database.BatchableContext bc) {
        
     //   for (String name : accountNames) {
     //       System.debug('Account Name: ' + name);
     //   }
        
        // Executed after all batches are processed (optional)
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

String[] toAddress = new String[]{'mudassir_Ahmed_siddiqui@outlook.com', 'shahid.anum.as@gmail.com'};

mail.setToAddresses(toAddress);

mail.setSubject('Batch Job is completed Mudassir');

mail.setPlainTextBody('Hey, the batch job that you started is successful Mudassir '+accountNames.size());

Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
        
    }
}