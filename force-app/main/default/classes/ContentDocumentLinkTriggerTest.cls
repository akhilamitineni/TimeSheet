@Istest
public class ContentDocumentLinkTriggerTest {
    
    @Istest
    public static void testCustomNotification(){
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.PathOnClient = 'TestFile.pdf';
        cv.Title = 'Test File';
        cv.VersionData = EncodingUtil.base64Decode('This is a test attachment');
        insert cv;
        
        Id cdId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
        contentDocumentLink.ContentDocumentId = cdId;
        ContentWorkspace cws = [Select Id, Name from ContentWorkspace where Name = 'File Library'];
        contentDocumentLink.LinkedEntityId = cws.Id;
        insert contentDocumentLink;
        System.debug(Limits.getEmailInvocations());
        System.assertEquals(1, Limits.getEmailInvocations());
    }
}