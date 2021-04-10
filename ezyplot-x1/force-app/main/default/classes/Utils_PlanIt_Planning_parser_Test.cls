@isTest
private class Utils_PlanIt_Planning_parser_Test{
  
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
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
		'        }, '+
		'        {'+
		'            \"address\": \"LAND REAR OF SCOUT HALL, WAVERLEY CRESCENT FRONTING DURHAM RISE, PLUMSTEAD, LONDON, SE18 7QT\", '+
		'            \"altid\": null, '+
		'            \"app_size\": \"Medium\", '+
		'            \"app_state\": \"Permitted\", '+
		'            \"app_type\": \"Full\", '+
		'            \"associated_id\": \"1-bed\", '+
		'            \"authority_id\": 304, '+
		'            \"authority_name\": \"Greenwich\", '+
		'            \"consulted_date\": null, '+
		'            \"decided_date\": \"2018-10-04\", '+
		'            \"description\": \"Construction of a 2 storey residential dwelling (1 x 1-bed ).\", '+
		'            \"distance\": 0.994, '+
		'            \"lat\": 51.484602, '+
		'            \"link\": \"https://www.planit.org.uk/planapplic/Greenwich/18/2578/F/\", '+
		'            \"lng\": 0.082392, '+
		'            \"name\": \"Greenwich/18/2578/F\", '+
		'            \"postcode\": \"SE18 7QT\", '+
		'            \"rec_type\": \"PlanApplic\", '+
		'            \"reference\": null, '+
		'            \"source_url\": \"https://planning.royalgreenwich.gov.uk/online-applications/search.do?action=advanced\", '+
		'            \"start_date\": \"2018-07-25\", '+
		'            \"uid\": \"18/2578/F\", '+
		'            \"url\": \"https://planning.royalgreenwich.gov.uk/online-applications/applicationDetails.do?activeTab=summary&keyVal=_GRNW_DCAPR_95113\", '+
		'            \"when_updated\": \"2020-03-27T21:49:26.687000+00:00\"'+
		'        }'+
		'    ], '+
		'    \"secs_taken\": 0.98, '+
		'    \"total\": 464'+
		'}';
		Utils_PlanIt_Planning_parser r = Utils_PlanIt_Planning_parser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_PlanIt_Planning_parser objUtils_PlanIt_Planning_parser = new Utils_PlanIt_Planning_parser(System.JSON.createParser(json));
		System.assert(objUtils_PlanIt_Planning_parser != null);
		System.assert(objUtils_PlanIt_Planning_parser.count == null);
		System.assert(objUtils_PlanIt_Planning_parser.detail == null);
		System.assert(objUtils_PlanIt_Planning_parser.limit_Z == null);
		System.assert(objUtils_PlanIt_Planning_parser.msg == null);
		System.assert(objUtils_PlanIt_Planning_parser.offset == null);
		System.assert(objUtils_PlanIt_Planning_parser.page_size == null);
		System.assert(objUtils_PlanIt_Planning_parser.records == null);
		System.assert(objUtils_PlanIt_Planning_parser.secs_taken == null);
		System.assert(objUtils_PlanIt_Planning_parser.total == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Utils_PlanIt_Planning_parser.Records objRecords = new Utils_PlanIt_Planning_parser.Records(System.JSON.createParser(json));
		System.assert(objRecords != null);
		System.assert(objRecords.address == null);
		System.assert(objRecords.altid == null);
		System.assert(objRecords.app_size == null);
		System.assert(objRecords.app_state == null);
		System.assert(objRecords.app_type == null);
		System.assert(objRecords.associated_id == null);
		System.assert(objRecords.authority_id == null);
		System.assert(objRecords.authority_name == null);
		System.assert(objRecords.consulted_date == null);
		System.assert(objRecords.decided_date == null);
		System.assert(objRecords.description == null);
		System.assert(objRecords.distance == null);
		System.assert(objRecords.lat == null);
		System.assert(objRecords.link == null);
		System.assert(objRecords.lng == null);
		System.assert(objRecords.name == null);
		System.assert(objRecords.postcode == null);
		System.assert(objRecords.rec_type == null);
		System.assert(objRecords.reference == null);
		System.assert(objRecords.source_url == null);
		System.assert(objRecords.start_date == null);
		System.assert(objRecords.uid == null);
		System.assert(objRecords.url == null);
		System.assert(objRecords.when_updated == null);
	}
}