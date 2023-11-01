@IsTest
public with sharing class AccountCleaningSchedulableTest {

    @TestSetup
    static void setup(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910'
        );
        Database.insert(acc);

        Opportunity opp = new Opportunity(
            AccountId = acc.Id,
            CloseDate = Date.today().addDays(-125),
            Name = acc.Name + ' - opp Parceiro',
            StageName = 'Closed Won'
        );
        Database.insert(opp);

        Task newTask = new Task(
            Subject = 'Consumidor Final',
            WhatId = acc.Id,
            Status = 'Completed'
        );
        Database.insert(newTask);
    }

    @IsTest
    static void shouldExecuteSchedule(){
        String cronExp = '0 0 1,7,13,19 ? * MON-FRI';

        Test.startTest();
        String jobId = AccountCleaningSchedulable.schedule();
        Assert.isNotNull(jobId);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Assert.areEqual(cronExp, ct.CronExpression);
        Test.stopTest();
    }

    @IsTest
    static void shouldInactivateAccount(){
        AccountCleaningBatchable batch = new AccountCleaningBatchable();

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        Account updatedAccount = [SELECT Inativa__c FROM Account];
        Assert.isTrue(updatedAccount.Inativa__c);
    }
}