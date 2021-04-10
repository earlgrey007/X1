public with sharing class Utils_EPC_Domestic_parser {

    public List<String> column_names {get;set;} // in json: column-names
    public List<Rows> rows {get;set;} 

    public Utils_EPC_Domestic_parser (JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'column-names') {
                        // ** SKIP ... doe not contain data ...
                    	column_names = arrayOfString(parser);
					} else if (text == 'rows') {
						rows = arrayOfRows(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Utils_EPC_Domestic_parser >> JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Rows {
		public String low_energy_fixed_light_count {get;set;} // in json: low-energy-fixed-light-count
		public String address {get;set;} 
		public String floor_height {get;set;} // in json: floor-height
		public String heating_cost_potential {get;set;} // in json: heating-cost-potential
		public String unheated_corridor_length {get;set;} // in json: unheated-corridor-length
		public String hot_water_cost_potential {get;set;} // in json: hot-water-cost-potential
		public String construction_age_band {get;set;} // in json: construction-age-band
		public String potential_energy_rating {get;set;} // in json: potential-energy-rating
		public String mainheat_energy_eff {get;set;} // in json: mainheat-energy-eff
		public String windows_env_eff {get;set;} // in json: windows-env-eff
		public String lighting_energy_eff {get;set;} // in json: lighting-energy-eff
		public String environment_impact_potential {get;set;} // in json: environment-impact-potential
		public String glazed_type {get;set;} // in json: glazed-type
		public String heating_cost_current {get;set;} // in json: heating-cost-current
		public String address3 {get;set;} 
		public String mainheatcont_description {get;set;} // in json: mainheatcont-description
		public String sheating_energy_eff {get;set;} // in json: sheating-energy-eff
		public String property_type {get;set;} // in json: property-type
		public String local_authority_label {get;set;} // in json: local-authority-label
		public String fixed_lighting_outlets_count {get;set;} // in json: fixed-lighting-outlets-count
		public String energy_tariff {get;set;} // in json: energy-tariff
		public String mechanical_ventilation {get;set;} // in json: mechanical-ventilation
		public String hot_water_cost_current {get;set;} // in json: hot-water-cost-current
		public String county {get;set;} 
		public String postcode {get;set;} 
		public String solar_water_heating_flag {get;set;} // in json: solar-water-heating-flag
		public String constituency {get;set;} 
		public String co2_emissions_potential {get;set;} // in json: co2-emissions-potential
		public String number_heated_rooms {get;set;} // in json: number-heated-rooms
		public String heat_loss_corridoor {get;set;} // in json: heat-loss-corridoor
		public String floor_description {get;set;} // in json: floor-description
		public String energy_consumption_potential {get;set;} // in json: energy-consumption-potential
		public String local_authority {get;set;} // in json: local-authority
		public String built_form {get;set;} // in json: built-form
		public String number_open_fireplaces {get;set;} // in json: number-open-fireplaces
		public String windows_description {get;set;} // in json: windows-description
		public String glazed_area {get;set;} // in json: glazed-area
		public String inspection_date {get;set;} // in json: inspection-date
		public String mains_gas_flag {get;set;} // in json: mains-gas-flag
		public String co2_emiss_curr_per_floor_area {get;set;} // in json: co2-emiss-curr-per-floor-area
		public String address1 {get;set;} 
		public String flat_storey_count {get;set;} // in json: flat-storey-count
		public String constituency_label {get;set;} // in json: constituency-label
		public String roof_energy_eff {get;set;} // in json: roof-energy-eff
		public String total_floor_area {get;set;} // in json: total-floor-area
		public String building_reference_number {get;set;} // in json: building-reference-number
		public String environment_impact_current {get;set;} // in json: environment-impact-current
		public String co2_emissions_current {get;set;} // in json: co2-emissions-current
		public String roof_description {get;set;} // in json: roof-description
		public String floor_energy_eff {get;set;} // in json: floor-energy-eff
		public String number_habitable_rooms {get;set;} // in json: number-habitable-rooms
		public String address2 {get;set;} 
		public String hot_water_env_eff {get;set;} // in json: hot-water-env-eff
		public String posttown {get;set;} 
		public String mainheatc_energy_eff {get;set;} // in json: mainheatc-energy-eff
		public String main_fuel {get;set;} // in json: main-fuel
		public String lighting_env_eff {get;set;} // in json: lighting-env-eff
		public String windows_energy_eff {get;set;} // in json: windows-energy-eff
		public String floor_env_eff {get;set;} // in json: floor-env-eff
		public String sheating_env_eff {get;set;} // in json: sheating-env-eff
		public String lighting_description {get;set;} // in json: lighting-description
		public String roof_env_eff {get;set;} // in json: roof-env-eff
		public String walls_energy_eff {get;set;} // in json: walls-energy-eff
		public String photo_supply {get;set;} // in json: photo-supply
		public String lighting_cost_potential {get;set;} // in json: lighting-cost-potential
		public String mainheat_env_eff {get;set;} // in json: mainheat-env-eff
		public String multi_glaze_proportion {get;set;} // in json: multi-glaze-proportion
		public String main_heating_controls {get;set;} // in json: main-heating-controls
		public String lodgement_datetime {get;set;} // in json: lodgement-datetime
		public String flat_top_storey {get;set;} // in json: flat-top-storey
		public String current_energy_rating {get;set;} // in json: current-energy-rating
		public String secondheat_description {get;set;} // in json: secondheat-description
		public String walls_env_eff {get;set;} // in json: walls-env-eff
		public String transaction_type {get;set;} // in json: transaction-type
		public String current_energy_efficiency {get;set;} // in json: current-energy-efficiency
		public String energy_consumption_current {get;set;} // in json: energy-consumption-current
		public String mainheat_description {get;set;} // in json: mainheat-description
		public String lighting_cost_current {get;set;} // in json: lighting-cost-current
		public String lodgement_date {get;set;} // in json: lodgement-date
		public String extension_count {get;set;} // in json: extension-count
		public String mainheatc_env_eff {get;set;} // in json: mainheatc-env-eff
		public String lmk_key {get;set;} // in json: lmk-key
		public String wind_turbine_count {get;set;} // in json: wind-turbine-count
		public String tenure {get;set;} 
		public String floor_level {get;set;} // in json: floor-level
		public String potential_energy_efficiency {get;set;} // in json: potential-energy-efficiency
		public String hot_water_energy_eff {get;set;} // in json: hot-water-energy-eff
		public String low_energy_lighting {get;set;} // in json: low-energy-lighting
		public String walls_description {get;set;} // in json: walls-description
		public String hotwater_description {get;set;} // in json: hotwater-description

		public Rows(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'low-energy-fixed-light-count') {
							low_energy_fixed_light_count = parser.getText();
						} else if (text == 'address') {
							address = parser.getText();
						} else if (text == 'floor-height') {
							floor_height = parser.getText();
						} else if (text == 'heating-cost-potential') {
							heating_cost_potential = parser.getText();
						} else if (text == 'unheated-corridor-length') {
							unheated_corridor_length = parser.getText();
						} else if (text == 'hot-water-cost-potential') {
							hot_water_cost_potential = parser.getText();
						} else if (text == 'construction-age-band') {
							construction_age_band = parser.getText();
						} else if (text == 'potential-energy-rating') {
							potential_energy_rating = parser.getText();
						} else if (text == 'mainheat-energy-eff') {
							mainheat_energy_eff = parser.getText();
						} else if (text == 'windows-env-eff') {
							windows_env_eff = parser.getText();
						} else if (text == 'lighting-energy-eff') {
							lighting_energy_eff = parser.getText();
						} else if (text == 'environment-impact-potential') {
							environment_impact_potential = parser.getText();
						} else if (text == 'glazed-type') {
							glazed_type = parser.getText();
						} else if (text == 'heating-cost-current') {
							heating_cost_current = parser.getText();
						} else if (text == 'address3') {
							address3 = parser.getText();
						} else if (text == 'mainheatcont-description') {
							mainheatcont_description = parser.getText();
						} else if (text == 'sheating-energy-eff') {
							sheating_energy_eff = parser.getText();
						} else if (text == 'property-type') {
							property_type = parser.getText();
						} else if (text == 'local-authority-label') {
							local_authority_label = parser.getText();
						} else if (text == 'fixed-lighting-outlets-count') {
							fixed_lighting_outlets_count = parser.getText();
						} else if (text == 'energy-tariff') {
							energy_tariff = parser.getText();
						} else if (text == 'mechanical-ventilation') {
							mechanical_ventilation = parser.getText();
						} else if (text == 'hot-water-cost-current') {
							hot_water_cost_current = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'postcode') {
							postcode = parser.getText();
						} else if (text == 'solar-water-heating-flag') {
							solar_water_heating_flag = parser.getText();
						} else if (text == 'constituency') {
							constituency = parser.getText();
						} else if (text == 'co2-emissions-potential') {
							co2_emissions_potential = parser.getText();
						} else if (text == 'number-heated-rooms') {
							number_heated_rooms = parser.getText();
						} else if (text == 'heat-loss-corridoor') {
							heat_loss_corridoor = parser.getText();
						} else if (text == 'floor-description') {
							floor_description = parser.getText();
						} else if (text == 'energy-consumption-potential') {
							energy_consumption_potential = parser.getText();
						} else if (text == 'local-authority') {
							local_authority = parser.getText();
						} else if (text == 'built-form') {
							built_form = parser.getText();
						} else if (text == 'number-open-fireplaces') {
							number_open_fireplaces = parser.getText();
						} else if (text == 'windows-description') {
							windows_description = parser.getText();
						} else if (text == 'glazed-area') {
							glazed_area = parser.getText();
						} else if (text == 'inspection-date') {
							inspection_date = parser.getText();
						} else if (text == 'mains-gas-flag') {
							mains_gas_flag = parser.getText();
						} else if (text == 'co2-emiss-curr-per-floor-area') {
							co2_emiss_curr_per_floor_area = parser.getText();
						} else if (text == 'address1') {
							address1 = parser.getText();
						} else if (text == 'flat-storey-count') {
							flat_storey_count = parser.getText();
						} else if (text == 'constituency-label') {
							constituency_label = parser.getText();
						} else if (text == 'roof-energy-eff') {
							roof_energy_eff = parser.getText();
						} else if (text == 'total-floor-area') {
							total_floor_area = parser.getText();
						} else if (text == 'building-reference-number') {
							building_reference_number = parser.getText();
						} else if (text == 'environment-impact-current') {
							environment_impact_current = parser.getText();
						} else if (text == 'co2-emissions-current') {
							co2_emissions_current = parser.getText();
						} else if (text == 'roof-description') {
							roof_description = parser.getText();
						} else if (text == 'floor-energy-eff') {
							floor_energy_eff = parser.getText();
						} else if (text == 'number-habitable-rooms') {
							number_habitable_rooms = parser.getText();
						} else if (text == 'address2') {
							address2 = parser.getText();
						} else if (text == 'hot-water-env-eff') {
							hot_water_env_eff = parser.getText();
						} else if (text == 'posttown') {
							posttown = parser.getText();
						} else if (text == 'mainheatc-energy-eff') {
							mainheatc_energy_eff = parser.getText();
						} else if (text == 'main-fuel') {
							main_fuel = parser.getText();
						} else if (text == 'lighting-env-eff') {
							lighting_env_eff = parser.getText();
						} else if (text == 'windows-energy-eff') {
							windows_energy_eff = parser.getText();
						} else if (text == 'floor-env-eff') {
							floor_env_eff = parser.getText();
						} else if (text == 'sheating-env-eff') {
							sheating_env_eff = parser.getText();
						} else if (text == 'lighting-description') {
							lighting_description = parser.getText();
						} else if (text == 'roof-env-eff') {
							roof_env_eff = parser.getText();
						} else if (text == 'walls-energy-eff') {
							walls_energy_eff = parser.getText();
						} else if (text == 'photo-supply') {
							photo_supply = parser.getText();
						} else if (text == 'lighting-cost-potential') {
							lighting_cost_potential = parser.getText();
						} else if (text == 'mainheat-env-eff') {
							mainheat_env_eff = parser.getText();
						} else if (text == 'multi-glaze-proportion') {
							multi_glaze_proportion = parser.getText();
						} else if (text == 'main-heating-controls') {
							main_heating_controls = parser.getText();
						} else if (text == 'lodgement-datetime') {
							lodgement_datetime = parser.getText();
						} else if (text == 'flat-top-storey') {
							flat_top_storey = parser.getText();
						} else if (text == 'current-energy-rating') {
							current_energy_rating = parser.getText();
						} else if (text == 'secondheat-description') {
							secondheat_description = parser.getText();
						} else if (text == 'walls-env-eff') {
							walls_env_eff = parser.getText();
						} else if (text == 'transaction-type') {
							transaction_type = parser.getText();
						} else if (text == 'current-energy-efficiency') {
							current_energy_efficiency = parser.getText();
						} else if (text == 'energy-consumption-current') {
							energy_consumption_current = parser.getText();
						} else if (text == 'mainheat-description') {
							mainheat_description = parser.getText();
						} else if (text == 'lighting-cost-current') {
							lighting_cost_current = parser.getText();
						} else if (text == 'lodgement-date') {
							lodgement_date = parser.getText();
						} else if (text == 'extension-count') {
							extension_count = parser.getText();
						} else if (text == 'mainheatc-env-eff') {
							mainheatc_env_eff = parser.getText();
						} else if (text == 'lmk-key') {
							lmk_key = parser.getText();
						} else if (text == 'wind-turbine-count') {
							wind_turbine_count = parser.getText();
						} else if (text == 'tenure') {
							tenure = parser.getText();
						} else if (text == 'floor-level') {
							floor_level = parser.getText();
						} else if (text == 'potential-energy-efficiency') {
							potential_energy_efficiency = parser.getText();
						} else if (text == 'hot-water-energy-eff') {
							hot_water_energy_eff = parser.getText();
						} else if (text == 'low-energy-lighting') {
							low_energy_lighting = parser.getText();
						} else if (text == 'walls-description') {
							walls_description = parser.getText();
						} else if (text == 'hotwater-description') {
							hotwater_description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Utils_EPC_Domestic_parser >> Rows consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static Utils_EPC_Domestic_parser parse(String json) {
		system.debug('Utils_EPC_Domestic_parser >> string :'+ json);
		system.debug('Utils_EPC_Domestic_parser >> string LENGTH :'+ json.length());
		System.JSONParser parser = System.JSON.createParser(json);
		return new Utils_EPC_Domestic_parser(parser);
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
	

    private static List<Rows> arrayOfRows(System.JSONParser p) {
        List<Rows> res = new List<Rows>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Rows(p));
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



}