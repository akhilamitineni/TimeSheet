public class ATSWrapper {
    
	private String resourceName;
    private String email;
    private String phoneNumber;
    private List<String> skillList;
    private Id resourceId; 
    private String stageName;
    private String source;
    private String status;
    private String resourceURL;
    private String submittalURL;
    private String submittalName;
    
    @AuraEnabled(cacheable=true)
    public String getResourceName(){
        return resourceName;
    }
    public void setResourceName(String newResourceName){
        this.resourceName = newResourceName;
    }

    @AuraEnabled(cacheable=true)
    public String getSubmittalName(){
        return submittalName;
    }
    public void setSubmittalName(String newSubmittalName){
        this.submittalName = newSubmittalName;
    }
    
    @AuraEnabled(cacheable=true)
    public String getEmail(){
        return email;
    }
    public void setEmail(String newEmail){
        this.email = newEmail;
    }
    
    @AuraEnabled(cacheable=true)
    public String getPhoneNumber(){
        return phoneNumber;
    }
    public void setPhoneNumber(String newPhoneNum){
        this.phoneNumber = newPhoneNum;
    }
    
    @AuraEnabled(cacheable=true)
    public List<String> getSkillList(){
        return skillList;
    }
    public void setSkillList(List<String> newSkillList){
        this.skillList = newSkillList;
    }
    
    @AuraEnabled(cacheable=true)
    public String getResourceId(){
        return resourceId;
    }
    public void setResourceId(Id newResourceId){
        this.resourceId = newResourceId;
    }

    @AuraEnabled(cacheable=true)
    public String getStageName(){
        return stageName;
    }
    public void setStageName(String newStageName){
        this.stageName = newStageName;
    }

    @AuraEnabled(cacheable=true)
    public String getSource(){
        return source;
    }
    public void setSource(String newSource){
        this.source = newSource;
    }
    
    @AuraEnabled(cacheable=true)
    public String getStatus(){
        return status;
    }
    public void setStatus(String newStatus){
        this.status = newStatus;
    }

    @AuraEnabled(cacheable=true)
    public String getResourceURL(){
        return resourceURL;
    }
    public void setResourceURL(String newResourceURL){
        this.resourceURL = newResourceURL;
    }

    @AuraEnabled(cacheable=true)
    public String getSubmittalURL(){
        return submittalURL;
    }
    public void setSubmittalURL(String newSubmittalURL){
        this.submittalURL = newSubmittalURL;
    }
}