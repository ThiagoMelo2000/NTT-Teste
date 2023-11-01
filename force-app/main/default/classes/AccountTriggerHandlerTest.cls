@IsTest
public with sharing class AccountTriggerHandlerTest {
    
    @IsTest
    static void shouldValidateCPFTrue(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910'
        );

        Database.SaveResult result; 
        try {
            result = Database.insert(acc);
            Assert.isTrue(result.isSuccess(), 'Fail to create Account');
        } catch (Exception e) {
            Assert.fail('Fail to create Account');
        }
    }

    @IsTest
    static void shouldValidateCPFFalse(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = 'dasda%%a4154'
        );

        Database.SaveResult result;
        try {
            result = Database.insert(acc);
            Assert.fail('should fail account insert');
        } catch (Exception e) {
            Assert.isTrue(e.getMessage().contains('Número do cliente é inválido'));
        }
    }

    @IsTest
    static void shouldCreateOpportunity(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.PARTNER).getRecordTypeId()
        );

        Database.insert(acc);

        Assert.isNotNull([SELECT Id FROM Opportunity], 'Opportunity was not created');
    }

    @IsTest
    static void shouldCreateTask(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.FINAL_CONSUMER).getRecordTypeId()
        );

        Database.insert(acc);

        Assert.isNotNull([SELECT Id FROM Task], 'Task was not created');
    }
}