@isTest
private class RiceOrderVendorServiceTest {
    @isTest
    static void testVendorAllocationsRollUpToOrder() {
        Rice_Order__c order = new Rice_Order__c(
            Name = 'Test Order',
            Customer_Name__c = 'Ada',
            Customer_Email__c = 'ada@example.com',
            Customer_Balance__c = 1000,
            Minimum_Balance__c = 100,
            Rice_Type__c = 'Basmati',
            Order_Quantity__c = 100
        );
        insert order;

        Test.startTest();
        insert new List<Rice_Order_Vendor__c>{
            new Rice_Order_Vendor__c(Rice_Order__c = order.Id, Vendor_Name__c = 'Vendor A', Quantity__c = 60),
            new Rice_Order_Vendor__c(Rice_Order__c = order.Id, Vendor_Name__c = 'Vendor B', Quantity__c = 40)
        };
        Test.stopTest();

        Rice_Order__c updatedOrder = [
            SELECT Allocated_Quantity__c, Remaining_Quantity__c, Vendor_Allocation_Status__c
            FROM Rice_Order__c
            WHERE Id = :order.Id
        ];

        System.assertEquals(100, updatedOrder.Allocated_Quantity__c);
        System.assertEquals(0, updatedOrder.Remaining_Quantity__c);
        System.assertEquals('Fully Allocated', updatedOrder.Vendor_Allocation_Status__c);
    }
}
