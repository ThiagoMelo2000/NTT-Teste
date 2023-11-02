public with sharing class OpportunityUtils {
    public static void createOpportunity(List<Account> accounts){
        
        try {
            if(accounts == null){
                throw new OpportunityUtilsException('Account list is null');
            }

            List<Opportunity> oppToCreate = new List<Opportunity>();
            for(Account acc : accounts){
                oppToCreate.add(new Opportunity(
                    Name = acc.Name + ' - opp Parceiro',
                    CloseDate = Date.today().addDays(30),
                    StageName = 'Qualification',
                    AccountId = acc.Id
                ));
            }
            Database.insert(oppToCreate);

        } catch (OpportunityUtilsException e) {
            throw new OpportunityUtilsException('Fail to create opportunities: ' + e.getMessage());
        }
    }

    public class OpportunityUtilsException extends Exception{}
}