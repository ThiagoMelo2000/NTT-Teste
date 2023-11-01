public with sharing class AccountTriggerHandler extends TriggerHandler {

    private final List<Account> oldAccounts;
    private final List<Account> newAccounts;

    public AccountTriggerHandler() {
        oldAccounts = Trigger.old;
        newAccounts = Trigger.new;
    }

    protected override void beforeInsert(){
        for(Account acc : newAccounts){
            if(acc?.Type == AccountTypes.CPF){
                if(!AccountUtils.validaCPF(acc.AccountNumber)){
                    AccountUtils.blockAccountCreation(acc);
                }
            } 
            if(acc?.Type == AccountTypes.CNPJ){
                if(!AccountUtils.validaCNPJ(acc.AccountNumber)){
                    AccountUtils.blockAccountCreation(acc);
                }
            }
        }
    }

    protected override void afterInsert(){
        List<Account> partnerAccounts = new List<Account>();
        List<Account> finalConsumerAccounts = new List<Account>();
        for(Account acc : newAccounts){
            if(acc?.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.FINAL_CONSUMER).getRecordTypeId()){
                partnerAccounts.add(acc);
            }

            if(acc?.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.FINAL_CONSUMER).getRecordTypeId()){
                finalConsumerAccounts.add(acc);
            }
        }

        if(!partnerAccounts.isEmpty()){
            OpportunityUtils.createOppotunity(partnerAccounts);
        }

        if(!finalConsumerAccounts.isEmpty()){
            TaskUtils.createTask(finalConsumerAccounts);
        }
    }
}