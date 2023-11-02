@IsTest
public with sharing class AccountTriggerHandlerTest {

    public static Account createAccountDraw(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910'
        );
        return acc;
    }
    
    @IsTest
    static void shouldValidateCPFTrue(){
        Account acc = createAccountDraw();

        Database.SaveResult result; 
        try {
            result = Database.insert(acc);
            Assert.isTrue(result.isSuccess(), 'Error to create Account');
        } catch (Exception e) {
            Assert.fail('Should create account');
        }
    }

    @IsTest
    static void shouldValidateCPFTrueWithMultipleAccounts(){
        List<Account> accountsToCreate = new List<Account>();
        for(Integer i = 0; i < 4; i++){
            accountsToCreate.add(createAccountDraw());
        }

        List<Database.SaveResult> results; 
        try {
            results = Database.insert(accountsToCreate);
            for(Database.SaveResult result : results){
                Assert.isTrue(result.isSuccess());
            }
        } catch (Exception e) {
            Assert.fail('Should create account');
        }
    }

    @IsTest
    static void shouldValidateCPFFalse(){
        Account acc = createAccountDraw();
        acc.AccountNumber = 'dasda%%a4154';

        Database.SaveResult result;
        try {
            result = Database.insert(acc);
            Assert.fail('Should not create account');
        } catch (Exception e) {
            Assert.isTrue(e.getMessage().contains('Número do cliente é inválido'));
        }
    }

    @IsTest
    static void shouldValidateCNPJTrue(){
        Account acc = createAccountDraw();
        acc.Type = AccountTypes.CNPJ;
        acc.AccountNumber = '79452433000138';

        Database.SaveResult result; 
        try {
            result = Database.insert(acc);
            Assert.isTrue(result.isSuccess(), 'Error to create Account');
        } catch (Exception e) {
            Assert.fail('Should create account');
        }
    }

    @IsTest
    static void shouldValidateCNPJFalse(){
        Account acc = createAccountDraw();
        acc.Type = AccountTypes.CNPJ;
        acc.AccountNumber = '465asdsa@21322';

        Database.SaveResult result;
        try {
            result = Database.insert(acc);
            Assert.fail('Should not create account');
        } catch (Exception e) {
            Assert.isTrue(e.getMessage().contains('Número do cliente é inválido'));
        }
    }

    @IsTest
    static void shouldCreateOpportunity(){
        Account acc = createAccountDraw(); 
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.PARTNER).getRecordTypeId();
        Database.insert(acc);

        Assert.isNotNull([SELECT Id FROM Opportunity], 'Opportunity was not created');
    }

    @IsTest
    static void shouldCreateTask(){
        Account acc = createAccountDraw();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.FINAL_CONSUMER).getRecordTypeId();
        Database.insert(acc);

        Assert.isNotNull([SELECT Id FROM Task], 'Task was not created');
    }

    @IsTest
    static void shouldBlockInvalidCPFChange(){
        Account acc = createAccountDraw();
        Database.insert(acc);

        acc.AccountNumber = '564534d123asdasdsa';
        try {
            Database.update(acc);
            Assert.fail('Should not update account');
        } catch (Exception e) {
            Assert.isTrue(e.getMessage().contains('Número do cliente é inválido'));
        }
    }

    @IsTest
    static void shouldBlockInvalidCNPJChange(){
        Account acc = createAccountDraw();
        acc.Type = AccountTypes.CNPJ;
        acc.AccountNumber = '79452433000138';
        Database.insert(acc);

        acc.AccountNumber = '564534d123asdasdsa';
        try {
            Database.update(acc);
            Assert.fail('Should not update account');
        } catch (Exception e) {
            Assert.isTrue(e.getMessage().contains('Número do cliente é inválido'));
        }
    }
}