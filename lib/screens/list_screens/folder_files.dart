import 'package:flutter/material.dart';

import '../../model/video_model.dart';
import '../../we_player/video_player.dart';
import '../../widgets/custom_widgets/custom_listtile.dart';
import '../../widgets/custom_widgets/thumbnail_widget.dart';
import '../../widgets/on_screen_widgets/show_dialog.dart';
import '../main_screens/home_screen.dart';

class FolderFiles extends StatelessWidget {
  const FolderFiles({super.key, required this.videos, required this.title});
  final List<VideoModel> videos;
  final String title;

  @override
  Widget build(BuildContext context) {
    floatingContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: ListView.separated(
            itemBuilder: (context, index) => CustomListTile(
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Stack(children: [
                    SizedBox(
                      height: 90,
                      width: 120,
                      child: FutureBuilder(
                          future: ThumbnailWidget()
                              .thumbnailImage(videos[index].videoPath),
                          builder: (builder, snapshot) => snapshot.hasData
                              ? snapshot.data!
                              : const CircularProgressIndicator()),
                    ),
                    const SizedBox(
                      height: 90,
                      width: 120,
                      child: Center(
                        child: Icon(Icons.play_circle_fill,
                            color: Colors.white, size: 30),
                      ),
                    )
                  ]),
                ),
                title: Text(
                  videos[index].videoName,
                  overflow: TextOverflow.ellipsis,
                ),
                subTitle: Text(videos[index].videoSize),
                trailing: IconButton(
                    onPressed: () {
                      currentIndex = index;
                      currentVideoList = videos;
                      ShowFileMenuState()
                          .showFileMenu(context, videos[index], null, context);
                    },
                    icon: const Icon(Icons.more_vert)),
                onTap: () {
                  currentIndex = index;
                  currentVideoList = videos;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => Videoplayer(
                                currentIndex: currentIndex,
                                currentList: currentVideoList,
                              )));
                }),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: videos.length),
      ),
    );
  }
}
