import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video_player.dart';
import 'we_player.dart';

VideoPlayerController? currentVideoPlayerController;
bool currentIsDisposed = false;

bool isVideoFloating = false;

class FloatingVideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController currentController;
  const FloatingVideoPlayerWidget({
    super.key,
    required this.currentController,
  });

  @override
  FloatingVideoPlayerWidgetState createState() =>
      FloatingVideoPlayerWidgetState();
}

class FloatingVideoPlayerWidgetState extends State<FloatingVideoPlayerWidget> {
  Icon centerIcon = const Icon(
    Icons.pause,
    color: Colors.white,
  );
  @override
  void initState() {
    currentVideoPlayerController = widget.currentController;
    if (!(currentVideoPlayerController!.value.isInitialized)) {
      currentVideoPlayerController!.initialize().then((value) {
        currentVideoPlayerController!.play();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isVideoFloating = true;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentVideoPlayerController!.value.isPlaying
              ? currentVideoPlayerController!.pause()
              : currentVideoPlayerController!.play();
        });
      },
      child: Stack(children: [
        VideoPlayer(currentVideoPlayerController!),
        Align(
          alignment: Alignment.topRight,
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              onPressed: () {
                WEPlayerState.removeOverlay();
                currentVideoPlayerController!.pause();
              },
              icon: const Icon(Icons.close_rounded),
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: ValueListenableBuilder(
              valueListenable: currentVideoPlayerController!,
              builder: (_, value, __) {
                if (value.position == value.duration) {
                  return const Icon(
                    Icons.replay,
                    color: Colors.white,
                  );
                }
                if (value.isPlaying) {
                  return const Icon(
                    Icons.pause,
                    color: Colors.white,
                  );
                } else {
                  return const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  );
                }
              }),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              onPressed: () {
                canDispose = true;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => WEPlayer(
                              controller: currentVideoPlayerController!,
                              startAt:
                                  currentVideoPlayerController!.value.position,
                            )));
                WEPlayerState.removeOverlay();
              },
              icon: const Icon(Icons.fullscreen),
              color: Colors.white,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
                colors: const VideoProgressColors(playedColor: Colors.purple),
                currentVideoPlayerController!,
                allowScrubbing: true))
      ]),
    );
  }
}
