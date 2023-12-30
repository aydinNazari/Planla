class EventModel {
  List<Map<String, dynamic>> eventsMap;

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
      eventsMap: List<Map<String, dynamic>>.from(map['eventsMap'] ?? []),
    );
  }
}
