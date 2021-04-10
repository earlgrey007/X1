@IsTest
public class Utils_PcodeGeolocation_parser_Test {
    
    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{\"status\":\"match\",\"match_type\":\"unit_postcode\",\"input\":\"GU35 0GJ\",\"data\":{\"postcode\":\"GU35 0GJ\",\"status\":\"live\",\"usertype\":\"small\",\"easting\":479342,\"northing\":136493,\"positional_quality_indicator\":1,\"country\":\"England\",\"latitude\":\"51.122233\",\"longitude\":\"-0.867680\",\"postcode_no_space\":\"GU350GJ\",\"postcode_fixed_width_seven\":\"GU350GJ\",\"postcode_fixed_width_eight\":\"GU35 0GJ\",\"postcode_area\":\"GU\",\"postcode_district\":\"GU35\",\"postcode_sector\":\"GU35 0\",\"outcode\":\"GU35\",\"incode\":\"0GJ\"},\"copyright\":[\"Contains OS data (c) Crown copyright and database right 2020\",\"Contains Royal Mail data (c) Royal Mail copyright and database right 2020\",\"Contains National Statistics data (c) Crown copyright and database right 2020\"]}';
        Utils_PcodeGeolocation_parser r = Utils_PcodeGeolocation_parser.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        Utils_PcodeGeolocation_parser objPcodeGeolocation_parser = new Utils_PcodeGeolocation_parser(System.JSON.createParser(json));
        System.assert(objPcodeGeolocation_parser != null);
        System.assert(objPcodeGeolocation_parser.status == null);
        System.assert(objPcodeGeolocation_parser.match_type == null);
        System.assert(objPcodeGeolocation_parser.input == null);
        System.assert(objPcodeGeolocation_parser.data == null);
        System.assert(objPcodeGeolocation_parser.copyright == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        Utils_PcodeGeolocation_parser.Data objData = new Utils_PcodeGeolocation_parser.Data(System.JSON.createParser(json));
        System.assert(objData != null);
        System.assert(objData.postcode == null);
        System.assert(objData.status == null);
        System.assert(objData.usertype == null);
        System.assert(objData.easting == null);
        System.assert(objData.northing == null);
        System.assert(objData.positional_quality_indicator == null);
        System.assert(objData.country == null);
        System.assert(objData.latitude == null);
        System.assert(objData.longitude == null);
        System.assert(objData.postcode_no_space == null);
        System.assert(objData.postcode_fixed_width_seven == null);
        System.assert(objData.postcode_fixed_width_eight == null);
        System.assert(objData.postcode_area == null);
        System.assert(objData.postcode_district == null);
        System.assert(objData.postcode_sector == null);
        System.assert(objData.outcode == null);
        System.assert(objData.incode == null);
    }
}