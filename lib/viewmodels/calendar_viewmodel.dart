import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';

import '../services/database_service.dart';

class CalendarViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  DateTime currentMonth = DateTime.now();
  Map<String, MoodEntry> entries = {};
  DateTime? selectedDate;
  MoodEntry? selectedEntry;

  String get monthTitle => DateFormat('yyyy年 M月', 'zh_CN').format(currentMonth);

  List<String> get weekdaySymbols => ['一', '二', '三', '四', '五', '六', '日'];

  Future<void> loadMonth() async {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    final list = await _db.getEntries(firstDay, lastDay);
    entries = {};
    for (final e in list) {
      entries[MoodEntry.dateKey(e.date)] = e;
    }
    notifyListeners();
  }

  List<DateTime?> daysInMonth() {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final prefixEmpty = firstDay.weekday - 1;

    final days = <DateTime?>[];
    for (int i = 0; i < prefixEmpty; i++) {
      days.add(null);
    }
    for (int d = 1; d <= lastDay.day; d++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, d));
    }
    return days;
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    selectedEntry = entries[MoodEntry.dateKey(date)];
    notifyListeners();
  }

  Future<void> updateEntry(int moodValue, String? note) async {
    if (selectedDate == null) return;
    await _db.upsertEntry(selectedDate!, moodValue, note);
    await loadMonth();
    selectedEntry = entries[MoodEntry.dateKey(selectedDate!)];
    notifyListeners();
  }

  Future<void> deleteEntry() async {
    if (selectedDate == null) return;
    await _db.deleteEntry(selectedDate!);
    selectedEntry = null;
    await loadMonth();
    notifyListeners();
  }

  void goToPreviousMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    loadMonth();
  }

  void goToNextMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    loadMonth();
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
