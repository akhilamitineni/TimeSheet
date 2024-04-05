public class ProcessInstanceItems {

    private String approverName;

    @AuraEnabled
    public String getApproverName(){
        return approverName;
    }
    public void setApproverName(String newApproverName){
        this.approverName = newApproverName;
    }

    private String approvalProcessName;

    @AuraEnabled
    public String getApprovalProcessName(){
        return approvalProcessName;
    }
    public void setApprovalProcessName(String newApprovalProcessName){
        this.approvalProcessName = newApprovalProcessName;
    }
 
    private String stepName;

    @AuraEnabled
    public String getStepName(){
        return stepName;
    }
    public void setStepName(String newStepName){
        this.stepName = newStepName;
    }
 
    private String opportunityName;

    @AuraEnabled
    public String getOpportunityName(){
        return opportunityName;
    }
    public void setOpportunityName(String newOpportunityName){
        this.opportunityName = newOpportunityName;
    }
 
    private String opportunityStage;

    @AuraEnabled
    public String getOpportunityStage(){
        return opportunityStage;
    }
    public void setOpportunityStage(String newOpportunityStage){
        this.opportunityStage = newOpportunityStage;
    }
 
    private String opportunityId;

    @AuraEnabled
    public String getOpportunityId(){
        return opportunityId;
    }
    public void setOpportunityId(String newOpportunityId){
        this.opportunityId = newOpportunityId;
    }



    


   



}