public with sharing class RiceOrderVendorService {
    public static void rollUpVendorAllocations(Set<Id> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            return;
        }

        Map<Id, Rice_Order__c> ordersById = new Map<Id, Rice_Order__c>([
            SELECT Id, Order_Quantity__c, Allocated_Quantity__c, Remaining_Quantity__c, Vendor_Allocation_Status__c
            FROM Rice_Order__c
            WHERE Id IN :orderIds
        ]);

        Map<Id, Decimal> allocationTotalsByOrderId = new Map<Id, Decimal>();
        for (Rice_Order_Vendor__c allocation : [
            SELECT Rice_Order__c, Quantity__c
            FROM Rice_Order_Vendor__c
            WHERE Rice_Order__c IN :orderIds
        ]) {
            Decimal total = allocationTotalsByOrderId.get(allocation.Rice_Order__c) != null
                ? allocationTotalsByOrderId.get(allocation.Rice_Order__c)
                : 0;
            Decimal quantity = allocation.Quantity__c != null ? allocation.Quantity__c : 0;
            allocationTotalsByOrderId.put(allocation.Rice_Order__c, total + quantity);
        }

        for (Id orderId : orderIds) {
            Rice_Order__c order = ordersById.get(orderId);
            if (order == null) {
                continue;
            }

            Decimal totalAllocated = allocationTotalsByOrderId.get(orderId) != null ? allocationTotalsByOrderId.get(orderId) : 0;
            order.Allocated_Quantity__c = totalAllocated;
            order.Remaining_Quantity__c = (order.Order_Quantity__c != null ? order.Order_Quantity__c : 0) - totalAllocated;
            if (order.Remaining_Quantity__c <= 0) {
                order.Vendor_Allocation_Status__c = 'Fully Allocated';
            } else if (totalAllocated > 0) {
                order.Vendor_Allocation_Status__c = 'Partially Allocated';
            } else {
                order.Vendor_Allocation_Status__c = 'Not Allocated';
            }
        }

        update ordersById.values();
    }
}
