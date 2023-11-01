public with sharing class TaskSelector {
    private static TaskSelector INSTANCE = new TaskSelector();

    public static TaskSelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new TaskSelector();
        }
        return INSTANCE;
    }

    @TestVisible
    private static List<Task> tasksToReturn;

    public List<Task> selectOpensByAccountIds(Set<Id> accountIds){
        return [SELECT Subject, Status, Priority, CreatedDate, WhatId FROM Task WHERE WhatId in :accountIds AND IsClosed = false ORDER BY CreatedDate DESC];
    }

    public List<Task> selectClosedsByAccountIds(Set<Id> accountIds){
        if (tasksToReturn != null) {
            return tasksToReturn;
        } else {
            return [SELECT Subject, Status, Priority, CreatedDate, WhatId FROM Task WHERE WhatId != null AND WhatId not in :accountIds AND IsClosed = true AND LastModifiedDate >= LAST_N_DAYS: 90 ORDER BY CreatedDate DESC];
        }
    }
}