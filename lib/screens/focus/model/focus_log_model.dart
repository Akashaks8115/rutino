import 'package:hive/hive.dart';

class FocusLogModel {
  String id;
  String mode; // Study, Meditate, Reading
  int durationMinutes;
  DateTime timestamp;
  String rating; // Great, Distracted, Difficult

  FocusLogModel({
    required this.id,
    required this.mode,
    required this.durationMinutes,
    required this.timestamp,
    required this.rating,
  });
}

class FocusLogModelAdapter extends TypeAdapter<FocusLogModel> {
  @override
  final int typeId = 1; // 0 is used for HabitModel

  @override
  FocusLogModel read(BinaryReader reader) {
    return FocusLogModel(
      id: reader.readString(),
      mode: reader.readString(),
      durationMinutes: reader.readInt(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      rating: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, FocusLogModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.mode);
    writer.writeInt(obj.durationMinutes);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeString(obj.rating);
  }
}
