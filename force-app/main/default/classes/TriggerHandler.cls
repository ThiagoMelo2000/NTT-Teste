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
        } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) || (ctx != null && ctx == 'before delete')) {
            this.context = TriggerContext.BEFORE_DELETE;
        } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||(ctx != null && ctx == 'after insert')) {
            this.context = TriggerContext.AFTER_INSERT;
        } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) || (ctx != null && ctx == 'after update')) {
            this.context = TriggerContext.AFTER_UPDATE;
        } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) || (ctx != null && ctx == 'after delete')) {
            this.context = TriggerContext.AFTER_DELETE;
        } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) || (ctx != null && ctx == 'after undelete')) {
            this.context = TriggerContext.AFTER_UNDELETE;
        }
    }
   
    @TestVisible
    protected virtual void beforeInsert(){}
    @TestVisible
    protected virtual void beforeUpdate(){}
    @TestVisible
    protected virtual void beforeDelete(){}
    @TestVisible
    protected virtual void afterInsert(){}
    @TestVisible
    protected virtual void afterUpdate(){}
    @TestVisible
    protected virtual void afterDelete(){}
    @TestVisible
    protected virtual void afterUndelete(){}

    @TestVisible
    private TriggerContext context;

    // the current sobject type records filtered by record type (or not)
    @TestVisible
    protected List<sObject> newRecords = new List<sObject>();
    protected List<sObject> oldRecords = new List<sObject>();

    public void run() {
        try{
            if(this.context == TriggerContext.BEFORE_INSERT) {
                this.beforeInsert();
            } else if(this.context == TriggerContext.BEFORE_UPDATE) {
                this.beforeUpdate();
            } else if(this.context == TriggerContext.BEFORE_DELETE) {
                this.beforeDelete();
            } else if(this.context == TriggerContext.AFTER_INSERT) {
                this.afterInsert();
            } else if(this.context == TriggerContext.AFTER_UPDATE) {
                this.afterUpdate();
            } else if(this.context == TriggerContext.AFTER_DELETE) {
                this.afterDelete();
            } else if(this.context == TriggerContext.AFTER_UNDELETE) {
                this.afterUndelete();
            }
        }catch(Exception e){
            throw e;
        }
    }

    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT, 
        BEFORE_UPDATE, 
        BEFORE_DELETE,
        AFTER_INSERT, 
        AFTER_UPDATE, 
        AFTER_DELETE,
        AFTER_UNDELETE
    }
}