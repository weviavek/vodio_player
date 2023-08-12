// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mostly_played_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MostlyPlayedModelAdapter extends TypeAdapter<MostlyPlayedModel> {
  @override
  final int typeId = 5;

  @override
  MostlyPlayedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MostlyPlayedModel(
      fields[0] as VideoModel,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MostlyPlayedModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.videoModel)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MostlyPlayedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
