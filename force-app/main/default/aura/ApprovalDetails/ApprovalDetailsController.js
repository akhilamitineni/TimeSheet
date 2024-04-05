({
    doInIt: function (component, event, helper) {
        component.set('v.myColumns', [
            {label: 'Approval Process Step', fieldName: 'Name', type: 'text', editable: false},
            {label: 'Date', fieldName: 'LastModifiedDate', type: 'date', editable: false, typeAttributes: {  
                day: 'numeric',  
                month: 'numeric',  
                year: 'numeric',  
                hour: '2-digit',  
                minute: '2-digit',
                hour12: false}},    
            {label: 'Approver Name', fieldName: 'Approver_Name__c', type: 'text', editable: false},
            {
                label: 'Approval Status',
                fieldName: 'Approval_Status__c',
                type: 'picklist',
                editable: false,
                typeAttributes: {
                    placeholder: 'Choose Approval Status',
                    options: [
                        { label: 'Approved', value: 'Approved' },
                        { label: 'Rejected', value: 'Rejected' },
                        { label: 'Pending', value: 'Pending' }
                    ],
                    value: { fieldName: 'Approval_Status__c' },
                    context: { fieldName: 'Id' },
                    variant: 'label-hidden',
                    name: 'Approval Status',
                    label: 'Approval Status'
            	}
            },
            {label: 'Comments', fieldName: 'Comments__c', type: 'text', editable: true},
        ]);
        helper.fetchData(component, event, helper);
    },

    handleSave: function (component, event, helper) {
        var drafts = event.getParam('draftValues');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Updated',
            message: 'Saved Successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        var action = component.get("c.updateApprovalDetails");
        action.setParams({"approverCommentList" : drafts});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
            	toastEvent.fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": component.get("v.recordId")
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
    },
    doRefresh: function(component, event, helper) {
    	helper.fetchDataWithoutRefresh(component, event, helper);
    },      
 	handleCellChange: function(component, event, helper) {
        let updatedDraftValues = helper.updateDraftValues(component, event.getParam('draftValues')[0]);
        component.set('v.draftValues', updatedDraftValues);
	},
    
    handleCancel: function(component, event) {
        event.preventDefault();
        var navEvt = $A.get("e.force:navigateToSObject");
        $A.get('e.force:refreshView').fire();  
    },
            
    handleValueChange: function(component, event, helper) {
        event.stopPropagation();
        let dataRecieved = event.getParam('data');
        let updatedItem;
        switch (dataRecieved.label) {
            case 'Approval Status':
                updatedItem = {
                    Id: dataRecieved.context,
                    Approval_Status__c: dataRecieved.value
                };
                break;
            default:
                this.setClassesOnData(dataRecieved.context, '', '');
                break;
        }
        let updatedDraftValues = helper.updateDraftValues(component, updatedItem);
        component.set('v.draftValues', updatedDraftValues);        
	}
})