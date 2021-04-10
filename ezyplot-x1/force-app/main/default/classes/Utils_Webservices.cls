public with sharing class Utils_Webservices {
    public Utils_Webservices() {
    }

/*
    ** overview of ALL methods below: **
    public static void getLR_Trans_Data( Id Pid, String pPostcode){
    public static void getEPC_Data( Id pId, String pPostcode){
    public static void PD_Planning_callout( Id Id, String pPostcode){
    public static void getPD_Ask Data( Id Id, String pPostcode){    // TODO
*/


    // *** >> *************************************************************************************************************
    //                                              ** LR TRANSACTION DATA  ** 

    @future (callout=true)
    public static void getLR_Trans_Data( Id Pid, String pPostcode){
        system.debug('getLR_Trans_Data: APEX param received: >> '+pId+','+pPostcode);
            
        // ***>>*******************
        // ** call data provider **
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        // ** SET HEADERS & ENDPOINT *** 
        request.setMethod('GET');
    
        // 
        string url = 'https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_pageSize=50&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=1900-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon' 
                        + '&'+'propertyAddress.postcode=' + pPostcode.replace(' ','+');     // changes format to SE18+6FY 

        request.setEndpoint(url);
        System.debug('getLR_Trans_Data: calling URL >> ' + url);
    
        // ** MAKE CALL *** 
        HttpResponse response = http.send(request);
        System.debug('getLR_Trans_Data: Received the following response:' + response);
        // System.debug('getLR_Trans_Data: Received the following response body:' + response.getbody());
    
        // ** call data provider **
        // ***<<*******************
    
        // ***>>*****************
        // ** PARSE THE RESULT **
    
        Utils_LR_Transactions_parser p = Utils_LR_Transactions_parser.parse(response.getBody());
        // System.debug('getLR_Trans_Data: parsed LR_Trans_Data values :' + p);
    
        // ** PARSE THE RESULT **
        // ***<<*****************

        // ***>>**********************
        // ** STORE THE RESULT DATA **

        // SAVE PARSED RESULT IN Land_Registry_transaction__c records ** 
        string saveResult = Utils_SaveData.save_LR_Transaction_Data( pId, pPostcode, p);
        System.debug('getLR_Trans_Data: saved LR Transactions with link to Area_Retrieval :' + saveResult);

        // ** STORE THE RESULT DATA **
        // ***<<**********************

        // ** UPDATE Area_Retrieval record that prompted this call        
        Area_Retrieval_Status__c[] a = [SELECT Id, LR_Trans_Data_Retrieval_result_buffer__c, LR_Trans_Data_Last_retrieved__c 
                                            FROM Area_Retrieval_Status__c where Id = :pId limit 1];
        System.debug('getLR_Trans_Data: a :' + a);
                                            
        for(Area_Retrieval_Status__c x: a){
            System.debug('getLR_Trans_Data: x :' + x);
                x.LR_Trans_Data_Last_retrieved__c = date.today();
                x.LR_Trans_Data_Retrieval_result_buffer__c = saveResult;
                update a;
        }        

        // get EPC data as a batch child process
        System.debug('getLR_Trans_Data >> Queueing Utils_EPC_Domestic__callout..' );
//        system.enqueuejob(new Utils_EPC_Domestic__callout (pId, pPostcode));        

    // NOTES:        
    // use          https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_pageSize=50&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon
    // next page    https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=1&propertyAddress.town=&_pageSize=50&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon

    }

    //                                              **  LR TRANSACTION DATA ** 
    // *** << *************************************************************************************************************



    // *** >> *************************************************************************************************************
    //                                                  **  EPC DATA   ** 

    @future (callout=true) 
    public static void getEPC_Data(Id pId, String pPostcode){
        system.debug('getEPCdata: APEX param received: >> '+pId);

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
                        + '?'+'from-year=2014'              // default = from 2008
                        + '&'+'postcode=' + pPostcode.replace(' ','')
                        + '&'+'size=3000'
                        ;
        request.setEndpoint(url);

        // ** MAKE CALL *** 
        HttpResponse response = http.send(request);
        System.debug('getEPCdata: Received the following response:' + response);

        // ** call data provider **
        // ***<<******************* 



        // ***>>*****************
        // ** PARSE THE RESULT **

        Utils_EPC_Domestic_parser p = Utils_EPC_Domestic_parser.parse(response.getBody());
        System.debug('getEPC_Data: parsed EPC_Data values :' + p);

        // ** PARSE THE RESULT **
        // ***<<*****************


        // ***>>**********************
        // ** STORE THE RESULT DATA **

        string saveResult = Utils_SaveData.save_EPC_Data( pId, pPostcode, p );
        System.debug('getEPC_Data: saved EPC recs with link to Area_Retrieval :' + saveResult);

        // ** UPDATE Area_Retrieval record that prompted this call        
        Area_Retrieval_Status__c[] b = [SELECT Id, EPC_Data_Retrieval_result_buffer__c, EPC_Data_Last_retrieved__c 
                                            FROM Area_Retrieval_Status__c where Id = :pId limit 1];
        System.debug('get_EPC_Data_Data: b :' + b);
                                            
        for(Area_Retrieval_Status__c x: b){
            System.debug('get_EPC_Data_Data: x :' + x);
                x.EPC_Data_Last_retrieved__c = date.today();
                x.EPC_Data_Retrieval_result_buffer__c = saveResult;
                update b;
        }


    // for later release:
    // send message saying 'x EPC records updated' to e.OwnerId
    // 
    // **  WRAP UP   ** 
    // ****************
    
    }    

    //                                                  **  EPC DATA   ** 
    // *** << *************************************************************************************************************


    /* 27 MAR 2021: PLANNING was moved to its own seperate class 

    // *** >> *************************************************************************************************************
    //                                        **  PD PLANNING DATA ** 

    @future (callout=true) 
    public static void PD_Planning_callout( Id Pid, String pPostcode){
        system.debug('PD_Planning_callout: APEX param received: >> '+pId+','+pPostcode);
                
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        // ** SET HEADERS & ENDPOINT *** 
        request.setMethod('GET');
        string url = 'https://api.propertydata.co.uk/planning?key=9JWMLFUXLT&decision_rating=positive' 
                    + '&'+'postcode=' + pPostcode.replace(' ','+');
                    request.setEndpoint(url);
        System.debug('PD_Planning_callout: calling URL >> ' + url);
    
        // ** MAKE CALL *** 
        HttpResponse response = http.send(request);
        System.debug('PD_Planning_callout: Received the following response:' + response);
        System.debug('PD_Planning_callout: Received the following response body:' + response.getbody());
    
        // **********************
        // ** PARSE THE RESULT **
        Utils_PD_Planning_Parser p = Utils_PD_Planning_Parser.parse(response.getBody());
        System.debug('PD_Planning_callout: parsed Planning values :' + p);
    
        string saveResult='';    
        if (p.status == 'error'){
            saveResult = p.status + ' ' + p.code +': '+ p.message;
            } 
        else {
            // ** SAVE PARSED RESULT IN RELATED Planning List ** 
            saveResult = Utils_SaveData.save_PlanningData( pId, pPostcode, p );
            System.debug('PD_Planning_callout: saved Planning applications with link to Area_Retrieval :' + saveResult);
        }
    
        // ** UPDATE Area_Retrieval record that prompted this call        
        Area_Retrieval_Status__c[] a = [SELECT Id, Planning_Retrieval_result_buffer__c, Planning_Last_retrieved__c 
                                            FROM Area_Retrieval_Status__c where Id = :pId limit 1];
        System.debug('PD_Planning_callout: a :' + a);
                                            
        for(Area_Retrieval_Status__c x: a){
            System.debug('PD_Planning_callout: x :' + x);
                x.Planning_Last_retrieved__c = date.today();
                x.Planning_Retrieval_result_buffer__c = saveResult;
                update a;
        }
    
        // for later release:
        // send message saying 'x Planning records updated' to e.OwnerId
        System.debug('PD_Planning_callout: Planning records retrieved for :' + pPostcode);
        // **  WRAP UP   ** 
        // ****************
    }    
        //                                        **  PD PLANNING DATA ** 
        // *** << *************************************************************************************************************

    /* << 27 MAR 2021: PLANNING moved to its own seperate class */
        
    

    // *** >> *************************************************************************************************************
    //                                                  **  ASK DATA  ** 

    @future (callout=true) 
    public static void getPD_Ask_Data( Id Pid, String pPostcode){
        system.debug('getPD_Ask_Data: APEX param received: >> '+pId+','+pPostcode);
                
        // ***>>*******************
        // ** call data provider **

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // ** SET HEADERS & ENDPOINT *** 
        request.setMethod('GET');

        // 
        string url = 'https://api.propertydata.co.uk/prices?key=9JWMLFUXLT&points=100' 
                        + '&postcode=' + pPostcode ;
        request.setEndpoint(url);
        System.debug('getPD_Ask_Data: calling URL >> ' + url);

        // ** MAKE CALL *** 
        HttpResponse response = http.send(request);
        System.debug('getPD_Ask_Data: Received the following response:' + response);
        System.debug('getPD_Ask_Data: Received the following response body:' + response.getbody());

        // ** call data provider **
        // ***<<*******************

        // ***>>*****************
        // ** PARSE THE RESULT **

        Utils_PD_Ask_Parser p = Utils_PD_Ask_Parser.parse(response.getBody());
        System.debug('getPD_Ask_Data: parsed PD_AskData values :' + p);

        // ** PARSE THE RESULT **
        // ***<<*****************


        // ***>>**********************
        // ** STORE THE RESULT DATA **

        string errmsg = '';
        if (p.status == 'error'){
            errmsg = p.status + ' ' + p.code +': '+ p.message;
            } 

        string saveResult='';    
        if (errmsg == ''){
            // ** SAVE PARSED RESULT IN RELATED PD_AskData List ** 
            saveResult = Utils_SaveData.save_PD_Ask_Data( pId, pPostcode, p );
            // ++ System.debug('getPD_Ask_Data: saved PD_AskData applications with link to Area_Retrieval :' + saveResult);
        }

        // ** UPDATE Area_Rtrieval record that prompted this call        
        Area_Retrieval_Status__c a = [SELECT Id, PD_Ask_Data_Retrieval_result_buffer__c, PD_Ask_Data_Last_retrieved__c 
                                            FROM Area_Retrieval_Status__c where Id = :pId LIMIT 1];
        // ++ System.debug('getPD_Ask_Data: about to update calling record :' + pId + ' with ' + p.data.RawData.size() +' PD_Ask_Data ' );
        
        if (a != null){
            if (errmsg==''){
                a.PD_Ask_Data_Last_retrieved__c = date.today();
                a.PD_Ask_Data_Retrieval_result_buffer__c = saveResult;
            } else {
                a.PD_Ask_Data_Retrieval_result_buffer__c = errmsg;
            }
        } else {
            a.PD_Ask_Data_Retrieval_result_buffer__c = 'No PD_AskData records found. Please verify Postcode' ;
        }
        update a;

        // for later release:
        // send message saying 'x ASK records updated' to e.OwnerId
        // 
        // **  WRAP UP   ** 
        // ****************
        }    
    //                                                  **  ASK DATA  ** 
    // *** << *************************************************************************************************************

    // *** >> *************************************************************************************************************
    //                                                  **  GET GEOCODE    ** 

    @future (callout=true) 
    public static void getGeocode_Data(Id pId, String pPostcode){
        system.debug('getGeocodedata: APEX param received: >> '+pId);

        // ***>>*******************
        // ** call data provider **
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // ** SET HEADERS *** 
        request.setMethod('GET');

        // ** SET ENDPOINT *** 
        String url ='http://api.getthedata.com/postcode/'
                        + pPostcode
                        ;
        request.setEndpoint(url);

        // ** MAKE CALL *** 
        HttpResponse response = http.send(request);
        System.debug('getGeocodedata: Received the following response:' + response);

        // ** call data provider **
        // ***<<******************* 



        // ***>>*****************
        // ** PARSE THE RESULT **

        Utils_GetGeocode_parser p = Utils_GetGeocode_parser.parse(response.getBody());
        System.debug('getGeocode_Data: parsed Geocode_Data values :' + p);

        // ** PARSE THE RESULT **
        // ***<<*****************


        // ***>>**********************
        // ** STORE THE RESULT DATA **

/*
        string saveResult = Utils_SaveData.save_Geocode_Data( pId, pPostcode, p );
        System.debug('getGeocode_Data: saved Geocode recs with link to Area_Retrieval :' + saveResult);

        // ** UPDATE Area_Retrieval record that prompted this call        
        Area_Retrieval_Status__c[] b = [SELECT Id, Centerpoint_Lat_in__c, Centerpoint_Lng_in__c FROM Area_Retrieval_Status__c where Id = :pId limit 1];

        System.debug('get_Geocode_Data: b :' + b);
                                            
        for(Area_Retrieval_Status__c x: b){
            System.debug('get_Geocode_Data: x :' + x);
                x.Centerpoint_Lat_in__c = p.data[0].latitude;
                x.Centerpoint_Lng_in__c = p.data[0].longitude;
                update b;
        }
*/

        // for later release:
        // send message saying 'x Geocode records updated' to e.OwnerId
        // 
        // **  WRAP UP   ** 
        // ****************
        
    }    

    /* 27 MAR 2021: movd int its own seperaate class 

        // *** >> *************************************************************************************************************
        //                                                  **  PD VALUATION SALE  ** 

        @future (callout=true) 
        public static void getPD_Valuation_sale_Data( Id Pid, 
            String pPostcode,
            String pArea, 
            String pType,
            String pDate,
            String pBeds,
            String pBaths,
            String pOutdoor,
            String pParking
            ){

            system.debug('getPD_Valuation_sale_Data: APEX param received: >> '+pId
                + ',' +pPostcode
                + ',' +pArea, 
                + ',' +pType,
                + ',' +pDate,
                + ',' +pBeds,
                + ',' +pBaths,
                + ',' +pOutdoor,
                + ',' +pParking
            );
                    
            // ***>>*******************
            // ** call data provider **
        
            Http http = new Http();
            HttpRequest request = new HttpRequest();
        
            // ** SET HEADERS & ENDPOINT *** 
            request.setMethod('GET');
        
            // https://api.propertydata.co.uk/valuation-sale?key=9JWMLFUXLT&postcode=OX41YB&internal_area=828&property_type=flat&construction_date=pre_1914&bedrooms=3&bathrooms=1&finish_quality=below_average&outdoor_space=garden&off_street_parking=0 
            //
            string url = 'https://api.propertydata.co.uk/valuation-sale?key=9JWMLFUXLT' 
                + '&postcode=' + pPostcode 
                + '&internal_area=' + pArea 
                + '&property_type=' + pType
                + '&construction_date=' + pDate
                + '&bedrooms=' + pBeds
                + '&bathrooms=' + pBaths
                + '&finish_quality=Average'
                + '&outdoor_space=' + pOutdoor
                + '&off_street_parking=' + pParking
                ;


            request.setEndpoint(url);
            System.debug('getPD_Valuation_sale_Data: calling URL >> ' + url);
        
            // ** MAKE CALL *** 
            HttpResponse response = http.send(request);
            System.debug('getPD_Valuation_sale_Data: Received the following response:' + response);
            System.debug('getPD_Valuation_sale_Data: Received the following response body:' + response.getbody());
        
            // ** call data provider **
            // ***<<*******************
        
            // ***>>*****************
            // ** PARSE THE RESULT **
        
            Utils_PD_Ask_Parser p = Utils_Valuation_sale_Parser.parse(response.getBody());
            System.debug('getPD_Valuation_saleData: parsed PD_Valuation_sale_Data values :' + p);
        
            // ** PARSE THE RESULT **
            // ***<<*****************
        
        
            // ***>>**********************
            // ** STORE THE RESULT DATA **
        
            string errmsg = '';
            if (p.status == 'error'){
                errmsg = p.status + ' ' + p.code +': '+ p.message;
                } 
        
            string saveResult='';    
            if (errmsg == ''){
                // ** SAVE PARSED RESULT  ** 
                saveResult = Utils_SaveData.save_PD_Valuation_sale_Data( pId, pPostcode, p );
                // ++ System.debug('getPD_Valuation_sale_Data: saved PD_Valuation_sale_Data applications with link to Area_Retrieval :' + saveResult);
            }

        // !! NEEDS TO CHANGE
            // ** UPDATE Area_Rtrieval record that prompted this call        
            Area_Retrieval_Status__c a = [SELECT Id, PD_Valuation_sale_Data_Retrieval_result_buffer__c, PD_Valuation_sale_Data_Last_retrieved__c 
                                                FROM Area_Retrieval_Status__c where Id = :pId LIMIT 1];
            // ++ System.debug('getPD_Valuation_sale_Data: about to update calling record :' + pId + ' with ' + p.data.RawData.size() +' PD_Valuation_sale_Data ' );
            
            if (a != null){
                if (errmsg==''){
                    a.PD_Valuation_sale_Data_Last_retrieved__c = date.today();
                    a.PD_Valuation_sale_Data_Retrieval_result_buffer__c = saveResult;
                } else {
                    a.PD_Valuation_sale_Data_Retrieval_result_buffer__c = errmsg;
                }
            } else {
                a.PD_Valuation_sale_Data_Retrieval_result_buffer__c = 'No PD_AskData records found. Please verify Postcode' ;
            }
            update a;
        
        }    
        //                                                  **  PD VALUATION SALE  ** 
        // *** << *************************************************************************************************************
    
    /* 27 MAR 2021: movd int its own seperaate class */









}
