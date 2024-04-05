({
    createContact : function(component,contact) {
        let cont = component.get("v.newContact");
        var action = component.get("c.saveContact");
        action.setParams({"cont": contact});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state==="SUCCESS"){
                var contacts = component.get("v.contacts");
                contacts.push(cont);
                component.set("v.contacts",contacts);
            }
        });
        $A.enqueueAction(action);
    }
})