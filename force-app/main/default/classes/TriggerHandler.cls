public virtual class TriggerHandler {

    public TriggerHandler() {
        this.setTriggerContext();
    }

    @TestVisible
    private Boolean isTriggerExecuting;

    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {
        if(!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        } else {
            this.isTriggerExecuting = true;
        }
        
        if((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||(ctx != null && ctx == 'before insert')) {
            this.context = TriggerContext.BEFORE_INSERT;
        } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||(ctx != null && ctx == 'before update')){
            this.context = TriggerContext.BEFORE_UPDATE;
        } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||(ctx != null && ctx == 'after insert')) {
            this.context = TriggerContext.AFTER_INSERT;
        }
    }
   
    @TestVisible
    protected virtual void beforeInsert(){}
    @TestVisible
    protected virtual void beforeUpdate(){}
    @TestVisible
    protected virtual void afterInsert(){}

    @TestVisible
    private TriggerContext context;

    @TestVisible
    protected List<sObject> newRecords = new List<sObject>();
    protected List<sObject> oldRecords = new List<sObject>();

    public void run() {
        try{
            if(this.context == TriggerContext.BEFORE_INSERT) {
                this.beforeInsert();
            } else if(this.context == TriggerContext.BEFORE_UPDATE) {
                this.beforeUpdate();
            } else if(this.context == TriggerContext.AFTER_INSERT) {
                this.afterInsert();
            }
        }catch(Exception e){
            throw e;
        }
    }

    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT, 
        BEFORE_UPDATE,
        AFTER_INSERT
    }
}