public class Opp_update {

//WAS    public inherited sharing class LH_updateLH_Opp {

    @InvocableMethod
    public static void Opp_update(List<Id> OppIds)
    {
        // CALCULATE PREMIUM

        List<Opportunity> Ids =
            [select id, Extension_premium__c, Ground_rent__c, Value_with_extended_lease_OMV__c,
                Years_left_on_lease__c
            from Opportunity WHERE id in :OppIds
            ];
        Double e = 0.05;
        Double G = 50;          // use as default
        Double T = 0;
        Double V = 0;

        for(Opportunity rec : Ids)
        {       
            // just to keep calcs in formulas below cleaner:
            G = rec.Ground_rent__c;
            T = rec.Years_left_on_lease__c;
            V = rec.Value_with_extended_lease_OMV__c;

            double core1 = Math.pow(1+e, -T);
            double core2 = G/e*(1-core1);
            double core3 = V*(1 + core1);
            double base = 91;
            double V1discount = base-Math.pow((base-T)/10,2)-(base-T)/10/2;
            double V1 = V1discount*V/100;
          
            rec.Extension_premium__c = 0.5* (core2 + core3 - V1);

        }
        update Ids;
    }

}