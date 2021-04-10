public class LR_SetStartDate
{
    @InvocableMethod
    public static void SetStartDate(List<Id> IDs)
    {
    
        List<LR_Title__c> LR_IDs =
            [select id, Debug_APEX_bufer__c, Associated_Property_Description__c, 
            Lease_registration_date_string__c, Lease_registration_date__c, LeaseTerm_length__c,
            Postcode__c,Region__c,Term__c 
            from LR_Title__c WHERE id in :IDs
            ];
        
        for(LR_Title__c LRrec : LR_IDs)
        {       
            integer iDay = 0;
            integer iMonth = 0;
            integer iYear = 0;

            //retrieve postcode from associated description:
            if (LRrec.Associated_Property_Description__c != null){ // if NOT empty
                LRrec.Debug_APEX_bufer__c = 'NO POSTCODE FOUND';                        //debug
                list<string> lstPostParts = LRrec.Associated_Property_Description__c.split(' ',99);   // format inported by Talend is dd-MM-yyyy
                system.debug('lstPostParts >>' + lstPostParts);                                       //debug
                if (lstPostParts.size()>=1){
                    string sTmp = 
                        lstPostParts[lstPostParts.size()-2] +
                        + ' '
                        + lstPostParts[lstPostParts.size()-1];

                    // ensure UK postcode is valid

                    // REGEX tester 
                    String regexStr = sTmp;
                    Pattern regexPattern = Pattern.compile( '([A-Z][A-HJ-Y]?[0-9][A-Z0-9]? ?[0-9][A-Z]{2}|GIR ?0A{2})' );
                    Matcher regexMatcher = regexPattern.matcher(regexStr);
                    
                    if (Pattern.matches('([A-Z][A-HJ-Y]?[0-9][A-Z0-9]? ?[0-9][A-Z]{2}|GIR ?0A{2})', sTmp)){
                        LRrec.Postcode__c = sTmp;
                        LRrec.Debug_APEX_bufer__c = 'match :-)';
                    }

                    }
                }
            //END retrieve postcode from associated description:

            //convert registration date STRING to DATE:
            if (LRrec.Lease_registration_date_string__c != null){ // if NOT empty
                list<string> lstRegDate = LRrec.Lease_registration_date_string__c.split('-',4);   // format inported by Talend is dd-MM-yyyy
                system.debug('lstRegDate >>' + lstRegDate);                                       //debug
                if (lstRegDate.size()>=2){
                    iDay =   integer.valueOf(lstRegDate[0].deleteWhitespace());
                    iMonth = integer.valueOf(lstRegDate[1].deleteWhitespace());
                    iYear =  integer.valueOf(lstRegDate[2].deleteWhitespace());
                    LRrec.Lease_registration_date__c = Date.newInstance(iYear, iMonth, iDay);
                    }
                }
            //END convert registration date STRING to DATE:

            //if Term__c contains YEAR:
            if (LRrec.Term__c != null){ // if NOT empty 
                list<string> lstYear = LRrec.Term__c.toLowerCase().split('year',2);
                system.debug('lstYear >>' + lstYear);                                             //debug
                if (lstYear.size()>1){
                    LRrec.LeaseTerm_length__c = integer.valueOf(lstYear[0].deleteWhitespace());
                }
            }
            //END if Term__c contains YEAR:
            
            //if Term__c contains FROM:
            if (LRrec.Term__c != null){ // if NOT empty
                list<string> lstFrom = LRrec.Term__c.toLowerCase().split('from ',5);
                system.debug('lstFrom >>' + lstFrom);                                             //debug
                list<string> lstFromDate = lstFrom[1].split(' ',5);
                system.debug('lstFromDate >>' + lstFromDate);                                             //debug
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
                    system.debug('Debug_APEX_bufer__c >>' + LRrec.Debug_APEX_bufer__c);     //debug
                }           
            }
            //END if Term__c contains FROM:

         }
        update LR_IDs;
    }
}