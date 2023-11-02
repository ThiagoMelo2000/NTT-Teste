global with sharing class AccountCleaningBatchable implements Database.Batchable<SObject>{

    global List<Account> start(Database.BatchableContext context){
        return AccountSelector.getInstance().selectAllActives();
    }

    global void execute(Database.BatchableContext context, List<Account> accounts){
        Set<Id> activeAccountIds = new Set<Id>();
        for(Account acc : accounts){
            activeAccountIds.add(acc.Id);
        }

        List<Account> accountsToUpdate = new List<Account>();
        List<Task> openTasks = TaskSelector.getInstance().selectOpensByAccountIds(activeAccountIds);
        if(!openTasks.isEmpty()){
            for(Task openTask : openTasks){
                activeAccountIds.remove(openTask.WhatId);
            }
        } 
        
        List<Opportunity> openOpps = OpportunitySelector.getInstance().selectInNegotiationByAccountIds(activeAccountIds);
        if(!openOpps.isEmpty()){
            for(Opportunity opp : openOpps){
                activeAccountIds.remove(opp.AccountId);
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