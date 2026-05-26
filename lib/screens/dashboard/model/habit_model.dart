import 'package:hive/hive.dart';

enum HabitType { yesNo, quantifiable }

class HabitModel {
  String id;
  String title;
  int completedCount;
  int targetCount;
  String timeOfDay; // Morning, Afternoon, Evening
  String icon;
  HabitType type;
  String note;

  // Book Reading specific fields
  String? mode; // 'per_book' or 'daily_routine'
  String? bookName;
  int? totalBookPages;
  int? totalPagesReadSoFar;
  String? unit; // 'pages'

  // Workout specific fields
  String? workoutType; // e.g. "Weight Training", "Cardio"
  String? workoutGoalType; // "duration" or "task"

  HabitModel({
    required this.id,
    required this.title,
    required this.completedCount,
    required this.targetCount,
    required this.timeOfDay,
    required this.icon,
    required this.type,
    this.note = '',
    this.mode,
    this.bookName,
    this.totalBookPages,
    this.totalPagesReadSoFar,
    this.unit,
    this.workoutType,
    this.workoutGoalType,
  });
}

class HabitModelAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 0;

  @override
  HabitModel read(BinaryReader reader) {
    String id = reader.readString();
    String title = reader.readString();
    int completedCount = reader.readInt();
    int targetCount = reader.readInt();
    String timeOfDay = reader.readString();
    String icon = reader.readString();
    HabitType type = HabitType.values[reader.readInt()];
    String note = reader.readString();

    String? mode;
    String? bookName;
    int? totalBookPages;
    int? totalPagesReadSoFar;
    String? unit;

    String? workoutType;
    String? workoutGoalType;

    if (reader.availableBytes > 0) {
      mode = reader.readString();
      bookName = reader.readString();
      totalBookPages = reader.readInt();
      totalPagesReadSoFar = reader.readInt();
      unit = reader.readString();
      workoutType = reader.readString();
      workoutGoalType = reader.readString();
    }

    return HabitModel(
      id: id,
      title: title,
      completedCount: completedCount,
      targetCount: targetCount,
      timeOfDay: timeOfDay,
      icon: icon,
      type: type,
      note: note,
      mode: mode,
      bookName: bookName,
      totalBookPages: totalBookPages,
      totalPagesReadSoFar: totalPagesReadSoFar,
      unit: unit,
      workoutType: workoutType,
      workoutGoalType: workoutGoalType,
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeInt(obj.completedCount);
    writer.writeInt(obj.targetCount);
    writer.writeString(obj.timeOfDay);
    writer.writeString(obj.icon);
    writer.writeInt(obj.type.index);
    writer.writeString(obj.note);
    // New fields
    writer.writeString(obj.mode ?? '');
    writer.writeString(obj.bookName ?? '');
    writer.writeInt(obj.totalBookPages ?? 0);
    writer.writeInt(obj.totalPagesReadSoFar ?? 0);
    writer.writeString(obj.unit ?? '');
    writer.writeString(obj.workoutType ?? '');
    writer.writeString(obj.workoutGoalType ?? '');
  }
}
