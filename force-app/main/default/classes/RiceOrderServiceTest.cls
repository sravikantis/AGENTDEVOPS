@isTest
private class RiceOrderServiceTest {
    @isTest
    static void testOrderRejectedWhenBalanceTooLow() {
        Rice_Order__c order = new Rice_Order__c(
            Name = 'Test Order',
            Customer_Name__c = 'Ada',
            Customer_Email__c = 'ada@example.com',
            Customer_Balance__c = 50,
            Minimum_Balance__c = 100,
            Rice_Type__c = 'Basmati',
            Order_Quantity__c = 5
        );

        Test.startTest();
        RiceOrderService.processOrder(order);
        Test.stopTest();

        System.assertEquals('Rejected', order.Status__c);
        System.assertEquals('Customer balance is below the minimum required balance.', order.Validation_Message__c);
    }

    @isTest
    static void testOrderPendingWhenBalanceSufficient() {
        Rice_Order__c order = new Rice_Order__c(
            Name = 'Test Order 2',
            Customer_Name__c = 'Grace',
            Customer_Email__c = 'grace@example.com',
            Customer_Balance__c = 150,
            Minimum_Balance__c = 100,
            Rice_Type__c = 'Jasmine',
            Order_Quantity__c = 2
        );

        Test.startTest();
        RiceOrderService.processOrder(order);
        Test.stopTest();

        System.assertEquals('Pending Review', order.Status__c);
        System.assertEquals('Order submitted successfully.', order.Validation_Message__c);
    }

    @isTest
    static void testAvailableRiceTypes() {
        List<String> riceTypes = RiceOrderService.getAvailableRiceTypes();
        System.assertEquals(4, riceTypes.size());
        System.assert(riceTypes.contains('Jasmine'));
    }
}
