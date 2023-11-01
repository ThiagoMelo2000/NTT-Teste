public with sharing class OpportunitySelector {
    private static OpportunitySelector INSTANCE = new OpportunitySelector();

    public static OpportunitySelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new OpportunitySelector();
        }
        return INSTANCE;
    }

    public List<Opportunity> selectInNegotiationByAccountIds(Set<Id> accountIds){
        return [SELECT AccountId, Id, StageName, LastModifiedDate, IsWon FROM Opportunity WHERE AccountId in :accountIds AND IsWon = false AND StageName = 'Negotiation/Review'];
    }

    public List<Opportunity> selectWonByAccountIds(Set<Id> accountIds){
        return [SELECT AccountId, Id, StageName, LastModifiedDate, IsWon FROM Opportunity WHERE AccountId in :accountIds AND IsWon = true AND CloseDate < LAST_N_DAYS:120];
    }
}