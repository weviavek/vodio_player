import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/playlist_model.dart';
import '../../model/video_model.dart';

ValueNotifier<List<PlaylistItemModel>> playlistNotifier = ValueNotifier([]);

class PlaylistFuntions extends ChangeNotifier {
  Future createPlaylist(String currentPlaylistName) async {
    final playlistDB = await Hive.openBox<PlaylistItemModel>("playlist");
    int id = await playlistDB.add(
        PlaylistItemModel(playlistName: currentPlaylistName, playlistItem: []));
    playlistDB.put(id,
        PlaylistItemModel(playlistName: currentPlaylistName, playlistItem: []));
    getPlaylistFromDB();
  }

  deleteCurrentPlaylist(String targetPlaylistName) async {
    final playlistDB = await Hive.openBox<PlaylistItemModel>("playlist");
    int i = 0;
    for (final currentPlaylist in playlistDB.values) {
      if (currentPlaylist.playlistName == targetPlaylistName) {
        playlistDB.deleteAt(i);
      }
      i++;
    }
    getPlaylistFromDB();
  }

  void getPlaylistFromDB() async {
    final playlistDB = await Hive.openBox<PlaylistItemModel>("playlist");
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistDB.values);
    playlistNotifier.notifyListeners();
  }

  Future<bool> containsPlaylist(currentPlaylistName) async {
    final playlistDB = await Hive.openBox<PlaylistItemModel>("playlist");
    for (final currentList in playlistDB.values) {
      if (currentList.playlistName == currentPlaylistName) {
        return true;
      }
    }

    return false;
  }

  void addVideoToPlaylist(
      String targetPlaylistName, VideoModel currentVideoModel) async {
    Box<PlaylistItemModel> playlistDB =
        await Hive.openBox<PlaylistItemModel>('playlist');
    int i = 0;
    for (PlaylistItemModel currentPlaylist in playlistDB.values) {
      if (currentPlaylist.playlistName == targetPlaylistName) {
        final tempList = currentPlaylist.playlistItem;
        tempList.add(currentVideoModel);
        playlistDB.putAt(
            i,
            PlaylistItemModel(
                playlistName: targetPlaylistName, playlistItem: tempList));
      }
      i++;
    }
    getPlaylistFromDB();
  }

  void removeVideoFromPlaylist(String currentPlaylistName, int indexInDB,
      VideoModel currentVideoModelInDB) async {
    final playlistDB = await Hive.openBox<PlaylistItemModel>("playlist");
    for (PlaylistItemModel currentPlaylist in playlistDB.values) {
      if (currentPlaylist.playlistName == currentPlaylistName) {
        List<VideoModel> tempList = currentPlaylist.playlistItem;
        tempList.removeAt(indexInDB);
        currentPlaylist.playlistItem = tempList;
      }
    }

    getPlaylistFromDB();
  }
}
