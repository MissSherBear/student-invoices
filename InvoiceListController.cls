public with sharing class InvoiceListController {

    @AuraEnabled(cacheable=true)
    public static List<bt_stripe__Sales_Document__c> getInvoiceList() {
        return [SELECT Name, bt_stripe__Name__c, Invoice_Url__c, View_Invoice__c, bt_stripe__Payment_Status__c, bt_stripe__Issue_Date__c, bt_stripe__Due_Date__c, Invoice_Type__c, bt_stripe__Balance_Paid_Amount__c, bt_stripe__Balance_Due_Amount__c, Net_Amount__c, bt_stripe__Subject__c, bt_stripe__Contact__c, bt_stripe__Bill_To__c
                     FROM bt_stripe__Sales_Document__c WHERE bt_stripe__Bill_To__c IN (SELECT AccountId FROM User WHERE username=:UserInfo.getUsername())];
    }
}
