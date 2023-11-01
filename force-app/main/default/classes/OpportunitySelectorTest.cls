@IsTest
public with sharing class OpportunitySelectorTest {

    @TestSetup
    static void setup(){
        Account acc = new Account(
            Name = 'Test',
            Type = AccountTypes.CPF,
            AccountNumber = '12345678910'
        );
        Database.insert(acc);
    }
    
    @IsTest
    static void shouldSelectOpenOpps(){
        Account acc = [SELECT Id, Name FROM Account];

        Opportunity opp = new Opportunity(
            Name = acc.Name + ' - opp Parceiro',
            StageName = 'Negotiation/Review',
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id
        );

        Database.insert(opp);

        List<Opportunity> selectedOpps = OpportunitySelector.getInstance().selectInNegotiationByAccountIds(new Set<Id>{acc.Id});
        Assert.isFalse(selectedOpps.isEmpty());
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
}