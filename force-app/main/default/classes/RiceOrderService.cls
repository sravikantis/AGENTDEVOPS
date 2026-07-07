public with sharing class RiceOrderService {
    public static final Decimal DEFAULT_MINIMUM_BALANCE = 100;

    @InvocableMethod(label='Validate rice orders' description='Checks customer balance and sets order status.')
    public static void validateOrders(List<Rice_Order__c> orders) {
        if (orders == null) {
            return;
        }

        for (Rice_Order__c order : orders) {
            processOrder(order);
        }
    }

    public static void processOrder(Rice_Order__c order) {
        if (order == null) {
            return;
        }

        Decimal minimumBalance = order.Minimum_Balance__c != null ? order.Minimum_Balance__c : DEFAULT_MINIMUM_BALANCE;
        Decimal customerBalance = order.Customer_Balance__c != null ? order.Customer_Balance__c : 0;

        if (customerBalance < minimumBalance) {
            order.Status__c = 'Rejected';
            order.Validation_Message__c = 'Customer balance is below the minimum required balance.';
            return;
        }

        if (String.isBlank(order.Rice_Type__c)) {
            order.Status__c = 'Rejected';
            order.Validation_Message__c = 'Please select a rice type before submitting the order.';
            return;
        }

        order.Status__c = 'Pending Review';
        order.Validation_Message__c = 'Order submitted successfully.';
    }

    public static void notifyCustomer(Rice_Order__c order) {
        if (order == null || String.isBlank(order.Customer_Email__c)) {
            return;
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{ order.Customer_Email__c });
        mail.setSubject('Rice order update');
        mail.setPlainTextBody(
            'Hello ' + order.Customer_Name__c + ', your order for ' + order.Rice_Type__c +
            ' has been received and is being reviewed.'
        );
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
    }

    public static List<String> getAvailableRiceTypes() {
        return new List<String>{ 'Basmati', 'Jasmine', 'Brown', 'Wild' };
    }
}
