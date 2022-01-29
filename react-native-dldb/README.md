# react-native-dldb

## Getting started

`$ npm install react-native-dldb --save`
`$ cd ios && pod install && cd ..`

## Usage
```javascript
import dldb from 'react-native-dldb';

...
// at app start, after user consent
dldb.init(
    '11111111-1111-1111-1111-111111111111',
    '{"button" : "t","batteryLevel" : "i"}'
    );
...
// once per day
dldb.heartbeat();
...
// on a very regular basis, when app idle ?
dldb.runQueriesIfAny();
...
// wherever useful
dldb.addEvents('{"button":"log in", "batteryLevel" : 55 }');
// location and event
dldb.addEventsWithLocation(
    '{"batteryLevel" : 5 }',
    {latitude : 45.0, longitude : 0.0, accuracy : 20}
    );
// location only
dldb.addLocation(
    {latitude : 45.0, longitude : 0.0, accuracy : 20}
    );
```

- [Javascript APIs](/Docs/javascriptAPI.md)

# About DLDB
## DLDB BETA VERSION

DLDB provides behavioural analytics for mobile applications with privacy by design. The core idea behind DLDB is zero knowledge proof

DLDB  architecture relies on an SDK to be integrated into your mobile application, and a dashboard https://dashboard.dldb.io/ to build, query, analyze the behaviour of your application users.

For your application, DLDB deploys a distributed database, where each database instance is inside the mobile application scope. All the analytics queries are run by the devices and no raw data ever leaves the devices. Only the statistical KPI-s are sent anonymously to the DLDB dashboard . 

From the DLDB dashboard, developers, analysts and app owners can build their own queries and analyze the results. No need to have any additional storage or analytics platform: DLDB provides an end-to-end solution.

DLDB SDK is written in C and has bindings to most common languages - works natively on iOS, Android, React-Native and Flutter. We also have Python binding and C libraries for IoT devices.

## Highlights :
- Seamless integration of DLDB SDK into your mobile app source base, in many flavours, on all major platforms
- Define your own schema of collected events and values
- Built-in GDPR compliance on the right to forget: all data belonging to your user stays on the device, so delete the data whenever requested
- Built-in GDPR compliance on the traceability of data usage: all requests processed by the DLDB SDK are traced and can be shown on demand
- No additional online storage
- Rapid scaling