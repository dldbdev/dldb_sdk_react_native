# APIs

wherever you need to use DLDB
```Javascript
import dldb from 'react-native-dldb';
```

The list of available methods for the DLDB React-Native library.

- [Javascript APIs](#allAPI)
    - [init](#init)
    - [heartbeat](#heartbeat)
    - [runQueriesIfAny](#runQueriesIfAny)
    - [close](#close)
    - [addEvents](#addEvents)
    - [addEventsWithLocation](#addEventsWithLocation)
    - [addLocation](#addLocation)
    - [queriesLog](#queriesLog)
    - [locationsLog](#locationsLog)
---

##  **`init(dldbApiKey, eventsDictionaryAsJson)`**

Initialize the DLDB SDK with the dldbApiKey and events dictionary.<br/>
The dldbApiKey is required and can be obtained from the  [DLDB dashboard](https://dashboard.dldb.io).<br/>

| parameter    | type     | description                               |
| -----------  |----------|------------------------------------------ |
| dldbApiKey   | string   | dpi key                                   |
| eventsDictionaryAsJson  | string | success callback                          |

The events dictionary is a json string containing one object per event. Each object defines the event name as a key and the values as the type of events : 't' for text, 'i' for numeric value.
A dictionary `{ "button" : "t", "batteryLevel": "i" }` defines 2 events : `button` with text value, and `batteryLevel` with numeric value.
The dictionary is meant to be a constant and can be changed only with new versions of your app.
The event names defined in this dictionary will the only events accepted by the functions [addEvents](#addEvents) and [addEventsWithLocation](#addEventsWithLocation)


*Example:*

```javascript

dldb.init(
    '11111111-1111-1111-1111-111111111111',
    '{"button" : "t","batteryLevel" : "i"}'
    );
```
---

## **`addEvents(eventsAsJson)`**

| parameter    | type     | description                                   |
| -----------  |----------|------------------------------------------     |
| eventsAsJson | string   | The name and values of the events             |

Events `eventsAsJson` can be any metric or KPI relevant for better understanding of end-user behaviour. All events provided through this call will be attached to the same second. If you do have access to the location when this function is called, use [addEventsWithLocation](#addEventsWithLocation)
Event names must be present in the dictionary provided when calling [init](#init). Events with unknown names will be discarded.
The events will be attached to exactly the same instant, which will be the current second when the function is called, relying on device clock and time zone information.

*Example:*

```javascript

dldb.addEvents('{"button":"log in", "batteryLevel" : 55 }');
...
dldb.addEvents('{"batteryLevel" : 5 }');
...
```

---
## **`addEventsWithLocation(eventsAsJson, location)`**

| parameter    | type     | description                                   |
| -----------  |----------|------------------------------------------     |
| eventsAsJson | string   | The name and values of the events             |
| location     | object   | the location of the events                    |

Events `eventsAsJson` can be any metric or KPI relevant for better understanding of end-user behaviour. All events provided through this call will be attached to the same second. If you do not have access to the location when this function is called, use [addEvents](#addEvents)
Event names must be present in the dictionary provided when calling [init](#init). Events with unknown names will be discarded.
The events will be attached to exactly the same instant, which will be the current second when the function is called, relying on device clock and time zone information.

`location` indicates where the events is happening.

| Property  | Description   |
| --------  | ------------- |
| latitude  | in decimal degrees  |
| longitude | in decimal degrees  |
| accuracy  | horizontal accuracy in meters aka the radius of the area, defaults to 100m if not present |

`longitude` and `latitude` are taken into account if both are present and valid values.

*Example:*

```javascript
// location and event
dldb.addEventsWithLocation(
    '{"batteryLevel" : 5 }',
    {latitude : 45.0, longitude : 0.0, accuracy : 20}
    );
...
```

---
## **`addLocation(location)`**

| parameter    | type     | description                                   |
| -----------  |----------|------------------------------------------     |
| location     | object   | the location of the events                    |

`location` indicates where the events is happening.

| Property  | Description   |
| --------  | ------------- |
| latitude  | in decimal degrees  |
| longitude | in decimal degrees  |
| accuracy  | horizontal accuracy in meters aka the radius of the area, defaults to 100m if not present |

`longitude` and `latitude` are taken into account if both are present and valid values.

*Example:*

```javascript
dldb.addLocation(
    {latitude : 45.0, longitude : 0.0, accuracy : 20}
    );
...
```

---
## **`heartbeat()`**

to be called on a low frequency basis compatible with the app usage frequency, in order to provide accurate estimates of query response time to the dashboard.

*Example:*

```javascript
dldb.heartbeat();
```

---
## **`runQueriesIfAny()`**

to be called on a regular basis compatible with the app usage frequency, in order to provide fast query responses to the dashboard. The more often it is called the faster the queries will be replied on dashboard

*Example:*

```javascript
dldb.runQueriesIfAny();
```

---
##  **`close()`**

to be called when shutting down the app.

*Example:*

```javascript
dldb.close();
```

---
## **`queriesLog(maxEntries)`**

| parameter    | type     | description                                   |
| -----------  |----------|------------------------------------------     |
| maxEntries   | number   | the max number of entries to include in the log |

return a promise to the log of `maxEntries` most recent queries ran on the device.

The log is a json array (most recent last) of json objects, each object representing a query ran on the device

| Property  | Description   |
| --------  | ------------- |
| id        | uuid of query  |
| type      | type of query  |
| fetched   | timestamp in ms when the query was fetched from server |
| answered  | timestamp in ms when the query was answered on the device  |
| finished  | timestamp in ms when the query was finished on the device |
| tries     | number of tries to run the query |
| json_in   | parameters of the query |
| json_out  | results of the query |

*Example:*

```javascript

onQueriesLog = async () => {
    try {
        const queriesLog = await dldb.queriesLog(5);
        console.log(`Got the queries log ${queriesLog}`);
        this.setState({
                status: 'DLDB queries log',
                message: queriesLog
            });
        } catch (e) {
            console.error(e);
    }
}

<Button onPress={onQueriesLog} title="Queries log">

...
```
---

## **`locationsLog(durationInSeconds, maxEntries, resolution)`**

| parameter    | type     | description                                   |
| -----------  |----------|------------------------------------------     |
| durationInSeconds | number   | how far back in the past to look for locations |
| maxEntries   | number   | the max number of entries to include in the log |
| resolution   | number   | resolution of returned locations |

return a promise to the log of at most `maxEntries` most recent unique locations stored on the device during the last `durationInSeconds`.

The log is a json array (most recent last) of [h3](https://h3geo.org) in hex string format, at resolution `resolution`.
A call to this function generates an entry into the queries log.

*Example:*

```javascript

onLocationsLog = async () => {
    try {
        const locationsLog = await dldb.locationsLog(5);
        console.log(`Got the locations log ${locationsLog}`);
        this.setState({
                status: 'DLDB locations log',
                message: locationsLog
            });
        } catch (e) {
            console.error(e);
    }
}

<Button onPress={onLocationsLog} title="Locations log">

...
```
---
