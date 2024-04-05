trigger AutoNumberTrigger on Opportunity (after insert) {
        
    for(Opportunity opp:trigger.new){
        String[] strArray = opp.Record_Sequence_Number__c.split('\\-');
        String str = strArray[1];
        Integer num = Integer.valueOf(str);
        Id oppRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        Opportunity opty = new Opportunity(Name='TestName',StageName ='Qualification',CloseDate = System.today(), Quantity__c=200, RecordTypeId=oppRecordType);
        if(math.mod(num+1,10)==0){
            Opportunity opp1 = opty.clone(false,true,true,false);
            opp1.Id = null;
            insert opp1;
            delete opp1;
        }
    }
}