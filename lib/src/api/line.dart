enum LineType { bus, train, metro, unknown }

class Line {
  bool active;
  String code;
  int id;
  DateTime startDate;
  String name;
  LineType type;

  Line(
      {required this.active,
      required this.code,
      required this.id,
      required this.startDate,
      required this.name,
      required this.type});

  @override
  String toString() {
    return 'Line{active: $active, code: $code, id: $id, startDate: $startDate, name: $name, type: $type}';
  }

  static Line fromJson(Map json) {
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

    return Line(
        active: json['act'],
        code: json['cod'],
        id: json['id'],
        startDate: DateTime.parse(json['ini']),
        name: json['nam'],
        type: type);
  }
}
