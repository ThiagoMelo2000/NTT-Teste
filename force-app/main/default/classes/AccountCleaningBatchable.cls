global with sharing class AccountCleaningBatchable implements Database.Batchable<SObject>{

    global List<Account> start(Database.BatchableContext context){
        return AccountSelector.getInstance().selectAllActives();
    }

    global void execute(Database.BatchableContext context, List<Account> accounts){
        Set<Id> activeAccountIds = new Set<Id>();
        Set<Id> accountsToDiscart = new Set<Id>();
        for(Account acc : accounts){
            activeAccountIds.add(acc.Id);
        }

        List<Account> accountsToUpdate = new List<Account>();
        List<Task> openTasks = TaskSelector.getInstance().selectOpensByAccountIds(activeAccountIds);
        List<Opportunity> openOpps = OpportunitySelector.getInstance().selectInNegotiationByAccountIds(activeAccountIds);
        if(!openTasks.isEmpty()){
            for(Task openTask : openTasks){
                accountsToDiscart.add(openTask.WhatId);
            }
        } 
        if(!openOpps.isEmpty()){
            for(Opportunity opp : openOpps){
                accountsToDiscart.add(opp.AccountId);
            }
        }

        if(!accountsToDiscart.isEmpty()){
            for(Id accountId : accountsToDiscart){
                activeAccountIds.remove(accountId);
            }
        }

        List<Task> closedTasks = TaskSelector.getInstance().selectClosedsByAccountIds(activeAccountIds);
        if(!closedTasks.isEmpty()){
            for(Task closedTask : closedTasks){
                accountsToUpdate.add(updateAccount(closedTask.WhatId));
            }
        }

        List<Opportunity> closedOpps = OpportunitySelector.getInstance().selectWonByAccountIds(activeAccountIds);
        if(!closedOpps.isEmpty()){
            for(Opportunity opp : closedOpps){
                accountsToUpdate.add(updateAccount(opp.AccountId));
            }
        }

        System.debug('accountsToUpdate:: ' + accountsToUpdate);
        if(!accountsToUpdate.isEmpty()){
            Database.update(accountsToUpdate);
        }
    }

    public static Account updateAccount(Id accountId){
        Account acc = new Account(
            Id = accountId,
            Inativa__c = true
        );

        return acc;
    }

    global void finish(Database.BatchableContext context) {
    }
}