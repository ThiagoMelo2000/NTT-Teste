@IsTest
public with sharing class OpportunitySelectorTest {

    private static final Id partnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.PARTNER).getRecordTypeId();

    @TestSetup
    static void setup(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910',
            RecordTypeId = partnerRecordTypeId
        );
        Database.insert(acc);
    }
    
    @IsTest
    static void shouldSelectOpenOpps(){
        Account acc = [SELECT Id, Name FROM Account];

        Opportunity oppToUpdate = [SELECT StageName FROM Opportunity WHERE AccountId = :acc.Id];
        oppToUpdate.StageName = 'Negotiation/Review';
        Database.update(oppToUpdate);

        List<Opportunity> selectedOpps = OpportunitySelector.getInstance().selectInNegotiationByAccountIds(new Set<Id>{acc.Id});
        Assert.isFalse(selectedOpps.isEmpty());
    }

    @IsTest
    static void shouldSelectOpenOppsWithMultipleAccounts(){
        List<Account> accountsToCreate = new List<Account>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Set<Id> accountIds = new Set<Id>();

        for(Integer i = 0; i < 4; i++){
            accountsToCreate.add(new Account(
                Name = 'Test ' + i,
                Type = AccountTypes.CPF,
                AccountNumber = '12345678910',
                RecordTypeId = partnerRecordTypeId
            ));
        }
        Database.insert(accountsToCreate);

        for(Account acc : accountsToCreate){
            accountIds.add(acc.Id);
        }

        List<Opportunity> openOpps = [SELECT StageName FROM Opportunity WHERE AccountId IN :accountIds];
        for(Opportunity openOpp : openOpps){
            openOpp.StageName = 'Negotiation/Review';
            oppsToUpdate.add(openOpp);
        }
        Database.update(oppsToUpdate);

        List<Opportunity> selectedOpps = OpportunitySelector.getInstance().selectInNegotiationByAccountIds(accountIds);
        Assert.isFalse(selectedOpps.isEmpty());
        Assert.areEqual(accountsToCreate.size(), selectedOpps.size());
    }

    @IsTest
    static void shouldSelectWonOpps(){
        Account acc = [SELECT Id, Name FROM Account];
        
        Opportunity opp = new Opportunity(
            Name = acc.Name + ' - opp Parceiro',
            StageName = 'Closed Won',
            CloseDate = Date.today().addDays(-125),
            AccountId = acc.Id
        );

        Database.insert(opp);

        List<Opportunity> selectedOpps = OpportunitySelector.getInstance().selectWonByAccountIds(new Set<Id>{acc.Id});
        Assert.isFalse(selectedOpps.isEmpty());
    }

    @IsTest
    static void shouldSelectWonOppsWithMultipleAccounts(){
        List<Account> accountsToCreate = new List<Account>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Set<Id> accountIds = new Set<Id>();

        for(Integer i = 0; i < 4; i++){
            accountsToCreate.add(new Account(
                Name = 'Test ' + i,
                Type = AccountTypes.CPF,
                AccountNumber = '12345678910',
                RecordTypeId = partnerRecordTypeId
            ));
        }
        Database.insert(accountsToCreate);

        for(Account acc : accountsToCreate){
            accountIds.add(acc.Id);
        }

        List<Opportunity> openOpps = [SELECT StageName FROM Opportunity WHERE AccountId IN :accountIds];
        for(Opportunity openOpp : openOpps){
            openOpp.StageName = 'Closed Won';
            openOpp.CloseDate = Date.today().addDays(-125);
            oppsToUpdate.add(openOpp);
        }
        Database.update(oppsToUpdate);

        List<Opportunity> selectedOpps = OpportunitySelector.getInstance().selectWonByAccountIds(accountIds);
        Assert.isFalse(selectedOpps.isEmpty());
        Assert.areEqual(accountsToCreate.size(), selectedOpps.size());
    }
}