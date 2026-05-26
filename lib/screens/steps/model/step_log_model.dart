import 'package:hive/hive.dart';

part 'step_log_model.g.dart';

@HiveType(typeId: 4) // Ensure typeId is unique
class StepLogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String date;

  @HiveField(2)
  int stepsCount;

  @HiveField(3)
  int targetGoal;

  @HiveField(4)
  double caloriesBurned;

  @HiveField(5)
  double distanceKm;

  @HiveField(6)
  bool isCompleted;

  StepLogModel({
    required this.id,
    required this.date,
    required this.stepsCount,
    required this.targetGoal,
    required this.caloriesBurned,
    required this.distanceKm,
    required this.isCompleted,
  });
}
