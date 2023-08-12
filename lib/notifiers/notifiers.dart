
import 'package:flutter/material.dart';

import '../functions/database_functions/mostly_played_funtions.dart';
import '../screens/list_screens/folder_list.dart';
import '../screens/main_screens/first_page.dart';
import '../we_player/video_player.dart';

class Notifier extends ChangeNotifier {
  static notifyTimer() {
    timerNotifier.notifyListeners();
  }

  static notifyVideoPlayer() {
    buildVideoPlayerNotifier.notifyListeners();
  }

  static notifyFolders() {
    folderNotifier.notifyListeners();
  }

  static notifyMostlyplayed() {
    mostlyPlayedNotifier.notifyListeners();
  }

  static notifyFirstScreen() {
    firstScreenNotifier.notifyListeners();
  }
}
