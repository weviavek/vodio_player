import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/video_model.dart';
import 'mostly_played_funtions.dart';
import 'playlist_database_funtions.dart';

ValueNotifier<List<VideoModel>> favoriteNotifier = ValueNotifier([]);
ValueNotifier<List<VideoModel>> recentNotifier = ValueNotifier([]);
ValueNotifier allVideoNorifier = ValueNotifier([]);

class DatabaseFunctions extends ChangeNotifier {
  static bool containsInFavorites(String path) {
    for (final current in favoriteNotifier.value) {
      if (path == current.videoPath) {
        return true;
      }
    }
    return false;
  }

  static bool containsInRecent(String path) {
    for (final current in recentNotifier.value) {
      if (path == current.videoPath) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> addFavorites(VideoModel current) async {
    final favoritesDB = await Hive.openBox<VideoModel>("favorites");
    if (containsInFavorites(current.videoPath)) {
      return false;
    } else {
      int id = await favoritesDB.add(current);
      favoritesDB.put(id, current);
      favoriteNotifier.notifyListeners();
      getAllVideos();
    }
    return true;
  }

  static Future<bool> removeFromFav(VideoModel current) async {
    String currentPath = current.videoPath;
    int i = 0;
    final favoritesDB = await Hive.openBox<VideoModel>("favorites");
    for (final currrent in favoritesDB.values) {
      if (currrent.videoPath == currentPath) {
        favoritesDB.deleteAt(i);
      }
      i++;
    }
    favoriteNotifier.notifyListeners();
    getAllVideos();
    return true;
  }

  static getAllVideos() async {
    final favoriteDB = await Hive.openBox<VideoModel>("favorites");
    favoriteNotifier.value.clear();
    favoriteNotifier.value.addAll(favoriteDB.values);
  }

  static void getRecentVideos() async {
    final recentDB = await Hive.openBox<VideoModel>("recentDB");
    recentNotifier.value.clear();
    recentNotifier.value.addAll(recentDB.values);
    allVideoNorifier.notifyListeners();
    recentNotifier.notifyListeners();
  }

  static addToRecent(VideoModel current) async {
    final recentDB = await Hive.openBox<VideoModel>("recentDB");
    if (containsInRecent(current.videoPath)) {
      removeFromRecent(current);
    }
    int id = await recentDB.add(current);
    recentDB.put(id, current);
    getRecentVideos();
  }

  static Future<bool> removeFromRecent(VideoModel current) async {
    String currentPath = current.videoPath;
    int i = 0;
    final recentDB = await Hive.openBox<VideoModel>("recentDB");
    for (final currrent in recentDB.values) {
      if (currrent.videoPath == currentPath) {
        try {
          recentDB.deleteAt(i);
        } catch (_) {}
      }
      i++;
    }
    recentNotifier.notifyListeners();
    getRecentVideos();
    return true;
  }

  getAllVideoFromDB() {
    getAllVideos();
    getRecentVideos();
    PlaylistFuntions().getPlaylistFromDB();
    MostlyPlayedFunctions().getMostlyPlayedVideosFromDB();
  }
}
