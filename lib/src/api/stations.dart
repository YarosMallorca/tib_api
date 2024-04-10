import 'dart:convert';
import 'package:http/http.dart';
import 'package:tib_api/src/api/line.dart';

/// A class that represents a station.
///
/// A station has a code, an ID, a latitude, a longitude, a name, and a reference.
/// The reference is optional.
class Station {
  int code;
  int id;
  double lat;
  double long;
  String name;
  String? ref;

  Station(
      {required this.code,
      required this.id,
      required this.lat,
      required this.long,
      required this.name,
      this.ref});

  @override
  String toString() {
    return 'Station{code: $code, id: $id, lat: $lat, long: $long, name: $name, ref: $ref}';
  }

  static Station fromJson(Map json) {
    return Station(
        code: int.parse(json['cod']),
        id: json['id'],
        lat: json['lat'],
        long: json['lon'],
        name: json['nam'],
        ref: json['ref']);
  }

  /// Connects to the TIB API and returns the list of lines that pass through the station.
  /// The [stationCode] is the code of the station.
  ///
  /// The stationCode is the `code`, not `id` of the station.
  static Future<List<Line>> getLines(int stationCode) async {
    Uri url =
        Uri.parse("https://ws.tib.org/sictmws-rest/stops/ctmr4/$stationCode");
    try {
      String response = await get(url).then((value) => value.body);

      List<Line> lines = [];
      for (Map line in jsonDecode(response)["lines"]) {
        Line responseLine = Line.fromJson(line);
        lines.add(responseLine);
      }

      return lines;
    } on FormatException {
      throw FormatException("The station code is invalid. 😶");
    }
  }
}

/// A class that connects to the TIB API and returns the list of stations.
class Stations {
  /// Connects to the TIB API and returns the list of stations.
  /// The [count] is the number of stations to return.
  /// The default value is 1000.
  ///
  /// The API returns a JSON response that is decoded and converted to a list of
  /// stations (type [Station).
  static Future<List<Station>> getStations({int count = 1000}) async {
    final url =
        Uri.parse("https://ws.tib.org/sictmws-rest/stops/ctmr4?res=$count");

    try {
      String response = await get(url).then((value) => value.body);

      List<Station> stations = [];
      for (Map station in jsonDecode(response)["stopsInfo"]) {
        Station responseStation = Station.fromJson(station);
        stations.add(responseStation);
      }

      return stations;
    } catch (e) {
      throw Exception(
          "There was an error fetching the stations. 😕 Please try again later.");
    }
  }
}
