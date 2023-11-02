@IsTest
public with sharing class OpportunityUtilsTest {
    private static final Id partnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(AccountRecordTypes.PARTNER).getRecordTypeId(); 
   
    @IsTest
    static void shouldCreateOpportunity(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910',
            RecordTypeId = partnerRecordTypeId
        );
        Database.insert(acc);

        Assert.isNotNull([SELECT Id FROM Opportunity LIMIT 1], 'Opportunity was not created');

        Opportunity opp = [SELECT Name, StageName FROM Opportunity LIMIT 1];
        Assert.areEqual('Test - opp Parceiro', opp.Name);
        Assert.areEqual('Qualification', opp.StageName);
    }

    @IsTest
    static void shouldCreateOpportunityWithMultipleAccounts(){
        List<Account> accountsToCreate = new List<Account>();
        for(Integer i = 0; i < 4; i++){
            accountsToCreate.add(new Account(
                Name = 'Test',
                Type = AccountTypes.CPF,
                AccountNumber = '12345678910',
                RecordTypeId = partnerRecordTypeId
            ));
        }
        Database.insert(accountsToCreate);
        Assert.isFalse([SELECT Id FROM Opportunity].isEmpty(), 'Opportunities was not created');

        List<Opportunity> opps = [SELECT Name, StageName FROM Opportunity];
        Assert.areEqual(accountsToCreate.size(), opps.size());
    }

    @IsTest
    static void shouldNotCreateOpportunity(){
        try {
            OpportunityUtils.createOpportunity(null);
        } catch (Exception e) {
            Assert.areEqual('Fail to create opportunities: Account list is null', e.getMessage());
        }
    }
}