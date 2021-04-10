/*
UPDATES REQUESTED RECORD/FIELDS BUT DES NOT SAVE THEM...
*/

global class LeaseholdBatch implements Database.Batchable<sObject> {

  public List<Id> LR_Ids;
  
  @InvocableMethod(label='execute the batch LeaseholdBatch' description='This method will be execute LeaseholdBatch')
  public static void executeBatchMethod(List<Id> IDs) {
    Database.executeBatch(new LeaseholdBatch(IDs), 30);
  }
    public LeaseholdBatch (List<Id> IDs){
        this.LR_IDs = IDs;
    }
  
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('LR IDs >> ' + LR_IDs);
        
/*
//        String query = 'SELECT Id,Region__c,Term__c FROM LR_Leaseholds__c WHERE Id in: LR_Ids';
        return Database.getQueryLocator([SELECT Id,Name,Region__c,Term__c FROM LR_Leaseholds__c WHERE Id in: LR_IDs]);
    */
    return Database.getQueryLocator([SELECT Id FROM UK_National_space_standard__c WHERE Id in: LR_IDs]);
  }
    
    global void execute(Database.BatchableContext BC, List<UK_National_space_standard__c> scope) {  
       system.debug('SCOPE >> ' + scope);
/*
//       Map<id,LR_Leaseholds__c>LRmap=New  Map<id,LR_Leaseholds__c>(); 
       for(LR_Leaseholds__c LR:scope){
        {        
            system.debug(LR);
            LR.Region__c = LR.Term__c;
            system.debug(LR);
        }
          
//       LRmap.put(LR.id,LR);
      } 
*/
    }
   
   global void finish(Database.BatchableContext BC) {
   }

}