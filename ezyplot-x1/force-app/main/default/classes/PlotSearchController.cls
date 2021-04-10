public with sharing class PlotSearchController {
    @AuraEnabled
    public static List<Plot__c> searchPlots( String searchTerm ) {
        List<Plot__c> lstPlots = new List<Plot__c>();
        if ( String.isNotBlank( searchTerm ) 	&& searchTerm.length() > 1 ) {
            List<List<SObject>> searchResults = [
                FIND :searchTerm
                RETURNING Plot__c(
                    Id, Name, Address_town__c, Address_postcode__c
                    ORDER BY Name
                    LIMIT 10
                )
            ];
            lstPlots = searchResults[0];
        }
        return lstPlots;
    }
}