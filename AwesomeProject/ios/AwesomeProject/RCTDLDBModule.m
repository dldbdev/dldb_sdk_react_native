//created by christophe@dld.io

#import <Foundation/Foundation.h>

#import "RCTDLDBModule.h"
#import <React/RCTLog.h>

#import "DLDB_C.h"

@implementation RCTDLDBModule
DLDB_C* myDLDB;
  
// To export a module named DLDBModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(init:(NSString *)dldbApiKey eventsDictionaryAsJson:(NSString *)eventsDictionaryAsJson)
{
  if(myDLDB == nil)
    myDLDB = [[DLDB_C alloc] init];
  RCTLogInfo(@"starting DLDB %@ at %@", dldbApiKey, eventsDictionaryAsJson);
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  [myDLDB start:documentsDirectory dldbApiKey: dldbApiKey registerCallback:nil dictionary:eventsDictionaryAsJson];
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

@end
