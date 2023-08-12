import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vodio_player/widgets/on_screen_widgets/details_show.dart';

import '../../functions/database_functions/database_functions.dart';
import '../../functions/dialogs/daialog_functions.dart';
import '../../model/video_model.dart';
import '../../we_player/floating_video_player.dart';
import '../../we_player/we_player.dart';
import 'snackbar_helper.dart';

late double width;
late OverlayEntry closeEntry;

late OverlayEntry entry;
bool entryIsInitialized = false;
Offset offset = const Offset(40, 20);

class ShowFileMenu extends StatefulWidget {
  const ShowFileMenu({
    super.key,
    required this.currentList,
  });
  final List<VideoModel> currentList;

  @override
  State<ShowFileMenu> createState() => ShowFileMenuState();
}

class ShowFileMenuState extends State<ShowFileMenu> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Future<void> showFileMenu(context, VideoModel currentVideoModel,
      Duration? startAt, BuildContext snakContext) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: AlertDialog(
              content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.picture_in_picture_alt_rounded),
                  title: const Text("Play on floating Screen"),
                  onTap: () {
                    //Route to floating player
                    Navigator.pop(context);
                    currentVideoPlayerController = VideoPlayerController.file(
                        File(currentVideoModel.videoPath));

                    WEPlayerState().overlayFunction(
                        startAt, currentVideoPlayerController!);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.playlist_add_rounded),
                  title: const Text("Add to playlist"),
                  onTap: () {
                    Navigator.pop(context);
                    Dialogs().addVideoToPlaylist(context, currentVideoModel);
                  },
                ),
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.favorite_border_rounded),
                    title: DatabaseFunctions.containsInFavorites(
                            currentVideoModel.videoPath)
                        ? const Text('Remove From Favorites')
                        : const Text('Add to Favorites'),
                    onTap: () async {
                      Navigator.pop(context);
                      if (DatabaseFunctions.containsInFavorites(
                          currentVideoModel.videoPath)) {
                        DatabaseFunctions.removeFromFav(currentVideoModel);
                        SnackBarhelper.snack(snakContext,
                            "${currentVideoModel.videoName} removed from favorites");
                      } else {
                        await DatabaseFunctions.addFavorites(currentVideoModel)
                            ? SnackBarhelper.snack(snakContext,
                                "${currentVideoModel.videoName} added favorites")
                            : SnackBarhelper.snack(snakContext,
                                "${currentVideoModel.videoName} already in favorites");
                      }
                    }),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('Details'),
                  onTap: () {
                    Navigator.pop(context);
                    ShowDetails.showDetailsDialog(currentVideoModel, context);
                  },
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}
