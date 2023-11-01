global with sharing class AccountCleaningSchedulable implements Schedulable {

    global void execute(SchedulableContext sc){
        AccountCleaningBatchable job = new AccountCleaningBatchable();
        Database.executeBatch(job, 200);
    }

    public static String schedule(){
        AccountCleaningSchedulable schedule = new AccountCleaningSchedulable();
        String cronExp = '0 0 1,7,13,19 ? * MON-FRI';
        return System.schedule('Clearing Accounts', cronExp, schedule);
    }
}