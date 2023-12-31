class EventModel {
  List<Map> eventsMap;

  EventModel({
    required this.eventsMap,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventsMap': eventsMap,
    };
  }
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eventsMap: List<Map>.from(map['eventsMap'] ?? []),
    );
  }
}
