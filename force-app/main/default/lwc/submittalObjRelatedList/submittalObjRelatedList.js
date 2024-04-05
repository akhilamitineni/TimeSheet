import { LightningElement, api, wire, track } from 'lwc';
import fetchResources from '@salesforce/apex/SubmittalResourceController.fetchResources';
const columns = [
    { label: 'Submittal Name', fieldName: 'submittalURL', type: 'url',typeAttributes: { label: { fieldName: 'submittalName' }, target: '_blank' } },
    { label: 'Resource Name', fieldName: 'resourceURL', type: 'url',typeAttributes: { label: { fieldName: 'resourceName' }, target: '_blank' } },
    { label: 'Primary Email', fieldName: 'email', type:'email' },
    { label: 'Phone', fieldName: 'phoneNumber', type:'phone' },
    { label: 'Stage', fieldName: 'stageName'},
    { label: 'Status', fieldName: 'status'},
    {label: 'Source', fieldName: 'source'}
];
export default class SubmittalObjRelatedList extends LightningElement {
    @api recordId;
    @track submittalData;
    error;
    @track submittalDataWithUrl;
    columns=columns;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';

    @wire(fetchResources, { jobId: '$recordId' })
    submittalRecords({error,data }) {
        //alert('data : '+ data);
        //alert('record Id : '+ this.recordId);
        if(data) {
            this.submittalData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.submittalData = undefined;
        }
    }
}