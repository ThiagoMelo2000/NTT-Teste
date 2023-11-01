public with sharing class TaskUtils {
   
    public static void createTask(List<Account> accounts){
        
        try {
            if(accounts == null){
                throw new TaskUtilsException('Account list is null');
            }
            List<Task> tasksToCreate = new List<Task>();

            for(Account acc : accounts){
                tasksToCreate.add(new Task(
                    Subject = 'Consumidor Final',
                    WhatId = acc.Id,
                    Status = 'Not Started',
                    Priority = 'Normal'
                ));
            }
            Database.insert(tasksToCreate);
            
        } catch (TaskUtilsException e) {
            throw new TaskUtilsException('Fail to create tasks: ' + e.getMessage());
        }
    }

    public class TaskUtilsException extends Exception{}
}