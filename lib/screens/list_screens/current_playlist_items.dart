import 'package:flutter/material.dart';

import '../../functions/database_functions/database_functions.dart';
import '../../functions/database_functions/mostly_played_funtions.dart';
import '../../functions/database_functions/playlist_database_funtions.dart';
import '../../functions/dialogs/daialog_functions.dart';
import '../../functions/dialogs/warning_popups.dart';
import '../../model/video_model.dart';
import '../../we_player/floating_video_player.dart';
import '../../we_player/we_player.dart';
import '../../widgets/animations/empty_animation.dart';
import '../../widgets/custom_widgets/thumbnail_widget.dart';
import '../main_screens/home_screen.dart';

class CurrentPlaylistItem extends StatefulWidget {
  final List<VideoModel> currentPlaylistItems;
  final String currentPlaylistName;
  final int currentPlaylistIndex;
  const CurrentPlaylistItem(
      {super.key,
      required this.currentPlaylistName,
      required this.currentPlaylistItems,
      required this.currentPlaylistIndex});

  @override
  State<CurrentPlaylistItem> createState() => _CurrentPlaylistItemState();
}

class _CurrentPlaylistItemState extends State<CurrentPlaylistItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentPlaylistName),
      ),
      body: ValueListenableBuilder(
          valueListenable: playlistNotifier,
          builder: (context, value, child) => widget
                  .currentPlaylistItems.isEmpty
              ? EmptyScreen(
                  pageName: widget.currentPlaylistName,
                )
              : ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        leading: Stack(children: [
                          SizedBox(
                            height: 60,
                            width: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: FutureBuilder(
                                  future: ThumbnailWidget().thumbnailImage(
                                      value[widget.currentPlaylistIndex]
                                          .playlistItem[index]
                                          .videoPath),
                                  builder: (builder, snapshot) =>
                                      snapshot.hasData
                                          ? snapshot.data!
                                          : const CircularProgressIndicator()),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                            width: 90,
                            child: Center(
                              child: Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ]),
                        title: Text(value[widget.currentPlaylistIndex]
                            .playlistItem[index]
                            .videoName),
                        subtitle: Text(value[widget.currentPlaylistIndex]
                            .playlistItem[index]
                            .videoSize),
                        trailing: IconButton(
                            onPressed: () {
                              WarningPopup.deleteVideoFromPlaylistDialog(
                                  context,
                                  value[widget.currentPlaylistIndex]
                                      .playlistName,
                                  value[widget.currentPlaylistIndex]
                                      .playlistItem[index],
                                  index);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 30,
                            )),
                        onTap: () {
                          MostlyPlayedFunctions()
                                              .addToMostlyPlayed(
                                  value[widget.currentPlaylistIndex]
                                      .playlistItem[index]);
                          if (isVideoFloating) {
                            WEPlayerState.removeOverlay();
                          }
                          DatabaseFunctions.addToRecent(
                              value[widget.currentPlaylistIndex]
                                  .playlistItem[index]);
                          currentIndex = index;
                          currentVideoList =
                              value[widget.currentPlaylistIndex].playlistItem;
                          Navigator.pushNamed(context, "/videoplayer");
                        },
                      ),
                  separatorBuilder: (separatorBuilder, _) => const Divider(),
                  itemCount:
                      value[widget.currentPlaylistIndex].playlistItem.length)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Dialogs().addVideoInPlaylist(
              context, widget.currentPlaylistName, widget.currentPlaylistItems);
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
