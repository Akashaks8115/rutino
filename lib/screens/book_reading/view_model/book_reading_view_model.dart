import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../dashboard/model/habit_model.dart';
import '../../focus/service/notification_service.dart';

class BookReadingViewModel extends ChangeNotifier {
  String _mode = 'per_book'; // 'per_book' or 'daily_routine'
  String get mode => _mode;

  String _bookName = '';
  String get bookName => _bookName;

  int _totalBookPages = 0;
  int get totalBookPages => _totalBookPages;

  int _targetDailyPages = 15;
  int get targetDailyPages => _targetDailyPages;

  int _hour = 21;
  int get hour => _hour;
  int _minute = 30;
  int get minute => _minute;

  final List<int> _selectedDays = [1, 2, 3, 4, 5, 6, 7];
  List<int> get selectedDays => _selectedDays;

  bool _isReminderEnabled = true;
  bool get isReminderEnabled => _isReminderEnabled;

  void setMode(String mode) {
    _mode = mode;
    notifyListeners();
  }

  void setBookName(String name) {
    _bookName = name;
    notifyListeners();
  }

  void setTotalPages(int pages) {
    _totalBookPages = pages;
    notifyListeners();
  }

  void setTargetDailyPages(int target) {
    if (target > 0) {
      _targetDailyPages = target;
      notifyListeners();
    }
  }

  void setTime(int hour, int minute) {
    _hour = hour;
    _minute = minute;
    notifyListeners();
  }

  void toggleDay(int day) {
    if (_selectedDays.contains(day)) {
      _selectedDays.remove(day);
    } else {
      _selectedDays.add(day);
    }
    notifyListeners();
  }

  void toggleReminder(bool value) {
    _isReminderEnabled = value;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final habitBox = Hive.box<HabitModel>('habits');
    final prefsBox = Hive.box('prefs');

    HabitModel bookHabit =
        habitBox.get('3') ??
        HabitModel(
          id: '3',
          title: _mode == 'per_book'
              ? _bookName.isEmpty
                    ? 'Read Book'
                    : _bookName
              : 'Read Book',
          completedCount: 0,
          targetCount: _targetDailyPages,
          timeOfDay: 'Evening',
          icon: '📚',
          type: HabitType.quantifiable,
        );

    bookHabit.title = _mode == 'per_book'
        ? _bookName.isEmpty
              ? 'Read Book'
              : _bookName
        : 'Read Book';
    bookHabit.targetCount = _targetDailyPages;
    bookHabit.mode = _mode;
    bookHabit.bookName = _bookName;
    bookHabit.totalBookPages = _totalBookPages;
    // ensure we don't wipe out existing read pages
    bookHabit.totalPagesReadSoFar ??= 0;
    bookHabit.unit = 'pages';

    habitBox.put('3', bookHabit);

    // ensure it's enabled in dashboard
    final enabled = List<String>.from(
      prefsBox.get('enabled_features', defaultValue: <String>[]),
    );
    if (!enabled.contains('3')) {
      enabled.add('3');
      prefsBox.put('enabled_features', enabled);
    }

    if (_isReminderEnabled) {
      String timeStr =
          '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}';
      await NotificationService.scheduleBookReminders(
        timeStr,
        _selectedDays,
        bookHabit.title,
      );
    } else {
      // await NotificationService.cancelBookNotifications(); // if we make one
    }
  }
}
