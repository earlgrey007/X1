public with sharing class Utils_PlanIt_Planning_callout implements Queueable, Database.AllowsCallouts {

    private ID pId;
    private string pPostcode;
    
    public Utils_PlanIt_Planning_callout( Id p_Id, String p_Postcode ) {
        this.pPostcode = p_Postcode;
        this.pId = p_Id;
    }

    public void execute (QueueableContext context){
        system.debug('Utils_PlanIt_Planning_callout: APEX param received: >> '+pId+','+pPostcode);
            
        // ***>>*******************
        // ** call data provider **
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        // ** SET HEADERS & ENDPOINT *** 
        request.setMethod('GET');
        
        //
        string url = 'https://www.planit.org.uk/api/applics/json?krad=1&recent=999&pg_sz=500'
                        + '&pcode'+ pPostcode.replace(' ','+');               // changes format to SE18+6FY 

        request.setEndpoint(url);
        System.debug('Utils_PlanIt_Planning_callout: calling URL >> ' + url);

        // fill reponse.getbody() with a MOCK response for testing purposes

        String mockJson = '{'+
        '    \"count\": 464, '+
        '    \"detail\": \"464 nearest applications to SE18 6FY within 1.0 km during most recent 999 days\", '+
        '    \"limit\": 500, '+
        '    \"msg\": \"464 nearest applications to SE18 6FY\", '+
        '    \"offset\": 0, '+
        '    \"page_size\": 500, '+
        '    \"records\": ['+
        '        {'+
        '            \"address\": \"Unit 7, Block E, Phase 4 (OSD), Royal Arsenal Riverside, 14 Victory Parade, Woolwich, SE18 6FY\", '+
        '            \"altid\": null, '+
        '            \"app_size\": \"Small\", '+
        '            \"app_state\": \"Permitted\", '+
        '            \"app_type\": \"Conditions\", '+
        '            \"associated_id\": \"13/3261/MA\", '+
        '            \"authority_id\": 304, '+
        '            \"authority_name\": \"Greenwich\", '+
        '            \"consulted_date\": null, '+
        '            \"decided_date\": \"2019-12-13\", '+
        '            \"description\": \"Submission of part details (Unit 7, Block E only), pursuant to discharge of condition 10 (Ground Floor Commercial Uses) of planning permission dated 28/03/2014 (Ref: 13/3261/MA).\", '+
        '            \"distance\": 0.0, '+
        '            \"lat\": 51.491282, '+
        '            \"link\": \"https://www.planit.org.uk/planapplic/Greenwich/19/3109/SD/\", '+
        '            \"lng\": 0.072856, '+
        '            \"name\": \"Greenwich/19/3109/SD\", '+
        '            \"postcode\": \"SE18 6FY\", '+
        '            \"rec_type\": \"PlanApplic\", '+
        '            \"reference\": null, '+
        '            \"source_url\": \"https://planning.royalgreenwich.gov.uk/online-applications/search.do?action=advanced\", '+
        '            \"start_date\": \"2019-09-06\", '+
        '            \"uid\": \"19/3109/SD\", '+
        '            \"url\": \"https://planning.royalgreenwich.gov.uk/online-applications/applicationDetails.do?keyVal=_GRNW_DCAPR_100219&activeTab=summary\", '+
        '            \"when_updated\": \"2020-01-13T12:46:47.900000+00:00\"'+
        '        }'+
        '    ], '+
        '    \"secs_taken\": 0.98, '+
        '    \"total\": 464'+
        '}';
        Utils_PlanIt_Planning_parser p = Utils_PlanIt_Planning_parser.parse( mockJson );

        if ( !Test.isRunningTest() ){           
            //  if this is NOT a test.. make callout to endpoint
        
            // ** CALL data provider ** 
            HttpResponse response = http.send(request);
            System.debug('Utils_PlanIt_Planning_callout: Received the following response:' + response);
        
            // ** PARSE REAL RESULT **    
            p = Utils_PlanIt_Planning_parser.parse(response.getBody());
        }

        // ***>>**********************
        // ** STORE THE RESULT DATA **

        string saveResult='';    

/*      implement later:
        if (p.status == 'error'){
            saveResult = p.status + ' ' + p.code +': '+ p.message;
            } 
        else {
            // ** SAVE PARSED RESULT IN RELATED Planning List ** 
            saveResult = Utils_SaveData.save_PlanIT_PlanningData( pId, pPostcode, p );
            System.debug('PD_Planning_callout: saved Planning applications with link to Area_Retrieval :' + saveResult);
        }
*/

        saveResult = Utils_SaveData.save_PlanIT_Planning( pId, pPostcode, p );
        System.debug('PD_Planning_callout: saved Planning applications with link to Area_Retrieval :' + saveResult);

        // ** UPDATE Area_Retrieval record that prompted this call        
        Area_Retrieval_Status__c a = new Area_Retrieval_Status__c(
            Id = pId,
            Planning_Last_retrieved__c = date.today(),
            Planning_Retrieval_result_buffer__c = saveResult
        );
        System.debug('Utils_PlanIt_Planning_callout: saving Postcode geocode in Area_Retrieval record :' + a);                                            
        update a;

        // ** STORE THE RESULT DATA **
        // ***<<**********************

    }

}