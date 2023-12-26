@isTest

private class Test02_BatchClass {

    @isTest
    static void testBatch() {
        //Create 200 test accounts - this simulates one execute
        List<Account> accounts = Test00_DataFactory.createAccount(200);

        // Verify that the batch class correctly updates by executing a batch of records at the same time
        Test.startTest();

        // Schedule the test job
        AccountTaskBatch createTaskForBatch = new AccountTaskBatch();
        String cronExp = '0 0 1 ? * 2#1';
        String jobId = System.schedule('Batch Job', cronExp, createTaskForBatch);
        createTaskForBatch.execute(null);

        Test.stopTest();

        // after the testing stops, 
        List<Account> accounts1 = [SELECT Id,(SELECT Id FROM Tasks) FROM Account];

        // Verify that all accounts have one task after the batch execution
        for(Account a : accounts1){
            System.assert(a.Tasks.size() == 1);
        }
        }
}
