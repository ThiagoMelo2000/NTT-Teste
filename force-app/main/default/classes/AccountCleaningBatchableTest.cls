@IsTest
public with sharing class AccountCleaningBatchableTest {

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
    public static void shouldUpdateAccountToInactiveWithCloseOpp(){
        Account acc = [SELECT Id, Name, Inativa__c FROM Account];

        Opportunity opp = new Opportunity(
            AccountId = acc.Id,
            CloseDate = Date.today().addDays(-125),
            Name = acc.Name + ' - opp Parceiro',
            StageName = 'Closed Won'
        );

        Database.insert(opp);
        AccountCleaningBatchable job = new AccountCleaningBatchable();

        Test.startTest();
        Database.executeBatch(job);
        Test.stopTest();

        Account updatedAccount = [SELECT Inativa__c FROM Account WHERE Id = :acc.Id];
        Assert.isTrue(updatedAccount.Inativa__c);
    }

    @IsTest
    public static void shouldUpdateAccountToInactiveWithOpenOpp(){
        Account acc = [SELECT Id, Name, Inativa__c FROM Account];

        Account accWithOpenOpp = new Account(
            Name = 'Test2'
        );
        Database.insert(accWithOpenOpp);

        Opportunity openOpp = new Opportunity(
            AccountId = accWithOpenOpp.Id,
            Name = accWithOpenOpp.Name + ' - opp Parceiro',
            StageName = 'Negotiation/Review',
            CloseDate = Date.today().addDays(30)
        );
        Database.insert(openOpp);

        Opportunity closeOpp = new Opportunity(
            AccountId = acc.Id,
            CloseDate = Date.today().addDays(-125),
            Name = acc.Name + ' - opp Parceiro',
            StageName = 'Closed Won'
        );

        Database.insert(closeOpp);
        AccountCleaningBatchable job = new AccountCleaningBatchable();

        Test.startTest();
        Database.executeBatch(job);
        Test.stopTest();

        Account updatedAccount = [SELECT Inativa__c FROM Account WHERE Id = :acc.Id];
        Assert.isTrue(updatedAccount.Inativa__c);
        Account notUpdatedAccount = [SELECT Inativa__c FROM Account WHERE Id = :accWithOpenOpp.Id];
        Assert.isFalse(notUpdatedAccount.Inativa__c);
    }

    @IsTest
    public static void shouldUpdateAccountToInactiveWithClosedTask(){

        Account acc = [SELECT Id, Name, Inativa__c FROM Account];

        Task newTask = new Task(
            Subject = 'Consumidor Final',
            WhatId = acc.Id,
            Status = 'Completed'
        );

        Database.insert(newTask);
        TaskSelector.tasksToReturn = new List<Task>{newTask};
        AccountCleaningBatchable job = new AccountCleaningBatchable();

        Test.startTest();
        Database.executeBatch(job);
        Test.stopTest();

        Account updatedAccount = [SELECT Inativa__c FROM Account WHERE Id = :acc.Id];
        Assert.isTrue(updatedAccount.Inativa__c);
    }

    @IsTest
    public static void shouldUpdateAccountToInactiveWithOpenTask(){

        Account acc = [SELECT Id, Name, Inativa__c FROM Account];

        Account accWithOpenTask = new Account(
            Name = 'Test2'
        );
        Database.insert(accWithOpenTask);

        Task openTask = new Task(
            Subject = 'Consumidor Final',
            WhatId = accWithOpenTask.Id,
            Status = 'Not Started'
        );
        Database.insert(openTask);

        Task closedTask = new Task(
            Subject = 'Consumidor Final',
            WhatId = acc.Id,
            Status = 'Completed'
        );

        Database.insert(closedTask);
        TaskSelector.tasksToReturn = new List<Task>{closedTask};

        AccountCleaningBatchable job = new AccountCleaningBatchable();
        Test.startTest();
        Database.executeBatch(job);
        Test.stopTest();

        Account updatedAccount = [SELECT Inativa__c FROM Account WHERE Id = :acc.Id];
        Assert.isTrue(updatedAccount.Inativa__c);
        Account notUpdatedAccount = [SELECT Inativa__c FROM Account WHERE Id = :accWithOpenTask.Id];
        Assert.isFalse(notUpdatedAccount.Inativa__c);
    }
}