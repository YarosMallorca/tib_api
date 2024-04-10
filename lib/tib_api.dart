/// The unofficial TIB API for Dart. It provides access to the TIB API and the
/// realtime data of the buses.
///
/// ! WARNING ! This is an unofficial API and is not supported by TIB.
/// Functionality may break at any time.
/// Use at your own risk.
///
library;

// APIs
export 'src/api/departures.dart';
export 'src/api/stations.dart';
export 'src/api/line.dart';

// Realtime
export 'src/realtime/bus_position.dart';
export 'src/realtime/bus_stopped.dart';
export 'src/realtime/station_info.dart';

// Sockets
export 'src/sockets/location_socket.dart';
