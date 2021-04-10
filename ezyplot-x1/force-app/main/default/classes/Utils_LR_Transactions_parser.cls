// parse json response to 
// https://landregistry.data.gov.uk/data/ppi/transaction-record.json?_page=0&propertyAddress.town=&_pageSize=50&max-transactionDate=&propertyAddress.street=&type.label=&estateType.prefLabel=&min-pricePaid=&propertyAddress.district=&recordStatus.prefLabel=&propertyAddress.county=&transactionDate=&transactionId=&newBuild=&propertyAddress.type.=&transactionCategory.prefLabel=&min-transactionDate=2015-01-01&max-pricePaid=&hasTransaction=&propertyType.prefLabel=&_view=address&propertyAddress.paon=&propertyAddress.postcode=SE18+6FY&pricePaid=&_sort=propertyAddress.paon,propertyAddress.saon

public with sharing class Utils_LR_Transactions_parser {

	public class EstateType {
		public String x_about {get;set;} // in json: _about
		public List<Label> label {get;set;} 
		public List<Label> prefLabel {get;set;} 

		public EstateType(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '_about') {
							x_about = parser.getText();
						} else if (text == 'label') {
							label = arrayOfLabel(parser);
						} else if (text == 'prefLabel') {
							prefLabel = arrayOfLabel(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'EstateType consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Type_Z {
		public String x_about {get;set;} // in json: _about
		public List<Label> label {get;set;} 

		public Type_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '_about') {
							x_about = parser.getText();
						} else if (text == 'label') {
							label = arrayOfLabel(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Type_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PropertyAddress {
		public String x_about {get;set;} // in json: _about
		public String county {get;set;} 
		public String district {get;set;} 
		public String locality {get;set;} 
		public String paon {get;set;} 
		public String postcode {get;set;} 
		public String saon {get;set;} 
		public String street {get;set;} 
		public String town {get;set;} 
		public List<String> type_Z {get;set;} // in json: type

		public PropertyAddress(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '_about') {
							x_about = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'district') {
							district = parser.getText();
						} else if (text == 'locality') {
							locality = parser.getText();
						} else if (text == 'paon') {
							paon = parser.getText();
						} else if (text == 'postcode') {
							postcode = parser.getText();
						} else if (text == 'saon') {
							saon = parser.getText();
						} else if (text == 'street') {
							street = parser.getText();
						} else if (text == 'town') {
							town = parser.getText();
						} else if (text == 'type') {
							type_Z = arrayOfString(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'PropertyAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String format {get;set;} 
	public String version {get;set;} 
	public Result result {get;set;} 

	public Utils_LR_Transactions_parser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'format') {
						format = parser.getText();
					} else if (text == 'version') {
						version = parser.getText();
					} else if (text == 'result') {
						result = new Result(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Utils_LR_Transactions_parser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class IsPartOf {
		public String x_about {get;set;} // in json: _about
		public String definition {get;set;} 
		public String hasPart {get;set;} 
		public List<String> type_Z {get;set;} // in json: type

		public IsPartOf(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '_about') {
							x_about = parser.getText();
						} else if (text == 'definition') {
							definition = parser.getText();
						} else if (text == 'hasPart') {
							hasPart = parser.getText();
						} else if (text == 'type') {
							type_Z = arrayOfString(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'IsPartOf consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Label {
		public String x_value {get;set;} // in json: _value
		public String x_lang {get;set;} // in json: _lang

		public Label(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '_value') {
							x_value = parser.getText();
						} else if (text == '_lang') {
							x_lang = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Label consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Items {
		public String x_about {get;set;} // in json: _about
		public EstateType estateType {get;set;} 
		public String hasTransaction {get;set;} 
		public Boolean newBuild {get;set;} 
		public Integer pricePaid {get;set;} 
		public PropertyAddress propertyAddress {get;set;} 
		public EstateType propertyType {get;set;} 
		public EstateType recordStatus {get;set;} 
		public EstateType transactionCategory {get;set;} 
		public Date transactionDate {get;set;} 
		public String transactionId {get;set;} 
		public List<Type_Z> type_Z {get;set;} // in json: type

		public Items(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '_about') {
							x_about = parser.getText();
						} else if (text == 'estateType') {
							estateType = new EstateType(parser);
						} else if (text == 'hasTransaction') {
							hasTransaction = parser.getText();
						} else if (text == 'newBuild') {
							newBuild = parser.getBooleanValue();
						} else if (text == 'pricePaid') {
							pricePaid = parser.getIntegerValue();
						} else if (text == 'propertyAddress') {
							propertyAddress = new PropertyAddress(parser);
						} else if (text == 'propertyType') {
							propertyType = new EstateType(parser);
						} else if (text == 'recordStatus') {
							recordStatus = new EstateType(parser);
						} else if (text == 'transactionCategory') {
							transactionCategory = new EstateType(parser);
						} else if (text == 'transactionDate') {
							// format used by LR: "Thu, 25 Feb 2010"
							list<string> l_Date = parser.getText().split(' '); 
							// system.debug('parsing transactionDate into l_Date>> ' + l_Date);
							transactionDate = date.valueOf( l_Date[3] +'-'+ string.valueOf(Utils.getMonthNumber(l_Date[2])) +'-'+ l_Date[1]);
						} else if (text == 'transactionId') {
							transactionId = parser.getText();
						} else if (text == 'type') {
							type_Z = arrayOfType_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Items consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Result {
		public String x_about {get;set;} // in json: _about
		public String definition {get;set;} 
		public String extendedMetadataVersion {get;set;} 
		public String first {get;set;} 
		public IsPartOf isPartOf {get;set;} 
		public List<Items> items {get;set;} 
		public Integer itemsPerPage {get;set;} 
		public String next {get;set;} 
		public Integer page {get;set;} 
		public Integer startIndex {get;set;} 
		public List<String> type_Z {get;set;} // in json: type

		public Result(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '_about') {
							x_about = parser.getText();
						} else if (text == 'definition') {
							definition = parser.getText();
						} else if (text == 'extendedMetadataVersion') {
							extendedMetadataVersion = parser.getText();
						} else if (text == 'first') {
							first = parser.getText();
						} else if (text == 'isPartOf') {
							isPartOf = new IsPartOf(parser);
						} else if (text == 'items') {
							items = arrayOfItems(parser);
						} else if (text == 'itemsPerPage') {
							itemsPerPage = parser.getIntegerValue();
						} else if (text == 'next') {
							next = parser.getText();
						} else if (text == 'page') {
							page = parser.getIntegerValue();
						} else if (text == 'startIndex') {
							startIndex = parser.getIntegerValue();
						} else if (text == 'type') {
							type_Z = arrayOfString(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Result consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static Utils_LR_Transactions_parser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new Utils_LR_Transactions_parser(parser);
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
	





    private static List<Type_Z> arrayOfType_Z(System.JSONParser p) {
        List<Type_Z> res = new List<Type_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Type_Z(p));
        }
        return res;
    }


    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }




    private static List<Label> arrayOfLabel(System.JSONParser p) {
        List<Label> res = new List<Label>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Label(p));
        }
        return res;
    }





    private static List<Items> arrayOfItems(System.JSONParser p) {
        List<Items> res = new List<Items>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Items(p));
        }
        return res;
    }



}