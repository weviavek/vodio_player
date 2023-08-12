import 'package:flutter/material.dart';
import '../../functions/storage_functions/initial_functions.dart';
import '../settings_screen/settings_page.dart';
import 'all_video_list.dart';
import 'favorites_list.dart';
import 'folder_list.dart';

class HomeScreenItem {
  static List<Widget> get homeScreenItems {
    videoList = videoList.toSet().toList();
    return [
      folderList(),
      const AllVideoList(),
      const FavoritesList(),
      const SettingsPage()
    ];
  }

  static Widget currentView(int index) {
    return homeScreenItems[index];
  }
}
