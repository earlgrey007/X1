public inherited sharing class Lead_update {

    /*         overview of all sections below:
            // set DEFAULT values for fields - simplify data entry
            // POPULATE NAME + STREET, BASED ON 'Address IN'
            // CALCULATE FIRST SEEN + Days on Market
            // CALCULATE LEASE END DATE + years remaining
            // CALCULATE OMV ESTIMATE BY PULLING AVG £SQFT FROM AREA RETRIEVAL STATUS 
            // CALCULATE PREMIUM BASED ON OMV (OR EST OMV)
            // CALCULATE BEE ROI EST ON OMV ESTIMATE
            // CALCULATE HOT or COLD
            // CEATE NEW OPPORTUNITY IF MARKETING_STATUS CONTAINS 'OFFERING'
    */    

    @InvocableMethod
        public static void Lead_update(List<Id> LeadIds)
        {
            List<Lead> Ids =
                [select id, 
                    Address, Address_IN__c, Agent_account__c, Asking__c, Bedrooms__c, 
                    Callout_buffer__c, Cash_required_Auction_flip__c, Construction__c, Days_on_market__c, 
                    First_seen__c, First_seen_STRING__c, FirstName, Ground_rent__c, 
                    LastName, Lease_end_date__c, Lease_end_date_STRING__c, Lease_extension__c, 
                    Lease_extension_estimate__c, Marketing_status__c,
                    Name, OMV_est_district__c, OMV_estimate__c, OMV_long_lease__c, Outdoor_space__c,
                    Postcode__c, Postcode_district__c,
                    Property_type__c, Rating, Refurbishment__c, ROI_Auction__c,
                    ROI_BEE_estimate__c, ROI_BEE_estimate_perc__c, ROI_BEE_perc__c,
                    Status, Size_sqft__c, Website, Years_remaining__c                                         
                from Lead WHERE id in :LeadIds
                ];

            if (Ids.size()> 0){
                System.debug('Lead_update (Ids:) >> '+ Ids);

                // more efficient to declare vars here
                date dToday = date.today();
                string sFirstname = '';
                string sPostcode = '';
                string sPostcodeDistrict = '';

                // vars for lease extension premium calc 
                double e = 0.05;
                double G = 50;          // use as default Ground Rent 
                double T = 0;           // years remaining
                double V = 0;           // OMV
                double core1 = 0;
                double core2 = 0;
                double core3 = 0;
                double base = 0;
                double V1discount = 0;
                double V1 = 0;
        
                // MAIN SECTION
                for(Lead rec : Ids)
                {       

                    // set DEFAULT values for fields - simplify data entry
                    if (rec.Asking__c < 0) {
                        rec.Asking__c = 1;
                    }             

                    // POPULATE NAME + STREET, BASED ON 'Address IN'
                    if ((rec.Address_IN__c != null)
                        && (rec.Address.getCity() != null)
                        && (rec.Address.getPostalCode() != null))
                    {
                        sPostcode = '';
                        sPostcodeDistrict = '';
                        system.debug('Starting POPULATE NAME + STREET >> '+rec.Address_IN__c);
                        rec.Address_IN__c= rec.Address_IN__c.replace(rec.Address.getCity(),'');
                        system.debug('Post POPULATE NAME + STREET: city >> '+rec.Address_IN__c +'<<');
                        sPostcode = rec.Address.getPostalCode();
                        // strip out postcode
                        String[] lPostc = sPostcode.split(' '); 
                        if (lPostc.size() > 0){                                                    
                            rec.Address_IN__c= rec.Address_IN__c.replace(lPostc[0],'');
                            system.debug('Post POPULATE NAME + STREET postcode >> '+rec.Address_IN__c +'<<');                            
                            rec.Address_IN__c= rec.Address_IN__c.replace('London',''); // as this gets omitted sometimes
                            sPostcodeDistrict = lPostc[0];
                        }
                        system.debug('Post POPULATE NAME + STREET postcode >> '+rec.Address_IN__c +'<<');                            
                        if (lPostc.size() > 1){                                                    
                            rec.Address_IN__c= rec.Address_IN__c.replace(lPostc[1],'');
                        }
                        system.debug('Post POPULATE NAME + STREET postcode >> '+rec.Address_IN__c +'<<');                            
                        // clean op remaining additional chars
                        rec.Address_IN__c= rec.Address_IN__c.replace(',','');
                        rec.Address_IN__c= rec.Address_IN__c.replace('.','');
                        system.debug('Post POPULATE NAME + STREET: ADDRESS_IN >> '+rec.Address_IN__c +'<<');   
                        // populate FIRSTNAME + STREET (=Address)
                        sFirstname = rec.Address_IN__c.trim() +', '+rec.Address.getCity()+',';
                        if (sFirstname.length() > 39){
                            sFirstname = sFirstname.substring(0,37) +'..';
                        }
                        rec.FirstName = sFirstname;
                        system.debug('sFirstname >> ' +sFirstname  +'<<');
                        // rec.Address.STREET = rec.Address_IN__c; CANNOT BE SET IN APEX SO ITS IN THE PROCESS BUILDER                         
                    }

                    // CALCULATE FIRST SEEN + Days on Market
                    if (rec.First_seen_STRING__c != null){  //  eg. "15/03/2020"
                        system.debug('Starting FIRST SEEN >> ');
                        rec.First_seen__c = date.newInstance(
                            integer.valueOf( rec.First_seen_STRING__c.right(4)),         // year                   
                            integer.valueOf( rec.First_seen_STRING__c.mid(3,2)),         // month
                            integer.valueOf( rec.First_seen_STRING__c.left(2))           // day
                            );
                        rec.Days_on_market__c = rec.First_seen__c.daysBetween(Date.today());
                    } else {
                        if (rec.Days_on_market__c != null){
                            rec.First_seen__c = Date.today().addDays( math.round(-rec.Days_on_market__c));
                        }
                    }

                    // CALCULATE LEASE END DATE + years remaining
                    if (rec.Lease_end_date_STRING__c != null){  //  eg. "15/03/2020"
                        system.debug('Starting CALC LEASE END DATE >> ');
                        rec.Lease_end_date__c = date.newInstance(
                            integer.valueOf( rec.Lease_end_date_STRING__c.right(4)),                  //year      
                            integer.valueOf( rec.Lease_end_date_STRING__c.mid(3,2)),                // month
                            integer.valueOf( rec.Lease_end_date_STRING__c.left(2))                  // day
                            );
                        rec.Years_remaining__c = Date.today().daysBetween(rec.Lease_end_date__c) /365;
                    } else {
                        if (rec.Years_remaining__c > 0){
                            rec.Lease_end_date__c = dToday.addYears( math.round(rec.Years_remaining__c) );
                        }
                    }

                    // Link to postcode AREA - 29 MAR 2021
                    // CREATE area IF it does not exist
                    if (sPostcode != ''){
                        system.debug('Lead_update >> get area for >> ' + sPostcode);
                        Area_retrieval_status__c[] lArea = [SELECT id from Area_retrieval_status__c WHERE Name = :sPostcode LIMIT 1];

                        if (lArea.size() > 0){
                            system.debug('Lead_update >> area found >> ' + lArea[0].Id);
                            rec.Postcode__c = lArea[0].Id;
                        } else {
                            Area_retrieval_status__c pArea = new Area_retrieval_status__c( Name = sPostcode, Area__c = sPostcode );
                            insert pArea;                                
                            system.debug('Lead_update >> area CREATED >> ' + pArea.Id);
                            rec.Postcode__c = pArea.Id;
                        }      

                    }

                    /* 30 MAR 2021 - replaced by OMV formula fields on Lead 

                    // CALCULTATE OMV ESTIMATE BY PULLING AVG £SQFT FROM AREA RETRIEVAL 
                    if (sPostcode != ''){
                        system.debug('Lead_update >> get postcode district for >> ');

                        list<Area_retrieval_status__c> aList = [SELECT id, Average_psqft__c from Area_retrieval_status__c WHERE Name = :sPostcodeDistrict LIMIT 1];
                        
                        // in case postcode DISTRICT is not found, shorten 'SW1X' to 'SW1'
                        sPostcodeDistrict = sPostcodeDistrict.left(sPostcodeDistrict.length()-1);
                        system.debug('sPostcodeDistrict >> '+sPostcodeDistrict );
                        if (aList.size() == 0){
                            aList = [SELECT id, Average_psqft__c from Area_retrieval_status__c WHERE Name = :sPostcodeDistrict LIMIT 1];
                        }                            

                        // go for it ..
                        if ((aList.size() > 0)                            
                            && (aList[0].Average_psqft__c != null))
                        {
                            if (rec.Size_sqft__c != null){
                                rec.OMV_estimate__c = aList[0].Average_psqft__c * rec.Size_sqft__c;
                                system.debug('OMV estimate [' + sPostcodeDistrict + ']FOUND >> ' + aList[0].Average_psqft__c +' * '+rec.Size_sqft__c);
                            } else {
                                if (rec.Bedrooms__c != null){
                                    rec.OMV_estimate__c = aList[0].Average_psqft__c * (500 + 200*rec.Bedrooms__c);
                                    system.debug('OMV estimate [' + sPostcodeDistrict + ']FOUND >> ' + aList[0].Average_psqft__c +' * '+rec.Bedrooms__c+' bedrooms');
                                }
                            }                                
                            rec.Postcode_district__c = aList[0].Id; 
                        } else {
                            rec.OMV_estimate__c  = -1;
                            system.debug('Lead_update: OMV estimate [' + sPostcodeDistrict + ']NOT FOUND >> ' + rec);
                        }
                    }
                    */
                    
                    // CALCULATE PREMIUM BASED ON OMV (OR EST OMV)
                    if (rec.Years_remaining__c != null){

                        system.debug('Lead_update: Starting PREMIUM >>');
                        System.debug('Lead_update: POST NULL CHECK >> rec: '+ rec);

                        // just to keep calcs in formulas below cleaner:
                        if (rec.Ground_rent__c != null){
                            G = rec.Ground_rent__c;
                        } else {
                            G=50; 
                        }
                        T = rec.Years_remaining__c;

                        if (rec.OMV_long_lease__c != null){
                            V = rec.OMV_long_lease__c;
                            core1 = Math.pow(1+e, -T);
                            core2 = G/e*(1-core1);
                            core3 = V*(1 + core1);
                            base = 91;
                            V1discount = base-Math.pow((base-T)/10,2)-(base-T)/10/2;
                            V1 = V1discount*V/100;
                            rec.Lease_extension__c = 0.5* (core2 + core3 - V1);
                        } 
                        if (rec.OMV_estimate__c != null){
                            V = rec.OMV_estimate__c;
                            core1 = Math.pow(1+e, -T);
                            core2 = G/e*(1-core1);
                            core3 = V*(1 + core1);
                            base = 91;
                            V1discount = base-Math.pow((base-T)/10,2)-(base-T)/10/2;
                            V1 = V1discount*V/100;
                            rec.Lease_extension_estimate__c = 0.5* (core2 + core3 - V1);
                        }
                    }

                    // CALCULATE BEE ROI EST ON OMV ESTIMATE
                    if (rec.asking__c != null){
                        if ((rec.OMV_estimate__c != null)
                            && (rec.Lease_extension_estimate__c != null))
                        {
                            system.debug('Lead_update: Starting ROI EST >>');
                            double fees = 0.03 *rec.asking__c +3000;
                            double refurb = 0;
                            if (rec.Refurbishment__c != null){
                                refurb = rec.Refurbishment__c; 
                            }
                            rec.ROI_BEE_estimate__c = rec.OMV_estimate__c -rec.asking__c -rec.Lease_extension_estimate__c -refurb -fees;
                            rec.ROI_BEE_estimate_perc__c = 100* rec.ROI_BEE_estimate__c/(rec.OMV_estimate__c -rec.ROI_BEE_estimate__c) ;
                        }

                        if ((rec.OMV_long_lease__c != null)
                            && (rec.Lease_extension__c != null))
                        {
                            system.debug('Lead_update: Starting ROI EST >>');
                            double fees = 0.03 *rec.asking__c +3000;
                            double refurb = 0;
                            if (rec.Refurbishment__c != null){
                                refurb = rec.Refurbishment__c; 
                            }
                            rec.ROI_BEE__c = rec.OMV_long_lease__c -rec.asking__c -rec.Lease_extension__c -refurb -fees;
                            rec.ROI_BEE_perc__c = 100* rec.ROI_BEE__c/(rec.OMV_long_lease__c -rec.ROI_BEE__c) ;
                        }
                    }

                    // CALCULATE HOT or COLD
                    if (rec.ROI_BEE_perc__c > 0.50) {rec.Rating = 'Superhot';}
                    if (rec.ROI_BEE_perc__c > 0.30) {rec.Rating = 'Hot';}
                    if (rec.ROI_BEE_perc__c > 0.10) {rec.Rating = 'Warm';}
                    if (rec.ROI_BEE_perc__c < 0.10) {rec.Rating = 'Cold';}           

                    if (rec.marketing_status__c != null){

                        // IF MARKETING_STATUS IS 'OFFERING' >> CEATE NEW OPPORTUNITY 
                        if ( // needs to be either Offering or Qualified but not both
                            ((rec.marketing_status__c == 'Offering') && (rec.status != 'Qualified'))
                            || ((rec.marketing_status__c != 'Offering') && (rec.status == 'Qualified'))
                            )
                        {
                            system.debug( rec.marketing_status__c +' ('+ rec.name +')');
                            Opportunity newOpp = new Opportunity(
                                AccountId = rec.Agent_account__c,
                                Amount = (rec.Cash_required_Auction_flip__c * rec.ROI_Auction__c/100) *0.80, //soften profit down to absorb fees
                                CloseDate = date.today().addMonths(4),
                                Lead__c = rec.Id,
                                Name = rec.Name,
                                StageName = '0. Viewing');
                            insert newOpp;
                            rec.Status = 'Qualified';
                        }

                        // IF MARKETING_STATUS IS 'IGNORE' / 'REMOVED' >> STATUS = UNQUALIFIED
                        if (rec.status != 'Unqualified'){
                            if ((rec.marketing_status__c == 'Ignore') 
                            ||  (rec.marketing_status__c == 'Removed'))
                            {
                                rec.status = 'Unqualified';                    
                            }
                        }

                    }

                    // update STATUS as by now the lead is no longer New
                    if (rec.status == 'New')
                    {
                        rec.status = 'Analysis';                    
                    }

                    // get valuation for this lead
                    if ((rec.Callout_buffer__c == null )
                        && (rec.OMV_long_lease__c == null))
                    {
                        ID jobId_1 = system.enqueuejob( new Utils_PD_valuation_sale_Callout (rec.Id, 
                            rec.LastName.replace(' ','%20'),       // relace space in postcode with %20
                            string.valueOf(rec.Size_sqft__c), 
                            rec.Property_type__c,
                            rec.Construction__c,
                            string.valueOf(rec.Bedrooms__c),
                            '0',                // rec.Baths,
                            rec.Outdoor_space__c,
                            '0'                 // rec.Parking            
                        ));        
                        System.debug('Lead_update: ID of Job queued >> '+ jobId_1);
                        rec.Callout_buffer__c = 'In progress';
                    }

                }
                update Ids;
            }
        }  
}