trigger BatchApexErrorEvent on BatchApexErrorEvent (after insert) {
  List<Error_Log__c> lErrorLog = new List<Error_Log__c>();
        
  for (BatchApexErrorEvent event : Trigger.new) {
      Error_Log__c errorLog = new Error_Log__c();
      errorLog.Name = 'Batch Error';
      errorLog.Async_Apex_Job_Id__c = event.AsyncApexJobId;
      errorLog.Message__c = event.Message;
      lErrorLog.add(errorLog);
  }

  insert lErrorLog;
}