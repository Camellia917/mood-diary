import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../models/mood_type.dart';
import '../services/database_service.dart';

enum StatsPeriod { last7Days, last30Days, last90Days, allTime }

class StatsViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  StatsPeriod selectedPeriod = StatsPeriod.last30Days;
  List<MoodEntry> allEntries = [];

  int get periodDays {
    switch (selectedPeriod) {
      case StatsPeriod.last7Days: return 7;
      case StatsPeriod.last30Days: return 30;
      case StatsPeriod.last90Days: return 90;
      case StatsPeriod.allTime: return 0;
    }
  }

  Future<void> loadStats() async {
    final all = await _db.getAllEntries();
    if (periodDays > 0) {
      final start = DateTime.now().subtract(Duration(days: periodDays - 1));
      allEntries = all.where((e) => !e.date.isBefore(DateTime(start.year, start.month, start.day))).toList();
    } else {
      allEntries = all;
    }
    notifyListeners();
  }

  double get averageMood {
    if (allEntries.isEmpty) return 0;
    return allEntries.fold<int>(0, (s, e) => s + e.moodValue) / allEntries.length;
  }

  String get averageMoodLabel {
    if (allEntries.isEmpty) return '暂无数据';
    return MoodType.fromValue(averageMood.round().clamp(1, 5)).label;
  }

  MoodType? get mostFrequentMood {
    if (allEntries.isEmpty) return null;
    final counts = <int, int>{};
    for (final e in allEntries) {
      counts[e.moodValue] = (counts[e.moodValue] ?? 0) + 1;
    }
    final maxVal = counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return MoodType.fromValue(maxVal);
  }

  int get totalEntries => allEntries.length;

  Map<MoodType, int> get pieData {
    final map = <MoodType, int>{};
    for (final e in allEntries) {
      map[e.mood] = (map[e.mood] ?? 0) + 1;
    }
    return map;
  }

  List<MoodEntry> get lineChartData => allEntries;

  String get moodTrend {
    if (allEntries.length < 2) return '数据不足';
    final mid = allEntries.length ~/ 2;
    final first = allEntries.sublist(0, mid).fold<int>(0, (s, e) => s + e.moodValue) / mid;
    final second = allEntries.sublist(mid).fold<int>(0, (s, e) => s + e.moodValue) / (allEntries.length - mid);
    if (second > first + 0.3) return '呈上升趋势 📈';
    if (second < first - 0.3) return '呈下降趋势 📉';
    return '情绪稳定 📊';
  }

  void setPeriod(StatsPeriod period) {
    selectedPeriod = period;
    loadStats();
  }
}
