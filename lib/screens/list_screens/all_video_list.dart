import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../functions/database_functions/database_functions.dart';
import '../../functions/database_functions/mostly_played_funtions.dart';
import '../../functions/sorting/sorting_functions.dart';
import '../../functions/storage_functions/initial_functions.dart';
import '../../we_player/floating_video_player.dart';
import '../../we_player/video_player.dart';
import '../../we_player/we_player.dart';
import '../../widgets/animations/empty_animation.dart';
import '../../widgets/animations/mini_loading_animation.dart';
import '../../widgets/custom_widgets/custom_icons.dart';
import '../../widgets/custom_widgets/custom_listtile.dart';
import '../../widgets/custom_widgets/thumbnail_widget.dart';
import '../../widgets/list_widgets/recent_list.dart';
import '../../widgets/on_screen_widgets/show_dialog.dart';
import '../main_screens/home_screen.dart';
import 'search_screen.dart';

class AllVideoList extends StatefulWidget {
  const AllVideoList({super.key});

  @override
  State<AllVideoList> createState() => AllVideoListState();
}

class AllVideoListState extends State<AllVideoList> {

  int listCount =videoList.length<15?videoList.length:15;
  ScrollController scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
     

      setState(() {
         listCount = listCount + 5 >= videoList.length
          ? videoList.length
          : listCount + 5;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    floatingContext = context;
    DatabaseFunctions.getRecentVideos();
    return Scaffold(
        appBar: AppBar(
          leading: const Center(child: FaIcon(FontAwesomeIcons.video)),
          title: const Text("Video List"),
          actions: [
            PopupMenuButton(
                icon: const Icon(CustomIcon.sortAmountDown),
                itemBuilder: (itemBuilder) => [
                      PopupMenuItem(
                        child: const Text("Name A to Z"),
                        onTap: () => setState(() {
                          videoList = SortingFunctions()
                              .mergeSortByNameAtoZ(videoList, null);
                        }),
                      ),
                      PopupMenuItem(
                        child: const Text("Name Z to A"),
                        onTap: () => setState(() {
                          videoList = SortingFunctions()
                              .mergeSortByNameAtoZ(videoList, true);
                        }),
                      ),
                      PopupMenuItem(
                        child: const Text("Size Small to Large"),
                        onTap: () => setState(() {
                          videoList = SortingFunctions()
                              .mergeSortBySizeStoL(videoList, null);
                        }),
                      ),
                      PopupMenuItem(
                        child: const Text("Size Large to Small"),
                        onTap: () => setState(() {
                          videoList = SortingFunctions()
                              .mergeSortBySizeStoL(videoList, true);
                        }),
                      )
                    ]),
            IconButton(
                onPressed: () {
                  currentVideoList = videoList;

                  showSearch(context: context, delegate: SearchScreen());
                },
                icon: const FaIcon(
                  FontAwesomeIcons.binoculars,
                  color: Colors.white,
                ))
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: allVideoNorifier,
            builder: (context, value, child) => videoList.isNotEmpty
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: <Widget>[
                        ...?RecentList.recentList(),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: recentNotifier.value.isEmpty
                                ? const Radius.circular(0)
                                : const Radius.circular(25),
                            topRight: recentNotifier.value.isEmpty
                                ? const Radius.circular(0)
                                : const Radius.circular(25),
                          ),
                          child: ColoredBox(
                            color: const Color.fromARGB(255, 184, 219, 217),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 25.0, bottom: 25),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: listCount != videoList.length
                                      ? listCount + 1
                                      : listCount,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 12.0, right: 12),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 2, bottom: 2),
                                          child: Divider(
                                            color:
                                                Color.fromARGB(255, 47, 69, 80),
                                          ),
                                        ),
                                      ),
                                  itemBuilder: (context, index) {
                                    if (index == listCount) {
                                      if (listCount != videoList.length) {
                                        return const SizedBox(
                                            height: 80, child: MiniLoading());
                                      } else {
                                        return Container();
                                      }
                                    }
                                    return CustomListTile(
                                        leading: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Stack(children: [
                                            SizedBox(
                                              height: 80,
                                              width: 130,
                                              child: FutureBuilder(
                                                  future: ThumbnailWidget()
                                                      .thumbnailImage(
                                                          videoList[index]
                                                              .videoPath),
                                                  builder: (builder,
                                                          snapshot) =>
                                                      snapshot.hasData
                                                          ? snapshot.data!
                                                          : const CircularProgressIndicator()),
                                            ),
                                            const SizedBox(
                                              height: 80,
                                              width: 130,
                                              child: Center(
                                                child: Icon(
                                                    Icons.play_circle_fill,
                                                    color: Colors.white,
                                                    size: 30),
                                              ),
                                            )
                                          ]),
                                        ),
                                        title: Text(
                                          videoList[index].videoName,
                                          overflow: TextOverflow.ellipsis,
                                          style: listTileTitleText,
                                        ),
                                        subTitle: Text(
                                          videoList[index].videoSize,
                                          style: listTileSubTitleText,
                                        ),
                                        onTap: () {
                                          MostlyPlayedFunctions()
                                              .addToMostlyPlayed(videoList[index]);
                                          if (isVideoFloating) {
                                            WEPlayerState.removeOverlay();
                                          }
                                          DatabaseFunctions.addToRecent(
                                              videoList[index]);
                                          currentIndex = index;
                                          currentVideoList = videoList;

                                          currentRouteName = '/home';
                                          Navigator.pushNamed(
                                              context, "/videoplayer");
                                        },
                                        trailing: IconButton(
                                            onPressed: () {
                                              currentIndex = index;
                                              currentVideoList = videoList;
                                              ShowFileMenuState().showFileMenu(
                                                  context,
                                                  videoList[index],
                                                  null,
                                                  context);
                                            },
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                            )));
                                  }),
                            ),
                          ),
                        ),
                        _isLoading && videoList.length != videoList.length
                            ? const Center(
                                child: SizedBox(
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    )))
                            : Container()
                      ],
                    ),
                  )
                : const EmptyScreen(
                    pageName: "List",
                  )));
  }
}
