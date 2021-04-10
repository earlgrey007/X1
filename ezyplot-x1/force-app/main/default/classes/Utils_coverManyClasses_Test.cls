@isTest
public with sharing class Utils_coverManyClasses_Test {

    static testMethod void test_Area(){

        Area_retrieval_status__c newArea = new Area_retrieval_status__c(
            Name = 'A',
            Area__c = 'GU35 0AA',
            Area_level__c = 'Postcode'
        );
        insert newArea;

    }
        
}