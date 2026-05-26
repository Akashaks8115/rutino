import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../dashboard/model/habit_model.dart';
import '../../focus/service/notification_service.dart';

class WorkoutViewModel extends ChangeNotifier {
  String _workoutType = 'Weight Training'; 
  String get workoutType => _workoutType;

  String _goalType = 'duration'; // 'duration' or 'task'
  String get goalType => _goalType;

  int _targetMinutes = 45;
  int get targetMinutes => _targetMinutes;

  int _hour = 18;
  int get hour => _hour;
  int _minute = 30;
  int get minute => _minute;

  final List<int> _selectedDays = [1, 2, 3, 5, 6];
  List<int> get selectedDays => _selectedDays;

  bool _isReminderEnabled = true;
  bool get isReminderEnabled => _isReminderEnabled;

  void setWorkoutType(String type) {
    _workoutType = type;
    notifyListeners();
  }

  void setGoalType(String type) {
    _goalType = type;
    notifyListeners();
  }

  void setTargetMinutes(int minutes) {
    if (minutes > 0) {
      _targetMinutes = minutes;
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
    
    HabitModel workoutHabit = habitBox.get('4') ?? HabitModel(
      id: '4', 
      title: 'Fitness Session', 
      completedCount: 0, 
      targetCount: _goalType == 'duration' ? _targetMinutes : 1, 
      timeOfDay: 'Evening', 
      icon: '🏋️‍♂️', 
      type: _goalType == 'duration' ? HabitType.quantifiable : HabitType.yesNo
    );

    workoutHabit.title = _workoutType.isEmpty ? 'Fitness Session' : _workoutType;
    workoutHabit.targetCount = _goalType == 'duration' ? _targetMinutes : 1;
    workoutHabit.type = _goalType == 'duration' ? HabitType.quantifiable : HabitType.yesNo;
    workoutHabit.workoutType = _workoutType;
    workoutHabit.workoutGoalType = _goalType;
    workoutHabit.unit = _goalType == 'duration' ? 'mins' : 'session';
    if(workoutHabit.completedCount >= workoutHabit.targetCount) {
       workoutHabit.completedCount = workoutHabit.targetCount;
    }

    habitBox.put('4', workoutHabit);

    final enabled = List<String>.from(prefsBox.get('enabled_features', defaultValue: <String>[]));
    if (!enabled.contains('4')) {
      enabled.add('4');
      prefsBox.put('enabled_features', enabled);
    }

    if (_isReminderEnabled) {
      String timeStr = '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}';
      await NotificationService.scheduleWorkoutReminders(timeStr, _selectedDays, workoutHabit.title);
    }
  }
}
