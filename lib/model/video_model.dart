import 'package:hive_flutter/hive_flutter.dart';

part 'video_model.g.dart';

@HiveType(typeId: 0)
class VideoModel {
  @HiveField(0)
  final String videoPath;
  @HiveField(1)
  final String videoSize;
  @HiveField(2)
  final String videoName;
  @HiveField(3)
  final int? id;
  VideoModel(
      {required this.videoPath,
      required this.videoName,
      required this.videoSize,
      this.id});
}

@HiveType(typeId: 1)
class FavoriteVideos {
  @HiveField(0)
  List<VideoModel> favoriteList;

  FavoriteVideos({required this.favoriteList});
}
@HiveType(typeId: 2)
class RecentlyPlayedVideos {
  @HiveField(0)
  List<VideoModel> recentlyPlayedVideos;

  RecentlyPlayedVideos({required this.recentlyPlayedVideos});
}
