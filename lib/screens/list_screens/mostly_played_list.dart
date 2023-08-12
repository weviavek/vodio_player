import 'package:flutter/material.dart';

import '../../functions/database_functions/mostly_played_funtions.dart';
import '../../model/mostly_played_model.dart';
import '../../model/video_model.dart';
import '../../widgets/custom_widgets/custom_listtile.dart';
import '../../widgets/custom_widgets/thumbnail_widget.dart';
import '../main_screens/home_screen.dart';

class MostlyPlayedPage extends StatefulWidget {
  const MostlyPlayedPage({super.key});

  @override
  State<MostlyPlayedPage> createState() => _MostlyPlayedPageState();
}

class _MostlyPlayedPageState extends State<MostlyPlayedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mostly Played Videos"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: ValueListenableBuilder(
            valueListenable: mostlyPlayedNotifier,
            builder: (context, value, child) => ListView.separated(
                itemBuilder: (itemBuilder, index) => CustomListTile(
                      trailing: const SizedBox(),
                      leading: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Stack(children: [
                          SizedBox(
                            height: 80,
                            width: 130,
                            child: FutureBuilder(
                                future: ThumbnailWidget().thumbnailImage(
                                    value[index].videoModel.videoPath),
                                builder: (builder, snapshot) => snapshot.hasData
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
                        value[index].videoModel.videoName,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subTitle: Text("${value[index].count} Times played"),
                      onTap: () {
                        List<VideoModel> tempListFromMostlyPlayed = [];
                        for (MostlyPlayedModel currentModel in value) {
                          tempListFromMostlyPlayed.add(currentModel.videoModel);
                        }
                        currentVideoList = tempListFromMostlyPlayed;
                        currentIndex = index;
                        Navigator.pushNamed(context, '/videoplayer');
                      },
                    ),
                separatorBuilder: (_, __) => const Divider(),
                itemCount: value.length)),
      ),
    );
  }
}
