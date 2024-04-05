({
    doInit : function(component, event, helper) {
        let action = component.get("c.getContacts");
        action.setCallback(this,function(response){
        let state = response.getState();
        if(state==="SUCCESS"){
            component.set("v.contacts",response.getReturnValue());
        }else{
            console.log("Failed with state :" + state);
        }
        });
    $A.enqueueAction(action);
    },
    
    clickSave: function(component, event, helper) {
        let validContact = component.find('contactform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validContact){
            // Create the new contact
            let newContact = component.get("v.newContact");
            helper.createContact(component, newContact);
            component.set("v.newContact",{'sobjectType':'Contact',
                                            'Name': '',
                                            'Title': '',
                                            'Phone':null,
                                            'Email':''});
        }
    }
})