import 'package:flutter/material.dart';
import '../models/mood_type.dart';
import '../models/mood_entry.dart';
import '../services/database_service.dart';
import '../services/feedback_service.dart';

class TodayViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  MoodEntry? todayEntry;
  MoodType? selectedMood;
  String note = '';
  bool isSaved = false;
  bool showFeedback = false;

  String get todayDateString {
    final now = DateTime.now();
    final weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return '${now.year}年 ${now.month}月 ${now.day}日 ${weekdays[now.weekday - 1]}';
  }

  String get feedbackText {
    if (selectedMood == null) return '';
    return FeedbackService.feedbackFor(selectedMood!);
  }

  Future<void> loadToday() async {
    final today = DateTime.now();
    final entry = await _db.getEntry(today);
    if (entry != null) {
      todayEntry = entry;
      selectedMood = entry.mood;
      note = entry.note ?? '';
      isSaved = true;
      showFeedback = true;
    } else {
      todayEntry = null;
      selectedMood = null;
      note = '';
      isSaved = false;
      showFeedback = false;
    }
    notifyListeners();
  }

  Future<void> saveMood() async {
    if (selectedMood == null) return;
    final cleanNote = note.trim().isEmpty ? null : note.trim();
    final entry = await _db.upsertEntry(DateTime.now(), selectedMood!.value, cleanNote);
    todayEntry = entry;
    isSaved = true;
    showFeedback = true;
    notifyListeners();
  }

  void selectMood(MoodType mood) {
    selectedMood = mood;
    notifyListeners();
  }

  void setNote(String value) {
    note = value;
  }

  void startEditing() {
    isSaved = false;
    showFeedback = false;
    notifyListeners();
  }
}
