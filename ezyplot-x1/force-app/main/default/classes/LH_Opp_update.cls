public class LH_Opp_update {

//WAS    public inherited sharing class LH_updateLH_Opp {

    @InvocableMethod
    public static void LH_calcPremium(List<Id> Ids)
    {
    
        List<LH_Opp__c> LH_Ids =
            [select id, Extension_premium__c, Ground_rent__c, Our_offer__c, Value_with_extended_lease_OMV__c,
                Years_left_on_lease__c
            from LH_Opp__c WHERE id in :Ids
            ];
        Double e = 0.05;
        Double G = 50;          // use as default
        Double T = 0;
        Double V = 0;

        for(LH_Opp__c LHrec : LH_Ids)
        {       
            // just to keep calcs in formulas below cleaner:
            G = LHrec.Ground_rent__c;
            T = LHrec.Years_left_on_lease__c;
            V = LHrec.Value_with_extended_lease_OMV__c;

/*
  var core1 =  Math.pow(1+e,-T);
  var core2 = G/e*(1-core1);
  var core3 = V*(1 + core1);
  var base = 91;
  var V1discount = base-Math.pow((base-T)/10,2)-(base-T)/10/2;
  var V1 = V1discount*V/100
  var premium = 0.5* (core2 + core3 - V1);
*/            

            double core1 = Math.pow(1+e, -T);
            double core2 = G/e*(1-core1);
            double core3 = V*(1 + core1);
            double base = 91;
            double V1discount = base-Math.pow((base-T)/10,2)-(base-T)/10/2;
            double V1 = V1discount*V/100;
          
            LHrec.Extension_premium__c = 0.5* (core2 + core3 - V1);
        }
        update LH_Ids;
    }

}