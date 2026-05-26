import 'package:hive/hive.dart';

class ChallengeModel {
  String id;
  String title;
  int durationDays;
  int currentDayNumber;
  String? startDate;
  String status; // 'ongoing', 'completed', 'failed', 'locked', 'not_started'
  List<String> linkedHabitIds;
  int rewardXP;
  String? lastCheckInDate;
  String description;
  String difficulty;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.durationDays,
    this.currentDayNumber = 0,
    this.startDate,
    this.status = 'not_started',
    required this.linkedHabitIds,
    required this.rewardXP,
    this.lastCheckInDate,
    this.description = '',
    this.difficulty = 'Medium',
  });
}

class ChallengeModelAdapter extends TypeAdapter<ChallengeModel> {
  @override
  final int typeId = 4;

  @override
  ChallengeModel read(BinaryReader reader) {
    return ChallengeModel(
      id: reader.readString(),
      title: reader.readString(),
      durationDays: reader.readInt(),
      currentDayNumber: reader.readInt(),
      startDate: reader.readString(),
      status: reader.readString(),
      linkedHabitIds: reader.readStringList().cast<String>(),
      rewardXP: reader.readInt(),
      lastCheckInDate: reader.readString(),
      description: reader.readString(),
      difficulty: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ChallengeModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeInt(obj.durationDays);
    writer.writeInt(obj.currentDayNumber);
    writer.writeString(obj.startDate ?? '');
    writer.writeString(obj.status);
    writer.writeStringList(obj.linkedHabitIds);
    writer.writeInt(obj.rewardXP);
    writer.writeString(obj.lastCheckInDate ?? '');
    writer.writeString(obj.description);
    writer.writeString(obj.difficulty);
  }
}
