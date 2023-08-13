import 'package:flutter/material.dart';
import 'package:vodio_player/widgets/on_screen_widgets/snackbar_helper.dart';

import '../../model/video_model.dart';
import '../../widgets/custom_widgets/thumbnail_widget.dart';
import '../database_functions/playlist_database_funtions.dart';
import '../storage_functions/initial_functions.dart';

ValueNotifier<String> errorNotifier = ValueNotifier('');

class Dialogs extends ChangeNotifier {
  void createPlaylistDialog(context) {
    TextEditingController controller = TextEditingController();
    bool showError = false;
    showDialog(
        context: context,
        builder: (BuildContext context) => ValueListenableBuilder(
              valueListenable: errorNotifier,
              builder: (context, value, _) => AlertDialog(
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: 'Enter playlist name',
                      errorText: showError ? value : null),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Maybr Later")),
                  ElevatedButton(
                      onPressed: () async {
                        if (!(await PlaylistFuntions()
                            .containsPlaylist(controller.text.trim()))) {
                          if (controller.text == '') {
                            showError = true;
                            errorNotifier.value = "Name can't be empty";
                            errorNotifier.notifyListeners();
                          } else {
                            showError = false;
                            await PlaylistFuntions()
                                .createPlaylist(controller.text.trim())
                                .then((value) => Navigator.of(context).pop());
                          }
                        } else {
                          showError = true;
                          errorNotifier.value =
                              "Name already exists in playlist !!\nTry another name";
                          //code to snack
                          errorNotifier.notifyListeners();
                        }
                      },
                      child: const Text("Create"))
                ],
              ),
            ));
  }

  addVideoInPlaylist(
      context, String targetPlaylistName, List<VideoModel> currentItems) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Please Select Videos"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: videoList.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (builder, index) => ListTile(
                        leading: SizedBox(
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: FutureBuilder(
                                future: ThumbnailWidget()
                                    .thumbnailImage(videoList[index].videoPath),
                                builder: (builder, snapshot) => snapshot.hasData
                                    ? snapshot.data!
                                    : const CircularProgressIndicator()),
                          ),
                        ),
                        enabled: !(containsInPlaylist(
                            videoList[index].videoPath, currentItems)),
                        title: Text(
                          videoList[index].videoName,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          PlaylistFuntions().addVideoToPlaylist(
                              targetPlaylistName, videoList[index]);
                        })),
              ),
            ));
  }

  addVideoToPlaylist(context, VideoModel currentVideoModel) {
    PlaylistFuntions().getPlaylistFromDB();
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Maybe Later"))
              ],
              title: const Text("Please select a playlist"),
              content: SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.sizeOf(context).height / 3,
                  child: playlistNotifier.value.isNotEmpty
                      ? ListView.separated(
                          itemBuilder: (BuildContext context, index) =>
                              ListTile(
                                  enabled: !(containsInPlaylist(
                                      currentVideoModel.videoPath,
                                      playlistNotifier
                                          .value[index].playlistItem)),
                                  leading: (containsInPlaylist(
                                          currentVideoModel.videoPath,
                                          playlistNotifier
                                              .value[index].playlistItem))
                                      ? const Icon(Icons.playlist_add_check)
                                      : const Icon(Icons.playlist_add_rounded),
                                  title: Text(playlistNotifier
                                      .value[index].playlistName),
                                  onTap: () {
                                    Navigator.pop(context);
                                    PlaylistFuntions().addVideoToPlaylist(
                                        playlistNotifier
                                            .value[index].playlistName,
                                        currentVideoModel);
                                    SnackBarhelper.snack(context,
                                        "Video added to ${playlistNotifier.value[index].playlistName}");
                                  }),
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: playlistNotifier.value.length)
                      : Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                createPlaylistDialog(context);
                              },
                              child: const Text("Create New Playlist")),
                        )),
            ));
  }

  bool containsInPlaylist(String currentPath, List<VideoModel> currentList) {
    for (final currentModel in currentList) {
      if (currentModel.videoPath == currentPath) {
        return true;
      }
    }
    return false;
  }

  editPlaylistName(context, String currentName, List<VideoModel> currentList,
      int indexInDB) {
    TextEditingController controller = TextEditingController();
    controller.value = TextEditingValue(text: currentName);

    final GlobalKey<State> dialogKey = GlobalKey<State>();
    bool showError = false;
    showDialog(
        context: context,
        builder: (BuildContext context) => ValueListenableBuilder(
              valueListenable: errorNotifier,
              builder: (context, value, _) => AlertDialog(
                key: dialogKey,
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: 'Enter playlist name',
                      errorText: showError ? value : null),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Maybr Later")),
                  ElevatedButton(
                      onPressed: () async {
                        if (controller.text.trim() == currentName) {
                          showError = true;
                          errorNotifier.value = "It's the same name";
                          errorNotifier.notifyListeners();
                        } else if (!(await PlaylistFuntions()
                            .containsPlaylist(controller.text.trim()))) {
                          if (controller.text == '') {
                            showError = true;
                            errorNotifier.value = "Name can't be empty";
                            errorNotifier.notifyListeners();
                          } else {
                            showError = false;

                            PlaylistFuntions().editPlaylistName(currentName,
                                controller.text.trim(), currentList, indexInDB);

                            Navigator.pop(dialogKey.currentContext!);
                          }
                        } else {
                          showError = true;
                          errorNotifier.value =
                              "Name already exists in playlist !!\nTry another name";
                          //code to snack
                          errorNotifier.notifyListeners();
                        }
                      },
                      child: const Text("Create"))
                ],
              ),
            ));
  }
}
