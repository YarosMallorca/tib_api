import 'package:tib_api/src/api/departures.dart';
import 'package:tib_api/src/api/route_line.dart';
import 'package:tib_api/src/api/station_line.dart';
import 'package:tib_api/src/api/stations.dart';
import 'package:tib_api/src/messaging/tib_rss.dart';

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
  List<StationLine> lines = await Station.getLines(stations.first.code);
  print(lines);

  // Get the list of all lines
  final allRoutes = await RouteLine.getAllLines();
  print(allRoutes);

  // Get the list of line A42
  final route = await RouteLine.getLine('A42');
  print(route);

  // Get the path of the line
  final routePath = await RoutePath.getPath(route.code);
  print(routePath);

  final rss = await TibRss.getFeed();
  print(rss.items.first.title);
  print(await TibWarningScraper.scrapeAffectedLines(rss.items.first));
  print(await TibWarningScraper.scrapeWarningDescription(rss.items.first));
}
