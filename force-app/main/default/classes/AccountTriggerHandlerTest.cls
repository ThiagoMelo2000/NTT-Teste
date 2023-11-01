@IsTest
public with sharing class AccountTriggerHandlerTest {
    
    @IsTest
    public static void shouldValidateCPFTrue(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910'
        );

        Database.SaveResult result = Database.insert(acc);
        Assert.isTrue(result.isSuccess(), 'Fail to create Account');
    }

    @IsTest
    public static void shouldValidateCPFFalse(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = 'dasda%%a4154'
        );

        Database.SaveResult result;
        try {
            result = Database.insert(acc);
        } catch (Exception e) {
            Assert.isTrue(e.getMessage().contains('Número do cliente é inválido'));
        }
    }

    @IsTest
    public static void shouldCreateOpportunity(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parceiro').getRecordTypeId()
        );

        Database.insert(acc);

        Assert.isNotNull([SELECT Id FROM Opportunity], 'Opportunity was not created');
    }

    @IsTest
    public static void shouldCreateTask(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumidor Final').getRecordTypeId()
        );

        Database.insert(acc);

        Assert.isNotNull([SELECT Id FROM Task], 'Task was not created');
    }
}