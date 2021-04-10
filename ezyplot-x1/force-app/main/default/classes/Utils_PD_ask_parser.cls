public with sharing class Utils_PD_ask_parser {

	public class Raw_data {
		public Integer price {get;set;} 
		public String lat {get;set;} 
		public String lng {get;set;} 
		public Integer bedrooms {get;set;} 
		public String type_Z {get;set;} // in json: type
		public String distance {get;set;} 

		public Raw_data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'price') {
							price = parser.getIntegerValue();
						} else if (text == 'lat') {
							lat = parser.getText();
						} else if (text == 'lng') {
							lng = parser.getText();
						} else if (text == 'bedrooms') {
							bedrooms = parser.getIntegerValue();
						} else if (text == 'type') {
							type_Z = parser.getText();
						} else if (text == 'distance') {
							distance = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Raw_data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public Integer points_analysed {get;set;} 
		public String radius {get;set;} 
		public Integer average {get;set;} 
		public String z_70pc_range {get;set;} 
		public String z_80pc_range {get;set;} 
		public String z_90pc_range {get;set;} 
		public String z_100pc_range {get;set;} 
		public List<Raw_data> raw_data {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'points_analysed') {
							points_analysed = parser.getIntegerValue();
						} else if (text == 'radius') {
							radius = parser.getText();
						} else if (text == 'average') {
							average = parser.getIntegerValue();
						} else if (text == '70pc_range') {
							z_70pc_range = parser.getText();
						} else if (text == '80pc_range') {
							z_80pc_range = parser.getText();
						} else if (text == '90pc_range') {
							z_90pc_range = parser.getText();
						} else if (text == '100pc_range') {
							z_100pc_range = parser.getText();
						} else if (text == 'raw_data') {
							raw_data = arrayOfRaw_data(parser);
							System.debug('Utils_PD_ask_parser: Raw data >> ' +Raw_data);
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String status {get;set;} 
	public String postcode {get;set;} 
	public String postcode_type {get;set;} 
	public String url {get;set;} 
	public Data data {get;set;} 
	public String process_time {get;set;} 
	// >> ERROR HANDLING:
	public String code {get;set;} 
	public String message {get;set;} 
		// <<

	public Utils_PD_ask_parser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'status') {
						status = parser.getText();
					} else if (text == 'postcode') {
						postcode = parser.getText();
					} else if (text == 'postcode_type') {
						postcode_type = parser.getText();
					} else if (text == 'url') {
						url = parser.getText();
					} else if (text == 'data') {
						data = new Data(parser);
					} else if (text == 'process_time') {
						process_time = parser.getText();

					// >> error handling section:
					} else if (text == 'code') {
						code = parser.getText();
					} else if (text == 'message') {
						message = parser.getText();
					// <<


					} else {
						System.debug(LoggingLevel.WARN, 'Utils_PD_ask_parser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static Utils_PD_ask_parser parse(String json) {
		System.debug('Utils_PD_ask_parser: JSON received: ' +json);
		System.JSONParser parser = System.JSON.createParser(json);
		return new Utils_PD_ask_parser(parser);
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
	

    private static List<Integer> arrayOfInteger(System.JSONParser p) {
        List<Integer> res = new List<Integer>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getIntegerValue());
        }
        return res;
    }


    private static List<Raw_data> arrayOfRaw_data(System.JSONParser p) {
        List<Raw_data> res = new List<Raw_data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Raw_data(p));
        }
        return res;
    }



}