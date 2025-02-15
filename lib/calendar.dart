import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_app/event.dart';
import 'package:hair_app/event_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends HookConsumerWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedDayState = useState(DateTime.now());
    final selectedDayState = useState(DateTime.now());
    final selectedEventState = useState<List<Event>>([]); // 修正: 型を明示
    final eventProvider = ref.watch(tableCalendarEventControllerProvider);

    void updateSelectedEvents(DateTime selectedDay) {
      selectedEventState.value = eventProvider
          .where((event) => isSameDay(event.dateTime, selectedDay))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('カレンダー')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDayState.value,
            locale: 'ja_JP',
            selectedDayPredicate: (day) {
              return isSameDay(selectedDayState.value, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              selectedDayState.value = selectedDay;
              focusedDayState.value = focusedDay;
              updateSelectedEvents(selectedDay);
            },
            onDayLongPressed: (selectedDay, focusedDay) async {
              await showAddEventDialog(context, selectedDay, ref);
              updateSelectedEvents(selectedDay);
            },
            eventLoader: (date) {
              return eventProvider
                  .where((event) => isSameDay(event.dateTime, date))
                  .toList();
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: selectedEventState.value.isEmpty
                ? const Center(child: Text('この日のイベントはありません'))
                : ListView.builder(
                    itemCount: selectedEventState.value.length,
                    itemBuilder: (context, index) {
                      final event = selectedEventState.value[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(event.opponent),
                          subtitle: Text(event.location),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> showAddEventDialog(
      BuildContext context, DateTime selectedDay, WidgetRef ref) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'イベントの追加',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'タイトル'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 3,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: '詳細',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(tableCalendarEventControllerProvider.notifier)
                              .addEvent(
                                dateTime: selectedDay,
                                opponent: titleController.text,
                                location: descriptionController.text,
                              );
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '追加',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
