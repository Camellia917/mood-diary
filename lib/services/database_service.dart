import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import '../models/mood_entry.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  factory DatabaseService() => _instance;
  DatabaseService._();

  Database? _db;
  bool _initialized = false;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    if (!_initialized) {
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      }
      _initialized = true;
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mood_diary.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE mood_entries (
            id TEXT PRIMARY KEY,
            date TEXT NOT NULL,
            mood_value INTEGER NOT NULL,
            note TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
        await db.execute(
          'CREATE UNIQUE INDEX idx_date ON mood_entries(date)',
        );
      },
    );
  }

  Future<MoodEntry?> getEntry(DateTime date) async {
    final db = await database;
    final key = MoodEntry.dateKey(date);
    final maps = await db.query('mood_entries', where: 'date = ?', whereArgs: [key]);
    if (maps.isEmpty) return null;
    return MoodEntry.fromMap(maps.first);
  }

  Future<List<MoodEntry>> getEntries(DateTime from, DateTime to) async {
    final db = await database;
    final maps = await db.query(
      'mood_entries',
      where: 'date >= ? AND date <= ?',
      whereArgs: [MoodEntry.dateKey(from), MoodEntry.dateKey(to)],
      orderBy: 'date ASC',
    );
    return maps.map((m) => MoodEntry.fromMap(m)).toList();
  }

  Future<List<MoodEntry>> getAllEntries() async {
    final db = await database;
    final maps = await db.query('mood_entries', orderBy: 'date ASC');
    return maps.map((m) => MoodEntry.fromMap(m)).toList();
  }

  Future<MoodEntry> upsertEntry(DateTime date, int moodValue, String? note) async {
    final db = await database;
    final key = MoodEntry.dateKey(date);
    final now = DateTime.now().toIso8601String();
    final existing = await getEntry(date);

    if (existing != null) {
      final updated = existing.copyWith(moodValue: moodValue, note: note);
      await db.update(
        'mood_entries',
        {
          'mood_value': moodValue,
          'note': note,
          'updated_at': now,
        },
        where: 'date = ?',
        whereArgs: [key],
      );
      return updated;
    } else {
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      await db.insert('mood_entries', {
        'id': id,
        'date': key,
        'mood_value': moodValue,
        'note': note,
        'created_at': now,
        'updated_at': now,
      });
      return MoodEntry(
        id: id,
        date: DateTime(date.year, date.month, date.day),
        moodValue: moodValue,
        note: note,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<void> deleteEntry(DateTime date) async {
    final db = await database;
    await db.delete('mood_entries', where: 'date = ?', whereArgs: [MoodEntry.dateKey(date)]);
  }
}
