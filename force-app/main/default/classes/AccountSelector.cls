public with sharing class AccountSelector {
    
    private static AccountSelector INSTANCE = new AccountSelector();

    public static AccountSelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new AccountSelector();
        }
        return INSTANCE;
    }

    public List<Account> selectAllActives(){
        return [SELECT Id, Type, AccountNumber, Inativa__c FROM Account WHERE Inativa__c = FALSE];
    }
}