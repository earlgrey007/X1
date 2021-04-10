public class Utils_callouts_PD_LandForSale Implements Queueable, Database.AllowsCallouts {

    private ID pId;
    private string pPostcode;
    
    public Utils_callouts_PD_LandForSale ( Id p_Id, String p_Postcode ) {
        this.pPostcode = p_Postcode;
        this.pId = p_Id;
    }

    public void execute (QueueableContext context){
        system.debug('Utils_callouts_PD_LandForSale : APEX param received: >> '+pId+','+pPostcode);
            
        // ***>>*******************
        // ** call data provider **
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        // ** SET HEADERS & ENDPOINT *** 
        request.setMethod('GET');
    
        // 
        string url = 'https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_pageSize=50&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=1900-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon,transactionDate' 
                        + '&'+'propertyAddress.postcode=' + pPostcode.replace(' ','+');     // changes format to SE18+6FY 

        request.setEndpoint(url);
        System.debug('Utils_callouts_LR_Transactions : calling URL >> ' + url);
    
        // ** MAKE CALL *** 
        HttpResponse response = http.send(request);
        System.debug('Utils_callouts_LR_Transactions : Received the following response:' + response);
        // System.debug('getLR_Trans_Data: Received the following response body:' + response.getbody());
    
        // ** call data provider **
        // ***<<*******************
    
        // ***>>*****************
        // ** PARSE THE RESULT **
    
        Utils_LR_Transactions_parser p = Utils_LR_Transactions_parser.parse(response.getBody());
        // System.debug('Utils_callouts_LR_Transactions : parsed LR_Trans_Data values :' + p);
    
        // ** PARSE THE RESULT **
        // ***<<*****************

        // ***>>**********************
        // ** STORE THE RESULT DATA **

        // SAVE PARSED RESULT IN Land_Registry_transaction__c records ** 
        string saveResult = Utils_SaveData.save_LR_Transaction_Data( pId, pPostcode, p);
        System.debug('Utils_callouts_LR_Transactions : saved LR Transactions with link to Area_Retrieval :' + saveResult);

        // ** STORE THE RESULT DATA **
        // ***<<**********************

        // ** UPDATE Area_Retrieval record that prompted this call        
        Area_Retrieval_Status__c[] a = [SELECT Id, LR_Trans_Data_Retrieval_result_buffer__c, LR_Trans_Data_Last_retrieved__c 
                                            FROM Area_Retrieval_Status__c where Id = :pId limit 1];
        System.debug('Utils_callouts_LR_Transactions : a :' + a);
                                            
        for(Area_Retrieval_Status__c x: a){
            System.debug('Utils_callouts_LR_Transactions : x :' + x);
                x.LR_Trans_Data_Last_retrieved__c = date.today();
                x.LR_Trans_Data_Retrieval_result_buffer__c = saveResult;
                update a;
        }        

        // get EPC data as a batch child process
        System.debug('Utils_callouts_LR_Transactions : putting Utils_callouts_EPC_Domestic ('+ pId +','+ pPostcode +') in the queue');
        ID jobId = system.enqueuejob(new Utils_callouts_EPC_Domestic (pId, pPostcode));        

    // NOTES:        
    // use          https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_pageSize=50&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon
    // next page    https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=1&propertyAddress.town=&_pageSize=50&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon

    }

}