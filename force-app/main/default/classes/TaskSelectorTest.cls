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

        for(Integer i; i < 3; i++){
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
            
            tasksToCreate.add(new Task(
                WhatId = acc.Id,
                Status = 'Not Started',
                Subject = 'Test'
            ));
        }
        
        Database.insert(tasksToCreate);

        List<Task> selectedTasks = TaskSelector.getInstance().selectOpensByAccountIds(accountIds);
        Assert.isFalse(selectedTasks.isEmpty());
    }

    @IsTest
    static void shouldSelectClosedTask(){
        Account acc = [SELECT Id FROM Account];

        Task newTask = new Task(
            WhatId = acc.Id,
            Status = 'Completed',
            Subject = 'Test'
        );

        Database.insert(newTask);
        TaskSelector.tasksToReturn = new List<Task>{newTask};

        List<Task> selectedTasks = TaskSelector.getInstance().selectClosedsByAccountIds(new Set<Id>{acc.Id});
        Assert.isFalse(selectedTasks.isEmpty());
    }

    @IsTest
    static void shouldSelectClosedTaskWithMultipleAccounts(){
        List<Account> accountsToCreate = new List<Account>();
        List<Task> tasksToCreate = new List<Task>();
        Set<Id> accountIds = new Set<Id>();

        for(Integer i; i < 3; i++){
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
            
            tasksToCreate.add(new Task(
                WhatId = acc.Id,
                Status = 'Completed',
                Subject = 'Test'
            ));
        }
        
        Database.insert(tasksToCreate);
        TaskSelector.tasksToReturn = tasksToCreate;

        List<Task> selectedTasks = TaskSelector.getInstance().selectClosedsByAccountIds(accountIds);
        Assert.isFalse(selectedTasks.isEmpty());
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