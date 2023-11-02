@IsTest
public with sharing class TaskUtilsTest {
    private static final Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.FINAL_CONSUMER).getRecordTypeId();

    @IsTest
    static void shouldCreateTask(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910'
        );
        Database.insert(acc);

        TaskUtils.createTask(new List<Account>{acc});
        Assert.isNotNull([SELECT Id FROM Task LIMIT 1], 'Task was not created');
        Task createdTask = [SELECT WhatId FROM Task LIMIT 1];
        Assert.areEqual(acc.Id, createdTask.WhatId);
    }

    @IsTest
    static void shouldCreateTaskWithAccountList(){
        List<Account> accountsToCreate = new List<Account>();
        Set<Id> createAccountIds = new Set<Id>();

        for(Integer i = 0; i < 4; i++){
            accountsToCreate.add(new Account(
                Name = 'Test ' + i,
                Type = AccountTypes.CPF,
                AccountNumber = '1234567891' + i,
                RecordTypeId = consumerRecordTypeId
            ));
        }
        Database.insert(accountsToCreate);

        for(Account acc : accountsToCreate){
            createAccountIds.add(acc.Id);
        }

        TaskUtils.createTask(accountsToCreate);
        Assert.isFalse([SELECT Id FROM Task].isEmpty(), 'Task was not created');
        List<Task> createdTasks = [SELECT WhatId FROM Task];

        for(Task createdTask : createdTasks){
            Assert.isTrue(createAccountIds.contains(createdTask.WhatId));
        }
    }

    @IsTest
    static void shouldNotCreateTask(){
        try { 
            TaskUtils.createTask(null);
        } catch (Exception e) {
            Assert.areEqual('Fail to create tasks: Account list is null', e.getMessage());
        }
    }
}