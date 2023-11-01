@IsTest
public with sharing class AccountCleaningSchedulableTest {

    @TestSetup
    static void setup(){
        Account acc = new Account(
            Name = 'Test'
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
    public static void shouldExecuteSchedule(){
        String cronExp = '0 0 1,7,13,19 ? * MON-FRI';

        Test.startTest();
        String jobId = AccountCleaningSchedulable.schedule();
        Assert.isNotNull(jobId);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Assert.areEqual(cronExp, ct.CronExpression);
        Test.stopTest();
    }
}