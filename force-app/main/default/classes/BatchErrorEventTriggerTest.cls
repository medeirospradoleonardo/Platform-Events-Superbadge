@isTest
public class BatchErrorEventTriggerTest implements Database.RaisesPlatformEvents  {

    @testSetup
    static void setup() {
        List<Contact> lContact = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Pilot' + i,
                Pilot_Rating__c = 3.0
            );
            lContact.add(contact);
        }
        insert lContact;
        
        List<Mission__c> lMission = new List<Mission__c>();

        for (Contact contact : lContact) {
            Mission__c mission = new Mission__c(
                Pilot__c = contact.Id,
                Completion_Rating__c = 4.0,
                Overall_Rating__c = 5.0,
                Safety_Incidents__c = 1.0,
                Status__c = 'Complete',
                Subject__c = 'test'
            );
            lMission.add(mission);
        }
        insert lMission;
    }

    @isTest
    static void testBatchApexErrorEventTrigger_WithError() {

        Contact contact = [SELECT Id FROM Contact LIMIT 1];

        Mission__c mission = new Mission__c(
            Pilot__c = contact.Id,
            Completion_Rating__c = 4.0,
            Overall_Rating__c = 5.0,
            Safety_Incidents__c = 1.0,
            Status__c = 'Complete',
            Subject__c = 'test'
        );
    
        insert mission;

        Test.startTest();
		    EventBus.publish(new BatchApexErrorEvent());		
        Test.stopTest();

		Test.getEventBus().deliver();

        List<Error_Log__c> lErrorLog = [SELECT Id, Name, Async_Apex_Job_Id__c, Message__c FROM Error_Log__c];

        Assert.areEqual(1, lErrorLog.size(), '1 Erro deveria ser criado');
    }
    
}