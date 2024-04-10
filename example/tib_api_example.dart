import 'package:tib_api/src/api/departures.dart';
import 'package:tib_api/src/api/line.dart';
import 'package:tib_api/src/api/stations.dart';
import 'package:tib_api/src/sockets/location_socket.dart';

void main() async {
  // Get the list of stations
  final List<Station> stations = await Stations.getStations();
  print(stations);

  // Get the departures info of the first station
  // Limit to 5 departures
  List<Departure> departures = await Departures.getDepartures(
      stationCode: stations.first.code, numberOfDepartures: 5);
  print(departures);

  // Get the list of lines that pass through the first station
  List<Line> lines = await Station.getLines(stations.first.code);
  print(lines);

  // Get realtime data of the first departure
  //
  // This will run indefinitely, please stop it manually
  LocationWebSocket.locationStream(departures.first.tripId).then((stream) {
    stream.listen((message) {
      print(LocationWebSocket.locationParser(message));
    });
  });
}
