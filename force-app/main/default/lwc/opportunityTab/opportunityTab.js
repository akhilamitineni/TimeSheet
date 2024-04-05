import { LightningElement,api } from 'lwc';

import Additional_Revenue_Proposed from '@salesforce/schema/Opportunity.Additional_Revenue_Proposed__c';

import Estimated_Revenue_Proposed from '@salesforce/schema/Opportunity.Estimated_Revenue_Proposed__c';

import Recurring_Non_Recurring_Proposed from '@salesforce/schema/Opportunity.Recurring_Non_Recurring_Proposed__c';

import Total_Revenue_Proposed from '@salesforce/schema/Opportunity.Total_Revenue_Proposed__c';

import Additional_Revenue_Awarded from '@salesforce/schema/Opportunity.Additional_Revenue_Awarded__c';

import Estimated_Revenue_Awarded from '@salesforce/schema/Opportunity.Estimated_Revenue_Awarded__c';

import Recurring_Non_Recurring_Awarded from '@salesforce/schema/Opportunity.Recurring_Non_Recurring_Awarded__c';

import Total_Revenue_Awarded from '@salesforce/schema/Opportunity.Total_Revenue_Awarded__c';

export default class OpportunityTab extends LightningElement {

    @api recordId;

    fields = [Additional_Revenue_Proposed, Estimated_Revenue_Proposed, Recurring_Non_Recurring_Proposed, Total_Revenue_Proposed, Additional_Revenue_Awarded, 
        Estimated_Revenue_Awarded, Recurring_Non_Recurring_Awarded, Total_Revenue_Awarded]
}