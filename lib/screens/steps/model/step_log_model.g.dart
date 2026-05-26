// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepLogModelAdapter extends TypeAdapter<StepLogModel> {
  @override
  final int typeId = 4;

  @override
  StepLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepLogModel(
      id: fields[0] as String,
      date: fields[1] as String,
      stepsCount: fields[2] as int,
      targetGoal: fields[3] as int,
      caloriesBurned: fields[4] as double,
      distanceKm: fields[5] as double,
      isCompleted: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StepLogModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.stepsCount)
      ..writeByte(3)
      ..write(obj.targetGoal)
      ..writeByte(4)
      ..write(obj.caloriesBurned)
      ..writeByte(5)
      ..write(obj.distanceKm)
      ..writeByte(6)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
