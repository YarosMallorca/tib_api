import 'dart:convert';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:tib_api/src/api/station_line.dart';
import 'package:xml/xml.dart';

class RouteLine {
  bool? active;
  String code;
  int id;
  String name;
  int color;
  LineType type;

  static Future<List<RouteLine>> getAllLines() async {
    Uri url = Uri.parse("https://ws.tib.org/sictmws-rest/lines/ctmr4");
    try {
      String response = await get(url).then((value) => value.body);

      List<RouteLine> lines = [];
      for (Map line in jsonDecode(response)["linesInfo"]) {
        RouteLine responseLine = RouteLine.fromJson(line);
        lines.add(responseLine);
      }

      return lines;
    } on FormatException {
      throw FormatException("Something went wrong. 😶");
    }
  }

  static Future<RouteLine> getLine(String lineCode) async {
    Uri url =
        Uri.parse("https://ws.tib.org/sictmws-rest/lines/ctmr4/$lineCode");
    try {
      String response = await get(url).then((value) => value.body);
      return RouteLine.fromJson(jsonDecode(response));
    } on FormatException {
      throw FormatException("Something went wrong. 😶");
    }
  }

  RouteLine(
      {required this.active,
      required this.code,
      required this.id,
      required this.name,
      required this.color,
      required this.type});

  @override
  String toString() {
    return 'Line{active: $active, code: $code, color: $color id: $id, name: $name, type: $type}';
  }

  static RouteLine fromJson(Map json) {
    LineType type;

    if (json['typ'] == 1) {
      type = LineType.train;
    } else if (json['typ'] == 2) {
      type = LineType.metro;
    } else if (json['typ'] == 3) {
      type = LineType.bus;
    } else {
      type = LineType.unknown;
    }

    return RouteLine(
        active: json['act'],
        code: json['cod'],
        id: json['id'],
        name: json['nam'],
        color: int.parse(json['color'].replaceAll("#", "0xFF")),
        type: type);
  }
}

class RoutePath {
  String lineCode;
  List<List<LatLng>> paths;

  RoutePath({required this.lineCode, required this.paths});

  static Future<RoutePath> getPath(String lineCode) async {
    Uri url =
        Uri.parse("https://ws.tib.org/sictmws-rest/lines/ctmr4/$lineCode/kmz");
    try {
      String response = await get(url).then((value) => value.body);
      return RoutePath.fromKmz(response, lineCode);
    } on FormatException {
      throw FormatException("Something went wrong. 😶");
    }
  }

  @override
  String toString() {
    return 'RoutePath{lineCode: $lineCode, paths: $paths}';
  }

  static RoutePath fromKmz(String kmz, String lineCode) {
    final document = XmlDocument.parse(kmz);
    List<List<LatLng>> allCoordinates = [];
    var lineStrings = document.findAllElements('LineString');

    for (XmlElement lineString in lineStrings) {
      var coordinates = lineString.findElements('coordinates');
      if (coordinates.isNotEmpty) {
        List<LatLng> coordinatesList = [];
        var coordinatesString = coordinates.first.innerText;
        var coordinatesSplit = coordinatesString.split(" ");
        for (var coordinate in coordinatesSplit) {
          var latLong = coordinate.split(",");
          coordinatesList
              .add(LatLng(double.parse(latLong[1]), double.parse(latLong[0])));
        }
        allCoordinates.add(coordinatesList);
      }
    }
    return RoutePath(lineCode: lineCode, paths: allCoordinates);
  }
}
