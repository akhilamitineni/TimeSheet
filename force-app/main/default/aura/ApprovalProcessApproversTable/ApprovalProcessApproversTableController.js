({
	doInit : function(component, event, helper) {
		var action = component.get("c.getOpportunityApprovers");
     	action.setParams({
            "recordId": component.get("v.recordId")
     	});
     	action.setCallback( this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.opportunityApproversHistory", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}
})