public class Utils_PD_LandForSale_parser {

    public class List_Z {
        public String id {get;set;} 
        public String name {get;set;} 

        public List_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'List_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public String status {get;set;} 
    public List_Z list_Z {get;set;} // in json: list
    public String region_used {get;set;} 
    public Integer result_count {get;set;} 
    public List<Properties> properties {get;set;} 
    public String process_time {get;set;} 

    public Utils_PD_LandForSale_parser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'status') {
                        status = parser.getText();
                    } else if (text == 'list') {
                        list_Z = new List_Z(parser);
                    } else if (text == 'region_used') {
                        region_used = parser.getText();
                    } else if (text == 'result_count') {
                        result_count = parser.getIntegerValue();
                    } else if (text == 'properties') {
                        properties = arrayOfProperties(parser);
                    } else if (text == 'process_time') {
                        process_time = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'Utils_PD_LandForSale_parser consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Properties {
        public String id {get;set;} 
        public String address {get;set;} 
        public String postcode {get;set;} 
        public String type_Z {get;set;} // in json: type
        public Integer bedrooms {get;set;} 
        public Integer price {get;set;} 
        public String lat {get;set;} 
        public String lng {get;set;} 
        public String url {get;set;} 

        public Properties(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'postcode') {
                            postcode = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'bedrooms') {
                            bedrooms = parser.getIntegerValue();
                        } else if (text == 'price') {
                            price = parser.getIntegerValue();
                        } else if (text == 'lat') {
                            lat = parser.getText();
                        } else if (text == 'lng') {
                            lng = parser.getText();
                        } else if (text == 'url') {
                            url = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Properties consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static Utils_PD_LandForSale_parser parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new Utils_PD_LandForSale_parser(parser);
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
    




    private static List<Properties> arrayOfProperties(System.JSONParser p) {
        List<Properties> res = new List<Properties>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Properties(p));
        }
        return res;
    }



}