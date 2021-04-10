public with sharing class Utils {

    public static boolean PlanningRequired = false;

	/*
    public void setFieldOnCallingRecord(id callingId){
        Area_retrieval_status__c upd = [select id, AREa__c from Area_Retrieval_Status__c where id = :callingId];
        upd.area__c = 'after insert';
        system.debug('about to update area');
        update upd; 
	}
	*/

    public static integer getMonthNumber(string s_month){
		integer i=0;
		switch on s_month.toUpperCase() {
			when 'JAN' {i=1;}
			when 'FEB' {i=2;}
			when 'MAR' {i=3;}
			when 'APR' {i=4;}
			when 'MAY' {i=5;}
			when 'JUN' {i=6;}
			when 'JUL' {i=7;}
			when 'AUG' {i=8;}
			when 'SEP' {i=9;}
			when 'OCT' {i=10;}
			when 'NOV' {i=11;}
			when 'DEC' {i=12;}
			when else {i=0;}
		}
		return i;
	}


    public Utils() {

    }
}