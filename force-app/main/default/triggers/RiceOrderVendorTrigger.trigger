trigger RiceOrderVendorTrigger on Rice_Order_Vendor__c (after insert, after update, after delete, after undelete) {
    Set<Id> orderIds = new Set<Id>();
    if (Trigger.isDelete) {
        for (Rice_Order_Vendor__c allocation : Trigger.old) {
            if (allocation.Rice_Order__c != null) {
                orderIds.add(allocation.Rice_Order__c);
            }
        }
    } else {
        for (Rice_Order_Vendor__c allocation : Trigger.new) {
            if (allocation.Rice_Order__c != null) {
                orderIds.add(allocation.Rice_Order__c);
            }
        }
    }

    if (!orderIds.isEmpty()) {
        RiceOrderVendorService.rollUpVendorAllocations(orderIds);
    }
}
