trigger OrderStatusTrigger on Order (before insert, before update, after insert, after delete) {

    if (Trigger.isInsert || Trigger.isUpdate){
        if(Trigger.isBefore){
        System.debug(Trigger.new);
        System.debug(Trigger.old);
        //OrderHandlerClass.OrderHasProducts(Trigger.new);
        OrderHandlerClass.OrderHasProducts(Trigger.new);
        }
        if(Trigger.isAfter){
            OrderHandlerClass.OrderAttachedWithAccount(Trigger.new, Trigger.isInsert);
        }
    } 

    if(Trigger.isDelete){
        OrderHandlerClass.OrderAttachedWithAccount(Trigger.old, Trigger.isInsert);
    }

}