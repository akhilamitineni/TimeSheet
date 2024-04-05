({
    fetchData: function (component, event, helper) {
        console.log('Entered fetch data');
        var action = component.get("c.pullApproverCommentsForProposal");
        //action.setStorable(true);
        action.setParams({"opportunityId" : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var status = response.getState();
            if (status === "SUCCESS") {
                //alert('success1');
                var data = response.getReturnValue();
                console.log('The data is: ' + JSON.stringify(data));
                component.set('v.data', data);
				//component.set('v.lastSavedData', data); 
				$A.get('e.force:refreshView').fire();               
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    },
    fetchDataWithoutRefresh: function (component, event, helper) {
        console.log('Entered fetch data');
        var action = component.get("c.pullApproverComments");
        action.setParams({"opportunityId" : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var status = response.getState();
            if (status === "SUCCESS") {
                //alert('success22');
                var data = response.getReturnValue();
                console.log('The data is: ' + JSON.stringify(data));
                component.set('v.data', data);             
            }
        });
        $A.enqueueAction(action);
    },
    
    updateDraftValues: function(component, updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = JSON.parse(JSON.stringify(component.get('v.draftValues')));

        copyDraftValues.forEach((item) => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
        let updatedDraftValues;
        if (draftValueChanged) {
            updatedDraftValues = [...copyDraftValues];
        } else {
            updatedDraftValues = [...copyDraftValues, updateItem];
        }
        return updatedDraftValues;
    }  

})