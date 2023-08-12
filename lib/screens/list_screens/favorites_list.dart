import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../functions/database_functions/database_functions.dart';
import '../../model/video_model.dart';
import '../../we_player/video_player.dart';
import '../../we_player/we_player.dart';
import '../../widgets/animations/empty_animation.dart';
import '../../widgets/custom_widgets/custom_listtile.dart';
import '../../widgets/custom_widgets/thumbnail_widget.dart';
import '../../widgets/on_screen_widgets/show_dialog.dart';
import '../main_screens/home_screen.dart';
import 'search_screen.dart';
import '../../we_player/floating_video_player.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({super.key});

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  @override
  Widget build(BuildContext context) {
    DatabaseFunctions.getAllVideos();
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.favorite),
          title: const Text("Favorites"),
          actions: [
            IconButton(
                onPressed: () {
                  currentVideoList = favoriteNotifier.value;

                  showSearch(context: context, delegate: SearchScreen());
                },
                icon: const FaIcon(
                  FontAwesomeIcons.binoculars,
                  color: Colors.white,
                )),
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: favoriteNotifier,
            builder: (context, List<VideoModel> list, index) => list.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: ListView.separated(
                        itemBuilder: (context, index) => CustomListTile(
                              leading: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Stack(children: [
                                  SizedBox(
                                    height: 80,
                                    width: 120,
                                    child: FutureBuilder(
                                        future: ThumbnailWidget()
                                            .thumbnailImage(
                                                list[index].videoPath),
                                        builder: (builder, snapshot) => snapshot
                                                .hasData
                                            ? snapshot.data!
                                            : const CircularProgressIndicator()),
                                  ),
                                  const SizedBox(
                                    height: 80,
                                    width: 120,
                                    child: Center(
                                      child: Icon(Icons.play_circle_fill,
                                          color: Colors.white, size: 30),
                                    ),
                                  )
                                ]),
                              ),
                              title: Text(
                                list[index].videoName,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subTitle: Text(list[index].videoSize),
                              trailing: IconButton(
                                  onPressed: () {
                                    if (isVideoFloating) {
                                      WEPlayerState.removeOverlay();
                                    }
                                    currentIndex = index;
                                    currentVideoList = list;
                                    ShowFileMenuState().showFileMenu(
                                        context, list[index], null, context);
                                  },
                                  icon: const Icon(Icons.more_vert)),
                              onTap: () {
                                currentRouteName = '/home';
                                currentIndex = index;
                                currentVideoList = list;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => Videoplayer(
                                              currentIndex: currentIndex,
                                              currentList: currentVideoList,
                                            )));
                              },
                            ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: list.length),
                  )
                :const EmptyScreen(
                    pageName: "Favorites",
                  )));
  }
}
