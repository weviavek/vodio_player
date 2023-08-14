import 'package:flutter/material.dart';
import 'package:vodio_player/widgets/animations/unsupported_device.dart';

import '../../functions/storage_functions/initial_functions.dart';
import '../../we_player/video_player.dart';
import '../../widgets/animations/loading_animation.dart';
import '../../widgets/animations/permission_denied.dart';
import '../../widgets/custom_widgets/custom_colors.dart';
import '../list_screens/current_playlist_items.dart';
import '../list_screens/folder_files.dart';
import '../list_screens/mostly_played_list.dart';
import '../list_screens/viewed_videos_history.dart';
import 'home_screen.dart';

ValueNotifier firstScreenNotifier = ValueNotifier(0);

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen> {
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 47, 69, 80),
          primarySwatch: CustomColors().swatchColor,
          appBarTheme:
              AppBarTheme(backgroundColor: CustomColors().swatchColor)),
      home: ValueListenableBuilder(
        valueListenable: firstScreenNotifier,
        builder: (context, value, child) => FutureBuilder(
            future: InitialFunctions().rootDirec(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  //returns Null if unsuported android version
                  return const UnsupportedScreen();
                } else if (snapshot.data == 50) {
                  //allow permission manually
                  return const PermissionScreen();
                } else {
                  return const HomeScreen();
                }
              } else {
                return const LoadingWidget();
              }
            }),
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/currentFolderView': (context) => FolderFiles(
            videos: videoDirectories.values.elementAt(currentFolderIndex),
            title: videoDirectories.keys.elementAt(currentFolderIndex)),
        '/videoplayer': (context) => Videoplayer(
              currentIndex: currentIndex,
              currentList: currentVideoList,
            ),
        '/playlistPage': (context) => CurrentPlaylistItem(
            currentPlaylistName: currentPlaylistName,
            currentPlaylistItems: currentPlaylistItems,
            currentPlaylistIndex: currentPlaylistIndex),
        '/mostlyplayedPage': (context) => const MostlyPlayedPage(),
        '/history': (context) => const ViewedVideosHistory()
      },
    );
  }
}
