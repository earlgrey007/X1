/* TODO EXAMPLE

    ** overview of ALL methods below: **
    private static Decimal getDecimal(String str){

    EG SAMPLE FUNCTION :

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

*/

public class LR_Title_update
{
    @InvocableMethod
    public static void LR_Title_update_MAIN( List<Id> IDs)
    {
    
        List<LR_Title__c> LR_IDs =
            [select id, Debug_APEX_bufer__c, Associated_Property_Description__c, 
            Lease_registration_date_string__c, Lease_registration_date__c, LeaseTerm_length__c,
            Region__c,Area__c, Term__c 
            from LR_Title__c WHERE id in :IDs
            ];
        
        for(LR_Title__c LRrec : LR_IDs)
        {       
            integer iDay = 0;
            integer iMonth = 0;
            integer iYear = 0;
            LRrec.Debug_APEX_bufer__c = '';

            //convert REGISTRATION date string to date:
            if (LRrec.Lease_registration_date_string__c != null){ // if NOT empty
                list<string> lstRegDate = LRrec.Lease_registration_date_string__c.split('-',4);   // format inported by Talend is dd-MM-yyyy
                system.debug('LR_Title_update >> MAIN >> lstRegDate >>' + lstRegDate);                                       //debug
                if (lstRegDate.size()>=2){
                    iDay =   integer.valueOf(lstRegDate[0].deleteWhitespace());
                    iMonth = integer.valueOf(lstRegDate[1].deleteWhitespace());
                    iYear =  integer.valueOf(lstRegDate[2].deleteWhitespace());
                    LRrec.Lease_registration_date__c = Date.newInstance(iYear, iMonth, iDay);
                    }
                }
            //END convert registration date STRING to DATE

            //get lease length from Term__c:
            if (LRrec.Term__c != null){ // if NOT empty 
                list<string> lstYear = LRrec.Term__c.toLowerCase().split('year',2);
                system.debug('LR_Title_update >> MAIN >> lstYear >>' + lstYear);                                             //debug
                if (lstYear.size()>1){
                    LRrec.LeaseTerm_length__c = integer.valueOf(lstYear[0].deleteWhitespace());
                }
            }
            //END get lease length from Term__c
            
            //get FROM date from Term__c
            if (LRrec.Term__c != null){ // if NOT empty
                list<string> lstFrom = LRrec.Term__c.toLowerCase().split('from ',5);
                system.debug('LR_Title_update >> MAIN >> lstFrom >>' + lstFrom);                                             //debug
                list<string> lstFromDate = lstFrom[1].split(' ',5);
                system.debug('LR_Title_update >> MAIN >> lstFromDate >>' + lstFromDate);                                             //debug
                if (lstFromDate.size() >= 2){

                    // get the month number
                    switch on lstFromDate[1].deleteWhitespace() {
                        when 'january'{     iMonth =  1;} 
                        when 'february'{    iMonth =  2;}
                        when 'march'{       iMonth =  3;}
                        when 'april'{       iMonth =  4;}
                        when 'may'{         iMonth =  5;}
                        when 'june'{        iMonth =  6;}
                        when 'july'{        iMonth =  7;}
                        when 'august'{      iMonth =  8;}
                        when 'september'{   iMonth =  9;}
                        when 'october'{     iMonth = 10;}
                        when 'november'{    iMonth = 11;}
                        when else{          iMonth = 12;}
                    }

                    iDay = integer.valueOf(lstFromDate[0].deleteWhitespace());
                    iYear = integer.valueOf(lstFromDate[2].deleteWhitespace());             
                    LRrec.LeaseTerm_start_date__c = Date.newInstance(iYear, iMonth, iDay);
                    LRrec.LeaseTerm_end_date__c = 
                        LRrec.LeaseTerm_start_date__c.addYears(integer.valueOf(LRrec.LeaseTerm_length__c)); 
                    system.debug('LR_Title_update >> MAIN >> Debug_APEX_bufer__c >>' + LRrec.Debug_APEX_bufer__c);     //debug
                }           
            }
            //END get FROM date from Term__c

            //retrieve POSTCODE from associated description:
            if (LRrec.Associated_Property_Description__c != null){ // if NOT empty

                // START SOAN PAON MATCHING
                list<string> lstAddress = LRrec.Associated_Property_Description__c.split(' ',99);   // format inported by Talend is dd-MM-yyyy
                System.debug( 'LR_Title_update >> MAIN >> lstPostParts ' + lstAddress);
                Plot__c lPlot= [
                    SELECT Id, Name, Address_saon__c, Address_paon__c, Address_postcode__c, Area__c
                    FROM Plot__c 
                    WHERE Address_paon__c = :lstAddress[0] 
                    LIMIT 1];         
                System.debug( 'LR_Title_update >> MAIN >> lPlot ' + lPlot);
                if (LRrec.Associated_Property_Description__c.contains( lPlot.Address_postcode__c) ){
                    LRrec.Plot__c = lPlot.Id;
                    LRrec.Area__c = lPlot.Area__c;
                } else {
                    LRrec.Postcode__c = 'Plot not found for '+ lstAddress[0]; // make a note on the LR_Title rec - helpful for future patches
                }
                
                // 29 MARCH 2021 - routine below is replaced by PAON + Postcode matching above PLUS links to correct PLOT__C
                /*
                // START POSTCODE MATCHING 
                list<string> lstPostParts = LRrec.Associated_Property_Description__c.split(' ',99);   // format inported by Talend is dd-MM-yyyy
                System.debug( 'LR_Title_update >> MAIN >> lstPostParts ' + lstPostParts);                    
                if (lstPostParts.size()>=1){
                    string sTmpPostCode = 
                        lstPostParts[lstPostParts.size()-2] +
                        + ' '
                        + lstPostParts[lstPostParts.size()-1];

                    // REGEX tester (ensure UK postcode is valid)
                    if (Pattern.matches('([A-Z][A-HJ-Y]?[0-9][A-Z0-9]? ?[0-9][A-Z]{2}|GIR ?0A{2})', sTmpPostCode)){

                        //valid postcode found; connect to AREA record 
                        list<Area_retrieval_status__c> aList = [SELECT id, Name, Area_Level__c from Area_retrieval_status__c WHERE Name = :sTmpPostCode];
                        if (aList.size() > 0){
                            LRrec.Area__c = aList[0].Id;
                            System.debug( 'LR_Title_update >> MAIN >> Area '+sTmpPostCode+' connected to '+aList );                    
                        } else {
                            // create new AREA record
                            aList.add( new Area_retrieval_status__c(
                                Name = sTmpPostCode, Area__c = sTmpPostCode
                                // area_level__c = '6.Postcode' << = default value so no need to specify here
                                )
                            );
                            insert aList;
                            LRrec.Area__c = aList[0].Id;
                            System.debug( 'LR_Title_update >> MAIN >> >> Area '+sTmpPostCode+' not found; creating and connected to '+aList );                    
                        }
                        //END valid postcode found; connect to AREA record 

                    } else {
                        LRrec.Debug_APEX_bufer__c = 'NO valid postcode found';                        //debug
                        System.debug( 'LR_Title_update >> MAIN >> NO valid postcode found in '+LRrec.Associated_Property_Description__c );                    
                    }
                }
                */

            }
            //END retrieve PLOT + POSTCODE from associated description:

        }
        update LR_IDs;

    }
}