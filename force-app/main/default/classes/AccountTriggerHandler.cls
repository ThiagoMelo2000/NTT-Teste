public with sharing class AccountTriggerHandler extends TriggerHandler {

    private static final Id partnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.PARTNER).getRecordTypeId(); 
    private static final Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.FINAL_CONSUMER).getRecordTypeId(); 
    private final List<Account> oldAccounts;
    private final List<Account> newAccounts;
    private final Map<Id, Account> oldAccountMap;

    public AccountTriggerHandler() {
        oldAccounts = Trigger.old;
        newAccounts = Trigger.new;
        this.oldAccountMap = (Map<Id, Account>) Trigger.oldMap;
    }

    protected override void beforeInsert(){
        for(Account acc : newAccounts){
            if(acc?.Type == AccountTypes.CPF){
                if(!AccountUtils.validaCPF(acc.AccountNumber)){
                    AccountUtils.blockAccountCreation(acc);
                }
            } else if(acc?.Type == AccountTypes.CNPJ){
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
            if(acc?.RecordTypeId == partnerRecordTypeId){
                partnerAccounts.add(acc);
            } else if(acc?.RecordTypeId == consumerRecordTypeId){
                finalConsumerAccounts.add(acc);
            }
        }

        if(!partnerAccounts.isEmpty()){
            OpportunityUtils.createOppotunity(partnerAccounts);
        } else if(!finalConsumerAccounts.isEmpty()){
            TaskUtils.createTask(finalConsumerAccounts);
        }
    }

    protected override void beforeUpdate(){
        for(Account newAccount : newAccounts){
            Account oldAccount = oldAccountMap.get(newAccount.Id);

            if(((newAccount.Type == AccountTypes.CPF && !AccountUtils.validaCPF(newAccount.AccountNumber)) || (newAccount.Type == AccountTypes.CNPJ && !AccountUtils.validaCNPJ(newAccount.AccountNumber))) && 
              (newAccount.Type != oldAccount.Type || newAccount.AccountNumber != oldAccount.AccountNumber)
            ){
                AccountUtils.blockAccountCreation(newAccount);
            }
        }
    }
}