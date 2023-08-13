import 'package:flutter/material.dart';
import '../../functions/database_functions/database_functions.dart';
import '../../model/video_model.dart';
import '../../we_player/floating_video_player.dart';
import '../../we_player/video_player.dart';
import '../../we_player/we_player.dart';
import '../../widgets/animations/not_found.dart';
import '../../widgets/custom_widgets/thumbnail_widget.dart';
import '../../widgets/on_screen_widgets/show_dialog.dart';
import '../main_screens/home_screen.dart';

class SearchScreen extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: query == '' ? Container() : const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<VideoModel> matchItem = [];
    for (var item in currentVideoList) {
      if (item.videoName.toLowerCase().contains(query.toLowerCase())) {
        matchItem.add(item);
      }
    }
    return matchItem.isNotEmpty
        ? ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      height: 60,
                      width: 90,
                      child: FutureBuilder(
                          future: ThumbnailWidget()
                              .thumbnailImage(matchItem[index].videoPath),
                          builder: (builder, snapshot) => snapshot.hasData
                              ? snapshot.data!
                              : const CircularProgressIndicator()),
                    ),
                  ),
                  title: Text(
                    currentVideoList[index].videoName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(currentVideoList[index].videoSize),
                  trailing: IconButton(
                      onPressed: () => ShowFileMenuState().showFileMenu(
                          context, currentVideoList[index], null, context),
                      icon: const Icon(Icons.more_vert)),
                  onTap: () {
                    currentRouteName = '/home';
                    if (isVideoFloating) {
                      WEPlayerState.removeOverlay();
                    }
                    DatabaseFunctions.addToRecent(currentVideoList[index]);
                    currentIndex = index;
                    currentVideoList = currentVideoList;
                    Navigator.pushNamed(context, "/videoplayer");
                  },
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: currentVideoList.length)
        :const NotFoundScreen();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<VideoModel> matchItem = [];
    for (var item in currentVideoList) {
      if (item.videoName.toLowerCase().startsWith(query.toLowerCase())) {
        matchItem.add(item);
      }
    }
    return Padding(
        padding: const EdgeInsets.only(top: 12),
        child:query.isEmpty?ListView.separated(
                itemBuilder: (context, index) => ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          height: 60,
                          width: 90,
                          child: FutureBuilder(
                              future: ThumbnailWidget()
                                  .thumbnailImage(currentVideoList[index].videoPath),
                              builder: (builder, snapshot) => snapshot.hasData
                                  ? snapshot.data!
                                  : const CircularProgressIndicator()),
                        ),
                      ),
                      title: Text(
                        matchItem[index].videoName,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        currentRouteName = '/home';
                        if (isVideoFloating) {
                          WEPlayerState.removeOverlay();
                        }
                        DatabaseFunctions.addToRecent(matchItem[index]);
                        currentIndex = index;
                        currentVideoList = matchItem;
                        Navigator.pushNamed(context, "/videoplayer");
                      },
                    ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: matchItem.length): matchItem.isEmpty
            ? ListView.separated(
                itemBuilder: (context, index) => ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          height: 60,
                          width: 90,
                          child: FutureBuilder(
                              future: ThumbnailWidget()
                                  .thumbnailImage(matchItem[index].videoPath),
                              builder: (builder, snapshot) => snapshot.hasData
                                  ? snapshot.data!
                                  : const CircularProgressIndicator()),
                        ),
                      ),
                      title: Text(
                        matchItem[index].videoName,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        currentRouteName = '/home';
                        if (isVideoFloating) {
                          WEPlayerState.removeOverlay();
                        }
                        DatabaseFunctions.addToRecent(matchItem[index]);
                        currentIndex = index;
                        currentVideoList = matchItem;
                        Navigator.pushNamed(context, "/videoplayer");
                      },
                    ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: matchItem.length)
            :const NotFoundScreen());
  }
}
