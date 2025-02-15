import 'package:hair_app/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_provider.g.dart';

@riverpod
class TableCalendarEventController extends _$TableCalendarEventController {
  final List<Event> sampleEvents = [
  ];

  @override
  List<Event> build() {
    state = sampleEvents;
    return state;
  }

  void addEvent(
      {required DateTime dateTime,
      required String opponent,
      required DateTime time,
      required String location}) {
    var newData = Event(opponent: opponent, location: location, dateTime: dateTime, time: time);
    state.add(newData);
  }

  void removeEvent({required Event event}) {
    state.remove(event);
  }
}



