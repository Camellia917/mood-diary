import 'mood_type.dart';

class MoodEntry {
  final String id;
  final DateTime date;
  final int moodValue;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  MoodEntry({
    required this.id,
    required this.date,
    required this.moodValue,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  MoodType get mood => MoodType.fromValue(moodValue);

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': _dateOnly(date),
        'mood_value': moodValue,
        'note': note,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory MoodEntry.fromMap(Map<String, dynamic> map) => MoodEntry(
        id: map['id'] as String,
        date: DateTime.parse(map['date'] as String),
        moodValue: map['mood_value'] as int,
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  MoodEntry copyWith({int? moodValue, String? note, DateTime? updatedAt}) {
    return MoodEntry(
      id: id,
      date: date,
      moodValue: moodValue ?? this.moodValue,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  static String _dateOnly(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  static String dateKey(DateTime dt) => _dateOnly(dt);
}
