import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  factory DatabaseService() => _instance;
  DatabaseService._();

  Map<String, MoodEntry> _cache = {};
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getStringList('mood_keys') ?? [];
    _cache = {};
    for (final key in keys) {
      final json = prefs.getString('mood_$key');
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        _cache[key] = MoodEntry.fromMap(map);
      }
    }
    _loaded = true;
  }

  Future<void> _saveKeys(SharedPreferences prefs) async {
    final keys = _cache.keys.toList()..sort();
    await prefs.setStringList('mood_keys', keys);
  }

  Future<MoodEntry?> getEntry(DateTime date) async {
    await _ensureLoaded();
    return _cache[MoodEntry.dateKey(date)];
  }

  Future<List<MoodEntry>> getEntries(DateTime from, DateTime to) async {
    await _ensureLoaded();
    final fromKey = MoodEntry.dateKey(from);
    final toKey = MoodEntry.dateKey(to);
    return _cache.values
        .where((e) {
          final k = MoodEntry.dateKey(e.date);
          return k.compareTo(fromKey) >= 0 && k.compareTo(toKey) <= 0;
        })
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<List<MoodEntry>> getAllEntries() async {
    await _ensureLoaded();
    final list = _cache.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Future<MoodEntry> upsertEntry(DateTime date, int moodValue, String? note) async {
    await _ensureLoaded();
    final prefs = await SharedPreferences.getInstance();
    final key = MoodEntry.dateKey(date);
    final now = DateTime.now();
    final existing = _cache[key];

    final entry = MoodEntry(
      id: existing?.id ?? now.microsecondsSinceEpoch.toString(),
      date: DateTime(date.year, date.month, date.day),
      moodValue: moodValue,
      note: note,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    _cache[key] = entry;
    await prefs.setString('mood_$key', jsonEncode(entry.toMap()));
    await _saveKeys(prefs);
    return entry;
  }

  Future<void> deleteEntry(DateTime date) async {
    await _ensureLoaded();
    final prefs = await SharedPreferences.getInstance();
    final key = MoodEntry.dateKey(date);
    _cache.remove(key);
    await prefs.remove('mood_$key');
    await _saveKeys(prefs);
  }
}
