@IsTest
public with sharing class AccountSelectorTest {

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
    static void shouldSelectAllActiveAccounts(){
        Account acc = [SELECT Id FROM Account];

        List<Account> selectedAccounts = AccountSelector.getInstance().selectAllActives();
        Assert.isFalse(selectedAccounts.isEmpty());
    }

    @IsTest
    static void shouldSelectAccountById(){
        Account acc = [SELECT Id FROM Account];

        Account selectedAccount = AccountSelector.getInstance().selectById(acc.Id);
        Assert.isNotNull(selectedAccount);
        Assert.areEqual(acc.Id, selectedAccount.Id);
    }
}