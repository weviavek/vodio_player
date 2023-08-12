// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoModelAdapter extends TypeAdapter<VideoModel> {
  @override
  final int typeId = 0;

  @override
  VideoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoModel(
      videoPath: fields[0] as String,
      videoName: fields[2] as String,
      videoSize: fields[1] as String,
      id: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, VideoModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.videoPath)
      ..writeByte(1)
      ..write(obj.videoSize)
      ..writeByte(2)
      ..write(obj.videoName)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteVideosAdapter extends TypeAdapter<FavoriteVideos> {
  @override
  final int typeId = 1;

  @override
  FavoriteVideos read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteVideos(
      favoriteList: (fields[0] as List).cast<VideoModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteVideos obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.favoriteList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteVideosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecentlyPlayedVideosAdapter extends TypeAdapter<RecentlyPlayedVideos> {
  @override
  final int typeId = 2;

  @override
  RecentlyPlayedVideos read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlyPlayedVideos(
      recentlyPlayedVideos: (fields[0] as List).cast<VideoModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyPlayedVideos obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.recentlyPlayedVideos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlyPlayedVideosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
