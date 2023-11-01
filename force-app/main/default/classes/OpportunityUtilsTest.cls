@IsTest
public with sharing class OpportunityUtilsTest {
   
    @IsTest
    public static void shouldCreateOpportunity(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.PARTNER
        );
        Database.insert(acc);

        OpportunityUtils.createOppotunity(new List<Account>{acc});
        Assert.isNotNull([SELECT Id FROM Opportunity LIMIT 1], 'Opportunity was not created');

        Opportunity opp = [SELECT Name, StageName FROM Opportunity LIMIT 1];
        Assert.areEqual('Test - opp Parceiro', opp.Name);
        Assert.areEqual('Qualification', opp.StageName);
    }

    @IsTest
    public static void shouldNotCreateOpportunity(){
        try {
            OpportunityUtils.createOppotunity(null);
        } catch (Exception e) {
            Assert.areEqual('Fail to create opportunities: Account list is null', e.getMessage());
        }
    }
}