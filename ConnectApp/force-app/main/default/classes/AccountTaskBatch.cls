public class AccountTaskBatch implements Database.Batchable<sObject>, Schedulable{
    
        public Database.QueryLocator start(Database.BatchableContext info){ 
                // Retrieve all accounts without associated orders and tasks of subtype 'Call'
                return Database.getQueryLocator('SELECT ID, (SELECT Id FROM Tasks WHERE what.type = \'Account\' AND TaskSubType= \'Call\') FROM Account WHERE ID NOT IN (SELECT AccountID FROM Order)');
    
       }
        
       public void execute(Database.BatchableContext info, List<Account> scope){
                OrderHandlerClass.CreateTaskForAccounts(scope);
       }    
        
        public void finish(Database.BatchableContext info){   
             
        } 

        // Execute method for Schedulable interface to schedule the batch class
        public void execute(SchedulableContext sc) {
                // Instantiate and execute the batch class when scheduled
                AccountTaskBatch b = new AccountTaskBatch(); 
                Database.executeBatch(b);
        }

}