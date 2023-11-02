@IsTest
public with sharing class AccountSelectorTest {

    @IsTest
    static void shouldSelectAllActiveAccounts(){
        List<Account> accountsToCreated = new List<Account>();
        
        for(Integer i = 0; i < 4; i++){
            accountsToCreated.add(new Account(
                Name = 'Test',
                Type = AccountTypes.CPF,
                AccountNumber = '12345678910'
            ));
        }
        Database.insert(accountsToCreated);

        List<Account> selectedAccounts = AccountSelector.getInstance().selectAllActives();
        Assert.isFalse(selectedAccounts.isEmpty());
    }

    @IsTest
    static void shouldNotSelectAllActiveAccounts(){
        List<Account> accountsToCreated = new List<Account>();
        
        for(Integer i = 0; i < 4; i++){
            accountsToCreated.add(new Account(
                Name = 'Test',
                Type = AccountTypes.CPF,
                Inativa__c = true,
                AccountNumber = '12345678910'
            ));
        }
        Database.insert(accountsToCreated);

        List<Account> selectedAccounts = AccountSelector.getInstance().selectAllActives();
        Assert.isTrue(selectedAccounts.isEmpty());
    }

    @IsTest
    static void shouldSelectAccountById(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910'
        );
        Database.insert(acc);

        Account selectedAccount = AccountSelector.getInstance().selectById(acc.Id);
        Assert.isNotNull(selectedAccount);
        Assert.areEqual(acc.Id, selectedAccount.Id);
    }
}