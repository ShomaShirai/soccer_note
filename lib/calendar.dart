import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_app/event.dart';
import 'package:hair_app/event_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class Calendar extends HookConsumerWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedDayState = useState(DateTime.now());
    final selectedDayState = useState(DateTime.now());
    final selectedEventState = useState<List<Event>>([]);
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
                ? const Center(child: Text('この日の試合はありません'))
                : ListView.builder(
                    itemCount: selectedEventState.value.length,
                    itemBuilder: (context, index) {
                      final event = selectedEventState.value[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(event.opponent),
                          subtitle: Text("${event.location} - ${event.time.hour}:${event.time.minute}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool? confirmDelete =
                                  await showDeleteConfirmDialog(context);
                              if (confirmDelete == true) {
                                ref
                                    .read(tableCalendarEventControllerProvider.notifier)
                                    .removeEvent(event: event);
                                updateSelectedEvents(selectedDayState.value);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // イベントを追加するダイアログを表示
  Future<void> showAddEventDialog(
      BuildContext context, DateTime selectedDay, WidgetRef ref) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedTime; // 選択された時間を保持

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
                    '試合の追加',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: '対戦相手'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      // contentPadding:
                      //     EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: '試合会場',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          showTitleActions: true,
                          showSecondsColumn: false,
                          onChanged: (date) {
                            print(date);
                          },
                          onConfirm: (date) {
                            selectedTime = date;
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.jp);
                    },
                    child: const Text(
                      '試合開始時間を選択',
                      style: TextStyle(color: Colors.blue),
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
                          if (selectedTime == null) {
                            selectedTime = DateTime(selectedDay.year,
                                selectedDay.month, selectedDay.day, 0, 0);
                          }
                          ref
                            .read(tableCalendarEventControllerProvider.notifier)
                            .addEvent(
                              dateTime: selectedDay,
                              opponent: titleController.text,
                              time: selectedTime!,
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

  // イベント削除の確認ダイアログ
  Future<bool?> showDeleteConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('この試合を消してよいですか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }
}
