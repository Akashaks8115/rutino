import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/step_log_model.dart';

class StepTrackerViewModel extends ChangeNotifier {
  final Box<StepLogModel> _logsBox = Hive.box<StepLogModel>('steps_log_box');
  
  int _todaySteps = 0;
  int get todaySteps => _todaySteps;

  int _targetGoal = 10000;
  int get targetGoal => _targetGoal;

  double get caloriesBurned => _todaySteps * 0.04;
  double get distanceKm => _todaySteps * 0.00075;

  bool _isGoalAchieved = false;
  bool get isGoalAchieved => _isGoalAchieved;

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  late Stream<StepCount> _stepCountStream;

  Future<void> initStepTracker() async {
    if (_isTracking) return;

    if (await Permission.activityRecognition.request().isGranted) {
      _loadTargetGoal();
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
      _isTracking = true;
      notifyListeners();
    }
  }

  Future<void> _loadTargetGoal() async {
    final prefs = await SharedPreferences.getInstance();
    _targetGoal = prefs.getInt('step_target_goal') ?? 10000;
    notifyListeners();
  }

  Future<void> setTargetGoal(int goal) async {
    _targetGoal = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('step_target_goal', goal);
    
    // Recalculate goal achievement status
    if (_todaySteps >= _targetGoal && !_isGoalAchieved) {
       _isGoalAchieved = true;
       // We can trigger an event or callback here if needed
    } else if (_todaySteps < _targetGoal) {
       _isGoalAchieved = false;
    }
    
    await _saveCurrentLog();
    notifyListeners();
  }

  void onStepCount(StepCount event) async {
    String todayStr = DateTime.now().toString().split(' ')[0];
    int hardwareTotalSteps = event.steps;

    final prefs = await SharedPreferences.getInstance();
    int baselineSteps = prefs.getInt('baseline_steps_$todayStr') ?? -1;

    if (baselineSteps == -1) {
      // First time opening the app today
      await prefs.setInt('baseline_steps_$todayStr', hardwareTotalSteps);
      baselineSteps = hardwareTotalSteps;
      
      // Reset goal achieved state for the new day
      _isGoalAchieved = false;
    }

    _todaySteps = hardwareTotalSteps - baselineSteps;
    
    // Safety check just in case hardware sensor resets
    if (_todaySteps < 0) {
      _todaySteps = 0;
      await prefs.setInt('baseline_steps_$todayStr', hardwareTotalSteps);
    }

    bool isDone = _todaySteps >= _targetGoal;
    
    if (isDone && !_isGoalAchieved) {
      _isGoalAchieved = true;
      // Triggers GoalAchievedOverlay via UI listener
      // We'll manage this by notifying listeners and letting the UI react
    }

    await _saveCurrentLog();
    notifyListeners();
  }

  Future<void> _saveCurrentLog() async {
    String todayStr = DateTime.now().toString().split(' ')[0];
    bool isDone = _todaySteps >= _targetGoal;

    final log = StepLogModel(
      id: "steps_log_$todayStr",
      date: todayStr,
      stepsCount: _todaySteps,
      targetGoal: _targetGoal,
      caloriesBurned: caloriesBurned,
      distanceKm: distanceKm,
      isCompleted: isDone,
    );

    await _logsBox.put(log.id, log);
  }

  void onStepCountError(error) {
    debugPrint("Pedometer Error: $error");
    _isTracking = false;
    notifyListeners();
  }
}
