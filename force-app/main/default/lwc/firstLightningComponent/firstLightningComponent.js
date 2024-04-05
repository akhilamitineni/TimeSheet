import { LightningElement, wire, track } from 'lwc';
import fetchOpp from '@salesforce/apex/OppController.fetchOpp';

export default class FirstLightningComponent extends LightningElement {

    @track columns = [{
        label : 'Opportunity Name',
        fieldName : 'Name',
        type : 'text',
        
    },
    {
        label :'Stage',
        fieldName :'StageName',
        type : 'text',
        
    },
    {
        label : 'Amount',
        fieldName : 'Amount',
        type : 'currency',
        
    },
    {
        label : 'Close Date',
        fieldName : 'CloseDate',
        type : 'date',
        
    }
];
    @track error;
    @track oppList;
    @wire(fetchOpp) wiredOpportunities({error, data})
    {
        if (data){
            this.oppList = data;
        }else if (error){
            this.error = error;
        }

    }
}