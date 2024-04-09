// ignore_for_file: non_constant_identifier_names, unused_element

import 'dart:convert';

import 'package:http/http.dart';

class Departures {
  List<Departure>? departures;

  Departures({this.departures});

  static Future<List<Departure>> getDepartures(
      {required int stationId, required int numberOfDepartures}) async {
    Uri url = Uri.https('tib.org',
        '/o/manager/stop-code/$stationId/departures/ctmr4?res=$numberOfDepartures');

    String response = await get(url).then((value) => value.body);

    List<Departure> departures = [];
    for (var response in jsonDecode(response)) {
      Departure responseDeparture = Departure.fromJson(response);
      departures.add(responseDeparture);
    }

    return departures;
  }
}

class RealTrip {
  DateTime? estimatedArrival;
  double lat;
  double long;

  RealTrip({this.estimatedArrival, required this.lat, required this.long});

  @override
  toString() {
    return 'RealTrip{estimatedArrival: $estimatedArrival, lat: $lat, long: $long}';
  }

  static RealTrip fromJson(Map json) {
    return RealTrip(
        estimatedArrival:
            json['aet'] != null ? DateTime.tryParse(json['aet']) : null,
        lat: json['lastCoords']['lat'],
        long: json['lastCoords']['lng']);
  }
}

class Departure {
  DateTime departureTime;
  DateTime estimatedArrival;
  String name;
  int tripId;
  RealTrip? realTrip;
  int lineColor;
  bool delayed;
  String lineCode;
  String? destination;
  String? departureStop;

  Departure(
      {required this.departureTime,
      required this.estimatedArrival,
      required this.name,
      required this.tripId,
      this.realTrip,
      required this.lineColor,
      required this.delayed,
      required this.lineCode,
      this.destination,
      this.departureStop});

  @override
  String toString() {
    return 'Departure{departureTime: $departureTime, estimatedArrival: $estimatedArrival, name: $name, tripId: $tripId, realTrip: $realTrip, lineColor: $lineColor, delayed: $delayed, lineCode: $lineCode, destination: $destination, departureStop: $departureStop}';
  }

  static Departure fromJson(Map json) {
    return Departure(
        departureTime: DateTime.parse(json['dt']),
        estimatedArrival: DateTime.parse(json['aet']),
        name: json['snam'],
        tripId: json['trip_id'],
        realTrip: json['realTrip'] != null
            ? RealTrip.fromJson(json['realTrip'])
            : null,
        lineColor: int.parse(json['lineColor'].replaceAll("#", "0xFF")),
        delayed: json['dem'],
        lineCode: json['lcod'],
        destination: json['etn'],
        departureStop: json['et']);
  }
}
