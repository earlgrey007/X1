public with sharing class Utils_PD_Planning_Parser {

	public class Dates_Z {
		public String received_at {get;set;} 
		public String validated_at {get;set;} 
		public String decided_at {get;set;} 

		public Dates_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'received_at') {
							received_at = parser.getText();
						} else if (text == 'validated_at') {
							validated_at = parser.getText();
						} else if (text == 'decided_at') {
							decided_at = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Dates_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Agent {
		public String name {get;set;} 
		public String company {get;set;} 
		public String address {get;set;} 

		public Agent(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'company') {
							company = parser.getText();
						} else if (text == 'address') {
							address = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Agent consuming unrecognized property: '+text);
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

	public Utils_PD_Planning_Parser(JSONParser parser) {
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
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Appeal {
		public String status {get;set;} 
		public String decision {get;set;} 

		public Appeal(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'status') {
							status = parser.getText();
						} else if (text == 'decision') {
							decision = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Appeal consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Planning_applications {
		public String address {get;set;} 
		public Agent agent {get;set;} 
		public String authority {get;set;} 
		public String ward {get;set;} 
		public String case_officer {get;set;} 
		public String reference {get;set;} 
		public String category {get;set;} 
		public String proposal {get;set;} 
		public String type_Z {get;set;} // in json: type
		public String status {get;set;} 
		public Decision decision {get;set;} 
		public Appeal appeal {get;set;} 
		public Dates dates {get;set;} 
		public String lat {get;set;} 
		public String lng {get;set;} 
        public String distance {get;set;} 

		public Planning_applications(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'address') {
							address = parser.getText();
						} else if (text == 'agent') {
							agent = new Agent(parser);
						} else if (text == 'authority') {
							authority = parser.getText();
						} else if (text == 'ward') {
							ward = parser.getText();
						} else if (text == 'case_officer') {
							case_officer = parser.getText();
						} else if (text == 'reference') {
							reference = parser.getText();
						} else if (text == 'category') {
							category = parser.getText();
						} else if (text == 'proposal') {
							proposal = parser.getText();
						} else if (text == 'type') {
							type_Z = parser.getText();
						} else if (text == 'status') {
							status = parser.getText();
						} else if (text == 'decision') {
							decision = new Decision(parser);
						} else if (text == 'appeal') {
							appeal = new Appeal(parser);
						} else if (text == 'dates') {
							dates = new Dates(parser);
						} else if (text == 'lat') {
							lat = parser.getText();
						} else if (text == 'lng') {
							lng = parser.getText();
						} else if (text == 'distance') {
							distance = parser.getText();
                        } else {
							System.debug(LoggingLevel.WARN, 'Planning_applications consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Dates {
		public String received_at {get;set;} 
		public String validated_at {get;set;} 
		public String decided_at {get;set;} 

		public Dates(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'received_at') {
							received_at = parser.getText();
						} else if (text == 'validated_at') {
							validated_at = parser.getText();
						} else if (text == 'decided_at') {
							decided_at = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Dates consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public List<Planning_applications> planning_applications {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'planning_applications') {
							planning_applications = arrayOfPlanning_applications(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Agent_Z {
		public String name {get;set;} 
		public String company {get;set;} 
		public String address {get;set;} 

		public Agent_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'company') {
							company = parser.getText();
						} else if (text == 'address') {
							address = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Agent_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Decision {
		public String text_z {get;set;} 
		public String rating {get;set;} 

		public Decision(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'text') {
							text_z = parser.getText();
						} else if (text == 'rating') {
							rating = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Decision consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static Utils_PD_Planning_Parser parse(String json) {
        System.debug('Utils_PD_Planning_Parser -- param received --> ' +json);
        System.JSONParser parser = System.JSON.createParser(json);
		return new Utils_PD_Planning_Parser(parser);
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
	

    private static List<Planning_applications> arrayOfPlanning_applications(System.JSONParser p) {
        List<Planning_applications> res = new List<Planning_applications>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Planning_applications(p));
        }
        return res;
    }
}