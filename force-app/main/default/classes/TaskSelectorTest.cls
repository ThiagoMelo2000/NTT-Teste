@IsTest
public with sharing class TaskSelectorTest {
    
    @TestSetup
    static void setup(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910'
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