public with sharing class Utils_SaveData {

    /*
        ** overview of ALL methods below: **
        private static Decimal getDecimal(String str){
        private static integer getPlotIdx( string s_Psaon,string s_Ppaon,string s_Pcode, list<Plot__c> l_plots ){
        private static integer getPlanIdx( string sPlanningRef, list<Planning_Application__c> lst ){
        public static void save_PD_AskData( Id Id, String pPostcode){    // TODO
        public static void save_LR_Trans_Data( Id Id, String pPostcode){   // TODO
        public static void save_EpcData(Id EPCid, String pPostcode){
        public static void save_PD_PlanningData( Id Id, String pPostcode){
    */

    /* uesful to execute in WORKBENCH to clean up test data:
        Land_Registry_transaction__c[] v = [SELECT Id from Land_Registry_transaction__c];
        delete v; 
        EPC_domestic_data__c[] w = [SELECT Id from EPC_domestic_data__c];
        delete w; 
        Plot__c[] x = [SELECT Id from Plot__c];
        delete x; 
        Planning_Application__c[] y = [SELECT Id from Planning_Application__c]; 
        delete y; 
        Area_retrieval_status__c[] z = [SELECT Id from Area_retrieval_status__c WHERE postcode__c like '%SE18 6%' ];
        delete z; 
    */

    private static Decimal getDecimal(String str){
        // this returns 0 if a numeric string doesnt contain valid number

        Decimal ans = null;
        try{
            ans = Decimal.valueOf(str);
        }catch(TypeException ex){
            //Swallow exception, or perhaps log it.
            ans = 0;
        }
        return ans;
    }

    private static integer getPlotNameIdx( string s_Name, list<Plot__c> l_plots ){
        // checks if this PLOT already exists - BY NAME
        // (returns -1 if plot is not found)
        system.debug('Utils_SaveData >>  getPlotNameIdx: searching for >> '+ s_Name );
        integer i = 0;
        integer idx = -1;
        while (i < l_plots.size() && idx == -1){ 
            // system.debug('Utils_SaveData >>  getPlotIdx: comparing to >> '+ (l_plots[i].Name.replace(',','')).replace(' ','') );
            if (( s_Name.equalsIgnoreCase(( l_plots[i].Name.replace(',','')).replace(' ','')))
            ){
                idx = i;
                system.debug('Utils_SaveData >>  getPlotNameIdx: ## MATCH ## >> '+ l_plots[i] );
            }
            i++;
        }

        if (idx == -1) {
            system.debug('Utils_SaveData >>  getPlotNameIdx: ## NOT FOUND ## >> '+ s_Name +'<<IN>>'+l_plots );
        }

        return idx;
    }

    private static integer get_Saon_PlotIdx( string pSaon,string s_Pcode, list<Plot__c> pPlots ){
        // checks if this PLOT already exists - by SAON POSTCODE
        // (returns -1 if plot is not found)

        pSaon = pSaon.removeStartIgnoreCase('Flat').normalizeSpace().split(' ')[0]; //get rid of flat prefix, leading/trailing spaces, first part before ' ' 
        // pSaon = pSaon.toUpperCase().trim();  
        system.debug('Utils_SaveData >> get_Saon_PlotIdx: searching for >> '+ pSaon +' in a list where i is max '+pPlots.size() );

        string s_Plot = '';
        integer i = 0;
        integer idx = -1;
        while (i < pPlots.size() && idx == -1){ 
            if (pPlots[i].address_Saon__c != null){
                // system.debug('Utils_SaveData >>  getPlotIdx: comparing to >> '+ l_plots[i] );
                s_Plot = pPlots[i].address_saon__c.replace(',','').removeStartIgnoreCase('Flat').normalizeSpace();
                system.debug('Utils_SaveData >> get_Saon_PlotIdx: COMPARING against >> ['+i+'] >> '+ s_Plot );

                if ((s_Plot == pSaon)
                    && (pPlots[i].address_postcode__c == s_Pcode)            
                ){
                    idx = i;
                    system.debug('Utils_SaveData >> get_Saon_PlotIdx: ## MATCH ## >> '+ pPlots[i] );
                }
            }
            i++;
        }
        if (idx == -1) {
            system.debug('Utils_SaveData >>  get_Saon_PlotIdx: ## NOT FOUND ## >> '+ pSaon +'<<IN>>'+ s_Pcode +'<<IN>>'+pPlots );
        }

        return idx;
    }

    private static integer getPlotIdx( string s_Psaon,string s_Ppaon,string s_Pcode, list<Plot__c> l_plots ){
        // checks if this PLOT already exists - by SAON PAON POSTCODE
        // (returns -1 if plot is not found)

        system.debug('Utils_SaveData >>  getPlotIdx: searching for >> '+ s_Psaon + ' & ' + s_Ppaon + ' & ' + s_Pcode + ' & ' +l_plots );
        integer i = 0;
        integer idx = -1;
        while (i < l_plots.size() && idx == -1){ 
            // system.debug('Utils_SaveData >>  getPlotIdx: comparing to >> '+ l_plots[i] );
            system.debug('Utils_SaveData >>  getPlotIdx: COMPARING against >> '+ l_plots[i].Name);
            if ((l_plots[i].address_saon__c == s_Psaon)
                && (l_plots[i].address_paon__c == s_Ppaon)            
                && (l_plots[i].address_postcode__c == s_Pcode)            
            ){
                idx = i;
                system.debug('Utils_SaveData >>  getPlotIdx: ## MATCH ## >> '+ l_plots[i] );
            }
            i++;
        }
        if (idx == -1) {
            system.debug('Utils_SaveData >>  get_Saon_PlotNameIdx: ## NOT FOUND ## >> '+ s_Psaon +'[,]'+ s_Ppaon +'<<IN>>'+ s_Pcode +'<<IN>>'+l_plots );
        }

        return idx;
    }


    // *** >> *************************************************************************************************************
    //                                                  **  PD ASK DATA  ** 

    public static string save_PD_Ask_Data( Id pId, string pPostcode, Utils_PD_Ask_Parser p){
        system.debug('Utils_SaveData >>  save_PD_Ask_Data: processing parser input for '+pPostcode + '>>' +p);

        PD_Ask_Data__c pRec = new PD_Ask_Data__c();
        list<PD_Ask_Data__c> lAsk = new list<PD_Ask_Data__c>();

    /*  DELETE ALL ASK RECS for this postcode in case I mess up **ONLY USE WITH APPROVAL FROM RON
        PD_Ask_Data__c[] xList = [SELECT id from PD_Ask_Data__c WHERE Area_retrieval_status__c= :pId] ;
        delete xList;
        */
        // OR..
    /*    */
        // ensure Names of ALL existing matching records have same name so they will be upserted instead of added (preventing  double counting etc..) 
        lAsk = [
            SELECT id, Name, Bedrooms__c, type__c, Distance_from__c 
            FROM PD_Ask_Data__c];
        for(PD_Ask_Data__c u: lAsk){
            u.Name = u.type__c + '_' + u.Bedrooms__c ;
        }
        update lAsk;

        /* 
        // delete list with previous results so we know it holds accurate results for this area
        Popular_Properties__c[] yList = [
            SELECT id 
            FROM Popular_Properties__c 
            WHERE Area_retrieval_status__c= :pId] ;
        delete yList;
        */

        // ***>>*****************************************
        // ** Loop through all rows provided by Parser **    
        // ** and upsert as PD ask data records        **    

        for (integer i=0; i < p.Data.Raw_data.size() ; i++ ){
            pRec = new PD_Ask_data__c();
            // capture occurrence WHERE bedrooms in source is null (= studio) 
            if (p.data.Raw_data[i].bedrooms == null) { 
                    pRec.Bedrooms__c = 0; 
                    string s = pPostcode + ' (0 bed ' + p.Data.Raw_data[i].type_z  +')';
                    pRec.Name = s.abbreviate(79);
                } else {
                    pRec.Bedrooms__c = integer.ValueOf( p.data.Raw_data[i].bedrooms);
                    string s = pPostcode + ' (' + p.Data.Raw_data[i].bedrooms + ' bed ' + p.Data.Raw_data[i].type_z +')';
                    pRec.Name = s.abbreviate(79);
                }
            pRec.Distance__c =          decimal.ValueOf( p.data.Raw_data[i].distance);
            pRec.Distance_from__c =     pPostcode;
            pRec.Lat_in__c =            decimal.ValueOf( p.data.Raw_data[i].lat);
            pRec.Lng_in__c =            decimal.ValueOf( p.data.Raw_data[i].lng);
            pRec.Price__c =             p.data.Raw_data[i].price;
            pRec.Type__c =              p.data.Raw_data[i].type_z;   

            pRec.Area_retrieval_status__c = pId;
            lAsk.add( pRec );

            }
        upsert lAsk;

        // ** END Loop through all rows provided by Parser **    
        // ***<<*********************************************

        // *** >> *****************************************************
        // **  calculate average price of units (type) on the market **    

        // get all properties with an asking price within N from postcode:  
        lAsk = [
            SELECT Name, Price__c, Bedrooms__c, Type__c, Distance__c 
            FROM PD_Ask_Data__c 
            WHERE Distance_from__c = :pPostcode ];

        //ensure list is sorted by type, bedrooms:
        for(PD_Ask_Data__c org: lAsk){
            org.Name = org.type__c +'_'+ org.Bedrooms__c;
        }
        lAsk.sort();
        
        // this will hold the price AVERAGE and the SUM of types with N bedrooms :) 
        integer ipop =0;
        Popular_Properties__c pop = new Popular_Properties__c( 
            Units__c = 0,
            Type__c= lAsk.get(0).Name, 
            Average_Ask__c = 0,
            Distance_Max__c = 0,
            Area_retrieval_status__c = pId, 
            Name = lAsk.get(0).Name);
        list<Popular_Properties__c> lPopProp = new List<Popular_Properties__c>();
        lPopProp.add(pop);
        system.debug('comparables INIT: ' + lPopProp);

        for(PD_Ask_Data__c org: lAsk){
            // ++ system.debug('org to compare: ' + org);
            pop = lPopProp.get(ipop); 
            // if org.name already in lPopProp
            if (pop.Type__c == org.Name){
                // update average
                pop.Average_Ask__c = (pop.Average_Ask__c * pop.Units__c + org.Price__c)/(pop.Units__c+1);
                // increase occurrence count stored in bedrooms integer AFTER claculating new avg
                pop.Units__c ++;            
                // increase max distance from postcode center
                pop.Distance_Max__c = org.Distance__c;
                // ++ system.debug('pop updated: ' + pop);
            } else {
                // add p (=new type and bedroom number) to lPopProp
                pop = new Popular_Properties__c(
                    Units__c = 1,
                    Type__c = org.Name,
                    Name = org.Name,
                    Average_Ask__c = org.Price__c,
                    Distance_Max__c = org.Distance__c);
                lPopProp.add(pop);
                ipop ++;
                // ++ system.debug('pop added: ' + pop);
            }
        }


        // ** >> *********************************************
        // ** RETRIEVE AVERAGE SIZE PER TYPE FOR THIS POSTCODE 

//        EPC_Domestic_data__c[] eList = [SELECT total_floor_area__c, Type__c, built_form__c from EPC_Domestic_data__c WHERE postcode__c = 'BN11 4HP'];        // ** RETRIEVE AVERAGE SIZE PER TYPE FOR THIS POSTCODE 
        // ** << *********************************************


        // link all items to the Area record and save list 
        for(Popular_Properties__c c: lPopProp){ 
            c.Area_retrieval_status__c = pId;
        }
        upsert lPopProp;

        system.debug( 'comparables FINAL: ' + lPopProp);
        
    /*      change line above into:
        try {
            upsert lPopProp;
        } catch {
            do stuff}
    */

        return ( 'The nearest '+ lAsk.size() + ' for sale properties were retrieved. See Popular Properties for the summary per type aand bedrooms.');
    }
        // **  calculate average price of units (type) on the market **    
        // *** << *****************************************************
        
    //                                                  **  PD ASK DATA  ** 
    // *** << *************************************************************************************************************


    // *** >> *************************************************************************************************************
    //                                              ** LR TRANSACTION DATA  ** 

    public static string save_LR_Transaction_Data( String pPostcode, Utils_LR_Transactions_parser LRtrans ){   // IN PROGRESS
        system.debug('Utils_SaveData >>  save_LR_Transaction_Data: APEX param received: >> '+pPostcode); 

        // which area (=MASTER REC) are we linking under.. 
        area_Retrieval_Status__c thisAreaRec = new area_Retrieval_Status__c();
        area_Retrieval_Status__c[] thisAreaRecList = [
            SELECT Id, LR_Trans_Data_retrieval_required__c, LR_Trans_Data_Last_retrieved__c, LR_Trans_Data_Retrieval_result_buffer__c 
            FROM area_Retrieval_Status__c WHERE Area__c = :pPostcode LIMIT 1];
        if (thisAreaRecList.size() > 0){
            thisAreaRec = thisAreaRecList[0];
        } else {
            thisAreaRec = new area_Retrieval_Status__c(Name= pPostcode, Area__c= pPostcode);
            insert thisAreaRec;
        }

        // retrieve existing plots for this postcode 
        integer i_Idx = -1;
        integer i_newPlotIdx = -1;
        Plot__c aPlotRec = new Plot__c();
        list<Plot__c> l_Plots = [
            SELECT Id, Name, Area__c, address_saon__c, address_paon__c, address_postcode__c 
            FROM Plot__c 
            WHERE address_postcode__c = :pPostcode];
        list<Plot__c> lst_ExistingPlotsInThisPostcode = new list<Plot__c>();

        // go through parsed results from land Reg callout: store transactions, link to existing plots (create if non existent yet), populate recent price info on plot record intself
        Land_Registry_transaction__c nLRrec = new Land_Registry_transaction__c();
        list<Land_Registry_transaction__c> nLRlist = new list<Land_Registry_transaction__c>();
               
        for (integer i=0; i < LRtrans.Result.Items.size() ; i++ ){
            system.debug('Utils_SaveData >>  save_LR_Transaction_Data >> transacton record '+i+' >> '+ LRtrans.Result.items[i]); 

            Land_Registry_transaction__c thisLRrec = new Land_Registry_transaction__c();

            // populate new land reg record fields 
            thisLRrec.Name = '';
            if (LRtrans.Result.items[i].propertyAddress.saon != null){
                thisLRrec.Name = LRtrans.Result.items[i].propertyAddress.saon +',';}
            thisLRrec.Name = thisLRrec.Name 
                                +LRtrans.Result.items[i].propertyAddress.paon 
                                +','+LRtrans.Result.items[i].propertyAddress.street
                                +','+LRtrans.Result.items[i].propertyAddress.postcode;

            thisLRrec.saon__c = LRtrans.Result.items[i].propertyAddress.saon;
            thisLRrec.paon__c = LRtrans.Result.items[i].propertyAddress.paon;
            thisLRrec.street__c = LRtrans.Result.items[i].propertyAddress.street;
            thisLRrec.town__c = LRtrans.Result.items[i].propertyAddress.town;
            thisLRrec.postcode__c = LRtrans.Result.items[i].propertyAddress.postcode;
            thisLRrec.district__c = LRtrans.Result.items[i].propertyAddress.district;
            thisLRrec.price_paid__c = LRtrans.Result.items[i].pricepaid;
            thisLRrec.property_type__c = LRtrans.Result.items[i].propertyType.label[0].x_value;
            thisLRrec.estate_type__c = LRtrans.Result.items[i].estateType.label[0].x_value; 
            thisLRrec.new_build__c = LRtrans.Result.items[i].newBuild; 
            thisLRrec.transaction_date__c = LRtrans.Result.items[i].transactionDate;
            thisLRrec.transaction_id__c = LRtrans.Result.items[i].transactionId;
            thisLRrec.transaction_URL__c = LRtrans.Result.items[i].hasTransaction;

//  !!!
//  WHERE do i check of transaction rec already exists so it doesn add it twice?
//  !!!

            // N E W   F R O M   H E R E 
            /*
            // Map LR fields to PLOT fields and let the UPSERT PLOT procedure do the hard lifting
            list<Plot_c> PlotsToUpsert = new list<Plots_cc>(); 
            

            // upsert plots:
            save_Plot_Data (pPostcode, PlotsToUpsert);    

            // N E W   U N T I L   H E R E 
            */

            // either link to existing or create new plot and then link
            i_Idx = getPlotIdx( thisLRrec.saon__c,thisLRrec.paon__c,thisLRrec.postcode__c, l_Plots );   // if subject (same saon+paon+postcode) plot exists.. 
            if (i_Idx > -1){
                thisLRrec.Plot__c = l_Plots[i_Idx].Id;                                                  // link this land reg record to related plot
            } else {
                system.debug('Utils_SaveData >>  save_LR_Transaction_Data >> check TO BE CREATED list for >> ' + thisLRrec.saon__c + thisLRrec.paon__c + thisLRrec.postcode__c+ ' IN ' + lst_ExistingPlotsInThisPostcode); 
                i_newPlotIdx = -1;
                if ( !lst_ExistingPlotsInThisPostcode.isEmpty() ){
                    i_newPlotIdx = getPlotIdx( thisLRrec.saon__c,thisLRrec.paon__c,thisLRrec.postcode__c, lst_ExistingPlotsInThisPostcode );    // get list index IF subject (same saon+paon+postcode) is in the 'to be created' lists.. 
                }
                if ((i_newPlotIdx == -1)                                                                                // if not found 
                    ){
                    aPlotRec= new Plot__c(
                        Name = thisLRrec.Name,                                                              // add fields to new plot record
                        area__c = thisAreaRec.Id,
                        address_saon__c = thisLRrec.saon__c,
                        address_paon__c = thisLRrec.paon__c,
                        address_street__c = thisLRrec.street__c,
                        address_town__c = thisLRrec.town__c,
                        address_postcode__c = thisLRrec.postcode__c,
                        price_paid__c = thisLRrec.price_paid__c,
                        price_paid_date__c = thisLRrec.transaction_date__c,
                        new_build__c = thisLRrec.new_build__c,
                        property_type__c = thisLRrec.property_type__c,
                        tenure__c = thisLRrec.estate_type__c);

                    lst_ExistingPlotsInThisPostcode.add( aPlotRec);                                                            // add plot record to 'to be created' list
                } else {
                    // if this LR record transaction date is more recent, update price and transaction date on 'to be created' plot record
                    if (thisLRrec.transaction_date__c.daysBetween( lst_ExistingPlotsInThisPostcode.get( i_newPlotIdx ).price_paid_date__c ) < 0){     // returns negative if calling date > date argument
                        lst_ExistingPlotsInThisPostcode[i_newPlotIdx].price_paid__c = thisLRrec.price_paid__c;
                        lst_ExistingPlotsInThisPostcode[i_newPlotIdx].price_paid_date__c = thisLRrec.transaction_date__c;
                        lst_ExistingPlotsInThisPostcode[i_newPlotIdx].new_build__c = thisLRrec.new_build__c;
                    }
                }
           }
           nLRlist.add( thisLRrec);                                                                // add land reg transaction to NEW(?) land reg list 

        }

        // insert new plots
        insert lst_ExistingPlotsInThisPostcode;
        system.debug('Utils_SaveData >>  NewPlots: after insert >> ' + lst_ExistingPlotsInThisPostcode.size());

        // link new plot IDs to land reg records:
        for (Land_Registry_transaction__c RL : nLRlist){
            i_Idx = getPlotIdx( RL.Saon__c, RL.Paon__c, RL.postcode__c, lst_ExistingPlotsInThisPostcode );
            if (i_Idx>-1){
                RL.plot__c = lst_ExistingPlotsInThisPostcode[i_Idx].Id;
            }
        }
        system.debug('Utils_SaveData >>  NewPlots: after insert >> ' + nLRlist);
        upsert nLRlist;

        string sReturn = '';
        if (thisAreaRec != null){
            thisAreaRec.LR_Trans_Data_retrieval_required__c = FALSE;
            thisAreaRec.LR_Trans_Data_Last_retrieved__c = date.today();
            thisAreaRec.LR_Trans_Data_Retrieval_result_buffer__c = nLRlist.size() + ' Land Reg transactions processed, ' +lst_ExistingPlotsInThisPostcode.size() +' related plots created.';        
        }

        try {
            update thisAreaRec;
        } catch(DmlException e) {
            sReturn = e.getMessage();
        }            

        return sReturn;
    }

    //                                              ** LR TRANSACTION DATA  ** 
    // *** << *************************************************************************************************************

    // *** >> *************************************************************************************************************
    //                                                  **  EPC DATA  ** 

    // checks if this building ref nr is already stored with the same lodging date 
    // (returns 0 if building ref is not a number)
    private static id getEPCidx( string sBuildRef, date dLodge, list<EPC_Domestic_data__c> lst ){
        system.debug('Utils_SaveData >> getEPCidx >> searching for >> '+ sBuildRef + ' & ' +dLodge + ' & ' +lst );
        integer i = 0;
        id idx = null;
        while (i < lst.size() && idx == null){ 
            // system.debug('Utils_SaveData >> getEPCidx >> COMPARING against >> '+ lst[i].building_reference_number__c + ' & ' +lst[i].lodgement_date__c);
            if ((lst[i].building_reference_number__c == sBuildRef)
                && (dLodge.Daysbetween( lst[i].lodgement_date__c) < 1)
            ){
                system.debug('Utils_SaveData >> getEPCidx >> found id >> ' +lst[i].Id);
                idx = lst[i].Id;
            }
            i++;
        }
        return idx;
    }

    // calc number of beds based on national standards
    private static integer calcBedrooms( integer i_GIA, string s_proptype, list<UK_National_space_standard__c> l_spaceRef ){
        system.debug('Utils_SaveData >>  calcBedrooms >> calcBedrooms : param IN >> '+ i_GIA + ' & ' + s_proptype);
        integer i_beds = 0;
        boolean b_flat = s_proptype.containsIgnoreCase('flat');
        for (UK_National_space_standard__c r : l_spaceRef){
            if (b_flat) {
                if (i_GIA > r.X1storey__c * 0.93){
                    i_beds = integer.valueof(r.Name);
                }
            } else{
                if (i_GIA > r.X2storey__c - 40){
                    i_beds = integer.valueof(r.Name);
                }

            }
        }
        system.debug('Utils_SaveData >> calcBedrooms : param OUT >> '+ i_beds);
        return i_beds;
    }

//  public static string save_EPC_data( Id pId, string pPostcode, Utils_EPC_Domestic_parser epc){
    public static void save_EPC_data( string pPostcode, Utils_EPC_Domestic_parser epc){
        system.debug('Utils_SaveData >>  save_EPC_Data >> APEX param received: >> '+pPostcode + '>>' +epc); 

        // get notional space standards to estimate bedrooms  
        list<UK_National_space_standard__c> l_spaceRef = [
            SELECT Name, X1storey__c, X2storey__c, X3storey__c 
            FROM UK_National_space_standard__c 
            ORDER BY Name]; // ensure 1 bed is first, then 2 bed etc..

        // initialize plot synchrionisation
        integer i_Idx = 0;
        Plot__c aPlotRec = new Plot__c();
        list<Plot__c> lst_ExistingPlotsInThisPostcode = [
            SELECT Id, Name, Area__c, address_saon__c, address_paon__c, address_postcode__c, property_type__c, bedrooms__c 
            FROM Plot__c
            WHERE address_postcode__c = :pPostcode];
        list<Plot__c> lst_NewPlots = new list<Plot__c>();
        list<String> lst_NewPlotNames = new list<String>(); // store plotnames so we dont create duplicate plots !!
        list<Plot__c> l_updPlots = new list<Plot__c>();
        list<Id> lst_PlotIds = new list<Id>();
        system.debug('Utils_SaveData >>  save_EPC_Data >> Matching plots found: '+lst_ExistingPlotsInThisPostcode.size() +'/' +epc.Rows.size()); 

        // get list of EPC recs that do not have matching plots
        for (integer i=0; i < epc.Rows.size() ; i++){       

            // generate teh correct Plot Name for search AND create purposes
            aPlotRec= new Plot__c();
            aPlotRec.address_saon__c     = epc.rows[i].address1.toUpperCase().trim();
            aPlotRec.address_paon__c     = epc.rows[i].address2.subStringBefore(',').trim().toUpperCase();
            aPlotRec.address_street__c   = epc.rows[i].address2.subStringAfter(',').trim().toUpperCase();
            aPlotRec.address_town__c     = epc.rows[i].posttown.toUpperCase().trim();
            aPlotRec.address_postcode__c = pPostcode.toUpperCase();
            aPlotRec.Name                = aPlotRec.address_saon__c +','+aPlotRec.address_paon__c +','+aPlotRec.address_street__c +','+aPlotRec.address_postcode__c;

            // find plot based on the exact saon and paon components of the address
            system.debug('Utils_SaveData >> save_EPC_Data >> search for Plot >> ' + aPlotRec.Name.replace(',','').replace(' ',''));
            i_Idx = getPlotNameIdx( (aPlotRec.Name.replace(',','')).replace(' ','') , lst_ExistingPlotsInThisPostcode );

            if (i_Idx == -1){ // try this if plot not found yet:
                i_Idx = get_Saon_PlotIdx( epc.rows[i].address1, epc.rows[i].postcode, lst_ExistingPlotsInThisPostcode );
                system.debug('Utils_SaveData >> save_EPC_Data >> search for Plot found at index ['+i_Idx+']: ['+ epc.rows[i].address +'++'+epc.rows[i].postcode);         

            }
            system.debug('Utils_SaveData >> getEPCidx >> save_EPC_Data >> search for Plot lst_NewPlots BEFORE LOOP [' + lst_NewPlots);
            if ((i_Idx == -1)
            && (lst_NewPlotNames.indexOf(aPlotRec.Name) == -1)) {
                aPlotRec.Area__c             = lst_ExistingPlotsInThisPostcode[0].Area__c;
                aPlotRec.Occupation__c       = epc.rows[i].tenure;
                aPlotRec.Property_type__c    = epc.rows[i].property_type;
                if ((aPlotRec.Property_type__c=='Flat')||(aPlotRec.Property_type__c=='Maisonette')){ 
                    aPlotRec.Property_type__c='Flat-maisonette';
                }               
                lst_NewPlotNames.add(aPlotRec.Name);        // remember so we dont add the same plot twice 
                lst_NewPlots.add(aPlotRec);
                system.debug('Utils_SaveData >> getEPCidx >> save_EPC_Data >> search for Plot >> inserting [' + aPlotRec);
            }         
        }
        if (lst_NewPlots.size()>0){
            try{
                insert(lst_NewPlots);
            } catch (DmlException e){
                // duplicates should not happen but saw recurring INSERT for same plot
                system.debug('Utils_SaveData >>  save_EPC_Data >> UPSERT EXCEPTION ' + e.getMessage() );
            }
        }

        // this query now should cover the FULL list of plots incl the newly parsed EPC records:
        lst_ExistingPlotsInThisPostcode = [
            SELECT Id, Name, Area__c, address_saon__c, address_paon__c, address_postcode__c, address_town__c, Bedrooms__c, Price_paid__c, Price_paid_date__c, Property_type__c, Total_floor_area__c 
            FROM Plot__c
            WHERE address_postcode__c = :pPostcode];
        system.debug('Utils_SaveData >>  save_EPC_Data >> Matching plots found AFTER INSERT of missing ones: '+lst_ExistingPlotsInThisPostcode.size() +'/' +epc.Rows.size()); 

        // initialize EPC stuff
        integer iNull = 0;
        integer iEPC = 0;
        list<EPC_Domestic_data__c> lst_ExistingEPCrecs = [
            SELECT building_reference_number__c, Lodgement_Date__c, Id 
            FROM EPC_Domestic_data__c 
            WHERE postcode__c = :pPostcode];
        system.debug('Utils_SaveData >>  save_EPC_Data >> lst_ExistingEPCrecs: start >> '+lst_ExistingEPCrecs); 
        list<Id> lst_EPCids = new list<Id>();

    /*  DELETE ALL RECS in case I mess up **ONLY USE WITH APPROVAL FROM RON  
        lst_ExistingEPCrecs = [SELECT id from EPC_Domestic_data__c];
        delete lst_ExistingEPCrecs;
    */

        EPC_Domestic_data__c anEPCrec = new EPC_Domestic_data__c();
        list<EPC_Domestic_data__c> lst_parsedEPCrecs = new list<EPC_Domestic_data__c>();
               
        for (integer i=0; i < epc.Rows.size() ; i++ ){

            system.debug('Utils_SaveData >>  save_EPC_Data >> lst_ExistingEPCrecs: loop >> '+lst_ExistingEPCrecs); 
            anEPCrec = new EPC_Domestic_data__c();
            anEPCrec.building_reference_number__c = epc.rows[i].building_reference_number;
            anEPCrec.Lodgement_Date__c = date.ValueOf( epc.rows[i].Lodgement_Date);
            anEPCrec.Id = getEPCidx( anEPCrec.building_reference_number__c, anEPCrec.lodgement_date__c, lst_ExistingEPCrecs);                   // retrieve existing Id if rec exists; so this record will be updated instead of inserting an extra copy

            anEPCrec.Name = epc.rows[i].Address1.replace(', ',',') + ',' + epc.rows[i].Address2 + ',' + epc.rows[i].postcode;
            anEPCrec.Name = anEPCrec.Name.replace(',,',',');                                                                        //  clean up ',,' due to empty strings
            anEPCrec.total_floor_area__c = getDecimal(epc.rows[i].total_floor_area) *10.768;                                    //convert m2 to sqft  
            if (anEPCrec.total_floor_area__c == null){ 
                anEPCrec.total_floor_area__c =0;}                                
            anEPCrec.low_energy_fixed_light_count__c = getDecimal(epc.rows[i].low_energy_fixed_light_count);
            anEPCrec.number_open_fireplaces__c = getDecimal(epc.rows[i].number_open_fireplaces);
            anEPCrec.extension_count__c = getDecimal(epc.rows[i].extension_count);
            anEPCrec.wind_turbine_count__c = getDecimal(epc.rows[i].wind_turbine_count);
            anEPCrec.co2_emissions_potential__c = getDecimal(epc.rows[i].co2_emissions_potential);
            anEPCrec.number_heated_rooms__c = getDecimal(epc.rows[i].number_heated_rooms);
            anEPCrec.number_habitable_rooms__c = getDecimal(epc.rows[i].number_habitable_rooms);
            anEPCrec.co2_emissions_current__c = getDecimal(epc.rows[i].co2_emissions_current);
            anEPCrec.environment_impact_current__c = getDecimal(epc.rows[i].environment_impact_current);
            anEPCrec.current_energy_efficiency__c = getDecimal(epc.rows[i].current_energy_efficiency);
            anEPCrec.co2_emiss_curr_per_floor_area__c = getDecimal(epc.rows[i].co2_emiss_curr_per_floor_area);
            anEPCrec.environment_impact_potential__c = getDecimal(epc.rows[i].environment_impact_potential);
            anEPCrec.potential_energy_efficiency__c = getDecimal(epc.rows[i].potential_energy_efficiency);
            anEPCrec.lighting_cost_potential__c = getDecimal(epc.rows[i].lighting_cost_potential);
            anEPCrec.lighting_cost_current__c = getDecimal(epc.rows[i].lighting_cost_current);
            anEPCrec.multi_glaze_proportion__c = getDecimal(epc.rows[i].multi_glaze_proportion);
            anEPCrec.low_energy_lighting__c = getDecimal(epc.rows[i].low_energy_lighting);
            anEPCrec.hot_water_cost_current__c = getDecimal(epc.rows[i].hot_water_cost_current);
            anEPCrec.hot_water_cost_potential__c = getDecimal(epc.rows[i].hot_water_cost_potential);
            anEPCrec.energy_consumption_potential__c = getDecimal(epc.rows[i].energy_consumption_potential);
            anEPCrec.energy_consumption_current__c = getDecimal(epc.rows[i].energy_consumption_current);
            anEPCrec.heating_cost_potential__c = getDecimal(epc.rows[i].heating_cost_potential);
            anEPCrec.heating_cost_current__c = getDecimal(epc.rows[i].heating_cost_current);
            anEPCrec.main_heating_controls__c = getDecimal(epc.rows[i].main_heating_controls);
            anEPCrec.inspection_date__c = Date.valueOf(epc.rows[i].inspection_date);
            anEPCrec.lodgement_date__c = Date.valueOf(epc.rows[i].lodgement_date);
            anEPCrec.lodgement_datetime__c = Date.valueOf(epc.rows[i].lodgement_datetime);
            anEPCrec.lmk_key__c = epc.rows[i].lmk_key;
            anEPCrec.floor_height__c = getDecimal(epc.rows[i].floor_height);
            anEPCrec.unheated_corridor_length__c = getDecimal(epc.rows[i].unheated_corridor_length);
            anEPCrec.address3__c = epc.rows[i].address3;
            anEPCrec.fixed_lighting_outlets_count__c = getDecimal(epc.rows[i].fixed_lighting_outlets_count);
            anEPCrec.flat_storey_count__c = getDecimal(epc.rows[i].flat_storey_count);
            anEPCrec.photo_supply__c = getDecimal(epc.rows[i].photo_supply);
            anEPCrec.floor_env_eff__c = epc.rows[i].floor_env_eff;
            anEPCrec.sheating_env_eff__c = epc.rows[i].sheating_env_eff;
            anEPCrec.construction_age_band__c = epc.rows[i].construction_age_band;
            anEPCrec.potential_energy_rating__c = epc.rows[i].potential_energy_rating;
            anEPCrec.mainheat_energy_eff__c = epc.rows[i].mainheat_energy_eff;
            anEPCrec.windows_env_eff__c = epc.rows[i].windows_env_eff;
            anEPCrec.lighting_energy_eff__c = epc.rows[i].lighting_energy_eff;
            anEPCrec.glazed_type__c = epc.rows[i].glazed_type;
            anEPCrec.mainheatcont_description__c = epc.rows[i].mainheatcont_description;
            anEPCrec.sheating_energy_eff__c = epc.rows[i].sheating_energy_eff;
            anEPCrec.property_type__c = epc.rows[i].property_type;
            if ((anEPCrec.property_type__c=='flat')||(anEPCrec.property_type__c=='maisonette')){
                anEPCrec.property_type__c='Flat-maisonette';
            }
            anEPCrec.local_authority_label__c = epc.rows[i].local_authority_label;
            anEPCrec.energy_tariff__c = epc.rows[i].energy_tariff;
            anEPCrec.mechanical_ventilation__c = epc.rows[i].mechanical_ventilation;
            anEPCrec.county__c = epc.rows[i].county;
            anEPCrec.postcode__c = epc.rows[i].postcode;
            anEPCrec.solar_water_heating_flag__c = epc.rows[i].solar_water_heating_flag;
            anEPCrec.constituency__c = epc.rows[i].constituency;
            anEPCrec.heat_loss_corridoor__c = epc.rows[i].heat_loss_corridoor;
            anEPCrec.floor_description__c = epc.rows[i].floor_description;
            anEPCrec.local_authority__c = epc.rows[i].local_authority;
            anEPCrec.built_form__c = epc.rows[i].built_form;
            anEPCrec.windows_description__c = epc.rows[i].windows_description;
            anEPCrec.glazed_area__c = epc.rows[i].glazed_area;
            anEPCrec.mains_gas_flag__c = epc.rows[i].mains_gas_flag;
            anEPCrec.constituency_label__c = epc.rows[i].constituency_label;
            anEPCrec.roof_energy_eff__c = epc.rows[i].roof_energy_eff;
            anEPCrec.roof_description__c = epc.rows[i].roof_description;
            anEPCrec.floor_energy_eff__c = epc.rows[i].floor_energy_eff;
            anEPCrec.address1__c = epc.rows[i].address1;    // SAON
            anEPCrec.address2__c = epc.rows[i].address2;    // PAON
            anEPCrec.hot_water_env_eff__c = epc.rows[i].hot_water_env_eff;
            anEPCrec.posttown__c = epc.rows[i].posttown;
            anEPCrec.mainheatc_energy_eff__c = epc.rows[i].mainheatc_energy_eff;
            anEPCrec.main_fuel__c = epc.rows[i].main_fuel;
            anEPCrec.lighting_env_eff__c = epc.rows[i].lighting_env_eff;
            anEPCrec.windows_energy_eff__c = epc.rows[i].windows_energy_eff;
            anEPCrec.lighting_description__c = epc.rows[i].lighting_description;
            anEPCrec.roof_env_eff__c = epc.rows[i].roof_env_eff;
            anEPCrec.walls_energy_eff__c = epc.rows[i].walls_energy_eff;
            anEPCrec.mainheat_env_eff__c = epc.rows[i].mainheat_env_eff;
            anEPCrec.flat_top_storey__c = epc.rows[i].flat_top_storey;
            anEPCrec.current_energy_rating__c = epc.rows[i].current_energy_rating;
            anEPCrec.secondheat_description__c = epc.rows[i].secondheat_description;
            anEPCrec.walls_env_eff__c = epc.rows[i].walls_env_eff;
            anEPCrec.transaction_type__c = epc.rows[i].transaction_type;
            anEPCrec.mainheat_description__c = epc.rows[i].mainheat_description;
            anEPCrec.mainheatc_env_eff__c = epc.rows[i].mainheatc_env_eff;
            anEPCrec.tenure__c = epc.rows[i].tenure;
            anEPCrec.floor_level__c = epc.rows[i].floor_level;
            anEPCrec.hot_water_energy_eff__c = epc.rows[i].hot_water_energy_eff;
            anEPCrec.walls_description__c = epc.rows[i].walls_description;
            anEPCrec.hotwater_description__c = epc.rows[i].hotwater_description;
            
            system.debug('Utils_SaveData >>  save_EPC_Data >> anEPCrec record >> ' +anEPCrec);
            // sanity check; only add record to update list if we didnt add this Id yet or Id=null  
            if ((lst_EPCids.IndexOf( anEPCrec.Id)==-1)
                || (anEPCrec.Id==null)
                ){
                    lst_parsedEPCrecs.add( anEPCrec );
                    lst_EPCids.add( anEPCrec.Id);
                    if(anEPCrec.Id==null){ 
                        iNull ++;}

                    // figure out the exact saon, paon components of the address
                    string s_strippedName = epc.rows[i].address1 + epc.rows[i].address2 + epc.rows[i].postcode;
                    system.debug('Utils_SaveData >> getEPCidx >> save_EPC_Data: enriching.. s_strippedname A >> ' + s_strippedName);

                    s_strippedName = (s_strippedName.replace(',','')).replace(' ',''); 
                    system.debug('Utils_SaveData >>  save_EPC_Data >> enriching.. s_strippedname B >> ' + s_strippedName);

                    // get 'THE' plot that matches saon, paon + postcode
                    i_Idx = getPlotNameIdx( s_strippedName, lst_ExistingPlotsInThisPostcode );
                    if (i_Idx == -1){
                        system.debug('Utils_SaveData >> getEPCidx >> StrippedName not found. Trying just the SAON + postcode.. ');
                        i_Idx = get_Saon_PlotIdx( epc.rows[i].address1, epc.rows[i].postcode, lst_ExistingPlotsInThisPostcode );
                    }

                    if ((i_Idx > -1)                                       // plot exists in database 
                        && (lst_PlotIds.IndexOf( lst_ExistingPlotsInThisPostcode[i_Idx].Id) ==-1) // plot Id is not in 'to update' list yet (if so updating twice throws an error)  
                    ){
                        anEPCrec.Plot__c = lst_ExistingPlotsInThisPostcode[i_Idx].Id;
                        aPlotRec = new Plot__c(
                            Id = lst_ExistingPlotsInThisPostcode[i_Idx].Id,
                            Bedrooms__c = anEPCrec.number_habitable_rooms__c -1,    // assume 1 room is lounge
                            Energy_rating__c = anEPCrec.current_energy_rating__c,
                            Occupation__c = anEPCrec.tenure__c);                            
                        anEPCrec.Total_floor_area__c = anEPCrec.total_floor_area__c *10.768;
                        if (anEPCrec.Total_floor_area__c == null){
                            anEPCrec.Total_floor_area__c = 0;
                        }
                        if (anEPCrec.construction_age_band__c != 'NO DATA!' ){
                            aPlotRec.Construction_year__c = anEPCrec.construction_age_band__c;
                        }
                        if (anEPCrec.transaction_type__c == 'new dwelling'){
                            aPlotRec.Construction_year__c = string.valueOf( anEPCrec.inspection_date__c.year() );
                        }
                        // replace property type ONLY if it adds correct info to the existing value. Eg if LR provides 'Terraced' the ONLY replace if EPC's property TYPE says 'House'. 
                        if (anEPCrec.property_type__c == 'House') {    
                            aPlotRec.property_type__c = anEPCrec.built_form__c;
                        }
                        if (aPlotRec.bedrooms__c == -1){
                            aPlotRec.bedrooms__c = calcBedrooms( integer.valueof(aPlotRec.total_floor_area__c), lst_ExistingPlotsInThisPostcode[i_Idx].property_type__c, l_spaceRef );
                        }
                    
                        l_updPlots.add(aPlotRec); // add plot to list to be updated at the end
                        lst_PlotIds.add(aPlotRec.Id);
                        system.debug('Utils_SaveData >>  save_EPC_Data >> enriching plots: ' + lst_ExistingPlotsInThisPostcode[i_Idx].Name);
                    }
                }
            }

        try{
            upsert lst_parsedEPCrecs;
            system.debug('Utils_SaveData >>  save_EPC_Data >> UPSERT ok ');
        } catch (DmlException e){
            // duplicates should not happen but saw recurring EPC source entries for building ref 7449860768 + same lodging date
            system.debug('Utils_SaveData >>  save_EPC_Data >> UPSERT EXCEPTION ' + e.getMessage() );
        }

        try{                                    // needs a check.. update still causes hard error if duplicate IDs in list
            upsert l_updPlots;                  // update existing PLUS create new plots
            system.debug('Utils_SaveData >>  save_EPC_Data >> UPSERT ok ');
        } catch (DmlException e){
            // duplicates should not happen but saw recurring EPC source entries for same lodging date
            system.debug('Utils_SaveData >>  save_EPC_Data >> PLOT UPSERT EXCEPTION ' + e.getMessage() );
        }

        // *** > > > calc LOCAL sqft etc..
        system.debug('Utils_SaveData >>  save_EPC_Data >> Area >> plots sold in related postcodes last 18 months >> '+lst_ExistingPlotsInThisPostcode.size());

        double iFlatsAmountLocal=0;
        double iNon_FlatsAmountLocal=0;
        integer iFlatsCountLocal=0;
        integer iNon_FlatsCountLocal=0;
        double iFlatsSqftLocal=0.00001;          // prevents divide by zero error :)
        double iNon_FlatsSqftLocal=0.000001;     // prevents divide by zero error :)
        double iFlatsAmount=0;
        double iNon_FlatsAmount=0;
        integer iFlatsCount=0;
        integer iNon_FlatsCount=0;
        double iFlatsSqft=0.00001;          // prevents divide by zero error :)
        double iNon_FlatsSqft=0.000001;     // prevents divide by zero error :)

        if (lst_ExistingPlotsInThisPostcode.size() > 0){
            double SalesHistValue = [SELECT Sales_History__c FROM Area_Retrieval_Status__c WHERE Id = :lst_ExistingPlotsInThisPostcode[0].Area__c limit 1].Sales_History__c;
            date SalesHistToConsider= date.today().addDays(-SalesHistValue.intValue() *30);                // Sales_history__c is on months, so in this case go N * 30 days back                                           
    
            for (plot__c p :lst_ExistingPlotsInThisPostcode){
                system.debug('Utils_SaveData >>  save_EPC_Data >> looping through sales data >> '+p );

                if (  (p.Price_paid_date__c > SalesHistToConsider)
                   && (p.Price_paid__c != null)
                   && ((p.Total_floor_area__c != null) || (p.bedrooms__c != null))) 
                {
                    system.debug('Utils_SaveData >>  save_EPC_Data >> NO NULL VALUES ?? >> '+p );
                    if ((p.Total_floor_area__c == null) && (p.bedrooms__c != null)){
                        p.Total_floor_area__c = 300 + p.bedrooms__c * 200;  // good enough for rough valuation 
                    } 
                    if ((p.Property_type__c !=null) && (p.Property_type__c == 'Flat-maisonette')){
                        iFlatsAmount = iFlatsAmount + p.Price_paid__c;
                        iFlatsCount++;
                        iFlatsSqft = iFlatsSqft + p.Total_floor_area__c;
                    } else {
                        iNon_FlatsAmount = iNon_FlatsAmount + p.Price_paid__c;
                        iNon_FlatsCount++;
                        iNon_FlatsSqft = iNon_FlatsSqft + p.Total_floor_area__c;
                    }
                    if (p.address_postcode__c == pPostcode){
                        if ((p.Property_type__c !=null) && (p.Property_type__c == 'Flat-maisonette')){
                            iFlatsAmountLocal = iFlatsAmountLocal + p.Price_paid__c;
                            iFlatsCountLocal++;
                            iFlatsSqftLocal = iFlatsSqftLocal + p.Total_floor_area__c;
                        } else {
                            iNon_FlatsAmountLocal = iNon_FlatsAmountLocal + p.Price_paid__c;
                            iNon_FlatsCountLocal++;
                            iNon_FlatsSqftLocal = iNon_FlatsSqftLocal + p.Total_floor_area__c;
                        }
                    }
                    system.debug('Utils_SaveData >>  save_EPC_Data >> Sales data FLATS >> '+iFlatsCount +'++'+iFlatsAmount +'++'+iFlatsSqft );
                    system.debug('Utils_SaveData >>  save_EPC_Data >> Sales data NON FLATS >> '+iNon_FlatsCount +'++'+iNon_FlatsAmount +'++'+iNon_FlatsSqft );
                }
            }
        
        // ** UPDATE Area_Retrieval record that prompted this call        

            Area_Retrieval_Status__c[] anAreaList = 
                [SELECT Id,
                    EPC_Data_Retrieval_required__c, EPC_Data_Retrieval_result_buffer__c, EPC_Data_Last_retrieved__c,
                    Flats_sold_local__c, Flats_sold_local_psqft__c, Flat_price_local__c, Flat_size_local__c, 
                    Non_flat_sold_local__c, Non_flats_sold_local_psqft__c, Non_flats_price_local__c, Non_flats_size_local__c,
                    Flats_sold__c, Flats_sold_psqft__c, Flat_price__c, Flat_size__c, 
                    Non_flats_sold__c, Non_flats_sold_psqft__c, Non_flat_price__c, Non_flat_size__c 
                FROM Area_Retrieval_Status__c where Area__c = :pPostcode limit 1];
            
            for (Area_Retrieval_Status__c a :anAreaList){
                // flats:
                a.Flats_sold_local__c = iFlatsCountLocal;
                a.Flats_sold_local_psqft__c = iFlatsAmountLocal / iFlatsSqftLocal;
                if (iFlatsCount > 0){    
                    a.Flat_price_local__c = iFlatsAmountLocal / iFlatsCountLocal;
                    a.Flat_size_local__c = iFlatsSqftLocal / iFlatsCountLocal;
                }
                a.Non_flat_sold_local__c = iNon_FlatsCountLocal;
                a.Non_flats_sold_local_psqft__c = iNon_FlatsAmountLocal / iNon_FlatsSqftLocal;
                if (iNon_FlatsCount > 0){ 
                    a.Non_flats_price_local__c = iNon_FlatsAmountLocal / iNon_FlatsCountLocal;
                    a.Non_flats_size_local__c = iNon_FlatsSqftLocal / iNon_FlatsCountLocal;
                }

                a.Flats_sold__c = iFlatsCount;
                a.Flats_sold_psqft__c = iFlatsAmount / iFlatsSqft;
                if (iFlatsCount > 0){    
                    a.Flat_price__c = iFlatsAmount / iFlatsCount;
                    a.Flat_size__c = iFlatsSqft / iFlatsCount;
                }
                a.Non_flats_sold__c = iNon_FlatsCount;
                a.Non_flats_sold_psqft__c = iNon_FlatsAmount / iNon_FlatsSqft;
                if (iNon_FlatsCount > 0){ 
                    a.Non_flat_price__c = iNon_FlatsAmount / iNon_FlatsCount;
                    a.Non_flat_size__c = iNon_FlatsSqft / iNon_FlatsCount;
                }

                a.EPC_Data_Last_retrieved__c = date.today();
                a.EPC_Data_Retrieval_required__c = FALSE;
                a.EPC_Data_Retrieval_result_buffer__c = string.valueOf(epc.Rows.size()) + ' EPC rows received. ' + string.valueOf(iNull) + '(/'+lst_NewPlots.size()+') EPC (/Plot) records created; ' 
                    + string.valueOf(lst_parsedEPCrecs.size() -iNull) + '(/' + l_updPlots.size() + ') EPC (/Plot) records were updated.';
            }
        update anAreaList;    
        // *** < < < calc LOCAL sqft ect..
        }
        system.debug('Utils_SaveData >>  save_EPC_Data >> done; see EPC area record for result');

    }

    //                                                  **  EPC DATA  ** 
    // *** << *************************************************************************************************************


    // *** >> *************************************************************************************************************
    //                                                  **  PLAN IT PLANNING DATA  ** 
    //                        ** this is the MAIN planning soure as it provides history of ALL applicatons **
    //                    ( the Property Data set below returns only a handful of applications in the postcode )
    
    private static integer getPlanIdx( string sPlanningRef, list<Planning_Application__c> lst ){
        // checks if this building ref nr is already stored with the same lodging date 
        // (returns 0 if building ref is not a number)

        system.debug('Utils_SaveData >>  getPlanIdx: searching for >> '+ sPlanningRef + ' & ' +lst );
        integer i = 0;
        integer idx = -1;
        while (i < lst.size() && idx == -1){ 
            system.debug('Utils_SaveData >>  getPlanIdx: COMPARING against >> '+ lst[i].reference__c);
            if ((lst[i].reference__c == sPlanningRef)
           ){
                system.debug('Utils_SaveData >>  getPlanIdx: found id >> ' +lst[i].Id);
                idx = i;
            }
            i++;
        }
        return idx;
    }


    private static string safeAbbreviate( string s_param, integer s_length ){
        string s_return = '';
        if (s_param != null){
            s_return = s_param.abbreviate(s_length);
        }
        return s_return;
    }



    public static string save_PlanIT_Planning( Id pId, string pPostcode, Utils_PlanIT_Planning_Parser p){
        system.debug('Utils_SaveData >>  save_PlanIT_Planning : APEX param received: >> Id='+pId+' for '+pPostcode + '>>' +p);

        // get existing records in postcode district (=UK: part before middle space)
        integer iExisting = 0;
        list<Planning_Application__c> currPlanningRecs = [
            SELECT Id, reference__c, distance__c 
            FROM Planning_Application__c];
        system.debug('Utils_SaveData >>  save_Planning_Data: currPlanningrecs: start >> '+currPlanningrecs); 

        Planning_Application__c pRec = new Planning_Application__c();
        list<Planning_Application__c> lPlanningApplic = new list<Planning_Application__c>();

        /* DELETE ALL RECS in case I mess up **ONLY USE WITH APPROVAL FROM RON 
        lPlanningApplic = [SELECT id from Planning_Application__c];
        delete lPlanningApplic;
        lPlanningApplic.clear();
        */

        // pId is null if Area record was just created; this will retrieve the new record Id 
        if (pId == null){
            Area_retrieval_status__c[] areaList= [
                SELECT id 
                FROM Area_retrieval_status__c 
                WHERE Name = :pPostcode limit 1];
            system.debug('Utils_SaveData >>  save_PlanIT_Planning : AREA IDs received: >> '+areaList );
            if (areaList != null){
                pId = areaList[0].Id; }
            system.debug('Utils_SaveData >>  save_PlanIT_Planning : AREA ID received: >> Id='+pId );
        }

        // for future use to store architects, planners, etc
        contact c = new contact();
        list<Contact> cList = new list<Contact>(); //TODO store contact details under contact object 

        // ***************************
        // ** Loop through all rows **    

        for (integer i=0; i < p.records.size() ; i++ ){
            pRec = new Planning_Application__c();

/* later
            // retrieve existing Id if rec exists; so this record will be updated instead of inserting an extra copy
            integer i_planIdx = getPlanIdx( p.Records[i].reference, currPlanningrecs); 
            system.debug('Utils_SaveData >>  save_PlanIT_Planning i_PlanIdx: '+i_PlanIdx );
            if (i_PlanIdx >-1){
                pRec.Id = currPlanningRecs[i_PlanIdx].Id;
                system.debug('Utils_SaveData >>  save_PlanIT_Planning :'+currPlanningRecs[i_PlanIdx].distance__c+' << >> '+ decimal.valueOf( p.Records[i].distance) );
                if (currPlanningRecs[i_PlanIdx].distance__c > decimal.valueOf( p.Records[i].distance)){      // if ditance to this postcode is closer than existing linked area
                    pRec.distance__c = decimal.valueOf( p.Records[i].distance);       // update distance
                    pRec.Area_retrieval_status__c = pId;                                                // link to this area
                    system.debug('Utils_SaveData >>  save_PlanIT_Planning : TRUE '+pRec.distance__c+' << >> '+ decimal.valueOf( p.Records[i].distance) );
                }    
                iExisting ++;   // increase counter to display in final result
            } else {
                pRec.Area_retrieval_status__c = pId;
                pRec.distance__c = decimal.valueOf( p.Records[i].distance);    
            }
*/
            string s_category           = '';
            if (p.Records[i].description != null){
            if (p.Records[i].description.containsIgnoreCase('extension')){       s_category = 'EXTENSION'; }
            if (p.Records[i].description.containsIgnoreCase('erection')){        s_category = 'NEW BUILD'; }
            }

            string s =                  p.Records[i].uid + ' (' + s_category + ',' + p.Records[i].app_type + '): ' + p.Records[i].app_state ;

            pRec.Name =                 s.abbreviate(79).replace('null','unknown'); // onlyl use the firs 79 chars (Name has a length limit) and replace 'null' strings (happens when type_z is empty)
            pRec.Address__c =           p.Records[i].address;
            //  pRec.Contact_Name__c =      p.Records[i].agent.name;
            //  pRec.Contact_Company__c =   p.Records[i].agent.company;
            //  pRec.Contact_Address__c =   p.Records[i].agent.address;
            pRec.authority__c =         p.Records[i].authority_name;
            //  pRec.ward__c =              p.Records[i].ward;
            //  pRec.case_officer__c =      p.Records[i].case_officer;
            pRec.reference__c =         p.Records[i].uid;
            pRec.category__c =          s_category; // derived from description
//            if (p.Records[i].description != null){
//                pRec.proposal__c =      p.Records[i].description.abbreviate(999); // max length 999 chars
//            }
            pRec.proposal__c =          safeAbbreviate( p.Records[i].description, 999); // max length 999 chars
            pRec.type__c =              p.Records[i].app_type;
            pRec.Application_size__c =  p.Records[i].app_size;
            pRec.status__c =            p.Records[i].app_state;
            system.debug('Utils_SaveData >>  save_PlanIT_Planning: >> pRec at line 680 >>'+ pRec );
            //  pRec.decision_rating__c =   p.Records[i].decision.rating;
            //  pRec.appeal_status__c =     p.Records[i].appeal.status;
            //  pRec.appeal_decision__c =   p.Records[i].appeal.decision;
            pRec.Application_URL__c =   safeAbbreviate (p.Records[i].url, 254);

            if (p.Records[i].start_date != null ){
                pRec.date_received__c = date.ValueOf( p.Records[i].start_date); }
            //  pRec.date_validated__c =    date.ValueOf( p.Records[i].dates.validated_at);
            if (p.Records[i].decided_date != null){
                pRec.date_decided__c =  date.ValueOf( p.Records[i].decided_date); }
            
            if ((p.Records[i].lat != null) && (p.Records[i].lng != null)) {    
                pRec.lat_in__c = decimal.valueOf( p.Records[i].lat);
                pRec.lng_in__c = decimal.valueOf( p.Records[i].lng);
            }

            // system.debug('Utils_SaveData >>  save_PlanIT_Planning: >> full lPlanningApplic before add ('+lPlanningApplic.size()+') >> ' +lPlanningApplic);
            system.debug('Utils_SaveData >>  save_PlanIT_Planning: >> about to add to '+pId+' >> '+ pRec );


/*        // sanity check; only add record to update list if we didnt add this Id yet or Id=null  
            if ((lst_EPCids.IndexOf( anEPCrec.Id)==-1)
                || (anEPCrec.Id==null)
                ){
                    lst_parsedEPCrecs.add( anEPCrec );
                    lst_EPCids.add( anEPCrec.Id);
                    if(anEPCrec.Id==null){ 
                        iNull ++;}
                }
*/

            lPlanningApplic.add( pRec );

/*
            c = new contact(); // TODO: extend with other fields and insert after having the link from the new planning  record
            c.LastName = String.ValueOf(p.Records[i].agent.name);
            cList.Add( c);

            for (integer j=0; j<lPlanningApplic.size(); j++){
                system.debug('Utils_SaveData >>  save_PlanIT_Planning: >> checking lPlanningApplic until now ['+j+'] >> ' +lPlanningApplic.get(j) );    
            }
*/

            }
        upsert lPlanningApplic;

/*      change line above into:
        try {
            upsert lPlanningApplic;
        } catch {
            do stuff}
        */

        return( string.valueOf( iExisting) + ' existing applications were updated,' + string.valueOf( lPlanningApplic.size()- iExisting) + ' new applications added.');
    }

    //                                                  **  PLANIT PLANNING DATA  ** 
    // *** << *************************************************************************************************************





    // *** >> *************************************************************************************************************
    //                                                  **  PLANNING DATA  ** 
    //                                  **  retuns a very small set, not very useful ** 


    public static string save_PD_PlanningData( Id pId, string pPostcode, Utils_PD_Planning_Parser p){
        system.debug('Utils_SaveData >>  save_PD_PlanningData : APEX param received: >> Id='+pId+' for '+pPostcode + '>>' +p);

        // get existing records in postcode district (=UK: part before middle space)
        integer iExisting = 0;
        list<Planning_Application__c> currPlanningRecs = [
            SELECT Id, reference__c, distance__c 
            FROM Planning_Application__c];
        system.debug('Utils_SaveData >>  save_Planning_Data: currPlanningrecs: start >> '+currPlanningrecs); 

        Planning_Application__c pRec = new Planning_Application__c();
        list<Planning_Application__c> lPlanningApplic = new list<Planning_Application__c>();

        /* DELETE ALL RECS in case I mess up **ONLY USE WITH APPROVAL FROM RON 
        lPlanningApplic = [SELECT id from Planning_Application__c];
        delete lPlanningApplic;
        lPlanningApplic.clear();
        */

        // pId is null if Area record was just created; this will retrieve the new record Id 
        if (pId == null){
            Area_retrieval_status__c[] areaList= [
                SELECT id 
                FROM Area_retrieval_status__c 
                WHERE Name = :pPostcode limit 1];
            system.debug('Utils_SaveData >>  save_PD_PlanningData : AREA IDs received: >> '+areaList );
            if (areaList != null){
                pId = areaList[0].Id; }
            system.debug('Utils_SaveData >>  save_PD_PlanningData : AREA ID received: >> Id='+pId );
        }

        contact c = new contact();
        list<Contact> cList = new list<Contact>(); //TODO store contact details under contact object 

        // ***************************
        // ** Loop through all rows **    

        for (integer i=0; i < p.Data.Planning_applications.size() ; i++ ){
            pRec = new Planning_Application__c();

            // retrieve existing Id if rec exists; so this record will be updated instead of inserting an extra copy
            integer i_planIdx = getPlanIdx( p.Data.Planning_applications[i].reference, currPlanningrecs); 
            system.debug('Utils_SaveData >>  save_PD_PlanningData i_PlanIdx: '+i_PlanIdx );
            if (i_PlanIdx >-1){
                pRec.Id = currPlanningRecs[i_PlanIdx].Id;
                system.debug('Utils_SaveData >>  save_PD_PlanningData :'+currPlanningRecs[i_PlanIdx].distance__c+' << >> '+ decimal.valueOf( p.Data.Planning_applications[i].distance) );
                if (currPlanningRecs[i_PlanIdx].distance__c > decimal.valueOf( p.Data.Planning_applications[i].distance)){      // if ditance to this postcode is closer than existing linked area
                    pRec.distance__c = decimal.valueOf( p.Data.Planning_applications[i].distance);       // update distance
                    pRec.Area_retrieval_status__c = pId;                                                // link to this area
                    system.debug('Utils_SaveData >>  save_PD_PlanningData : TRUE '+pRec.distance__c+' << >> '+ decimal.valueOf( p.Data.Planning_applications[i].distance) );
                }    
                iExisting ++;   // increase counter to display in final result
            } else {
                pRec.Area_retrieval_status__c = pId;
                pRec.distance__c = decimal.valueOf( p.Data.Planning_applications[i].distance);    
            }

            string s =                  p.Data.Planning_applications[i].reference + ' (' + p.Data.Planning_applications[i].category + ',' + p.Data.Planning_applications[i].type_z + '): ' + p.Data.Planning_applications[i].decision.text_z ;

            pRec.Name =                 s.abbreviate(79).replace('null','unknown'); // onlyl use the firs 79 chars (Name has a length limit) and replace 'null' strings (happens when type_z is empty)
            pRec.Address__c =           p.Data.Planning_applications[i].address;
            pRec.Contact_Name__c =      p.Data.Planning_applications[i].agent.name;
            pRec.Contact_Company__c =   p.Data.Planning_applications[i].agent.company;
            pRec.Contact_Address__c =   p.Data.Planning_applications[i].agent.address;
            pRec.authority__c =         p.Data.Planning_applications[i].authority;
            pRec.ward__c =              p.Data.Planning_applications[i].ward;
            pRec.case_officer__c =      p.Data.Planning_applications[i].case_officer;
            pRec.reference__c =         p.Data.Planning_applications[i].reference;
            pRec.category__c =          p.Data.Planning_applications[i].category.ToUpperCase();     // source provides capitalised string..

            if (p.Data.Planning_applications[i].proposal != null){
                pRec.proposal__c =      p.Data.Planning_applications[i].proposal.abbreviate(999);   // max length 999 chars
            }
            pRec.type__c =              p.Data.Planning_applications[i].type_z;
            pRec.status__c =            p.Data.Planning_applications[i].status;
            pRec.decision_text__c =     p.Data.Planning_applications[i].decision.text_z;
            pRec.decision_rating__c =   p.Data.Planning_applications[i].decision.rating;
            pRec.appeal_status__c =     p.Data.Planning_applications[i].appeal.status;
            pRec.appeal_decision__c =   p.Data.Planning_applications[i].appeal.decision;
            
            pRec.date_received__c =     date.ValueOf( p.Data.Planning_applications[i].dates.received_at);
            pRec.date_validated__c =    date.ValueOf( p.Data.Planning_applications[i].dates.validated_at);
            pRec.date_decided__c =      date.ValueOf( p.Data.Planning_applications[i].dates.decided_at);
            
            pRec.lat_in__c =            decimal.valueOf( p.Data.Planning_applications[i].lat);
            pRec.lng_in__c =            decimal.valueOf( p.Data.Planning_applications[i].lng);

            // system.debug('Utils_SaveData >>  save_PD_PlanningData: >> full lPlanningApplic before add ('+lPlanningApplic.size()+') >> ' +lPlanningApplic);
            system.debug('Utils_SaveData >>  save_PD_PlanningData: >> about to add to '+pId+' >> '+ pRec );


/*        // sanity check; only add record to update list if we didnt add this Id yet or Id=null  
            if ((lst_EPCids.IndexOf( anEPCrec.Id)==-1)
                || (anEPCrec.Id==null)
                ){
                    lst_parsedEPCrecs.add( anEPCrec );
                    lst_EPCids.add( anEPCrec.Id);
                    if(anEPCrec.Id==null){ 
                        iNull ++;}
                }
*/

            lPlanningApplic.add( pRec );

            c = new contact(); // TODO: extend with other fields and insert after having the link from the new planning  record
            c.LastName = String.ValueOf(p.Data.Planning_applications[i].agent.name);
            cList.Add( c);

            for (integer j=0; j<lPlanningApplic.size(); j++){
                system.debug('Utils_SaveData >>  save_PD_PlanningData: >> checking lPlanningApplic until now ['+j+'] >> ' +lPlanningApplic.get(j) );
            }
        }
        upsert lPlanningApplic;

/*      change line above into:
        try {
            upsert lPlanningApplic;
        } catch {
            do stuff}
*/
    return( string.valueOf( iExisting) + ' existing applications were updated, ' + string.valueOf( lPlanningApplic.size()- iExisting) + ' new applications added.');
    }

    //                                                  **  PLANNING DATA  ** 
    // *** << *************************************************************************************************************



}