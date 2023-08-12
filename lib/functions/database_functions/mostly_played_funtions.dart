import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/mostly_played_model.dart';
import '../../model/video_model.dart';
import '../sorting/sorting_functions.dart';

ValueNotifier<List<MostlyPlayedModel>> mostlyPlayedNotifier = ValueNotifier([]);

class MostlyPlayedFunctions extends ChangeNotifier {
  Future addNewVideo(VideoModel currentVideoModel) async {
    final currentMPM = MostlyPlayedModel(
      currentVideoModel,
      1,
    );
    final mostlyPlayedDB =
        await Hive.openBox<MostlyPlayedModel>("mostlyplayed");
    int id = await mostlyPlayedDB.add(currentMPM);
    mostlyPlayedDB.put(id, currentMPM);
    getMostlyPlayedVideosFromDB();
  }

  getMostlyPlayedVideosFromDB() async {
    final mostlyPlayedDB =
        await Hive.openBox<MostlyPlayedModel>("mostlyplayed");
    mostlyPlayedNotifier.value.clear();
    mostlyPlayedNotifier.value.addAll(mostlyPlayedDB.values);

    mostlyPlayedNotifier.value =
        SortingFunctions.sortMostPlayedFisrt(mostlyPlayedNotifier.value);
    mostlyPlayedNotifier.notifyListeners();
  }

  Future<bool> checkIfVideoPlayingFirstTime(
      VideoModel currentVideoModel) async {
    final mostlyPlayedDB =
        await Hive.openBox<MostlyPlayedModel>("mostlyplayed");
    for (final currentModelInDB in mostlyPlayedDB.values) {
      if (currentModelInDB.videoModel.videoPath ==
          currentVideoModel.videoPath) {
        return false;
      }
    }
    return true;
  }

  addToMostlyPlayed(VideoModel currentVideoModel) async {
    if (await checkIfVideoPlayingFirstTime(currentVideoModel)) {
      await addNewVideo(currentVideoModel);
    } else {
      final mostlyPlayedDB =
          await Hive.openBox<MostlyPlayedModel>("mostlyplayed");
      int i = 0;
      for (final currentModelInDB in mostlyPlayedDB.values) {
        if (currentVideoModel.videoPath ==
            currentModelInDB.videoModel.videoPath) {
          final MostlyPlayedModel tempModel = MostlyPlayedModel(
              currentModelInDB.videoModel, currentModelInDB.count + 1);
          mostlyPlayedDB.putAt(i, tempModel);
        }
        i++;
      }
      getMostlyPlayedVideosFromDB();
    }
  }
}
