import 'package:hair_app/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_provider.g.dart';

@riverpod
class TableCalendarEventController extends _$TableCalendarEventController {
  final List<Event> sampleEvents = [
    Event(
      opponent: '対戦相手1',
      location: '場所1',
      dateTime: DateTime.now().add(const Duration(days: 1)),
    ),
    Event(
      opponent: '対戦相手2',
      location: '場所2',
      dateTime: DateTime.now().add(const Duration(days: 2)),
    ),
    Event(
      opponent: '対戦相手3',
      location: '場所3',
      dateTime: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  @override
  List<Event> build() {
    state = sampleEvents;
    return state;
  }

  void addEvent(
      {required DateTime dateTime,
      required String opponent,
      required String location}) {
    var newData = Event(opponent: opponent, location: location, dateTime: dateTime);
    state.add(newData);
  }

  void deleteEvent({required Event event}) {
    state.remove(event);
  }
}



