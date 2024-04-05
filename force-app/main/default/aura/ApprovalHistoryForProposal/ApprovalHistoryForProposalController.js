({
    doInIt: function (component, event, helper) {
        console.log('Entered doinit function');
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
        console.log('Entered the handle save');
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
        console.log('The draft values are '+ drafts);
        var action = component.get("c.updateApproverComments");
        action.setParams({"approverCommentList" : drafts});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
            	toastEvent.fire();
            	//component.set('v.lastSavedData', component.get('v.data')); 
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": component.get("v.recordId")
                  //"slideDevName": "related"
                });
                navEvt.fire();
                //$A.get('e.force:refreshView').fire();  
            }
        });
        $A.enqueueAction(action);
    },
    doRefresh: function(component, event, helper) {
    	helper.fetchDataWithoutRefresh(component, event, helper);
    },      
 	handleCellChange: function(component, event, helper) {
    	console.log('handleCellChange invoked.');
        let updatedDraftValues = helper.updateDraftValues(component, event.getParam('draftValues')[0]);
        component.set('v.draftValues', updatedDraftValues);
	},
    
    handleItemRegister: function(event) {
        /*
        event.stopPropagation();
        const item = event.detail;
        if (!this.privateChildren.hasOwnProperty(item.name))
            this.privateChildren[item.name] = {};
        this.privateChildren[item.name][item.guid] = item;        
        alert('aaaaa');
        */
    },
    
    handleCancel: function(component, event) {
        event.preventDefault();
        var navEvt = $A.get("e.force:navigateToSObject");
        //navEvt.setParams({
            //"recordId": component.get("v.recordId")
            //"slideDevName": "related"
        //});
        //navEvt.fire();
        $A.get('e.force:refreshView').fire();        
/*
        //alert('handleCancel called');
        //this.records = JSON.parse(JSON.stringify(this.lastSavedData));
        //this.handleWindowOnclick('reset');
        component.set('v.draftValues', []);
        component.set('v.data', component.get('v.lastSavedData'));
    
        let elementMarkup = document.getElementsByClassName('picklistBlock');
        alert(elementMarkup.constructor);
        if (elementMarkup) {
            alert('inside if: ' + elementMarkup.length);
            for(let element in elementMarkup) {
                alert('hi1:' + element);
                //element.reset();
            }
            Object.values(elementMarkup).forEach((element) => {
                alert('hi');
                element.callbacks.reset('reset');
            });
        }
*/  
    },
            
    handleValueChange: function(component, event, helper) {
    	console.log('handleCellChange invoked.');
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