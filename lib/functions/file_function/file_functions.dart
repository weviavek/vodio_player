import 'dart:io';

import '../../model/video_model.dart';

List<VideoModel> recentlyPlayed = [];

class FileFunctions {
  static String videoSizeHelper(String path) {
    int size = File(path).lengthSync();
    List<String> sizeNotations = ['bytes', 'KB', 'MB', 'GB'];
    int i = 0;
    while (size > 1024) {
      size = size ~/ 1024;
      i++;
    }
    return "$size ${sizeNotations[i]}";
  }

  static videoNameHelper(String path) {
    return path.split("/").last.split(".").first;
  }
}
