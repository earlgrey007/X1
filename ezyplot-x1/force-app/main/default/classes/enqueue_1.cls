public with sharing class enqueue_1 {
    public enqueue_1() {

        // *** >> **********************    S U P E R   I M P O R T A N T *****

        // Check for remaining Areas that need their LR Transactions retrieved *
        Area_Retrieval_Status__c[] LR_to_Queue = 
            [SELECT Id, Name, Area__c, LR_Trans_Data_retrieval_required__c
            FROM Area_Retrieval_Status__c 
            WHERE LR_Trans_Data_retrieval_required__c=TRUE 
            LIMIT 10];                                           // one is sufficient
        System.debug('Enqueue_1>> LR_Transactions to be queued: ' + LR_to_Queue);

        // IF there are Area that need LR retrieval..    
        if (LR_to_Queue.size() > 0){
            AsyncApexJob[] LR_in_Queue = [
                SELECT ApexClass.Name, Status
                FROM AsyncApexJob 
                WHERE apexClass.Name = 'enqueue_2'
                    AND (JobType='Queueable' AND Status IN ('Processing','Preparing','Queued')) 
                LIMIT 10] ;
            System.debug('Enqueue_1>> enqueue_2 IN queue: ' + LR_in_Queue);

            if (LR_in_Queue.size() == 0){
                System.debug('Enqueue_1>> Launching enqueue_2 ');
                ID jobId_2 = system.enqueuejob( new enqueue_2);            
            }
        }
        // *** << **********************    S U P E R   I M P O R T A N T *****


    }
}
