trigger Area on Area_retrieval_status__c (before insert, before update, after insert, after update) {

//    ORIGINAL >> trigger AreaRetrieval_Trigger on Area_retrieval_status__c (before insert, after insert, after update) {

system.debug('Area >> START');

// Iterate through each event message.
for (Area_retrieval_status__c t : Trigger.New){

    system.debug('Area >> level 1'+ Trigger.new);

    // Get Read-only mode status; happens sometimes when Salesforce is doing maintenance
    ApplicationReadWriteMode mode = System.getApplicationReadWriteMode();
    if (mode != ApplicationReadWriteMode.READ_ONLY){

        if (Trigger.isBefore){
            if ((t.area_level__c.left(1) == '5') || (t.area_level__c.left(1) == '6')){
                t.Area__c = t.Area__c.toUppercase();
                t.Name = t.Area__c;
            }

            t.Area_Level_check__c = t.Area__c.toUppercase() + t.area_level__c;
        }
        system.debug('Area >> level 2: area level check on '+ t.area_level__c);
        system.debug('Area >> level 2: area level check on '+ t.area_level__c.left(1));

        if ((t.area_level__c.left(1) == '6')            // = postcode level
            && (Pattern.matches('([A-Z][A-HJ-Y]?[0-9][A-Z0-9]? ?[0-9][A-Z]{2}|GIR ?0A{2})', t.Area__c)))
            {

            system.debug('Area >> digesting valid postcode '+t.Area__c);

            // which postcodes to be checked further (eg Land Reg and EPC)                
            string[] pcodeListPOST = new list<string>();
            pcodeListPOST.add(t.Area__c);

                /* DEPRICATED
                && (t.Area__c.length()<10)          // UK postcodes are max 9 long  
                && (t.Area__c.indexof(' ') > 1)     // UK postcodes require a space after position 2 (start at 0)
                && (t.Area__c.indexof(' ') < 5)     // UK postcodes require a space before position 5 (start at 0)
                ){           
                */
            
            if (Trigger.isBefore && Trigger.isInsert){
                t.Area__c = t.Area__c.toUppercase();
                t.Name = t.Area__c;
                system.debug('Area >> IS BEFORE INSERT >> t = ' + t);

                if (t.area_level__c.left(1) == '6'){        // = postcode level
                    
                    t.Planning_Retrieval_required__c        = FALSE;
                    t.Planning_Last_accessed__c             = date.newInstance(1980, 2, 2);
                    t.Planning_Last_retrieved__c            = date.newInstance(1980, 1, 1);
                    t.PD_Ask_Data_retrieval_required__c     = FALSE;
                    t.PD_Ask_Data_Last_accessed__c          = date.newInstance(1980, 2, 2);
                    t.PD_Ask_Data_Last_retrieved__c         = date.newInstance(1980, 1, 1);
//                    t.LR_Trans_Data_retrieval_required__c   = TRUE;
                    t.LR_Trans_Data_Last_accessed__c        = date.newInstance(1980, 2, 2);
                    t.LR_Trans_Data_Last_Retrieved__c       = date.newInstance(1980, 1, 1);
                    t.EPC_Data_retrieval_required__c        = FALSE;                            // automatic with LR Transactions
                    t.EPC_Data_Last_accessed__c             = date.newInstance(1980, 2, 2);
                    t.EPC_Data_Last_retrieved__c            = date.newInstance(1980, 1, 1);

                    // get area upline and link to plot IF upline exists
                    string s_postDistrict = t.area__c.substring(0, t.area__c.indexof(' '));

                    Area_retrieval_status__c[] lst_PostcDistrict = [
                        SELECT id, Name 
                        FROM Area_retrieval_status__c 
                        WHERE /* toLabel(area_level__c)='5_Postcode_District' AND */ Name= :s_postDistrict 
                        LIMIT 1];
                    if (lst_PostcDistrict.size() > 0){
                        system.debug('Area >> area parent for ' + t.Name +' >> '+ lst_PostcDistrict[0].Name);
                    }

                    if (lst_PostcDistrict.size() > 0){
                        t.parent_area__c = lst_PostcDistrict[0].Id;
                        system.debug('Area >> area parent FOUND for ' + t.Name +' >> '+ lst_PostcDistrict[0].Name);
                    } else {
                        lst_PostcDistrict.add( new Area_retrieval_status__c( Name = s_postDistrict, Area__c = s_postDistrict, area_level__c = '5_Postcode_District' )); 
                        insert lst_PostcDistrict;
                        t.parent_area__c = lst_PostcDistrict[0].Id;
                        system.debug('Area >> area parent CREATED for ' + t.Name +' >> '+ lst_PostcDistrict[0].Name);
                    }        
                } 
            }                                    

            if (Trigger.isAfter){
                system.debug('Area >>  IS AFTER >> t = ' + t);

//              if (t.Nearest_Postcodes_refreshed__c && t.Nearest_Postcodes__c != null){
                if (t.Nearest_Postcodes__c != null){
                    string[] pcodeListPRE = t.Nearest_Postcodes__c.split('__'); // ="LS10 1EJ_35m__LS10 1EK_76m__.."
                    for(string s :pcodeListPRE){
                        pcodeListPOST.add( s.substringBefore('_') );
                    }
                    system.debug('Area >> postcodeList >> '+pcodeListPOST);
                }                 
            
    //START MONITOR

                // this call is to test VERY IMPORTANT area pricing calcualtions - to be moved to a more logical place later
                system.debug('Area >> Calling  >> Utils_SaveData.update_Area_Pricing' ); 
                //execute on individual postcode level for now, but could perfectly rolll up to get underlying postcode data for DISTRICT calculations :)
    // TODO !!! ***     boolean AreaPricesUpdated = Utils_SaveData.update_Area_Pricing( t.Area__c);

                boolean PcodeGeo_Data_Queued = false;       
                boolean EPC_Data_Queued      = false;       
                boolean LR_Trans_Data_Queued = false;   
                boolean Planning_Data_Queued = false;

                AsyncApexJob[] enqueuedJobs = [
                    SELECT 
                        /* ApexClassId, */ 
                        ApexClass.Name, Status
                    FROM AsyncApexJob 
                    WHERE 
                        apexClass.Name IN ('Utils_PcodeGeolocation_callout', 'Utils_LR_Transactions_callout', 'Utils_EPC_Domestic_callout')
                        AND (JobType='Queueable' AND Status IN ('Processing','Preparing','Queued')) 
                    LIMIT 10] ;

                for (AsyncApexJob J :enqueuedJobs){
                    PcodeGeo_Data_Queued  = (PcodeGeo_Data_Queued) || (J.apexClass.Name == 'Utils_PcodeGeolocation_callout');   // returns TRUE if one of the args are TRUE
                    EPC_Data_Queued       = (EPC_Data_Queued)      || (J.apexClass.Name == 'Utils_EPC_Domestic_callout');       // returns TRUE if one of the args are TRUE
                    LR_Trans_Data_Queued  = (LR_Trans_Data_Queued) || (J.apexClass.Name == 'Utils_LR_Transactions_callout');    // returns TRUE if one of the args are TRUE
                    Planning_Data_Queued  = (Planning_Data_Queued) || (J.apexClass.Name == 'Utils_PlanIT_Planning_Callout');    // returns TRUE if one of the args are TRUE
                    system.debug('Area >> enqueuedJobs >> ' +J.apexClass.Name +' ++ '+J.Status); 
                }
    //END MONITOR

                // launch retrievals covering this area (=usually postcode)
                // get geocode for postcode if this was just created
                if ( (t.Centrepoint_geo__latitude__s == null)
                        && (!PcodeGeo_Data_Queued))
                {
                    System.debug('Area >> Launching Utils_PcodeGeolocation_callout ( ' + t.Name);
                    ID jobId_1 = system.enqueuejob( new Utils_PcodeGeolocation_callout (t.Id, t.Name));     // this will also launch Utils_LR_Transactions_callout afterwards 
                }

/*
                // get all land reg transactions for this postcode                
                if ( (t.LR_Trans_Data_retrieval_required__c)
                        && (!LR_Trans_Data_Queued))
                {
                    ID jobId_2 = system.enqueuejob( new Utils_LR_Transactions_callout (pcodeListPOST));        
                    System.debug('Area >> launching Utils_LR_Transactions_callout ** BLOCKED FOR TESTING PURPOSES ** for ' + t.Area__c + ' within '+ pcodeListPOST );
                } else {
                    System.debug('Area >> NOT launching Utils_LR_Transactions_callout for ' + pcodeListPOST);
                }
*/

                // THE BELOW CHECKS IF A SEPERATE EXECUTION EPC RUN IS REQUIRED BY CHECKING EPC RETRIEVAL ON THE UI SCREEN.
                // EPC RETRIEVAL IS *ALWAYS* AND *AUCTOMATICALLY* CALLED BY THE Utils_callouts_LR_Transactions ABOVE  
                if ( (t.EPC_Data_retrieval_required__c)
                    && (!t.LR_Trans_Data_retrieval_required__c) // only execute if LR_Trans is NOT required
                    && (!EPC_Data_Queued))
                {
                    System.debug('Area >> Launching EPC direct FROM TRIGGER: ' + pcodeListPOST);
                    system.enqueuejob(new Utils_EPC_Domestic_callout( pcodeListPOST)); // create this as queable
                }

                if ( (t.Planning_retrieval_required__c)
                        && (!Planning_Data_Queued))
                {
                    system.debug('Area >> '+t.Planning_Last_Retrieved__c + ' <equals today> ' + t.Planning_Last_Retrieved__c.isSameDay( date.today()));          // dont fire if just fired and completed
                    System.debug('Area >> Launching Planning: ' + t.Id +','+ t.Name);
                    // ***  ENABLE IN PROD:
                    // ID jobId_3 = system.enqueuejob( new Utils_PlanIT_Planning_Callout (t.Id, t.Name));        
                }

    /* IGNORE PD ASK FOR NOW 
                if (b_PD_Ask_Data_Required){
                    System.debug('Area >> Launching PD_Ask_Data: ' + t.Id +','+ t.Name);
                    // NEW >>   jobId2 = system.enqueuejob(new Utils_EPC_Domestic_callout (t.Id, t.Name));
                    // OLD >>   Utils_Webservices.GetPD_Ask_Data( t.Id, t.Name);
                }
    */


            } // end after insert
            
        } // end if region = postcode 

    } // end if in read only mode

} // end for

system.debug('Area >>  END' );
}