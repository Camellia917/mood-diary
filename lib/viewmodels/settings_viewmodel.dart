import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final NotificationService _notif = NotificationService();

  bool reminderEnabled = false;
  TimeOfDay reminderTime = const TimeOfDay(hour: 21, minute: 0);

  Future<void> init() async {
    if (_notif.reminderTime != null) {
      reminderEnabled = true;
      final t = _notif.reminderTime!;
      reminderTime = TimeOfDay(hour: t.hour, minute: t.minute);
    }
    notifyListeners();
  }

  Future<void> setReminder(bool enabled) async {
    reminderEnabled = enabled;
    if (enabled) {
      await _notif.requestPermission();
      await _notif.scheduleDailyReminder(reminderTime);
    } else {
      await _notif.cancelReminder();
    }
    notifyListeners();
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    reminderTime = time;
    if (reminderEnabled) {
      await _notif.scheduleDailyReminder(time);
    }
    notifyListeners();
  }
}
