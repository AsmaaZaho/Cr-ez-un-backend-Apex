@isTest

public with sharing class Test00_DataFactory {
    
    // Lists to store created test data
    public static List<Account> accounts = new List<Account>();
    public static List<Order> orders = new List<Order>();
    public static List<OrderItem> items = new List<OrderItem>();
    public static List<Task> tasks = new List<Task>();
    
    // Method to create a specified number of test accounts
    public static List<Account> createAccount(Integer nbAccount){

        for(Integer i=0; i<nbAccount; i++){
            accounts.add(new Account(Name = 'Test Account' + i));
        }
        insert accounts;
        return accounts;
    }

    // Method to create a specified number of test orders associated with accounts
    public static List<Order> createOrder(Integer nbOrder, String StatusOrder){

        for(Account a : accounts){
            for(Integer i=0; i<nbOrder; i++){
                orders.add(new Order(AccountId = a.Id, EffectiveDate=System.today(), Status= StatusOrder, Pricebook2Id= Test.getStandardPricebookId()));
            }
        }

        insert orders;
        return orders;
    }
    
    // Method to create test tasks associated with accounts
    public static List<Task> createTask(){

        for(Account a : accounts){
        tasks.add(new Task(Subject = 'Call',
        TaskSubtype ='Call',
        Status = 'Nouvelle',
        Priority = 'Normale',
        ActivityDate = Date.today().addDays(5),
        WhatId  = a.Id));
        }
        insert tasks;
        return tasks;
    }
    
    // Method to create a product, price book entry, and order items associated with orders
    public static List<OrderItem> createProduct(){

        //Create a product
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;

        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

    // Create OrderItems associated with orders
    for(Order o : orders){
    OrderItem oi1 = new OrderItem (OrderId = o.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
    items.add(oi1);
    OrderItem oi2 = new OrderItem (OrderId = o.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
    items.add(oi2);
    }
    insert items;
    return items;
    }
    

}