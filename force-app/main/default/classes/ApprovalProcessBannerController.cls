public class ApprovalProcessBannerController{
    @AuraEnabled
    public static String getOpportunity(String recordId){
        List<ProcessInstanceWorkitem> piwiList = [Select Id, ProcessInstanceId from ProcessInstanceWorkitem where Id = :recordId];
        String processName = '';
        if(piwiList != null && !piwiList.isEmpty()) {
            ProcessInstanceNode pin = [Select Id, ProcessNodeName from ProcessInstanceNode where 
                                       ProcessInstanceId = :piwiList.get(0).ProcessInstanceId and 
                                       NodeStatus = 'Pending'];
            processName = pin.ProcessNodeName;
            if(pin.ProcessNodeName.contains('Proposal Approval')){
                processName = 'PROPOSAL APPROVAL';
            }
            else{
                processName = 'BID ASSESSMENT';
            }
       	 }
        return processName; 
    }
}