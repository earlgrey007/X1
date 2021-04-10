/*
public with sharing class Offer_update {
    public Offer_update() {

    }
}
*/

public inherited sharing class Offer_update {

    /*         overview of all sections below:
    */    

        @InvocableMethod
        public static void Offer_update(List<Id> OfferIds)
        {
            List<Offer__c> Ids =
                [select id, Name, 
                    Accepted__c, Counter_date__c, Counter_offer__c, Offer_amount__c, Offer_date__c, 
                    Opportunity__c
                from Offer__c WHERE id in :OfferIds
                ];

            if (Ids.size()> 0){
                System.debug('Offer_update (Ids:) >> '+ Ids);

                // more efficient to declare vars here
                string s1= '';
                // vars for lease extension premium calc 
        
                // MAIN SECTION
                for(Offer__c rec : Ids)
                {       
                    // update Offer NAME 
                    rec.Name= '(' + string.valueOf(rec.Offer_date__c) + ') £'+rec.Offer_amount__c.format() + ' <-> ' 
                                + '£'+rec.Counter_Offer__c.format() + ' (' + string.valueOf(rec.Counter_date__c) +')';

                }
                update Ids;
            }
        }  
    }