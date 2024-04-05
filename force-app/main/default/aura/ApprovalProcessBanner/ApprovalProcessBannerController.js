({
	doInit : function(component, event, helper) {
		var action = component.get("c.getOpportunity");
     	action.setParams({
            "recordId": component.get("v.recordId")
     	});
     
     	action.setCallback( this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.stageName", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}
})