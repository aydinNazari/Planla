class EventModel {
 List<String> eventsKey;
 List<double> eventValue;
 EventModel({
   required this.eventsKey,required this.eventValue
});
 Map<String, dynamic> toMap() {
   return {
     'eventsKey' : eventsKey,
     'eventValue' : eventValue,
   };
 }

 factory EventModel.fromMap(Map<String, dynamic> map) {
   return EventModel(
     eventValue: map['eventValue'] ?? '',
     eventsKey: map['eventsKey'] ?? '',
   );
 }
}
