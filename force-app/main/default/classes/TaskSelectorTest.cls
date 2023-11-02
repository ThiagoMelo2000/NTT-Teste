@IsTest
public with sharing class TaskSelectorTest {
    
    private static final Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.FINAL_CONSUMER).getRecordTypeId();
    
    @TestSetup
    static void setup(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910',
            RecordTypeId = consumerRecordTypeId
        );

        Database.insert(acc);
    }

    @IsTest
    static void shouldSelectOpenTask(){
        Account acc = [SELECT Id FROM Account];

        Task newTask = new Task(
            WhatId = acc.Id,
            Status = 'Not Started',
            Subject = 'Test'
        );

        Database.insert(newTask);

        List<Task> selectedTasks = TaskSelector.getInstance().selectOpensByAccountIds(new Set<Id>{acc.Id});
        Assert.isFalse(selectedTasks.isEmpty());
    }

    @IsTest
    static void shouldSelectOpenTaskWhithMultipleAccounts(){
        List<Account> accountsToCreate = new List<Account>();
        List<Task> tasksToCreate = new List<Task>();
        Set<Id> accountIds = new Set<Id>();

        for(Integer i = 0; i < 3; i++){
            accountsToCreate.add(new Account(
                Name = 'Test ' + i,
                Type = AccountTypes.CPF,
                AccountNumber = '1234567891' + i,
                RecordTypeId = consumerRecordTypeId
            ));
        }
        Database.insert(accountsToCreate);

        List<Account> accounts = [SELECT Id, Name FROM Account];

        for(Account acc : accounts){
            accountIds.add(acc.Id);
        }

        List<Task> selectedTasks = TaskSelector.getInstance().selectOpensByAccountIds(accountIds);
        Assert.isFalse(selectedTasks.isEmpty());
        Assert.areEqual(accounts.size(), selectedTasks.size());
    }

    @IsTest
    static void shouldSelectClosedTask(){
        Account acc = [SELECT Id FROM Account];

        Task newTask = [SELECT Id, Status FROM Task WHERE WhatId = :acc.Id];
        newTask.Status = 'Completed';
        Database.update(newTask);

        TaskSelector.tasksToReturn = new List<Task>{newTask};

        List<Task> selectedTasks = TaskSelector.getInstance().selectClosedsByAccountIds(new Set<Id>{acc.Id});
        Assert.isFalse(selectedTasks.isEmpty());
    }

    @IsTest
    static void shouldSelectClosedTaskWithMultipleAccounts(){
        List<Account> accountsToCreate = new List<Account>();
        List<Task> tasksToClose = new List<Task>();
        Set<Id> accountIds = new Set<Id>();

        for(Integer i = 0; i < 3; i++){
            accountsToCreate.add(new Account(
                Name = 'Test ' + i,
                Type = AccountTypes.CPF,
                AccountNumber = '1234567891' + i,
                RecordTypeId = consumerRecordTypeId
            ));
        }
        Database.insert(accountsToCreate);

        List<Account> accounts = [SELECT Id FROM Account];

        for(Account acc : accounts){
            accountIds.add(acc.Id);
        }

        List<Task> openTasks = [SELECT Id, Status FROM Task WHERE WhatId in :accountIds];

        for(Task openTask : openTasks){
            openTask.Status = 'Completed';
            tasksToClose.add(openTask);
        }
        
        Database.update(tasksToClose);
        TaskSelector.tasksToReturn = tasksToClose;

        List<Task> selectedTasks = TaskSelector.getInstance().selectClosedsByAccountIds(accountIds);
        Assert.isFalse(selectedTasks.isEmpty());
        Assert.areEqual(openTasks.size(), selectedTasks.size());
    }
    
    @IsTest
    static void shouldNotSelectClosedTask(){
        Account acc = [SELECT Id FROM Account];

        Task newTask = new Task(
            WhatId = acc.Id,
            Status = 'Completed',
            Subject = 'Test'
        );

        Database.insert(newTask);

        List<Task> selectedTasks = TaskSelector.getInstance().selectClosedsByAccountIds(new Set<Id>{acc.Id});
        Assert.isTrue(selectedTasks.isEmpty());
    }
}