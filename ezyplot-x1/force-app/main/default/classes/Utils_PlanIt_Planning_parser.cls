public class Utils_PlanIt_Planning_parser {

	public Integer count {get;set;} 
	public String detail {get;set;} 
	public Integer limit_Z {get;set;} // in json: limit
	public String msg {get;set;} 
	public Integer offset {get;set;} 
	public Integer page_size {get;set;} 
	public List<Records> records {get;set;} 
	public Double secs_taken {get;set;} 
	public Integer total {get;set;} 

	public Utils_PlanIt_Planning_parser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'count') {
						count = parser.getIntegerValue();
					} else if (text == 'detail') {
						detail = parser.getText();
					} else if (text == 'limit') {
						limit_Z = parser.getIntegerValue();
					} else if (text == 'msg') {
						msg = parser.getText();
					} else if (text == 'offset') {
						offset = parser.getIntegerValue();
					} else if (text == 'page_size') {
						page_size = parser.getIntegerValue();
					} else if (text == 'records') {
						records = arrayOfRecords(parser);
					} else if (text == 'secs_taken') {
						secs_taken = parser.getDoubleValue();
					} else if (text == 'total') {
						total = parser.getIntegerValue();
					} else {
						System.debug(LoggingLevel.WARN, 'Utils_PlanIt_Planning_parser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Records {
		public String address {get;set;} 
		public String altid {get;set;} 
		public String app_size {get;set;} 
		public String app_state {get;set;} 
		public String app_type {get;set;} 
		public String associated_id {get;set;} 
		public Integer authority_id {get;set;} 
		public String authority_name {get;set;} 
		public String consulted_date {get;set;} 
		public String decided_date {get;set;} 
		public String description {get;set;} 
		public Double distance {get;set;} 
		public Double lat {get;set;} 
		public String link {get;set;} 
		public Double lng {get;set;} 
		public String name {get;set;} 
		public String postcode {get;set;} 
		public String rec_type {get;set;} 
		public String reference {get;set;} 
		public String source_url {get;set;} 
		public String start_date {get;set;} 
		public String uid {get;set;} 
		public String url {get;set;} 
		public String when_updated {get;set;} 

		public Records(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'address') {
							address = parser.getText();
						} else if (text == 'altid') {
							altid = parser.getText();
						} else if (text == 'app_size') {
							app_size = parser.getText();
						} else if (text == 'app_state') {
							app_state = parser.getText();
						} else if (text == 'app_type') {
							app_type = parser.getText();
						} else if (text == 'associated_id') {
							associated_id = parser.getText();
						} else if (text == 'authority_id') {
							authority_id = parser.getIntegerValue();
						} else if (text == 'authority_name') {
							authority_name = parser.getText();
						} else if (text == 'consulted_date') {
							consulted_date = parser.getText();
						} else if (text == 'decided_date') {
							decided_date = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'distance') {
							distance = parser.getDoubleValue();
						} else if (text == 'lat') {
							lat = parser.getDoubleValue();
						} else if (text == 'link') {
							link = parser.getText();
						} else if (text == 'lng') {
							lng = parser.getDoubleValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'postcode') {
							postcode = parser.getText();
						} else if (text == 'rec_type') {
							rec_type = parser.getText();
						} else if (text == 'reference') {
							reference = parser.getText();
						} else if (text == 'source_url') {
							source_url = parser.getText();
						} else if (text == 'start_date') {
							start_date = parser.getText();
						} else if (text == 'uid') {
							uid = parser.getText();
						} else if (text == 'url') {
							url = parser.getText();
						} else if (text == 'when_updated') {
							when_updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Records consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static Utils_PlanIt_Planning_parser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new Utils_PlanIt_Planning_parser(parser);
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
	

    private static List<Records> arrayOfRecords(System.JSONParser p) {
        List<Records> res = new List<Records>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Records(p));
        }
        return res;
    }



}