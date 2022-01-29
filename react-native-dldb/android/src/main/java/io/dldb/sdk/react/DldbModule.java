// DldbModule.java

package io.dldb.sdk.react;

import android.location.Location;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;

import io.dldb.DLDB;

public class DldbModule extends ReactContextBaseJavaModule {
    static {
        System.loadLibrary("dldb-lib");
    }

    private final DLDB dldb = new DLDB();
    private final ReactApplicationContext reactContext;

    public DldbModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNDLDB";
    }

    @ReactMethod
    public void init(String dldbApiKey, String eventsDictionaryAsJson) {
        dldb.init(getReactApplicationContext(),dldbApiKey,eventsDictionaryAsJson);
    }

    @ReactMethod
    public void heartbeat(Promise result) {
        try {
            long nextHeartbeat = dldb.heartbeat();
            result.resolve(nextHeartbeat);
        } catch(Exception e) {
            result.reject("DLDB heartbeat error ", e);
        }
        ;
    }

    @ReactMethod
    public void runQueriesIfAny() {
        dldb.runQueriesIfAny();
    }

    @ReactMethod
    public void close() {
        dldb.close();
    }

    /*
    @ReactMethod
    public void addEventsWithLocationAndTime(double longitude, double latitude, double horizontalAcccuracy,
                                            double timestampInMs, double offsetFromUTCInS, String eventsAsJson) {
        dldb.addEvents(longitude,latitude,horizontalAcccuracy,timestampInMs/1000,offsetFromUTCInS,eventsAsJson);
    }*/
    
    @ReactMethod
    public void addEventsWithLocation(double longitude, double latitude, double horizontalAcccuracy,
                                      String eventsAsJson) {
        final long timeUTCInMillis = Instant.now().toEpochMilli();
        Instant instantUTC = Instant.ofEpochMilli(timeUTCInMillis);
        long offsetFromUTC = ZonedDateTime.ofInstant(instantUTC, ZoneId.systemDefault()).getOffset().getTotalSeconds();
        Location loc = new Location("");
        loc.setLongitude(longitude);
        loc.setLatitude(latitude);
        loc.setAccuracy((float) horizontalAcccuracy);
        loc.setTime(Instant.now().toEpochMilli());
        dldb.addEvents(loc,eventsAsJson);
    }

    @ReactMethod
    public void addEventsWithoutLocation(String eventsAsJson) {
        dldb.addEvents(null,eventsAsJson);
    }

    @ReactMethod
    public void queriesLog(int maxEntries, Promise result) {
        try {
            String queriesLog = dldb.queriesLog(maxEntries);
            result.resolve(queriesLog);
        } catch(Exception e) {
            result.reject("DLDB queries log error ", e);
        }
    }

    @ReactMethod
    public void locationsLog(int durationInSeconds, int maxEntries, int resolution, Promise result) {
        try {
            String locationsLog = dldb.locationsLog(durationInSeconds, maxEntries, resolution);
            result.resolve(locationsLog);
        } catch(Exception e) {
            result.reject("DLDB locations log error ", e);
        }
    }
}
