import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/mostly_played_model.dart';
import 'model/playlist_model.dart';
import 'model/video_model.dart';
import 'screens/main_screens/first_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  runApp(const FirstScreen());
  Hive.registerAdapter(FavoriteVideosAdapter());
  Hive.registerAdapter(VideoModelAdapter());
  Hive.registerAdapter(RecentlyPlayedVideosAdapter());
  Hive.registerAdapter(PlaylistItemModelAdapter());
  Hive.registerAdapter(MostlyPlayedModelAdapter());
}
