public with sharing class RiceOrderWorkflowService {
    public static void createSampleWorkflowData() {
        List<Rice_Order__c> orders = new List<Rice_Order__c>();
        orders.add(new Rice_Order__c(
            Customer_Name__c = 'Asha Patel',
            Customer_Email__c = 'asha@example.com',
            Customer_Balance__c = 500,
            Minimum_Balance__c = 100,
            Rice_Type__c = 'Basmati',
            Order_Quantity__c = 200,
            Status__c = 'Pending Review',
            Customer_Confirmation__c = 'Confirmed',
            Transport_Plan__c = 'Truck booked from vendor yard to customer hub',
            Route_Plan__c = 'Vendor Yard -> Regional Hub -> Customer',
            Expected_Delivery_Date__c = Date.today().addDays(2),
            Payment_Terms__c = '50% advance, balance on delivery'
        ));

        orders.add(new Rice_Order__c(
            Customer_Name__c = 'Ravi Menon',
            Customer_Email__c = 'ravi@example.com',
            Customer_Balance__c = 800,
            Minimum_Balance__c = 100,
            Rice_Type__c = 'Jasmine',
            Order_Quantity__c = 150,
            Status__c = 'Approved',
            Customer_Confirmation__c = 'Confirmed',
            Transport_Plan__c = 'Tempo dispatched for local delivery',
            Route_Plan__c = 'Warehouse -> Market -> Customer',
            Expected_Delivery_Date__c = Date.today().addDays(1),
            Payment_Terms__c = 'Immediate payment after delivery'
        ));

        insert orders;

        List<Rice_Order_Vendor__c> allocations = new List<Rice_Order_Vendor__c>();
        for (Rice_Order__c order : orders) {
            allocations.add(new Rice_Order_Vendor__c(
                Rice_Order__c = order.Id,
                Vendor_Name__c = 'Green Fields Rice',
                Quantity__c = Integer.valueOf(order.Order_Quantity__c / 2),
                Notes__c = 'Confirmed availability for ' + order.Rice_Type__c
            ));
        }
        insert allocations;

        List<Rice_Order_Communication__c> comms = new List<Rice_Order_Communication__c>();
        for (Rice_Order__c order : orders) {
            comms.add(new Rice_Order_Communication__c(
                Rice_Order__c = order.Id,
                Channel__c = 'WhatsApp',
                Direction__c = 'Inbound',
                Communication_Date__c = Date.today(),
                Message__c = 'Vendor confirmed availability for ' + order.Rice_Type__c + ' and shared quantity details.'
            ));
        }
        insert comms;

        List<Rice_Transport_Team__c> teams = new List<Rice_Transport_Team__c>();
        teams.add(new Rice_Transport_Team__c(
            Name = 'FastLine Logistics',
            Rice_Order__c = orders[0].Id,
            Contact_Person__c = 'Suresh',
            Phone__c = '9876543210'
        ));
        teams.add(new Rice_Transport_Team__c(
            Name = 'Metro Truckers',
            Rice_Order__c = orders[1].Id,
            Contact_Person__c = 'Latha',
            Phone__c = '9123456780'
        ));
        insert teams;
    }
}
