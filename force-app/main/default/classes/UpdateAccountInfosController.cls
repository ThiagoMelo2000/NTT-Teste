public with sharing class UpdateAccountInfosController {
   
    @AuraEnabled(cacheable=true)
    public static Account getAccount(Id accountId){
        return AccountSelector.getInstance().selectById(accountId);
    }

    @AuraEnabled
    public static void updateAccount(String name, String type, String accountNumber, Id accountId){
        Account acc = new Account(
            Id = accountId,
            Name = name,
            Type = type,
            AccountNumber = accountNumber
        );

        Database.update(acc);
    }
}