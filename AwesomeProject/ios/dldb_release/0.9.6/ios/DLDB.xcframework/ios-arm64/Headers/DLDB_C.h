// created by christophe@dldb.io

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol DLDB_CDelegate <NSObject>
- (void)registered:(bool)success firstTime: (bool) firstTime error: (NSString*) errorAsJSON;
@end

@interface DLDB_C : NSObject

@property (nonatomic, readonly) NSString* path;
@property (nonatomic, readonly) NSString* dldbApiKey;
@property (nonatomic, readonly) int appID;

- (void) start: (NSString*) dbPath
    dldbApiKey: (NSString*) dldbApiKey
    registerCallback: (id<DLDB_CDelegate>) registerCallback
    dictionary: (NSString*) dictionary;
- (int32_t) heartbeat;
- (void) addEvents: (double) longitudeInDegrees
                    latitudeInDegrees: (double) latitudeInDegrees
                    horizontalAccuracyInMeters: (float) horizontalAccuracyInMeters
                    epochUTCInSeconds: (int32_t) epochUTCInSeconds
                    offsetFromUTCInSeconds: (int32_t) offsetFromUTCInSeconds
                    eventsAsJson: (NSString*) eventsAsJson;
- (void) addEvents: (CLLocation*) location eventsAsJson: (NSString*) eventsAsJson;
- (void) runQueriesIfAny;
- (void) close;
- (NSString*) queriesLog: (int) maxEntries;
- (NSString*) locationsLog: (int) durationInSeconds maxEntries: (int) maxEntries resolution: (int) resolution;

@end
