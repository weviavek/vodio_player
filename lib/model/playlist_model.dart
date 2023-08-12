import 'package:hive_flutter/hive_flutter.dart';

import 'video_model.dart';
part 'playlist_model.g.dart';

@HiveType(typeId: 3)
class PlaylistItemModel {
  PlaylistItemModel({required this.playlistName, required this.playlistItem});
  @HiveField(0)
  final String playlistName;
  @HiveField(1)
  List<VideoModel> playlistItem;
}

@HiveType(typeId: 3)
class Playlist {
  @HiveField(0)
  final Map<String, List<VideoModel>> playlists;
  Playlist({required this.playlists});
}
