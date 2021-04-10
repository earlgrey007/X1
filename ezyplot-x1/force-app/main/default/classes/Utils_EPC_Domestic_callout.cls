public class Utils_EPC_Domestic_callout implements Queueable, Database.AllowsCallouts {

    private ID pId;
    private string pPostcode;
    private list<String> pAreaList;
    
    public Utils_EPC_Domestic_callout (list<String> p_AreaList) {
        this.pAreaList = p_AreaList;
    }

    public void execute (QueueableContext context){
        system.debug('Utils_EPC_Domestic_callout: APEX param received: >> '+ pAreaList);

        // ***>>*******************
        // ** call data provider **
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // ** SET HEADERS *** 
        request.setMethod('GET');

        // for later release store api key in custom setting..
        Blob headerValue = Blob.valueOf('ron@rwjsolutions.co.uk:dcdd7989da0d15eee48f027b5f6ebeb6e73f8826');
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Accept','application/json');

        // ** SET ENDPOINT *** 
        String url ='https://epc.opendatacommunities.org/api/v1/domestic/search'
                        + '?'+'from-year=2009'              // default = from 2008
                        + '&'+'postcode=' + pAreaList[0].replace(' ','')
                        + '&'+'size=500'
                        ;
        request.setEndpoint(url);

        // fill reponse.getbody() with a MOCK response for testing purposes
        string mockJson = 
                    '{"column-names":["lmk-key","address1","address2","address3","postcode","building-reference-number","current-energy-rating","potential-energy-rating","current-energy-efficiency","potential-energy-efficiency","property-type","built-form","inspection-date","local-authority"'
                    + ',"constituency","county","lodgement-date","transaction-type","environment-impact-current","environment-impact-potential","energy-consumption-current","energy-consumption-potential","co2-emissions-current","co2-emiss-curr-per-floor-area","co2-emissions-potential"'
                    + ',"lighting-cost-current","lighting-cost-potential","heating-cost-current","heating-cost-potential","hot-water-cost-current","hot-water-cost-potential","total-floor-area","energy-tariff","mains-gas-flag","floor-level","flat-top-storey","flat-storey-count"'
                    + ',"main-heating-controls","multi-glaze-proportion","glazed-type","glazed-area","extension-count","number-habitable-rooms","number-heated-rooms","low-energy-lighting","number-open-fireplaces","hotwater-description","hot-water-energy-eff","hot-water-env-eff"'
                    + ',"floor-description","floor-energy-eff","floor-env-eff","windows-description","windows-energy-eff","windows-env-eff","walls-description","walls-energy-eff","walls-env-eff","secondheat-description","sheating-energy-eff","sheating-env-eff","roof-description"'
                    + ',"roof-energy-eff","roof-env-eff","mainheat-description","mainheat-energy-eff","mainheat-env-eff","mainheatcont-description","mainheatc-energy-eff","mainheatc-env-eff","lighting-description","lighting-energy-eff","lighting-env-eff","main-fuel"'
                    + ',"wind-turbine-count","heat-loss-corridoor","unheated-corridor-length","floor-height","photo-supply","solar-water-heating-flag","mechanical-ventilation","address","local-authority-label","constituency-label","posttown","construction-age-band"'
                    + ',"lodgement-datetime","tenure","fixed-lighting-outlets-count","low-energy-fixed-light-count"],"rows":[{"low-energy-fixed-light-count":"10","address":"Flat 17 Duncombe House, 15, Victory Parade","floor-height":"","heating-cost-potential":"145"'
                    + ',"unheated-corridor-length":"","hot-water-cost-potential":"60","construction-age-band":"NO DATA!","potential-energy-rating":"B","mainheat-energy-eff":"Very Good","windows-env-eff":"Good","lighting-energy-eff":"Very Good"'
                    + ',"environment-impact-potential":"94","glazed-type":"NO DATA!","heating-cost-current":"145","address3":"","mainheatcont-description":"Charging system linked to use of community heating, programmer and TRVs","sheating-energy-eff":"1"'
                    + ',"property-type":"Flat","local-authority-label":"Greenwich","fixed-lighting-outlets-count":"10","energy-tariff":"standard tariff","mechanical-ventilation":"NO DATA!","hot-water-cost-current":"60","county":"Greater London Authority"'
                    + ',"postcode":"SE18 6FY","solar-water-heating-flag":"","constituency":"E14000718","co2-emissions-potential":"0.4","number-heated-rooms":"","heat-loss-corridoor":"NO DATA!","floor-description":"(other premises below)","energy-consumption-potential"'
                    + ':"44","local-authority":"E09000011","built-form":"Detached","number-open-fireplaces":"0","windows-description":"Fully double glazed","glazed-area":"NO DATA!","inspection-date":"2017-05-02","mains-gas-flag":"","co2-emiss-curr-per-floor-area":"9"'
                    + ',"address1":"Flat 17 Duncombe House","flat-storey-count":"","constituency-label":"Greenwich and Woolwich","roof-energy-eff":"1","total-floor-area":"50","building-reference-number":"3890841578","environment-impact-current":"94"'
                    + ',"co2-emissions-current":"0.4","roof-description":"(other premises above)","floor-energy-eff":"1","number-habitable-rooms":"","address2":"15, Victory Parade","hot-water-env-eff":"Very Good","posttown":"LONDON","mainheatc-energy-eff":"Good"'
                    + ',"main-fuel":"NO DATA!","lighting-env-eff":"Very Good","windows-energy-eff":"Good","floor-env-eff":"1","sheating-env-eff":"1","lighting-description":"Low energy lighting in all fixed outlets","roof-env-eff":"1","walls-energy-eff":"Very Good"'
                    + ',"photo-supply":"","lighting-cost-potential":"36","mainheat-env-eff":"Very Good","multi-glaze-proportion":"","main-heating-controls":"","lodgement-datetime":"2017-05-04 11:59:11","flat-top-storey":"","current-energy-rating":"B","secondheat-description":"None"'
                    + ',"walls-env-eff":"Very Good","transaction-type":"new dwelling","current-energy-efficiency":"84","energy-consumption-current":"44","mainheat-description":"Community scheme","lighting-cost-current":"36","lodgement-date":"2017-05-04","extension-count":""'
                    + ',"mainheatc-env-eff":"Good","lmk-key":"1539502349802017050411591155130428","wind-turbine-count":"","tenure":"unknown","floor-level":"mid floor","potential-energy-efficiency":"84","hot-water-energy-eff":"Very Good","low-energy-lighting":"100"'
                    + ',"walls-description":"Average thermal transmittance 0.1 W00b2K","hotwater-description":"Community scheme"},{"low-energy-fixed-light-count":"10","address":"Flat 8 Duncombe House, 15, Victory Parade","floor-height":"","heating-cost-potential":"128"'
                    + ',"unheated-corridor-length":"","hot-water-cost-potential":"65","construction-age-band":"NO DATA!","potential-energy-rating":"B","mainheat-energy-eff":"Very Good","windows-env-eff":"Good","lighting-energy-eff":"Very Good","environment-impact-potential":"94"'
                    + ',"glazed-type":"NO DATA!","heating-cost-current":"128","address3":"","mainheatcont-description":"Charging system linked to use of community heating, programmer and TRVs","sheating-energy-eff":"1","property-type":"Flat","local-authority-label":"Greenwich"'
                    + ',"fixed-lighting-outlets-count":"10","energy-tariff":"standard tariff","mechanical-ventilation":"NO DATA!","hot-water-cost-current":"65","county":"Greater London Authority","postcode":"SE18 6FY","solar-water-heating-flag":"","constituency":"E14000718"'
                    + ',"co2-emissions-potential":"0.4","number-heated-rooms":"","heat-loss-corridoor":"NO DATA!","floor-description":"(other premises below)","energy-consumption-potential":"37","local-authority":"E09000011","built-form":"Detached","number-open-fireplaces":"0"'
                    + ',"windows-description":"Fully double glazed","glazed-area":"NO DATA!","inspection-date":"2017-05-02","mains-gas-flag":"","co2-emiss-curr-per-floor-area":"7","address1":"Flat 8 Duncombe House","flat-storey-count":"","constituency-label":"Greenwich and Woolwich"'
                    + ',"roof-energy-eff":"1","total-floor-area":"62","building-reference-number":"1101841578","environment-impact-current":"94","co2-emissions-current":"0.4","roof-description":"(other premises above)","floor-energy-eff":"1","number-habitable-rooms":""'
                    + ',"address2":"15, Victory Parade","hot-water-env-eff":"Very Good","posttown":"LONDON","mainheatc-energy-eff":"Good","main-fuel":"NO DATA!","lighting-env-eff":"Very Good","windows-energy-eff":"Good","floor-env-eff":"1","sheating-env-eff":"1"'
                    + ',"lighting-description":"Low energy lighting in all fixed outlets","roof-env-eff":"1","walls-energy-eff":"Very Good","photo-supply":"","lighting-cost-potential":"43","mainheat-env-eff":"Very Good","multi-glaze-proportion":"","main-heating-controls":""'
                    + ',"lodgement-datetime":"2017-05-04 11:58:56","flat-top-storey":"","current-energy-rating":"B","secondheat-description":"None","walls-env-eff":"Very Good","transaction-type":"new dwelling","current-energy-efficiency":"87","energy-consumption-current":"37"'
                    + ',"mainheat-description":"Community scheme","lighting-cost-current":"43","lodgement-date":"2017-05-04","extension-count":"","mainheatc-env-eff":"Good","lmk-key":"1539399549142017050411585654130528","wind-turbine-count":"","tenure":"unknown"'
                    + ',"floor-level":"mid floor","potential-energy-efficiency":"87","hot-water-energy-eff":"Very Good","low-energy-lighting":"100","walls-description":"Average thermal transmittance 0.1 W u00b2K","hotwater-description":"Community scheme"}]}';

        Utils_EPC_Domestic_parser p = Utils_EPC_Domestic_parser.parse( mockJson );

        if ( !Test.isRunningTest() ){           
            //  if this is NOT a test.. make callout to endpoint
        
            // ** CALL data provider ** 
            HttpResponse response = http.send(request);
            //System.debug('Utils_EPC_Domestic_callout: Received the following response: ' + response);
            System.debug('Utils_EPC_Domestic_callout: Received the following response LENGTH : ' + response.getbody().length());
        
            // ** PARSE REAL RESULT **    
            p = Utils_EPC_Domestic_parser.parse(response.getBody());
            System.debug('Utils_EPC_Domestic_callout: parsed EPC_Data values :' + p);
        }

        // ***>>**********************
        // ** STORE THE RESULT DATA *
        System.debug('Utils_EPC_Domestic_callout: saved EPC recs with link to Area_Retrieval');
        Utils_SaveData.save_EPC_Data( pAreaList[0], p );
        // ***<<**********************

        /*** >> **********************    S U P E R   I M P O R T A N T *****

        // Check for remaining Areas that need their LR Transactions retrieved *
        Area_Retrieval_Status__c[] LR_to_Queue = 
            [SELECT Id, Name, Area__c, LR_Trans_Data_retrieval_required__c
            FROM Area_Retrieval_Status__c 
            WHERE LR_Trans_Data_retrieval_required__c=TRUE 
            LIMIT 10];                                           // one is sufficient
        System.debug('Utils_EPC_Domestic_callout >> LR_Transactions to be queued: ' + LR_to_Queue);

        // IF there are Area that need LR retrieval..    
        if (LR_to_Queue.size() > 0){
            AsyncApexJob[] LR_in_Queue = [
                SELECT ApexClass.Name, Status
                FROM AsyncApexJob 
                WHERE apexClass.Name = 'Utils_LR_Transactions_callout'
                    AND (JobType='Queueable' AND Status IN ('Processing','Preparing','Queued')) 
                LIMIT 10] ;
            System.debug('Utils_EPC_Domestic_callout >> LR_Transactions IN queue: ' + LR_in_Queue);

            if (LR_in_Queue.size() == 0){
                System.debug('Utils_EPC_Domestic_callout >> Launching Utils_LR_Transactions_callout: '+ LR_to_Queue[0].Name);
                ID jobId_2 = system.enqueuejob( new Utils_LR_Transactions_callout (LR_to_Queue[0].Id, LR_to_Queue[0].Name));            
            }
        }
        // *** << **********************    S U P E R   I M P O R T A N T **** */

/* 6 APR 2021 .. COMMENTED OUT .. DO NOT CHAIN QUEUABLE JOBS FOR NOW
        if (pAreaList.size() > 0){
            system.debug('Utils_EPC_Domestic_callout: pAreaList = '+pAreaList);
            if (pAreaList[0] != pAreaList.remove(0)){          // removing is faster than copying second to last item into new list; stop is first item cannot be removed
                system.debug('Utils_EPC_Domestic_callout: W A R N I N G >> IF pPostcode ('+pAreaList[0]+') is still in '+pAreaList+', INVESTIGATE why not.');
            }

            if (pAreaList.size() > 0){
                System.debug('Utils_EPC_Domestic_callout >> Launching Utils_LR_Transactions_callout '+ pAreaList) ;
                ID jobId_LR_trans = system.enqueuejob( new Utils_LR_Transactions_callout (pAreaList));        
            }
        }
*/

    // for later release:
    // send message saying 'x EPC records updated' to e.OwnerId
    // 
    // **  WRAP UP   ** 
    // ****************
    
    }    

    //                                                  **  EPC DATA   ** 
    // *** << *************************************************************************************************************

}