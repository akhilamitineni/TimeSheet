trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    for(ContentDocumentLink documentLink : Trigger.New) {
        
        ContentDocument documentFile = [Select ParentId, Id, Title from ContentDocument where Id = : documentLink.ContentDocumentId];
        String libraryId = documentFile.ParentId;
        Set<String> recipientIds = new Set<String>();
        
        if (libraryId != null && libraryId != '') {
            ContentWorkspace cws = [Select Id, Name from ContentWorkspace where Name = 'File Library'];
            If (documentFile.ParentId == cws.Id) {
                
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setTitle('New Upgrade Notification');
                notification.setBody('A new upgrade has been rolled out to the Org');
                CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='File_Notification'];
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(documentLink.ContentDocumentId);
            
            	Group publicGroup = [Select Id from Group where Name ='DBT Group'];
            	List<GroupMember> groupMembers = [Select GroupId, UserOrGroupId from GroupMember where GroupId = : publicGroup.Id];
                
            	if (groupMembers != null && !groupMembers.isEmpty()) {
                	for (GroupMember member : groupMembers) {
                    	recipientIds.add(member.UserOrGroupId);
                	}
            	}
                notification.send(recipientIds);
                
            	list<Messaging.SingleEmailMessage> mailList =new List<Messaging.SingleEmailMessage>();
            	List<User> userList = [Select Id, Email from User where Id = : recipientIds];
            	String fileLink = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/ContentDocument/'+documentLink.ContentDocumentId+'/view';
            
            	for (User user : userList) {
                    Messaging.SingleEmailMessage userEmail = new Messaging.SingleEmailMessage();
                    List<String> sendToEmail = new List<String>();
                    sendToEmail.add(user.Email);
                    userEmail.setToAddresses(sendToEmail);
                    userEmail.setSenderDisplayName('System Administrator');
                    userEmail.setSubject('New Upgrade changes');
                    userEmail.setHtmlBody('Here is the link to the file that contains the latest upgrades rolled out to the Org.'+' '+'<a href="'+fileLink+'">Click Here for the File</a>');
                    mailList.add(userEmail);
            	}
            	Messaging.sendEmail(mailList);
        	}
        }        
	}
}