import { LightningElement, api, wire, track } from 'lwc';
import fetchResources from '@salesforce/apex/GetResourceSkillController.fetchResources';
const columns = [
    { label: 'Resource Name', fieldName: 'resourceURL', type: 'url', typeAttributes: { label: { fieldName: 'resourceName' }, target: '_blank' } },
    { label: 'Phone Number', fieldName: 'phoneNumber', type: 'phone' },
    { label: 'Email', fieldName: 'email', type: 'email' },
    { label: 'Skills', fieldName: 'skills', type: 'text' }
];
export default class DataTable extends LightningElement {
    @api recordId;
    resourceList;
    error;
    columns = columns;
    @wire(fetchResources, { jobId: '$recordId' })
    WireResourceRecord({ error, data }) {
        if (data != null) {
            let resourceUrl;
            let skills;
            this.resourceList = data.map(row => {
                resourceUrl = `/${row.resourceId}`;
                skills = row.skillList.toString();
                return { ...row, resourceUrl, skills }
            })
            this.error = null;
        } else {
            this.resourceList = null;
            this.error = error;
        }
    }
}