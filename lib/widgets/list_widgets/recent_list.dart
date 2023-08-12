import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../functions/database_functions/database_functions.dart';
import '../../model/video_model.dart';
import '../../screens/main_screens/home_screen.dart';
import '../../we_player/video_player.dart';
import '../custom_widgets/custom_icons.dart';

class RecentList {
  static List<Widget>? recentList() {
    if (recentNotifier.value.isNotEmpty) {
      List<Widget> recentListItems = [
        Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Text(
                "Recently Played List",
                style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 47, 69, 80),
                    shadows: shadowValue),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.find_replace_outlined,
                    size: 25,
                    color: const Color.fromARGB(255, 47, 69, 80),
                    shadows: shadowValue),
              )
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ValueListenableBuilder(
              valueListenable: recentNotifier,
              builder: (context, List<VideoModel> recentListReversed, child) {
                List<VideoModel> recentList =
                    recentListReversed.reversed.toList();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        recentList.length <= 10 ? recentList.length + 1 : 11,
                    itemBuilder: (bulder, index) {
                      return index < recentList.length&&index!=10
                          ? GestureDetector(
                              onTap: () {
                                DatabaseFunctions.addToRecent(
                                    recentList[index]);
                                currentIndex = index;
                                currentVideoList = recentList;

                                currentRouteName = '/home';
                                Navigator.pushNamed(context, '/videoplayer');
                              },
                              onLongPress: () =>
                                  DatabaseFunctions.removeFromRecent(
                                      recentList[index]),
                              child: Stack(children: [
                                SizedBox(
                                  width: 110,
                                  height: 150,
                                  child: FutureBuilder(
                                    future: getApplicationDocumentsDirectory(),
                                    builder: (context, thumPath) =>
                                        thumPath.hasData &&
                                                thumPath.data?.path != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.file(
                                                  File(
                                                      "${thumPath.data!.path}/${recentList[index].videoPath.split("/").last.replaceAll('.mp4', '.jpg')}"),
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : const Icon(Icons.video_file),
                                  ),
                                ),
                                SizedBox(
                                    width: 110,
                                    height: 150,
                                    child: Center(
                                      child: Icon(Icons.play_circle,
                                          color: Colors.white,
                                          size: 45,
                                          shadows: shadowValue),
                                    ))
                              ]),
                            )
                          : SizedBox(
                              width: 90,
                              height: 150,
                              child: GestureDetector(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.history_toggle_off,
                                        size: 40,
                                        shadows: shadowValue,
                                        color: const Color.fromARGB(
                                            255, 47, 69, 80),
                                      ),
                                      Text(
                                        "History",
                                        style: TextStyle(
                                            shadows: shadowValue,
                                            color: const Color.fromARGB(
                                                255, 47, 69, 80)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, '/history');
                                },
                              ),
                            );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Icon(Icons.list_rounded,
                  size: 30,
                  color: const Color.fromARGB(255, 47, 69, 80),
                  shadows: shadowValue),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  "All Videos",
                  style: TextStyle(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 47, 69, 80),
                      shadows: shadowValue),
                ),
              ),
            ],
          ),
        ),
      ];
      
      return recentListItems;
    }
    return null;
  }
}
