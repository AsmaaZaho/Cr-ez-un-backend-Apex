public with sharing class OrderHandlerClass {
    
    // Method to check if orders have associated order items when status is 'Actif'
    //if not display an error 
    public static void OrderHasProducts(List<Order> orders) {
        // Retrieve all the ids of order items linked to the specified orders
        Map<Id, Order> orderWithItem = new Map<Id, Order>([SELECT Id,Status, (SELECT Id FROM OrderItems) FROM Order WHERE Id IN :orders]);
        for(Order o : orders){
            Order order1 = orderWithItem.get(o.Id);
            if(o.Status == 'Actif' && (order1 == null || order1.OrderItems.size() == 0)){
                    o.addError('add products to this order');
            }
        }
    }

    // Method to update the 'Active__c' field on accounts based on attached orders or not
    public static void OrderAttachedWithAccount(List<Order> orders, Boolean isNew){
        Set<Id> accountId = new Set<Id>();
        for(Order o : orders){
            accountId.add(o.AccountId);
        }
        List<Account> acc = new List<Account>();
        acc = [SELECT Id,Active__c, (SELECT Id FROM Orders) FROM Account WHERE Id IN :accountId];

        for(Account a : acc){
            if(isNew){
                a.Active__c = true;
            }else if(a.Orders.size() == 0 ){
                a.Active__c	 = false;
            } 
        }
        update acc;
    }

    // Method to create tasks for accounts without existing tasks
    public static void CreateTaskForAccounts(List<Account> accounts){

        List<Task> taskList = new List<Task>();
        for(Account a: accounts){
            if(a.Tasks.size() == 0){
            taskList.add(new Task(Subject = 'Call',
                                    TaskSubtype ='Call',
                                    Status = 'Nouvelle',
                                    Priority = 'Normale',
                                    ActivityDate = Date.today().addDays(5),
                                    WhatId  = a.Id));
        
           }
        }
            if (taskList.size() > 0) {
                insert taskList;
           }

    }

}