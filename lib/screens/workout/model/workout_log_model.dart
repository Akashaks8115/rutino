import 'package:hive/hive.dart';

class WorkoutLogModel {
  String id;
  String habitId;
  String date; // YYYY-MM-DD
  double durationMinutes;
  bool isCompleted;
  String note;

  WorkoutLogModel({
    required this.id,
    required this.habitId,
    required this.date,
    required this.durationMinutes,
    required this.isCompleted,
    required this.note,
  });
}

class WorkoutLogModelAdapter extends TypeAdapter<WorkoutLogModel> {
  @override
  final int typeId = 2; // Unique Type ID for Workout Log

  @override
  WorkoutLogModel read(BinaryReader reader) {
    return WorkoutLogModel(
      id: reader.readString(),
      habitId: reader.readString(),
      date: reader.readString(),
      durationMinutes: reader.readDouble(),
      isCompleted: reader.readBool(),
      note: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutLogModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.habitId);
    writer.writeString(obj.date);
    writer.writeDouble(obj.durationMinutes);
    writer.writeBool(obj.isCompleted);
    writer.writeString(obj.note);
  }
}
