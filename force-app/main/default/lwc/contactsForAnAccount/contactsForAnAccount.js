import { LightningElement, track, api, wire } from 'lwc';
import getContact from '@salesforce/apex/contactClass.getContact'
const columns = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text' },
    { label: 'Last Name', fieldName: 'LastName', type: 'text' },
    {label:'Account Name', fieldName:'Account.Name'},
    { label: 'Email', fieldName: 'Email', type: 'email' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Mobile', fieldName: 'MobilePhone', type: 'phone' }
];
export default class ContactsForAnAccount extends LightningElement {
    @track hasData = false;
    @track accountId = '';
    @track listOfContact = [];
    @api recordId;

    columns = columns;

    handleAccountChange(event) {
        this.accountId = event.target.value;
    }

    handleSubmit() {
        getContact({ accId: this.accountId })
            .then(result => {
                this.listOfContact = result;
                this.hasData = true;
            })
            .catch(error => {
                this.listOfContact = [];
                this.hasData = false;
                console.error(error);
            });
    }
}