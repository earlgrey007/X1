@IsTest
public class Utils_LR_Transactions_parser_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{ \"format\" : \"linked-data-api\", \"version\" : \"0.2\", \"result\" : {\"_about\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_sort=propertyAddress.paon,propertyAddress.saon&_pageSize=2&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=\", \"definition\" : \"https://landregistry.data.gov.uk/meta/data/ppi/transaction-record.json?min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&propertyAddress.town=&transactionDate=&_sort=propertyAddress.paon,propertyAddress.saon&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&max-transactionDate=&_view=address&propertyAddress.street=&type.label=&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&estateType.prefLabel=\", \"extendedMetadataVersion\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_sort=propertyAddress.paon,propertyAddress.saon&_pageSize=2&max-transactionDate=&propertyAddress.street=&type.label=&_metadata=all&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=\", \"first\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_sort=propertyAddress.paon,propertyAddress.saon&_pageSize=2&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=\", \"isPartOf\" : {\"_about\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&propertyAddress.town=&transactionDate=&_sort=propertyAddress.paon,propertyAddress.saon&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&max-transactionDate=&_view=address&propertyAddress.street=&type.label=&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&estateType.prefLabel=\", \"definition\" : \"https://landregistry.data.gov.uk/meta/data/ppi/transaction-record.json?min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&propertyAddress.town=&transactionDate=&_sort=propertyAddress.paon,propertyAddress.saon&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&max-transactionDate=&_view=address&propertyAddress.street=&type.label=&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&estateType.prefLabel=\", \"hasPart\" : \"https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_sort=propertyAddress.paon,propertyAddress.saon&_pageSize=2&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=\", \"type\" : [\"http://purl.org/linked-data/api/vocab#ListEndpoint\"]}'+
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
		Utils_LR_Transactions_parser r = Utils_LR_Transactions_parser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_LR_Transactions_parser.EstateType objEstateType = new Utils_LR_Transactions_parser.EstateType(System.JSON.createParser(json));
		System.assert(objEstateType != null);
		System.assert(objEstateType.x_about == null);
		System.assert(objEstateType.label == null);
		System.assert(objEstateType.prefLabel == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_LR_Transactions_parser.Type_Z objType_Z = new Utils_LR_Transactions_parser.Type_Z(System.JSON.createParser(json));
		System.assert(objType_Z != null);
		System.assert(objType_Z.x_about == null);
		System.assert(objType_Z.label == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_LR_Transactions_parser objUtils_LR_Transactions_parser = new Utils_LR_Transactions_parser(System.JSON.createParser(json));
		System.assert(objUtils_LR_Transactions_parser != null);
		System.assert(objUtils_LR_Transactions_parser.format == null);
		System.assert(objUtils_LR_Transactions_parser.version == null);
		System.assert(objUtils_LR_Transactions_parser.result == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_LR_Transactions_parser.PropertyAddress objPropertyAddress = new Utils_LR_Transactions_parser.PropertyAddress(System.JSON.createParser(json));
		System.assert(objPropertyAddress != null);
		System.assert(objPropertyAddress.x_about == null);
		System.assert(objPropertyAddress.county == null);
		System.assert(objPropertyAddress.district == null);
		System.assert(objPropertyAddress.paon == null);
		System.assert(objPropertyAddress.postcode == null);
		System.assert(objPropertyAddress.saon == null);
		System.assert(objPropertyAddress.street == null);
		System.assert(objPropertyAddress.town == null);
		System.assert(objPropertyAddress.type_Z == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_LR_Transactions_parser.IsPartOf objIsPartOf = new Utils_LR_Transactions_parser.IsPartOf(System.JSON.createParser(json));
		System.assert(objIsPartOf != null);
		System.assert(objIsPartOf.x_about == null);
		System.assert(objIsPartOf.definition == null);
		System.assert(objIsPartOf.hasPart == null);
		System.assert(objIsPartOf.type_Z == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_LR_Transactions_parser.Label objLabel = new Utils_LR_Transactions_parser.Label(System.JSON.createParser(json));
		System.assert(objLabel != null);
		System.assert(objLabel.x_value == null);
		System.assert(objLabel.x_lang == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_LR_Transactions_parser.Items objItems = new Utils_LR_Transactions_parser.Items(System.JSON.createParser(json));
		System.assert(objItems != null);
		System.assert(objItems.x_about == null);
		System.assert(objItems.estateType == null);
		System.assert(objItems.hasTransaction == null);
		System.assert(objItems.newBuild == null);
		System.assert(objItems.pricePaid == null);
		System.assert(objItems.propertyAddress == null);
		System.assert(objItems.propertyType == null);
		System.assert(objItems.recordStatus == null);
		System.assert(objItems.transactionCategory == null);
		System.assert(objItems.transactionDate == null);
		System.assert(objItems.transactionId == null);
		System.assert(objItems.type_Z == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_LR_Transactions_parser.Result objResult = new Utils_LR_Transactions_parser.Result(System.JSON.createParser(json));
		System.assert(objResult != null);
		System.assert(objResult.x_about == null);
		System.assert(objResult.definition == null);
		System.assert(objResult.extendedMetadataVersion == null);
		System.assert(objResult.first == null);
		System.assert(objResult.isPartOf == null);
		System.assert(objResult.items == null);
		System.assert(objResult.itemsPerPage == null);
		System.assert(objResult.next == null);
		System.assert(objResult.page == null);
		System.assert(objResult.startIndex == null);
		System.assert(objResult.type_Z == null);
	}
}