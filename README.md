# TIB API

## Features

An unofficial Dart package for the TIB (Transports de les Illes Balears) API.
It provides a simple way to access the TIB API and get information about the bus stops, lines, schedules, etc.

This package is not affiliated with TIB in any way.
Functionality is limited and might break if the API changes.

## Getting started

Install the package by adding it to your `pubspec.yaml` file:

```yaml
dependencies:
  tib_api: ^0.1.0
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

Listen to realtime updates of a specific bus:

```dart
LocationWebSocket.locationStream(departures.first.tripId).then((stream) {
    stream.listen((message) {
      final action = LocationWebSocket.locationParser(message);
    });
  });
```

Full example can be found in the [example.dart](example/tib_api_example.dart)

## Warning

As this is an unofficial package, the API might change at any time and break the package. Use at your own risk. If you find any issues, please report them in the [GitHub repository issue tracker](https://github.com/YarosMallorca/tib_api/issues).
