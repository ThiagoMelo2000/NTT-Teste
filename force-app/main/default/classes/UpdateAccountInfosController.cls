public with sharing class UpdateAccountInfosController {
   
    @AuraEnabled(cacheable=true)
    public static Account getAccount(Id accountId){
        return AccountSelector.getInstance().selectById(accountId);
    }

    @AuraEnabled
    public static Boolean verifyInfos(String type, String accountNumber){
        return type == AccountTypes.CPF && AccountUtils.validaCPF(accountNumber) || 
               type == AccountTypes.CNPJ && AccountUtils.validaCNPJ(accountNumber);
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