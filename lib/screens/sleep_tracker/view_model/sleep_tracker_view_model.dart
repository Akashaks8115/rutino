import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SleepTrackerViewModel extends ChangeNotifier {
  late Box _sleepBox;

  // A map of DateTime string (yyyy-MM-dd) to total sleep duration in minutes
  Map<String, int> sleepData = {};

  SleepTrackerViewModel() {
    _initBox();
  }

  void _initBox() {
    if (Hive.isBoxOpen('sleep_logs')) {
      _sleepBox = Hive.box('sleep_logs');
      _loadData();
    } else {
      Hive.openBox('sleep_logs').then((box) {
        _sleepBox = box;
        _loadData();
      });
    }
  }

  void _loadData() {
    sleepData.clear();
    for (var key in _sleepBox.keys) {
      final value = _sleepBox.get(key);
      if (value != null && value is Map) {
        final dateStr = value['date'] as String?;
        final duration = value['totalDurationMinutes'] as int?;
        if (dateStr != null && duration != null) {
          sleepData[dateStr] = duration;
        }
      }
    }
    notifyListeners();
  }

  /// Calculates the color intensity for a specific day based on minutes slept.
  /// < 240 mins (4 hours) = Poor (Red/Orange)
  /// < 420 mins (7 hours) = Okay (Light Blue)
  /// >= 420 mins (7 hours) = Optimal (Deep Blue)
  Color getColorForDuration(int? minutes, Color primaryColor) {
    if (minutes == null || minutes == 0) return Colors.grey.withValues(alpha: 0.1);
    
    if (minutes < 240) {
      return Colors.red.withValues(alpha: 0.5); // Poor
    } else if (minutes < 420) {
      return primaryColor.withValues(alpha: 0.5); // Okay
    } else if (minutes <= 600) {
      return primaryColor; // Optimal (7-10 hours)
    } else {
      return primaryColor.withValues(alpha: 0.8); // Oversleeping slightly
    }
  }

  int getSleepDurationForDate(DateTime date) {
    final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return sleepData[dateString] ?? 0;
  }
}
