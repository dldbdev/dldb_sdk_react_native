// main index.js

import { NativeModules } from 'react-native';

const { RNDLDB } = NativeModules;
const dldb = {};

dldb.init = RNDLDB.init;
dldb.hearbeat = function() { RNDLDB.hearbeat(); };
dldb.runQueriesIfAny = RNDLDB.runQueriesIfAny;
dldb.close = RNDLDB.close;
dldb.addEvents = function(eventsAsJson) {
    if(eventsAsJson != null && typeof eventsAsJson == 'string' && eventsAsJson.length > 2)
        RNDLDB.addEventsWithoutLocation(eventsAsJson);
};
dldb.addEventsWithLocation = function(eventsAsJson, location) {
    if(location != null && typeof location == 'object') {
        let longitude = NaN;
        if('longitude' in location)
            longitude = location.longitude;
        else if('lng' in location)
            longitude = location.lng;
        let latitude = NaN;
        if('latitude' in location)
            latitude = location.latitude;
        else if('lat' in location)
            latitude = location.lat;
        let horizontalAcccuracy = 100;
        if('accuracy' in location)
            horizontalAcccuracy = location.accuracy;
        RNDLDB.addEventsWithLocation(longitude,latitude,horizontalAcccuracy,eventsAsJson);
    } else
        RNDLDB.addEventsWithoutLocation(eventsAsJson);
};
dldb.addLocation = function(location) {
    if(location != null && typeof location == 'object') {
        let longitude = NaN;
        if('longitude' in location)
            longitude = location.longitude;
        else if('lng' in location)
            longitude = location.lng;
        let latitude = NaN;
        if('latitude' in location)
            latitude = location.latitude;
        else if('lat' in location)
            latitude = location.lat;
        let horizontalAcccuracy = 100;
        if('accuracy' in location)
            horizontalAcccuracy = location.accuracy;
        RNDLDB.addEventsWithLocation(longitude,latitude,horizontalAcccuracy,null);
    }
}
dldb.queriesLog = RNDLDB.queriesLog;
dldb.locationsLog = RNDLDB.locationsLog;


export default dldb;
