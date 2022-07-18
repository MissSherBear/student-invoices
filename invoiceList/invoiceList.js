import { LightningElement, wire, track } from 'lwc';
import NAME_FIELD from '@salesforce/schema/bt_stripe__Sales_Document__c.bt_stripe__Name__c';
import SUBJECT_FIELD from '@salesforce/schema/bt_stripe__Sales_Document__c.bt_stripe__Subject__c';
import BALANCE_DUE_FIELD from '@salesforce/schema/bt_stripe__Sales_Document__c.bt_stripe__Balance_Due_Amount__c';
import STATUS_FIELD from '@salesforce/schema/bt_stripe__Sales_Document__c.bt_stripe__Payment_Status__c';
import getInvoiceList from '@salesforce/apex/InvoicePdfController.getInvoiceList';
const COLUMNS = [
    { label: 'Invoice Name', fieldName: SUBJECT_FIELD.fieldApiName, type: 'text' },
    { label: 'Amount Due', fieldName: BALANCE_DUE_FIELD.fieldApiName, type: 'currency' },
    { label: 'Status', fieldName: STATUS_FIELD.fieldApiName, type: 'text' }
];

export default class InvoiceList extends LightningElement {
    columns = COLUMNS;
    @wire(getInvoiceList)
    invoices;
}