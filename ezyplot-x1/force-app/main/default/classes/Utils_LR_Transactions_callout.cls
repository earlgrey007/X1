public class Utils_LR_Transactions_callout implements Queueable, Database.AllowsCallouts {

    private ID pId;
    private string pPostcode;
    private list<string> pAreaList;
    
    public Utils_LR_Transactions_callout ( list<string> p_AreaList ) {
        this.pAreaList = p_AreaList;
    }

    public void execute (QueueableContext context){
        system.debug('Utils_LR_Transactions_callout : APEX param received: >> '+pAreaList);

            // ***>>*******************
            // ** call data provider **
        
            Http http = new Http();
            HttpRequest request = new HttpRequest();
        
            // ** SET HEADERS & ENDPOINT *** 
            request.setMethod('GET');
        
            // 
            string url = 'https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_pageSize=500&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=1900-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon,transactionDate' 
                            + '&'+'propertyAddress.postcode=' + pAreaList[0].replace(' ','+');     // changes format to SE18+6FY 

            request.setEndpoint(url);
            System.debug('Utils_LR_Transactions_callout : calling URL >> ' + request);

            // fill reponse.getbody() with a MOCK response for testing purposes
            String mockJson = '{ \"format\" : \"linked-data-api\", \"version\" : \"0.2\", \"result\" : {\"_about\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_sort=propertyAddress.paon,propertyAddress.saon&_pageSize=2&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=\", \"definition\" : \"https://landregistry.data.gov.uk/meta/data/ppi/transaction-record.json?min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&propertyAddress.town=&transactionDate=&_sort=propertyAddress.paon,propertyAddress.saon&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&max-transactionDate=&_view=address&propertyAddress.street=&type.label=&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&estateType.prefLabel=\", \"extendedMetadataVersion\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_sort=propertyAddress.paon,propertyAddress.saon&_pageSize=2&max-transactionDate=&propertyAddress.street=&type.label=&_metadata=all&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=\", \"first\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_sort=propertyAddress.paon,propertyAddress.saon&_pageSize=2&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=\", \"isPartOf\" : {\"_about\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&propertyAddress.town=&transactionDate=&_sort=propertyAddress.paon,propertyAddress.saon&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&max-transactionDate=&_view=address&propertyAddress.street=&type.label=&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&estateType.prefLabel=\", \"definition\" : \"https://landregistry.data.gov.uk/meta/data/ppi/transaction-record.json?min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&propertyAddress.town=&transactionDate=&_sort=propertyAddress.paon,propertyAddress.saon&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&max-transactionDate=&_view=address&propertyAddress.street=&type.label=&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&estateType.prefLabel=\", \"hasPart\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_sort=propertyAddress.paon,propertyAddress.saon&_pageSize=2&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=\", \"type\" : [\"http://purl.org/linked-data/api/vocab#ListEndpoint\"]}'+
            '    , \"items\" : [{\"_about\" : \"http://landregistry.data.gov.uk/data/ppi/transaction/5F54B81D-CA66-2B45-E053-6B04A8C01FB0/current\", \"estateType\" : {\"_about\" : \"http://landregistry.data.gov.uk/def/common/leasehold\", \"label\" : [{\"_value\" : \"Leasehold\", \"_lang\" : \"en\"}'+
            '        ], \"prefLabel\" : [{\"_value\" : \"Leasehold\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      , \"hasTransaction\" : \"http://landregistry.data.gov.uk/data/ppi/transaction/5F54B81D-CA66-2B45-E053-6B04A8C01FB0\", \"newBuild\" : true, \"pricePaid\" : 557100, \"propertyAddress\" : {\"_about\" : \"http://landregistry.data.gov.uk/data/ppi/address/4bc24647d02444713a863178f83f78d3d1d3909f\", \"county\" : \"GREATER LONDON\", \"district\" : \"GREENWICH\", \"paon\" : \"DUNCOMBE HOUSE, 15\", \"postcode\" : \"SE18 6FY\", \"saon\" : \"FLAT 1\", \"street\" : \"VICTORY PARADE\", \"town\" : \"LONDON\", \"type\" : [\"http://landregistry.data.gov.uk/def/common/BS7666Address\"]}'+
            '      , \"propertyType\" : {\"_about\" : \"http://landregistry.data.gov.uk/def/common/flat-maisonette\", \"label\" : [{\"_value\" : \"Flat-maisonette\", \"_lang\" : \"en\"}'+
            '        ], \"prefLabel\" : [{\"_value\" : \"flat-maisonette\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      , \"recordStatus\" : {\"_about\" : \"http://landregistry.data.gov.uk/def/ppi/add\", \"label\" : [{\"_value\" : \"Add\", \"_lang\" : \"en\"}'+
            '        ], \"prefLabel\" : [{\"_value\" : \"Add\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      , \"transactionCategory\" : {\"_about\" : \"http://landregistry.data.gov.uk/def/ppi/standardPricePaidTransaction\", \"label\" : [{\"_value\" : \"Standard price paid transaction\", \"_lang\" : \"en\"}'+
            '        ], \"prefLabel\" : [{\"_value\" : \"Standard price paid transaction\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      , \"transactionDate\" : \"Thu, 06 Jul 2017\", \"transactionId\" : \"5F54B81D-CA66-2B45-E053-6B04A8C01FB0\", \"type\" : [{\"_about\" : \"http://landregistry.data.gov.uk/def/ppi/TransactionRecord\", \"label\" : [{\"_value\" : \"TransactionRecord\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      ]}'+
            '    , {\"_about\" : \"http://landregistry.data.gov.uk/data/ppi/transaction/5F54B81D-C918-2B45-E053-6B04A8C01FB0/current\", \"estateType\" : {\"_about\" : \"http://landregistry.data.gov.uk/def/common/leasehold\", \"label\" : [{\"_value\" : \"Leasehold\", \"_lang\" : \"en\"}'+
            '        ], \"prefLabel\" : [{\"_value\" : \"Leasehold\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      , \"hasTransaction\" : \"http://landregistry.data.gov.uk/data/ppi/transaction/5F54B81D-C918-2B45-E053-6B04A8C01FB0\", \"newBuild\" : true, \"pricePaid\" : 320000, \"propertyAddress\" : {\"_about\" : \"http://landregistry.data.gov.uk/data/ppi/address/4cfe0473cc3300987651419b6c4c43ae7419e12b\", \"county\" : \"GREATER LONDON\", \"district\" : \"GREENWICH\", \"paon\" : \"DUNCOMBE HOUSE, 15\", \"postcode\" : \"SE18 6FY\", \"saon\" : \"FLAT 10\", \"street\" : \"VICTORY PARADE\", \"town\" : \"LONDON\", \"type\" : [\"http://landregistry.data.gov.uk/def/common/BS7666Address\"]}'+
            '      , \"propertyType\" : {\"_about\" : \"http://landregistry.data.gov.uk/def/common/flat-maisonette\", \"label\" : [{\"_value\" : \"Flat-maisonette\", \"_lang\" : \"en\"}'+
            '        ], \"prefLabel\" : [{\"_value\" : \"flat-maisonette\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      , \"recordStatus\" : {\"_about\" : \"http://landregistry.data.gov.uk/def/ppi/add\", \"label\" : [{\"_value\" : \"Add\", \"_lang\" : \"en\"}'+
            '        ], \"prefLabel\" : [{\"_value\" : \"Add\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      , \"transactionCategory\" : {\"_about\" : \"http://landregistry.data.gov.uk/def/ppi/standardPricePaidTransaction\", \"label\" : [{\"_value\" : \"Standard price paid transaction\", \"_lang\" : \"en\"}'+
            '        ], \"prefLabel\" : [{\"_value\" : \"Standard price paid transaction\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      , \"transactionDate\" : \"Tue, 04 Jul 2017\", \"transactionId\" : \"5F54B81D-C918-2B45-E053-6B04A8C01FB0\", \"type\" : [{\"_about\" : \"http://landregistry.data.gov.uk/def/ppi/TransactionRecord\", \"label\" : [{\"_value\" : \"TransactionRecord\", \"_lang\" : \"en\"}'+
            '        ]}'+
            '      ]}'+
            '    ], \"itemsPerPage\" : 2, \"next\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=1&propertyAddress.town=&_sort=propertyAddress.paon,propertyAddress.saon&_pageSize=2&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=\", \"page\" : 0, \"startIndex\" : 1, \"type\" : [\"http://purl.org/linked-data/api/vocab#Page\"]}'+
            '}';
            Utils_LR_Transactions_parser p = Utils_LR_Transactions_parser.parse( mockJson );

            if ( !Test.isRunningTest() ){           
                //  if this is NOT a test.. make callout to endpoint
            
                // ** CALL data provider ** 
                HttpResponse response = http.send(request);
                System.debug('Utils_LR_Transactions_callout : Received the following response:' + response);
                // System.debug('Utils_LR_Transactions_callout: Received the following response body:' + response.getbody());
                
                // ** PARSE REAL RESULT **    
                p = Utils_LR_Transactions_parser.parse(response.getBody());
                System.debug('Utils_LR_Transactions_callout : parsed LR_Trans_Data values :' + p);
            }

            // ***>>**********************
            // ** STORE THE RESULT DATA **

            // SAVE PARSED RESULT IN Land_Registry_transaction__c records ** 
            string saveResult = Utils_SaveData.save_LR_Transaction_Data( pAreaList[0], p);
            System.debug('Utils_LR_Transactions_callout : saved LR Transactions with link to Area_Retrieval :' + saveResult);

             // get EPC data as a batch child process- ENSURE this also loops through ALL nearest postcodes
            ID jobId = system.enqueuejob(new Utils_EPC_Domestic_callout (pAreaList));
            System.debug('Utils_LR_Transactions_callout : launching Utils_callouts_EPC_Domestic ['+ pAreaList[0] +'] with arealist ['+ pAreaList.size());

// NOTES:        
    // use          https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_pageSize=50&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon
    // next page    https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=1&propertyAddress.town=&_pageSize=50&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon

    }

}