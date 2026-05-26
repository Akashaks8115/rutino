import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rutino/libs.dart';
import 'package:share_plus/share_plus.dart';

class AnalyticsViewModel extends ChangeNotifier {
  Map<DateTime, double> _heatmapData = {};
  List<double> _weeklyData = [];
  String _bestDay = "Sunday";
  String _worstDay = "Friday";
  bool _isLoading = true;

  Map<DateTime, double> get heatmapData => _heatmapData;
  List<double> get weeklyData => _weeklyData;
  String get bestDay => _bestDay;
  String get worstDay => _worstDay;
  bool get isLoading => _isLoading;

  AnalyticsViewModel() {
    _loadData();
    try {
      Hive.box<HabitModel>('habits').listenable().addListener(() {
        _loadData();
      });
    } catch (e) {
      // Ignore if Hive is not ready yet
    }
  }

  Future<void> _loadData() async {
    final today = DateTime.now();
    final todayClean = DateTime(today.year, today.month, today.day);

    Map<DateTime, double> newHeatmap = {};
    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final cleanDate = DateTime(date.year, date.month, date.day);
      newHeatmap[cleanDate] = 0.0;
    }

    double todayRate = 0.0;
    try {
      final habitsBox = Hive.box<HabitModel>('habits');
      final prefsBox = Hive.box('prefs');
      final enabledFeatures = List<String>.from(
        prefsBox.get('enabled_features', defaultValue: []),
      );

      final activeHabits = habitsBox.values
          .where((h) => enabledFeatures.contains(h.id))
          .toList();
      if (activeHabits.isNotEmpty) {
        double totalRates = 0.0;
        for (var habit in activeHabits) {
          final rate = habit.targetCount > 0
              ? (habit.completedCount / habit.targetCount).clamp(0.0, 1.0)
              : 0.0;
          totalRates += rate;
        }
        todayRate = totalRates / activeHabits.length;
      }

      newHeatmap[todayClean] = todayRate;
    } catch (e) {
      // Ignore
    }

    _heatmapData = newHeatmap;

    _weeklyData = List.generate(7, (index) => 0.0);
    _weeklyData[today.weekday - 1] = todayRate * 100.0;

    List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    _bestDay = "N/A (0%)";
    _worstDay = "N/A (0%)";

    if (todayRate > 0) {
      _bestDay =
          "${days[today.weekday - 1]} (${(todayRate * 100).toStringAsFixed(0)}%)";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> exportReport(BuildContext context) async {
    try {
      List<List<dynamic>> rows = [
        ["Date", "Completion Rate"],
      ];

      final sortedKeys = _heatmapData.keys.toList()..sort();
      for (var date in sortedKeys) {
        rows.add([
          date.toIso8601String().split('T').first,
          "${(_heatmapData[date]! * 100).toStringAsFixed(1)}%",
        ]);
      }

      String csv = rows.map((row) => row.join(',')).join('\n');

      final directory = await getTemporaryDirectory();
      final path = "${directory.path}/rutino_report.csv";
      final file = File(path);
      await file.writeAsString(csv);

      await Share.shareXFiles([
        XFile(path),
      ], text: 'My Rutino Analytics Report');
    } catch (e) {
      CustomToast.showWarning(
        context,
        "Export Failed",
        "Could not export analytics report.",
      );
    }
  }
}
