@isTest

public with sharing class Test01_HandlerClass {


    @isTest
    static void testDisplayErrorMessage(){
        //Create one test account 
        List<Account> account = Test00_DataFactory.createAccount(1);
        Boolean exceptionThrown = false;
        Boolean expectedExceptionThrown = false;

        Test.startTest(); 
        // Catch the error message if the order has no products and his status is Actif
        try{
            Test00_DataFactory.createOrder(1,'Actif'); 
        }catch(Exception e)
        {
            exceptionThrown = true;

            // Check if the exception message contains the expected error message
            expectedExceptionThrown =  (e.getMessage().contains('add products to this order')) ? true : false; 
        } 
        Test.StopTest();

        // Assert catching the error displayed by creating an order without a product
        System.AssertEquals(true, exceptionThrown);
        System.assertEquals(true, expectedExceptionThrown);
    }

    @isTest
    static void testCaseActiveAccount(){

        //Create one test account 
        List<Account> account = Test00_DataFactory.createAccount(1);

        Test00_DataFactory.createOrder(1, 'Draft');

        Test.startTest();
        OrderHandlerClass.OrderAttachedWithAccount(Test00_DataFactory.orders, true);
        Test.stopTest();

        // Query the database to retrieve the created account
        Account account1 = [SELECT Id, Active__c FROM Account LIMIT 1];

        // Assert that the Active__c field of the account is checked
        System.assertEquals(true, account1.Active__c);

    }

    @isTest
    static void testDeleteAnOrder(){

        List<Account> account = Test00_DataFactory.createAccount(1);
        Test00_DataFactory.createOrder(1, 'Draft');

        Test.startTest();
        // Delete the test orders using the delete DML statement
        delete Test00_DataFactory.orders;
        Test.stopTest();

        Account account1 = [SELECT Id, Active__c FROM Account LIMIT 1];

        // Assert that the Active__c field of the account is unchecked after deleting the order
        System.assertEquals(false, account1.Active__c);

    }
    }
