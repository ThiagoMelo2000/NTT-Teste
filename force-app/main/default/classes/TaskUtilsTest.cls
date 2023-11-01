@IsTest
public with sharing class TaskUtilsTest {
    
    @IsTest
    public static void shouldCreateTask(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.FINAL_CONSUMER
        );
        Database.insert(acc);

        TaskUtils.createTask(new List<Account>{acc});
        Assert.isNotNull([SELECT Id FROM Task LIMIT 1], 'Task was not created');
        Task createdTask = [SELECT WhatId FROM Task LIMIT 1];
        Assert.areEqual(acc.Id, createdTask.WhatId);
    }

    @IsTest
    public static void shouldNotCreateTask(){
        try { 
            TaskUtils.createTask(null);
        } catch (Exception e) {
            Assert.areEqual('Fail to create tasks: Account list is null', e.getMessage());
        }
    }
}