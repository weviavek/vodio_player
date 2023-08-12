import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../functions/database_functions/database_functions.dart';
import '../functions/database_functions/mostly_played_funtions.dart';
import '../notifiers/notifiers.dart';
import '../screens/main_screens/home_screen.dart';
import 'custom_video_progress_bar.dart';
import 'floating_video_player.dart';
import 'video_player.dart';
import 'video_player_playback_speed.dart';

Color videoPlayerIconColor = Colors.white;
double videoPlayerIconSize = 25;
bool canBuild = false;

class WEPlayer extends StatefulWidget {
  const WEPlayer({super.key, required this.controller, this.startAt});
  final VideoPlayerController controller;
  final Duration? startAt;

  @override
  State<WEPlayer> createState() => WEPlayerState();
}

class WEPlayerState extends State<WEPlayer> {
  bool canBuildOverlay = true;
  Timer? _timer;
  bool _showButton = true;
  Icon? currentFullScreenIcon;
  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 4), () {
      _showButton = false;
    });
    _showButton = true;
  }

  Color videoPlayerIconColor = Colors.white;
  final double videoPlayerIconSize = 25;
  Icon pauseIcon = const Icon(Icons.pause);
  Icon playIocn = const Icon(Icons.play_arrow);
  Icon replayIcon = const Icon(Icons.replay);
  Icon fullScreenIcon = const Icon(Icons.fullscreen);
  Icon exitFullScreenIcon = const Icon(Icons.fullscreen_exit);

  late double width;

  static late OverlayEntry entry;
  static Offset offset = const Offset(40, 20);
  static ValueNotifier<String> durationNotifier = ValueNotifier('');

  @override
  void initState() {
    _resetTimer();
    currentFullScreenIcon = exitFullScreenIcon;
    canDispose = true;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    Wakelock.enable();

    super.initState();
  }

  // Inside WEPlayerState class
  void _togglePlay() {
    if (currentVideoPlayerController!.value.isPlaying) {
      currentVideoPlayerController!.pause();
    } else {
      currentVideoPlayerController!.play();
    }
  }

  void _toggleFullScreen() {
    setState(() {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        currentFullScreenIcon = exitFullScreenIcon;
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        currentFullScreenIcon = fullScreenIcon;
      }
    });
  }

  String _videoDuration(Duration duration) {
    String durationInString(int value) => value.toString().padLeft(2, '0');
    final hours = durationInString(duration.inHours.remainder(60));
    final minutes = durationInString(duration.inMinutes.remainder(60));
    final seconds = durationInString(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  String _videoLength(Duration duration) {
    String durationInString(int value) => value.toString().padLeft(2, '0');
    final hours = durationInString(duration.inHours.remainder(60));
    final minutes = durationInString(duration.inMinutes.remainder(60));
    final seconds = durationInString(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Wakelock.enable();

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      },
    );

    currentVideoPlayerController = widget.controller;

    currentVideoPlayerController!.play();

    return Material(
      color: Colors.black,
      child: GestureDetector(
        onTap: () {
          if (_showButton) {
            setState(() {
              _showButton = false;
            });
            Notifier.notifyTimer();
            _timer?.cancel();
          } else {
            setState(() {
              _showButton = true;
            });
            _resetTimer();
          }
        },
        child: Stack(children: [
          Center(
            child: AspectRatio(
                aspectRatio: currentVideoPlayerController!.value.aspectRatio,
                child: VideoPlayer(currentVideoPlayerController!)),
          ),
          ValueListenableBuilder(
              valueListenable: timerNotifier,
              builder: (context, value, child) => _showButton
                  ? Stack(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: currentIndex != 0
                                      ? () {
                                          currentIndex--;
                                          MostlyPlayedFunctions()
                                              .addToMostlyPlayed(
                                                  currentVideoList[
                                                      currentIndex]);
                                          DatabaseFunctions.addToRecent(
                                              currentVideoList[currentIndex]);
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/videoplayer',
                                                  (route) => route.isFirst);
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.skip_previous_rounded,
                                    color: videoPlayerIconColor,
                                    size: videoPlayerIconSize,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.sizeOf(context).width / 6,
                                    right:
                                        MediaQuery.sizeOf(context).width / 6),
                                child: IconButton(
                                  onPressed: _togglePlay,
                                  icon: ValueListenableBuilder(
                                      valueListenable:
                                          currentVideoPlayerController!,
                                      builder: (context, value, child) {
                                        if (value.duration == value.position) {
                                          return replayIcon;
                                        } else if (currentVideoPlayerController!
                                            .value.isPlaying) {
                                          return pauseIcon;
                                        } else {
                                          return playIocn;
                                        }
                                      }),
                                  color: videoPlayerIconColor,
                                  iconSize: videoPlayerIconSize,
                                ),
                              ),
                              IconButton(
                                  onPressed: currentVideoList.length >
                                          currentIndex + 1
                                      ? () {
                                          currentIndex++;
                                          MostlyPlayedFunctions()
                                              .addToMostlyPlayed(currentVideoList[currentIndex]);
                          DatabaseFunctions.addToRecent(currentVideoList[currentIndex]);
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/videoplayer',
                                                  currentRouteName == '/home'
                                                      ? (route) => route.isFirst
                                                      : ModalRoute.withName(
                                                          currentRouteName));
                                          Wakelock.enable();
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.skip_next_rounded,
                                    color: videoPlayerIconColor,
                                    size: videoPlayerIconSize,
                                  )),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: IconButton(
                                        icon: ValueListenableBuilder(
                                            valueListenable:
                                                currentVideoPlayerController!,
                                            builder: (context, value, _) =>
                                                value.volume == 0
                                                    ? Icon(
                                                        Icons.volume_off,
                                                        color:
                                                            videoPlayerIconColor,
                                                        size:
                                                            videoPlayerIconSize,
                                                      )
                                                    : Icon(
                                                        Icons.volume_up,
                                                        color:
                                                            videoPlayerIconColor,
                                                        size:
                                                            videoPlayerIconSize,
                                                      )),
                                        onPressed: () {
                                          currentVideoPlayerController!
                                                      .value.volume !=
                                                  0
                                              ? currentVideoPlayerController!
                                                  .setVolume(0)
                                              : currentVideoPlayerController!
                                                  .setVolume(1);
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        onPressed: _toggleFullScreen,
                                        icon: const Icon(
                                            Icons.screen_rotation_outlined),
                                        color: videoPlayerIconColor,
                                        iconSize: videoPlayerIconSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          children: [
                                            ValueListenableBuilder(
                                                valueListenable:
                                                    currentVideoPlayerController!,
                                                builder: (builder, value, _) =>
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Text(
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              decoration:
                                                                  TextDecoration
                                                                      .none),
                                                          _videoDuration(
                                                              value.position)),
                                                    )),
                                            Flexible(
                                              child: SizedBox(
                                                  height: 10,
                                                  child: VideoProgressBar(
                                                      currentVideoPlayerController!,
                                                      barHeight: 5,
                                                      handleHeight: 7,
                                                      drawShadow: false)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Text(
                                                _videoLength(
                                                    currentVideoPlayerController!
                                                        .value.duration),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? 25
                                  : 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: VideoMenu().videoPlayerMenu(context)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? 25
                                  : 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: IconButton(
                                onPressed: () {
                                  canDispose = false;
                                  if (MediaQuery.of(context).orientation ==
                                      Orientation.landscape) {
                                    SystemChrome.setPreferredOrientations(
                                            [DeviceOrientation.portraitUp])
                                        .then((value) {
                                      overlayHelper(context);
                                    });
                                  } else {
                                    overlayHelper(context);
                                  }
                                },
                                icon: const Icon(Icons.picture_in_picture),
                                color: videoPlayerIconColor,
                                iconSize: videoPlayerIconSize,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : const SizedBox()),
        ]),
      ),
    );
  }

  overlayHelper(BuildContext context) {
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (canBuildOverlay) {
          canBuildOverlay = false;
          overlayFunction(currentVideoPlayerController!.value.position,
              currentVideoPlayerController!);
        }
      },
    );
  }

  overlayFunction(
      Duration? startAt, VideoPlayerController currentController) async {
    canBuild = false;
    currentVideoPlayerController = currentController;

    final overlay = Overlay.of(floatingContext!);
    if (!(currentVideoPlayerController!.value.isInitialized)) {
      await currentVideoPlayerController!.initialize().then((value) {
        if (startAt != null) {
          currentVideoPlayerController!.seekTo(startAt);
        }
      });
    } else if (startAt != null) {
      currentVideoPlayerController!.seekTo(startAt);
    }
    entry = OverlayEntry(
        maintainState: true,
        builder: (builder) {
          return Stack(children: <Widget>[
            Positioned(
              top: offset.dy,
              left: offset.dx,
              child: GestureDetector(
                  onPanUpdate: (details) {
                    offset += details.delta;
                    entry.markNeedsBuild();
                  },
                  child: currentVideoPlayerController!.value.isInitialized
                      ? SizedBox(
                          width: currentVideoPlayerController!
                                      .value.aspectRatio >
                                  1
                              ? (MediaQuery.sizeOf(floatingContext!).width) -
                                  ((MediaQuery.sizeOf(floatingContext!).width) /
                                      3)
                              : (MediaQuery.sizeOf(floatingContext!).width) -
                                  ((MediaQuery.sizeOf(floatingContext!).width) /
                                      1.5),
                          child: AspectRatio(
                            aspectRatio:
                                currentVideoPlayerController!.value.aspectRatio,
                            child: Stack(children: [
                              FloatingVideoPlayerWidget(
                                currentController:
                                    currentVideoPlayerController!,
                              ),
                            ]),
                          ),
                        )
                      : Container()),
            )
          ]);
        });
    overlay.insert(entry);
  }

  @override
  void dispose() {
    if (canDispose) {
      currentVideoPlayerController!.pause();
    }

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    Wakelock.disable();
    super.dispose();
  }

  static removeOverlay() {
    isVideoFloating = false;
    entry.remove();
  }
}
