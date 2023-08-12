import 'package:flutter/material.dart';
import '../../functions/database_functions/database_functions.dart';
import '../../functions/database_functions/mostly_played_funtions.dart';
import '../../model/video_model.dart';
import '../../we_player/video_player.dart';
import '../../widgets/animations/empty_animation.dart';
import '../../widgets/custom_widgets/custom_listtile.dart';
import '../../widgets/custom_widgets/thumbnail_widget.dart';
import '../main_screens/home_screen.dart';

class ViewedVideosHistory extends StatelessWidget {
  const ViewedVideosHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("History"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: ValueListenableBuilder(
              valueListenable: recentNotifier,
              builder: (context, List<VideoModel> historyList, child) {
                List<VideoModel> tempHistoryList =
                    historyList.reversed.toList();
                return tempHistoryList.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) => CustomListTile(
                              trailing: const SizedBox(),
                              subTitle: Text(tempHistoryList[index].videoSize),
                              leading: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Stack(children: [
                                  SizedBox(
                                    height: 80,
                                    width: 130,
                                    child: FutureBuilder(
                                        future: ThumbnailWidget()
                                            .thumbnailImage(
                                                tempHistoryList[index]
                                                    .videoPath),
                                        builder: (builder, snapshot) => snapshot
                                                .hasData
                                            ? snapshot.data!
                                            : const CircularProgressIndicator()),
                                  ),
                                  const SizedBox(
                                    height: 80,
                                    width: 130,
                                    child: Center(
                                      child: Icon(Icons.play_circle_fill,
                                          color: Colors.white, size: 30),
                                    ),
                                  )
                                ]),
                              ),
                              title: Text(
                                tempHistoryList[index].videoName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 17),
                              ),
                              onTap: () {
                                currentIndex = index;
                                currentVideoList = tempHistoryList;
                                MostlyPlayedFunctions()
                                              .addToMostlyPlayed(currentVideoList[currentIndex]);
                          DatabaseFunctions.addToRecent(currentVideoList[currentIndex]);

                                currentRouteName = '/history';
                                Navigator.pushNamed(context, '/videoplayer');
                              },
                            ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: tempHistoryList.length)
                    :const EmptyScreen(
                        pageName: "History",
                      );
              }),
        ));
  }
}
