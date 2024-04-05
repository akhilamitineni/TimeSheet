({
    doInit : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf(".com")+4);
        component.set("v.cbaseURL", baseURL);
        var action = component.get("c.retrieveOpportunities");
        action.setParams({"recordId": component.get("v.recordId")});
        action.setCallback( this, function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
               component.set("v.CompetitorAccountOpportunities", response.getReturnValue());
               console.log(response.getReturnValue());
           }
       });
       $A.enqueueAction(action);
    }
})