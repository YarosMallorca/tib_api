// ignore_for_file: non_constant_identifier_names, unused_element

import 'dart:convert';

import 'package:http/http.dart';

class Departures {
  List<Departure>? departures;

  Departures({this.departures});

  /// Connects to the TIB API and returns the list of departures from a station.
  /// The [stationCode] is the ID of the station.
  /// The [numberOfDepartures] is the number of departures to return.
  ///
  /// Throws a [FormatException] if the station code is invalid.
  /// Throws an [HttpException] if the server is unreachable.
  /// Throws a [SocketException] if there is no internet connection.
  /// Throws an [Exception] if there are no departures found.
  static Future<List<Departure>> getDepartures(
      {required int stationCode, required int numberOfDepartures}) async {
    Uri url = Uri.https('tib.org',
        '/o/manager/stop-code/$stationCode/departures/ctmr4?res=$numberOfDepartures');
    try {
      String response = await get(url).then((value) => value.body);
      List<Departure> departures = [];
      for (var response in jsonDecode(response)) {
        Departure responseDeparture = Departure.fromJson(response);
        departures.add(responseDeparture);
      }

      if (departures.isEmpty) {
        throw Exception(
            "No departures found. 😕 Please check that the station code is correct.");
      } else {
        return departures;
      }
    } on FormatException {
      throw FormatException("The station code is invalid. 😶");
    } catch (e) {
      print(e);
      throw Exception(
          "There was an error fetching the departures. 😕 Please try again later.");
    }
  }
}

/// A class that represents a real-time trip from a Departure.
/// A real-time trip has an estimated arrival time, a latitude, and a longitude.
///
/// The estimated arrival time is optional.
class RealTrip {
  DateTime? estimatedArrival;
  double lat;
  double long;
  int id;

  RealTrip(
      {this.estimatedArrival,
      required this.lat,
      required this.long,
      required this.id});

  @override
  toString() {
    return 'RealTrip{estimatedArrival: $estimatedArrival, lat: $lat, long: $long}';
  }

  static RealTrip fromJson(Map json) {
    return RealTrip(
        estimatedArrival:
            json['aet'] != null ? DateTime.tryParse(json['aet']) : null,
        lat: json['lastCoords']['lat'],
        long: json['lastCoords']['lng'],
        id: int.parse(json['id']));
  }
}

/// A departure from the departures list.
///
/// A departure has a departure time, an estimated arrival time, a name, a trip ID,
/// a real trip, a line color, a delayed status, a line code, a destination, and a departure stop.
/// The real trip, destination, and departure stop are optional.
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
