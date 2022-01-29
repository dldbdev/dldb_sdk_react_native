// Dldb.m

#import "Dldb.h"
#import <React/RCTLog.h>

#import "DLDB_C.h"

@implementation Dldb
DLDB_C* myDLDB;
  
RCT_EXPORT_MODULE(RNDLDB)

RCT_EXPORT_METHOD(init:(NSString *)dldbApiKey eventsDictionaryAsJson:(NSString *)eventsDictionaryAsJson)
{
  if(myDLDB == nil)
    myDLDB = [[DLDB_C alloc] init];
  RCTLogInfo(@"starting DLDB %@ at %@", dldbApiKey, eventsDictionaryAsJson);
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  [myDLDB start:documentsDirectory dldbApiKey: dldbApiKey registerCallback:nil dictionary:eventsDictionaryAsJson];
}

RCT_EXPORT_METHOD(heartbeat) {
  if(myDLDB != nil)
    [myDLDB heartbeat];
}

RCT_EXPORT_METHOD(runQueriesIfAny) {
  if(myDLDB != nil)
    [myDLDB runQueriesIfAny];
}

RCT_EXPORT_METHOD(addEventsWithoutLocation: (NSString*) eventsAsJson)
{
  if(myDLDB != nil)
    [myDLDB addEvents: nil eventsAsJson:eventsAsJson];
}

RCT_EXPORT_METHOD(queriesLog:(double)maxEntries
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  if(myDLDB != nil) {
    NSString* queriesLog = [myDLDB queriesLog: maxEntries];
    if(queriesLog != nil)
      resolve(queriesLog);
    else
      resolve(@"");    
  } else {
    reject(@"Dldb_queriesLog_failure", @"Dldb not started", nil);
  }
}

RCT_EXPORT_METHOD(locationsLog:(double)durationInSeconds
                 maxEntries:(double)maxEntries
                 resolution:(double)resolution
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  if(myDLDB != nil) {
    NSString* locationsLog = [myDLDB locationsLog: durationInSeconds maxEntries:maxEntries resolution:resolution];
    if(locationsLog != nil)
      resolve(locationsLog);
    else
      resolve(@"");    
  } else {
    reject(@"Dldb_locationsLog_failure", @"Dldb not started", nil);
  }
}

@end
