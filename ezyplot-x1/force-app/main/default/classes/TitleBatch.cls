/*
FIX ERROR .. missing execute ???
*/

global class TitleBatch implements Database.Batchable<sObject> {

  public List<Id> LR_Ids;
  
  @InvocableMethod(label='execute the batch TitleBatch' description='This method will be execute TitleBatch')
  
  public static void executeBatchMethod(List<Id> IDs) {
    Database.executeBatch(new TitleBatch(IDs), 30);
  }

  public TitleBatch (List<Id> IDs){
    this.LR_IDs = IDs;
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    system.debug('LR IDs >> ' + LR_IDs);
      
    return Database.getQueryLocator([SELECT Id,Name,Region__c,Term__c FROM LR_Title__c WHERE Id in: LR_IDs]);
  }
  
  global void execute(Database.BatchableContext BC, List<LR_Title__c> scope) {  
    system.debug('SCOPE >> ' + scope);

//  Map<id,LR_Title__c>LRmap=New  Map<id,LR_Title__c>(); 
    for(LR_Title__c LR:scope){
          system.debug(LR);
          LR.Region__c = LR.Term__c;
          system.debug(LR);
    }     
//  LRmap.put(LR.id,LR);
  }
  
  global void finish(Database.BatchableContext BC) {
  }

}