import 'package:flutter/material.dart';
import '../functions/database_functions/database_functions.dart';
import '../screens/main_screens/home_screen.dart';
import 'floating_video_player.dart';
import 'we_player.dart';

class VideoMenu {
  static void changeSpeedTo(double value) {
    currentVideoPlayerController!.setPlaybackSpeed(value);
  }

  Widget videoPlayerMenu(context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      color: videoPlayerIconColor,
      iconSize: videoPlayerIconSize,
      itemBuilder: (BuildContext contex) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: playbackSpeedMenu(),
          ),
          PopupMenuItem<int>(
              value: 1,
              child: DatabaseFunctions.containsInFavorites(
                      currentVideoList[currentIndex].videoPath)
                  ? const Text('Remove From Favorites')
                  : const Text('Add to Favorites'),
              onTap: () async {
                if (DatabaseFunctions.containsInFavorites(
                    currentVideoList[currentIndex].videoPath)) {
                  DatabaseFunctions.removeFromFav(
                      currentVideoList[currentIndex]);
                } else {
                  await DatabaseFunctions.addFavorites(
                      currentVideoList[currentIndex]);
                }
              }),
        ];
      },
    );
  }

  List<PopupMenuItem> playbackSpeedItems = [
    PopupMenuItem<double>(
      value: 0.25,
      child: const Text("0.25"),
      onTap: () {
        changeSpeedTo(0.25);
      },
    ),
    PopupMenuItem<double>(
      value: 0.50,
      child: const Text("0.50"),
      onTap: () {
        changeSpeedTo(0.5);
      },
    ),
    PopupMenuItem<double>(
      value: 0.75,
      child: const Text("0.75"),
      onTap: () {
        changeSpeedTo(0.75);
      },
    ),
    PopupMenuItem<double>(
      value: 1.0,
      child: const Text("Normal"),
      onTap: () {
        changeSpeedTo(1);
      },
    ),
    PopupMenuItem<double>(
      value: 1.25,
      child: const Text("1.25"),
      onTap: () {
        changeSpeedTo(1.25);
      },
    ),
    PopupMenuItem<double>(
      value: 1.5,
      child: const Text("1.5"),
      onTap: () {
        changeSpeedTo(1.5);
      },
    ),
    PopupMenuItem<double>(
      value: 1.5,
      child: const Text("1.75"),
      onTap: () {
        changeSpeedTo(1.75);
      },
    )
  ];

  Widget playbackSpeedMenu() {
    return PopupMenuButton(
      child: const Text("Playback Speeds"),
      itemBuilder: (BuildContext context) {
        Navigator.pop(context);
        return playbackSpeedItems;
      },
    );
  }
}
