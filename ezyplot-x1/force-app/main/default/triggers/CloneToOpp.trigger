trigger CloneOpp on LH_Opp__c (after update){
    
    Opportunity[] ls=new Opportunity[]{};
        for(LH_Opp__c o: trigger.new){
            Opportunity opp=new Opportunity();
            //Assign whichever values you want to clone to the fields of your custom object, for example:

            o.GROUND_RENT__C=opp.GROUND_RENT__C;
            
            ls.add(opp);
        }
    insert ls;
}