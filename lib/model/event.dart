// スキーマの定義
class Event {
  final DateTime dateTime;
  final String opponent;
  final DateTime time;
  final String location;

  Event({
    required this.dateTime,
    required this.opponent,
    required this.time,
    required this.location,
  });
}