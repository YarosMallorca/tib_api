/// Represents the position of a bus.
/// It is received by the location socket and is used to track the bus.
///
/// The position includes the latitude, longitude, speed, and the timestamp of
/// the position.
class BusPosition {
  final double lat;
  final double long;
  final double speed;
  final DateTime timestamp;

  BusPosition(
      {required this.lat,
      required this.long,
      required this.speed,
      required this.timestamp});

  @override
  String toString() {
    return 'BusPosition{lat: $lat, long: $long, speed: $speed, timestamp: $timestamp}';
  }

  static BusPosition fromJson(Map json) {
    return BusPosition(
        lat: json['lat'],
        long: json['lng'],
        speed: json['vel'],
        timestamp: DateTime.parse(json['upd']));
  }
}
