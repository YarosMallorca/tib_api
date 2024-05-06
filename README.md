# TIB API

## Features

An unofficial Dart package for the TIB (Transports de les Illes Balears) API.
It provides a simple way to access the TIB API and get information about the bus stops, lines, schedules, etc.

**This package is not affiliated with TIB in any way.**

### **!!! WARNING !!!**

Some of the functions called repeatedly can lead to a **crash of the TIB's backend server**. Use with caution.
I am **NOT** responsible for any misuse of this package for malicious purposes.

As this is an unofficial package, the API might change at any time and break the package. Use at your own risk. If you find any issues, please report them in the [GitHub repository issue tracker](https://github.com/YarosMallorca/tib_api/issues).

Major, breaking changes are upcoming and will be documented in the [CHANGELOG](CHANGELOG.md).

## Getting started

Install the package by adding it to your `pubspec.yaml` file:

```yaml
dependencies:
  tib_api: ^0.5.6
```

## Usage

Get the list of bus stops:

```dart
await Stations.getStations();
```

Get the list of departures from a specific bus stop:

```dart
await Departures.getDepartures(stationId: id, numberOfDepartures: 10);
```

Get a list of lines that pass through a specific bus stop:

```dart
await Station.getLines(stationCode);
```

Get the list of all lines:

```dart
await RouteLine.getAllLines();
```

Get specific line information:

```dart
await RouteLine.getLine('A42');
```

Get the route of a specific line:

```dart
await RoutePath.getPath(route.code);
```

Listen to realtime updates of a specific bus:

```dart
LocationWebSocket.locationStream(busId).then((stream) {
    stream.listen((message) {
      final action = LocationWebSocket.locationParser(jsonDecode(message));
    });
  });
```

Get the RSS feed of the public TIB warnings:

```dart
await TibRss.getWarningFeed();
```

Get the RSS feed of the public TIB news:

```dart
await TibRss.getNewsFeed();
```

[BETA] scrape the TIB website for the affected lines of a specific warning:

```dart
await TibWarningScraper.scrapeAffectedLines(rssItem);
```

[BETA] scrape the TIB website for the description of a specific warning:

```dart
await TibWarningScraper.scrapeWarningDescription(rssItem);
```

[BETA] scrape the TIB website for the timetable PDF of a specific line:

```dart
await RouteLine.getPdfTimetable('A42');
```

Full example can be found in the [example.dart](example/tib_api_example.dart)
