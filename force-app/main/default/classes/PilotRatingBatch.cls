global class PilotRatingBatch implements Database.Batchable<SObject>, Database.RaisesPlatformEvents {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Completion_Rating__c, Overall_Rating__c, Safety_Incidents__c, Pilot__c FROM Mission__c WHERE Status__c = \'Complete\'');
    }

    global void execute(Database.BatchableContext bc, List<Mission__c> scope) {
        List<Contact> lContact = new List<Contact>();
        
        try {

            for (Mission__c mission : scope) {
                if (mission.Pilot__c == null) {
                    continue;
                }

                Double newOverallRating;

                newOverallRating = mission.Pilot__r.Pilot_Rating__c + mission.Overall_Rating__c;
                mission.Pilot__r.Pilot_Rating__c = newOverallRating;
                
                lContact.add(mission.Pilot__r);
            }

            update lContact;
            
        } catch (Exception e) {
            EventBus.publish(new BatchApexErrorEvent(
                AsyncApexJobId = bc.getJobId(),
                Message = e.getMessage()
            ));
        }
    }

    global void finish(Database.BatchableContext bc) {}
}