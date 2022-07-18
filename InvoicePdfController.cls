public without sharing class InvoicePdfController {
  public bt_stripe__Sales_Document__c invoice {get;set;}
  public bt_stripe__Sales_Document__c currentInvoice {get;set;}
  //public List<bt_stripe__Sales_Document__c> invoiceList {get;set;}
  public List<bt_stripe__Line_Item__c> invoiceLineItems {get;set;}
  public List<Discount__c> discounts {get;set;}
  public List<Financial_Aid__c> financialAid {get;set;}
  public List<Verto_Fund__c> vertoFunds {get;set;}
  public List<bt_stripe__Transaction__c> transactions {get;set;}
  public bt_stripe__Transaction__c currentTransaction {get;set;}
  public Boolean showButton {get;set;}
  private ApexPages.StandardSetController setController;


  public String renderAs {get; set;} // Determines whether page is rendered as a PDF or just displayed as HTML

    public InvoicePdfController(ApexPages.StandardController controller) {
        showButton = true;
        invoice = (bt_stripe__Sales_Document__c)controller.getRecord();

        invoice = [SELECT bt_stripe__Name__c, bt_stripe__Payment_Status__c, bt_stripe__Issue_Date__c, bt_stripe__Due_Date__c, Invoice_Type__c, bt_stripe__Balance_Paid_Amount__c, bt_stripe__Balance_Due_Amount__c, Net_Amount__c, OwnerId, bt_stripe__Bill_To__c, bt_stripe__Bill_To_Name__c, bt_stripe__Bill_To_Street__c, 
                   bt_stripe__Bill_To_City__c, bt_stripe__Bill_To_State__c, bt_stripe__Bill_To_Country__c, bt_stripe__Bill_To_Postal_Code__c, bt_stripe__Email__c, bt_stripe__Subject__c
                   FROM bt_stripe__Sales_Document__c WHERE Id =:invoice.Id];

        currentInvoice = [SELECT Id, bt_stripe__Name__c FROM bt_stripe__Sales_Document__c WHERE Id =:invoice.Id];
        
        //invoiceList = [SELECT bt_stripe__Name__c, bt_stripe__Payment_Status__c, bt_stripe__Issue_Date__c, bt_stripe__Due_Date__c, Invoice_Type__c, bt_stripe__Balance_Paid_Amount__c, bt_stripe__Balance_Due_Amount__c, Net_Amount__c, bt_stripe__Subject__c
         //       FROM bt_stripe__Sales_Document__c LIMIT 3];

        invoiceLineItems = [SELECT Name, bt_stripe__Sales_Document__c, bt_stripe__Item_Name__c, bt_stripe__Balance_Due_Amount__c, bt_stripe__Unit_Price__c, bt_stripe__List_Price__c
                            FROM bt_stripe__Line_Item__c 
                            WHERE bt_stripe__Sales_Document__r.Id = :invoice.Id ORDER BY Name];

        discounts = [SELECT Name, Amount__c, Sales_Document__c FROM Discount__c WHERE Sales_Document__r.Id =:invoice.Id];
        financialAid = [SELECT Name, Tentative_Loan_Amount__c, Sales_Document__c FROM Financial_Aid__c WHERE Sales_Document__r.Id =:invoice.Id];
        vertoFunds = [SELECT Name, Amount__c, Sales_Document__c FROM Verto_Fund__c WHERE Sales_Document__r.Id =:invoice.Id];
        currentTransaction = [SELECT bt_paylink__PayLink__c, bt_stripe__Amount__c, bt_stripe__Due_Date__c, bt_stripe__Transaction_Status__c, bt_stripe__Sales_Document__c FROM bt_stripe__Transaction__c WHERE bt_stripe__Transaction_Status__c = 'Open' AND bt_stripe__Sales_Document__r.Id =:invoice.Id ORDER BY bt_stripe__Due_Date__c LIMIT 1];

        if (invoice.bt_stripe__Payment_Status__c == 'Paid' || invoice.bt_stripe__Payment_Status__c == 'Overpaid' || invoice.bt_stripe__Payment_Status__c == 'Refunded' || invoice.bt_stripe__Payment_Status__c == 'Partially Refunded') {
            showButton = false;
        } 
    }

    @AuraEnabled(cacheable=true)
    public static List<bt_stripe__Sales_Document__c> getInvoiceList() {
        return [SELECT bt_stripe__Name__c FROM bt_stripe__Sales_Document__c LIMIT 3];
    }


    /* public void fetchRecords() {
        invoiceList = [SELECT bt_stripe__Name__c, bt_stripe__Payment_Status__c, bt_stripe__Issue_Date__c, bt_stripe__Due_Date__c, Invoice_Type__c, bt_stripe__Balance_Paid_Amount__c, bt_stripe__Balance_Due_Amount__c, Net_Amount__c, bt_stripe__Subject__c
                     FROM bt_stripe__Sales_Document__c LIMIT 3];
    } */
        
    

    // Action method to go to PayLink
    public PageReference payInvoice() {
        PageReference ref = new PageReference(currentTransaction.bt_paylink__PayLink__c);
        return ref;
    }

    // Action method to "print" to PDF
    public PageReference print() {
        renderAs = 'pdf';
        return null;
    }
}
