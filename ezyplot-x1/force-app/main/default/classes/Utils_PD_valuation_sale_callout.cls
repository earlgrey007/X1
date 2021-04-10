public with sharing class Utils_PD_valuation_sale_callout implements Queueable, Database.AllowsCallouts {

    private ID pId;
    private string pPostcode;
    private String pArea; 
    private String pType;
    private String pDate;
    private String pBeds;
    private String pBaths;
    private String pOutdoor;
    private String pParking;

    public Utils_PD_Valuation_sale_callout( Id p_Id, 
        String p_Postcode,
        String p_Area, 
        String p_Type,
        String p_Date,
        String p_Beds,
        String p_Baths,
        String p_Outdoor,
        String p_Parking
        ){

        this.pId = p_Id;
        this.pPostcode = p_Postcode;
        this.pArea = p_Area; 
        this.pType = p_Type;
        this.pDate = p_Date;
        this.pBeds = p_Beds;
        this.pBaths = p_Baths;
        this.pOutdoor = p_Outdoor;
        this.pParking =p_Parking;

    }

    public void execute (QueueableContext context){
        system.debug('Utils_PD_Valuation_sale_callout: APEX param received: >> '+pId+','+pPostcode);
            
        // ***>>*******************
        // ** call data provider **
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        // ** SET HEADERS & ENDPOINT *** 
        request.setMethod('GET');
        
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
        System.debug('Utils_PD_Valuation_sale_callout: calling URL >> ' + url);

        // fill reponse.getbody() with a MOCK response for testing purposes

        String mockJson = '{'+
		'  \"status\": \"success\",'+
		'  \"postcode\": \"OX4 1YB\",'+
		'  \"postcode_type\": \"full\",'+
		'  \"params\": {'+
		'    \"property_type\": \"Flat\",'+
		'    \"construction_date\": \"Pre-1914\",'+
		'    \"internal_area\": \"828\",'+
		'    \"bedrooms\": \"3\",'+
		'    \"bathrooms\": \"1\",'+
		'    \"finish_quality\": \"Below average\",'+
		'    \"outdoor_space\": \"Garden\",'+
		'    \"off_street_parking\": \"0 spaces\"'+
		'  },'+
		'  \"result\": {'+
		'    \"estimate\": 390000,'+
		'    \"margin\": 20000'+
		'  },'+
		'  \"process_time\": \"0.40\"'+
		'}';

        Utils_PD_Valuation_sale_parser r = Utils_PD_Valuation_sale_parser.parse( mockJson );

        if ( !Test.isRunningTest() ){           
            //  if this is NOT a test.. make callout to endpoint
        
            // ** CALL data provider ** 
            HttpResponse response = http.send(request);
            System.debug('Utils_PD_Valuation_sale_callout: Received the following response:' + response);

            // ***>>**********************
            // ** STORE THE RESULT DATA **

            // this lead rec initiated the callout
            Lead a = new Lead( Id = pId);

            if (response.getStatusCode() != 200){
                a.Callout_buffer__c = 'PD valuation result: '+ response.getStatus();
                } 
            else {
                // ** PARSE REAL RESULT **    
                r = Utils_PD_Valuation_sale_parser.parse(response.getBody());
                a.Callout_buffer__c = 'PD valuation result: '+ r.status;
                a.OMV_long_lease__c = r.result.estimate;
                }

            System.debug('Utils_PD_Valuation_sale_callout: saving data in LEAD record :' + a);                                            
            update a;

            // ** STORE THE RESULT DATA **
            // ***<<**********************

        }

    }

}