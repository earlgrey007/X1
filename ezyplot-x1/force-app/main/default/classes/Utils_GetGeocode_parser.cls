public with sharing class Utils_GetGeocode_parser {


    // for a SAMPLE of the json output : bottom of this code 

	public String status {get;set;} 
	public String match_type {get;set;} 
	public String input {get;set;} 
	public Data data {get;set;} 
	public List<String> copyright {get;set;} 

	public Utils_GetGeocode_parser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'status') {
						status = parser.getText();
					} else if (text == 'match_type') {
						match_type = parser.getText();
					} else if (text == 'input') {
						input = parser.getText();
					} else if (text == 'data') {
						data = new Data(parser);
					} else if (text == 'copyright') {
						copyright = arrayOfString(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Data {
		public String postcode {get;set;} 
		public String status {get;set;} 
		public String usertype {get;set;} 
		public Integer easting {get;set;} 
		public Integer northing {get;set;} 
		public Integer positional_quality_indicator {get;set;} 
		public String country {get;set;} 
		public String latitude {get;set;} 
		public String longitude {get;set;} 
		public String postcode_no_space {get;set;} 
		public String postcode_fixed_width_seven {get;set;} 
		public String postcode_fixed_width_eight {get;set;} 
		public String postcode_area {get;set;} 
		public String postcode_district {get;set;} 
		public String postcode_sector {get;set;} 
		public String outcode {get;set;} 
		public String incode {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'postcode') {
							postcode = parser.getText();
						} else if (text == 'status') {
							status = parser.getText();
						} else if (text == 'usertype') {
							usertype = parser.getText();
						} else if (text == 'easting') {
							easting = parser.getIntegerValue();
						} else if (text == 'northing') {
							northing = parser.getIntegerValue();
						} else if (text == 'positional_quality_indicator') {
							positional_quality_indicator = parser.getIntegerValue();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'latitude') {
							latitude = parser.getText();
						} else if (text == 'longitude') {
							longitude = parser.getText();
						} else if (text == 'postcode_no_space') {
							postcode_no_space = parser.getText();
						} else if (text == 'postcode_fixed_width_seven') {
							postcode_fixed_width_seven = parser.getText();
						} else if (text == 'postcode_fixed_width_eight') {
							postcode_fixed_width_eight = parser.getText();
						} else if (text == 'postcode_area') {
							postcode_area = parser.getText();
						} else if (text == 'postcode_district') {
							postcode_district = parser.getText();
						} else if (text == 'postcode_sector') {
							postcode_sector = parser.getText();
						} else if (text == 'outcode') {
							outcode = parser.getText();
						} else if (text == 'incode') {
							incode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static Utils_GetGeocode_parser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new Utils_GetGeocode_parser(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	
    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

}


/*
		'   \"data\": {'+
		'      \"postcode\": \"GU35 0GJ\",'+
		'      \"status\": \"live\",'+
		'      \"usertype\": \"small\",'+
		'      \"easting\": 479342,'+
		'      \"northing\": 136493,'+
		'      \"positional_quality_indicator\": 1,'+
		'      \"country\": \"England\",'+
		'      \"latitude\": \"51.122233\",'+
		'      \"longitude\": \"-0.867680\",'+
		'      \"postcode_no_space\": \"GU350GJ\",'+
		'      \"postcode_fixed_width_seven\": \"GU350GJ\",'+
		'      \"postcode_fixed_width_eight\": \"GU35 0GJ\",'+
		'      \"postcode_area\": \"GU\",'+
		'      \"postcode_district\": \"GU35\",'+
		'      \"postcode_sector\": \"GU35 0\",'+
		'      \"outcode\": \"GU35\",'+
		'      \"incode\": \"0GJ\"'+
		'   },'+
		'   \"copyright\": ['+
		'      \"Contains OS data (c) Crown copyright and database right 2020\",'+
		'      \"Contains Royal Mail data (c) Royal Mail copyright and database right 2020\",'+
		'      \"Contains National Statistics data (c) Crown copyright and database right 2020\"'+

*/