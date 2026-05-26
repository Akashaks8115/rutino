import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/habit_model.dart';
import '../../workout/model/workout_log_model.dart';
import '../widget/sleep_confirmation_sheet.dart';

class DashboardViewModel extends ChangeNotifier {
  late Box<HabitModel> _habitBox;
  late Box _statsBox;
  late Box _prefsBox;

  DateTime _selectedDate = DateTime.now();

  DashboardViewModel() {
    _habitBox = Hive.box<HabitModel>('habits');
    _statsBox = Hive.box('stats');
    _prefsBox = Hive.box('prefs');
    _initDefaultData();
    syncWidgetDataWithHive();
  }

  void _initDefaultData() {
    if (_statsBox.isEmpty) {
      _statsBox.put('streakCount', 0);
      _statsBox.put('xpLevel', 0);
      _statsBox.put('freezeBank', 0);
    }
  }

  int get streakCount => _statsBox.get('streakCount', defaultValue: 0);
  int get xpLevel => _statsBox.get('xpLevel', defaultValue: 0);
  int get freezeBank => _statsBox.get('freezeBank', defaultValue: 0);

  List<String> get enabledFeatures {
    final list = _prefsBox.get('enabled_features', defaultValue: <String>[]);
    return List<String>.from(list);
  }

  DateTime get selectedDate => _selectedDate;

  bool get isTodaySelected {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
           _selectedDate.month == now.month &&
           _selectedDate.day == now.day;
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<HabitModel> get habits {
    final enabled = enabledFeatures;
    final liveHabits = _habitBox.values.where((h) => enabled.contains(h.id)).toList();

    if (isTodaySelected) {
      return liveHabits;
    } else {
      String dateStr = _selectedDate.toString().split(' ')[0];
      return liveHabits.map((h) {
        bool isCompleted = Hive.box('logs_box').get('${h.id}_$dateStr', defaultValue: false);
        return HabitModel(
          id: h.id,
          title: h.title,
          completedCount: isCompleted ? h.targetCount : 0,
          targetCount: h.targetCount,
          timeOfDay: h.timeOfDay,
          icon: h.icon,
          type: h.type,
          note: h.note,
          mode: h.mode,
          bookName: h.bookName,
          totalBookPages: h.totalBookPages,
          totalPagesReadSoFar: h.totalPagesReadSoFar,
          unit: h.unit,
          workoutType: h.workoutType,
          workoutGoalType: h.workoutGoalType,
        );
      }).toList();
    }
  }

  int get completedHabitsCount =>
      habits.where((h) => h.completedCount >= h.targetCount).length;
  int get totalHabitsCount => habits.length;

  void toggleFeature(String id, bool isEnabled, HabitModel template) {
    final List<String> currentEnabled = enabledFeatures;
    if (isEnabled) {
      if (!currentEnabled.contains(id)) {
        currentEnabled.add(id);
      }
      if (!_habitBox.containsKey(id)) {
        _habitBox.put(id, template);
      }
    } else {
      currentEnabled.remove(id);
    }
    _prefsBox.put('enabled_features', currentEnabled);
    notifyListeners();
  }

  void incrementHabit(String id, int amount) {
    final habit = _habitBox.get(id);
    if (habit != null && habit.completedCount < habit.targetCount) {
      habit.completedCount += amount;

      // Handle overall book progression
      if (habit.id == '3' && habit.mode == 'per_book') {
         habit.totalPagesReadSoFar = (habit.totalPagesReadSoFar ?? 0) + amount;
      }

      if (habit.completedCount >= habit.targetCount) {
        habit.completedCount = habit.targetCount;
        int currentXp = _statsBox.get('xpLevel', defaultValue: 0);
        _statsBox.put('xpLevel', currentXp + 10);
        
        // Log daily completion for Challenge Mode
        String todayStr = DateTime.now().toString().split(' ')[0];
        Hive.box('logs_box').put('${id}_$todayStr', true);
      }
      _habitBox.put(id, habit);
      notifyListeners();
    }
  }

  void saveNoteForHabit(String id, String note) {
    final habit = _habitBox.get(id);
    if (habit != null) {
      habit.note = note;
      _habitBox.put(id, habit);
      notifyListeners();
    }
  }

  Future<void> logWorkoutSession(String habitId, double minutesTrained, String workoutNote) async {
    String todayStr = DateTime.now().toString().split(' ')[0];
    String logId = "${habitId}_$todayStr";

    var habit = _habitBox.get(habitId);
    if (habit != null) {
       int targetMinutes = habit.targetCount;
       bool isDone = minutesTrained >= targetMinutes;
       
       if (habit.completedCount < habit.targetCount) {
         habit.completedCount += minutesTrained.toInt();
         if (habit.completedCount >= habit.targetCount) {
            habit.completedCount = habit.targetCount;
            int currentXp = _statsBox.get('xpLevel', defaultValue: 0);
            _statsBox.put('xpLevel', currentXp + 20); // 20 XP for workout
            Hive.box('logs_box').put('${habitId}_$todayStr', true);
         }
         _habitBox.put(habitId, habit);
       }

       final Box logsBox = Hive.box('workout_logs');
       await logsBox.put(logId, WorkoutLogModel(
         id: logId,
         habitId: habitId,
         date: todayStr,
         durationMinutes: minutesTrained,
         isCompleted: isDone,
         note: workoutNote,
       ));

       notifyListeners();
    }
  }

  Future<void> syncWidgetDataWithHive() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String todayStr = DateTime.now().toString().split(' ')[0];
    // Widget saves date in "flutter.water_last_date"
    String lastDate = prefs.getString('water_last_date') ?? '';

    // Widget writes using Int "flutter.water_current_progress"
    int widgetWaterProgress = prefs.getInt('water_current_progress') ?? 0;
    
    String waterHabitId = '1'; // '1' is Drink Water ID
    final habit = _habitBox.get(waterHabitId);
    
    if (habit != null) {
       if (lastDate != todayStr && lastDate.isNotEmpty) {
          // New day detected by Flutter, reset app progress and sync to native
          habit.completedCount = 0;
          _habitBox.put(waterHabitId, habit);
          prefs.setString('water_last_date', todayStr);
          prefs.setInt('water_current_progress', 0);
          prefs.setBool('water_widget_checked', false);
          return;
       }

       int nativeProgress = widgetWaterProgress;
       if (nativeProgress > habit.completedCount) {
         int diff = nativeProgress - habit.completedCount;
         incrementHabit(waterHabitId, diff);
       } else if (nativeProgress < habit.completedCount) {
         // App has more progress (e.g. daily reset or added in app), sync it back to native
         prefs.setInt('water_current_progress', habit.completedCount);
         prefs.setString('water_last_date', todayStr);
       }
    }
  }

  void refresh() {
    notifyListeners();
  }

  Future<void> processAutomatedSleep(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? bedTimestamp = prefs.getInt('native_screen_off_time');
    int? wakeTimestamp = prefs.getInt('native_user_present_time');

    if (bedTimestamp != null && wakeTimestamp != null) {
      DateTime bedTime = DateTime.fromMillisecondsSinceEpoch(bedTimestamp);
      DateTime wakeTime = DateTime.fromMillisecondsSinceEpoch(wakeTimestamp);

      int totalMinutesSlept = wakeTime.difference(bedTime).inMinutes;
      String todayStr = DateTime.now().toString().split(' ')[0];
      
      bool isProcessed = prefs.getBool('sleep_processed_$todayStr') ?? false;

      if (!isProcessed && totalMinutesSlept >= 180 && totalMinutesSlept <= 960) {
        // Clear temporary timestamps
        await prefs.remove('native_screen_off_time');
        await prefs.remove('native_user_present_time');
        await prefs.setBool('sleep_processed_$todayStr', true);

        // Show Confirmation Sheet
        Future.microtask(() {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => SleepConfirmationSheet(
              bedTime: bedTime,
              wakeTime: wakeTime,
              totalMinutes: totalMinutesSlept,
              onConfirm: (finalBed, finalWake, finalMinutes) async {
                final sleepBox = Hive.box('sleep_logs');
                await sleepBox.put(todayStr, {
                  'id': "sleep_log_$todayStr",
                  'date': todayStr,
                  'bedTime': finalBed.toIso8601String(),
                  'wakeTime': finalWake.toIso8601String(),
                  'totalDurationMinutes': finalMinutes,
                  'isAutoDetected': true,
                  'isConfirmedByUser': true
                });
                
                // Add XP
                int currentXp = _statsBox.get('xpLevel', defaultValue: 0);
                _statsBox.put('xpLevel', currentXp + 15);
                notifyListeners();
              },
            ),
          );
        });
      }
    }
  }
}
