import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import '../model/video_model.dart';
import '../notifiers/notifiers.dart';
import 'floating_video_player.dart';
import 'we_player.dart';

String currentRouteName = '';

ValueNotifier<bool> buildVideoPlayerNotifier = ValueNotifier(false);

class Videoplayer extends StatefulWidget {
  final List<VideoModel> currentList;
  final int currentIndex;
  const Videoplayer(
      {super.key, required this.currentIndex, required this.currentList});

  @override
  State<Videoplayer> createState() => VideoplayerState();
}

ValueNotifier<bool> timerNotifier = ValueNotifier(true);
bool canDispose = true;

class VideoplayerState extends State<Videoplayer> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    canDispose = true;
    _videoPlayerController = VideoPlayerController.file(
        File(widget.currentList[widget.currentIndex].videoPath));

    buildVideoPlayerNotifier.value = false;
    //initTemo();
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  initTemo() async {
    await _videoPlayerController!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    _videoPlayerController!.initialize().then((value) {
      buildVideoPlayerNotifier.value = true;
      Notifier.notifyVideoPlayer();
    });
    return ValueListenableBuilder(
      valueListenable: buildVideoPlayerNotifier,
      builder: (context, value, child) =>
          value && _videoPlayerController != null
              ? WEPlayer(controller: _videoPlayerController!)
              : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (canDispose) {
      currentVideoPlayerController!.pause();

      _videoPlayerController!.dispose();
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    Wakelock.disable();
    super.dispose();
  }
}
