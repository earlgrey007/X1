public class Utils_PcodeGeolocation_callout implements Queueable, Database.AllowsCallouts {

    private ID pId;
    private string pPostcode;
    
    public Utils_PcodeGeolocation_callout( Id p_Id, String p_Postcode ) {
        this.pPostcode = p_Postcode;
        this.pId = p_Id;
    }

    public void execute (QueueableContext context){
        system.debug('Utils_PcodeGeolocation_callout: APEX param received: >> '+pId+','+pPostcode);
            
        // ***>>*******************
        // ** call data provider **
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        // ** SET HEADERS & ENDPOINT *** 
        request.setMethod('GET');

        string url = 'http://api.getthedata.com/postcode'
                        + '/'+ pPostcode.replace(' ','+');               // changes format to SE18+6FY 
        Utils_PcodeGeolocation_parser p = null;

        request.setEndpoint(url);
        System.debug('Utils_PcodeGeolocation_callout: calling URL >> ' + url);

        if ( Test.isRunningTest() ){           
            // fill reponse.getbody() with a MOCK response for testing purposes
            string mockJson = '{\"status\":\"match\",\"match_type\":\"unit_postcode\",\"input\":\"SE18 6FY\",\"data\":{\"postcode\":\"SE18 6FY\",\"status\":\"live\",\"usertype\":\"small\",\"easting\":479342,\"northing\":136493,\"positional_quality_indicator\":1,\"country\":\"England\",\"latitude\":\"51.122233\",\"longitude\":\"-0.867680\",\"postcode_no_space\":\"GU350GJ\",\"postcode_fixed_width_seven\":\"GU350GJ\",\"postcode_fixed_width_eight\":\"GU35 0GJ\",\"postcode_area\":\"GU\",\"postcode_district\":\"GU35\",\"postcode_sector\":\"GU35 0\",\"outcode\":\"GU35\",\"incode\":\"0GJ\"},\"copyright\":[\"Contains OS data (c) Crown copyright and database right 2020\",\"Contains Royal Mail data (c) Royal Mail copyright and database right 2020\",\"Contains National Statistics data (c) Crown copyright and database right 2020\"]}';
            p = Utils_PcodeGeolocation_parser.parse( mockJson );
        }

        if ( !Test.isRunningTest() ){           
            //  if this is NOT a test.. make callout to endpoint        
            // ** CALL data provider ** 
            HttpResponse response = http.send(request);
            System.debug('Utils_PcodeGeolocation_callout: Received the following response:' + response);
            // ** PARSE REAL RESULT **    
            p = Utils_PcodeGeolocation_parser.parse(response.getBody());
        }

        // ***>>**********************
        // find 10 nearest surrounding postcodes: (alternative use 'radius=50' (=max 50 meters; can be max 2000 meters)
        url = 'https://api.postcodes.io/postcodes?lat='+p.Data.latitude+ '&lon='+p.Data.longitude+ '&limit=10';
        Utils_Postcodes_IO_parser pNearest = null;

        request.setEndpoint(url);
        System.debug('Utils_PcodeGeolocation_callout: calling Utils_Postcodes_IO URL >> ' + url);

        // >> TODO HERE parse values coming back from postcodes.io
        if ( Test.isRunningTest() ){           
            // fill reponse.getbody() with a MOCK response for testing purposes
            string mockJson = 
                '{\"status\":200,\"result\":[{\"postcode\":\"B13 9XP\",\"quality\":1,\"eastings\":408797,\"northings\":282961,\"country\":\"England\",\"nhs_ha\":\"West Midlands\",\"longitude\":-1.872003,\"latitude\":52.444545,\"european_electoral_region\":\"West Midlands\",\"primary_care_trust\":\"South Birmingham\",\"region\":\"West Midlands\",\"lsoa\":\"Birmingham 093D\",\"msoa\":\"Birmingham 093\",\"incode\":\"9XP\",\"outcode\":\"B13\",\"parliamentary_constituency\":\"Birmingham, Hall Green\",\"admin_district\":\"Birmingham\",\"parish\":\"Birmingham, unparished area\",\"admin_county\":null,\"admin_ward\":\"Moseley\",\"ced\":null,\"ccg\":\"NHS Birmingham and Solihull\",\"nuts\":\"Birmingham\",\"codes\":{\"admin_district\":\"E08000025\",\"admin_county\":\"E99999999\",\"admin_ward\":\"E05011154\",\"parish\":\"E43000250\",\"parliamentary_constituency\":\"E14000562\",\"ccg\":\"E38000220\",\"ccg_id\":\"15E\",\"ced\":\"E99999999\",\"nuts\":\"UKG31\",\"lsoa\":\"E01009394\",\"msoa\":\"E02001919\",\"lau2\":\"E05011154\"},\"distance\":0},{\"postcode\":\"B13 9JG\",\"quality\":1,\"eastings\":408838,\"northings\":282962,\"country\":\"England\",\"nhs_ha\":\"West Midlands\",\"longitude\":-1.8714,\"latitude\":52.444553,\"european_electoral_region\":\"West Midlands\",\"primary_care_trust\":\"South Birmingham\",\"region\":\"West Midlands\",\"lsoa\":\"Birmingham 093D\",\"msoa\":\"Birmingham 093\",\"incode\":\"9JG\",\"outcode\":\"B13\",\"parliamentary_constituency\":\"Birmingham, Hall Green\",\"admin_district\":\"Birmingham\",\"parish\":\"Birmingham, unparished area\",\"admin_county\":null,\"admin_ward\":\"Moseley\",\"ced\":null,\"ccg\":\"NHS Birmingham and Solihull\",\"nuts\":\"Birmingham\",\"codes\":{\"admin_district\":\"E08000025\",\"admin_county\":\"E99999999\",\"admin_ward\":\"E05011154\",\"parish\":\"E43000250\",\"parliamentary_constituency\":\"E14000562\",\"ccg\":\"E38000220\",\"ccg_id\":\"15E\",\"ced\":\"E99999999\",\"nuts\":\"UKG31\",\"lsoa\":\"E01009394\",\"msoa\":\"E02001919\",\"lau2\":\"E05011154\"},\"distance\":41.0110341}]}';
            pNearest = Utils_Postcodes_IO_parser.parse( mockJson );
        }

        if ( !Test.isRunningTest() ){           
            //  if this is NOT a test.. make callout to endpoint        
            // ** CALL data provider ** 
            HttpResponse response = http.send(request);
            System.debug('Utils_PcodeGeolocation_callout: Received the following Utils_Postcodes_IO RESPONSE:' + response);
            // ** PARSE REAL RESULT **    
            pNearest = Utils_Postcodes_IO_parser.parse(response.getBody());
            System.debug('Utils_PcodeGeolocation_callout: Received the following Utils_Postcodes_IO BODY:' + pNearest);
        }

        Area_Retrieval_Status__c AreaRecToUpsert = new Area_Retrieval_Status__c();
        Area_Retrieval_Status__c[] AreaListToUpsert = new List<Area_Retrieval_Status__c>();
        Area_Retrieval_Status__c[] ListOfExistingAreas = [SELECT Id, Area__c FROM Area_Retrieval_Status__c WHERE Area__c = :pPostcode];

        string stringOfNearestForAreaRec = '';
        List<String> NearestPostcodesList = new list<string>();  

        if (pNearest != null){
            for (integer i = 1; i < pNearest.Result.size(); i++ ){                  // Skip record with 0 as this is the postcode itself 
                System.debug('Utils_PcodeGeolocation_callout: Received the following Utils_Postcodes_IO RESULT 0:' +pNearest.result[i].postcode +'++'+pNearest.result[i].latitude +'++'+pNearest.result[i].longitude +'++'+pNearest.result[i].distance );
                AreaRecToUpsert = new Area_Retrieval_Status__c();                                 // ensure rec is empty
                AreaRecToUpsert.Name =                                pNearest.result[i].postcode;
                AreaRecToUpsert.Area__c =                             pNearest.result[i].postcode;
                AreaRecToUpsert.Centrepoint_geo__latitude__s =        pNearest.result[i].latitude;      // populating this field also prevents the trigger to search for new neighbours upon creation of Area record
                AreaRecToUpsert.Centrepoint_geo__longitude__s =       pNearest.result[i].longitude;     // populating this field also prevents the trigger to search for new neighbours upon creation of Area record 
                if (pNearest.result[i].region == 'London'){
                    AreaRecToUpsert.Sales_history__c =                24;                               // if London then consider 2 years of sales hstory for valuation purposes                               
                }
                for (Area_Retrieval_Status__c e :ListOfExistingAreas){
                    if (e.Area__c == AreaRecToUpsert.Area__c){AreaRecToUpsert.Id = e.Id;}               // ensure existing records are updated 
                }                
/*              DOUBLE CHECK IF REQUIRED 
                if (AreaRecToUpsert.Id == null){                                                        // only do this when it's a NEW record
                    AreaRecToUpsert.Nearest_postcodes__c =            pNearest.result[i].postcode;      // prevents creating a chain reaction 
                }
*/
                AreaListToUpsert.Add(AreaRecToUpsert);
                stringOfNearestForAreaRec = stringOfNearestForAreaRec + pNearest.result[i].postcode +'_'+pNearest.result[i].distance+'m__';
                NearestPostcodesList.add(pNearest.result[i].postcode);

                System.debug('Utils_PcodeGeolocation_callout: Area to UPSERT:' +AreaRecToUpsert );                
            }
            System.debug('Utils_PcodeGeolocation_callout: AreaListToUpsert (count):' + AreaListToUpsert.size());
            System.debug('Utils_PcodeGeolocation_callout: AreaListToUpsert:' + AreaListToUpsert);

            try {
                upsert AreaListToUpsert;                
            } catch (DmlException e) {
                System.debug('Utils_PcodeGeolocation_callout: AreaListToUpsert UPSERT ERROR: ' + e.getMessage());                
            }
        }

        // ** UPDATE Area_Retrieval record that prompted this call        
        Area_Retrieval_Status__c aUpdate = new Area_Retrieval_Status__c(
            Id = pId,
            Centrepoint_geo__latitude__s = decimal.valueOf( p.Data.latitude),
            Centrepoint_geo__longitude__s = decimal.valueOf( p.Data.longitude),
            Nearest_postcodes__c = stringOfNearestForAreaRec
            );
        System.debug('Utils_PcodeGeolocation_callout: saving Postcode geocode in Area_Retrieval record :' + aUpdate);
 
        try {
            update aUpdate;
        } catch (DmlException e) {
            System.debug('Utils_PcodeGeolocation_callout: aUpdate UPDATE ERROR: ' + e.getMessage());                
        }
        // ** STORE THE RESULT DATA **
        // ***<<**********************


/*
        // ** retrieve the transaction + EPC data for all NEAREST postcodes         
        AsyncApexJob[] LR_TransJobsInFlexQueue = [
            SELECT  ApexClass.Name, Status
            FROM    AsyncApexJob 
            WHERE   apexClass.Name = 'Utils_LR_Transactions_callout'
                AND (JobType='Queueable' AND Status IN ('Processing','Preparing','Queued')) 
            LIMIT 1] ;

        if (LR_TransJobsInFlexQueue.size() == 0){
            ID jobId_1 = system.enqueuejob( new Utils_LR_Transactions_callout (NearestPostcodesList));        
            System.debug('Utils_PcodeGeolocation_callout >> Launching Utils_LR_Transactions_callout  for ' + NearestPostcodesList);
        } else {
            System.debug('Utils_PcodeGeolocation_callout >> NOT launching Utils_LR_Transactions_callout for ' + NearestPostcodesList);
        }
*/


    }

}