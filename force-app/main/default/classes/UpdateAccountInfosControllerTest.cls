@IsTest
public with sharing class UpdateAccountInfosControllerTest {
    
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
    static void shouldReturnAccount(){
        Account acc = [SELECT Id FROM Account];

        Account selectedAccount = UpdateAccountInfosController.getAccount(acc.Id);
        Assert.isNotNull(selectedAccount);
        Assert.areEqual(acc.Id, selectedAccount.Id);
    }

    @IsTest
    static void shouldUpdateAccount(){
        Account acc = [SELECT Id FROM Account];

        UpdateAccountInfosController.updateAccount('Test update', AccountTypes.CNPJ, '12345678912345', acc.Id);

        Account updatedAccount = [SELECT Id, Name, Type, AccountNumber FROM Account];
        Assert.areEqual('Test update', updatedAccount.Name);
        Assert.areEqual(AccountTypes.CNPJ, updatedAccount.Type);
        Assert.areEqual('12345678912345', updatedAccount.AccountNumber);
    }
}