import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player_example/custom_video_player_control/left_section.dart';
import 'package:video_player_example/custom_video_player_control/right_section.dart';
import 'package:video_player_example/utils/utils.dart';

class CustomVideoPlayerControls extends StatefulWidget {
  final BetterPlayerController controller;
  const CustomVideoPlayerControls({required this.controller, Key? key})
      : super(key: key);

  @override
  _CustomVideoPlayerControlsState createState() =>
      _CustomVideoPlayerControlsState();
}

class _CustomVideoPlayerControlsState extends State<CustomVideoPlayerControls> {
  StreamController<Duration> videoProgress = StreamController.broadcast();

  StreamController<List> bufferingProgress = StreamController();

  Duration? lastSeek;

  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.controller.videoPlayerController != null) {
      widget.controller.videoPlayerController!.addListener(() {
        videoProgress
            .add(widget.controller.videoPlayerController!.value.position);
        bufferingProgress
            .add(widget.controller.videoPlayerController!.value.buffered);
      });
    }
  }

  @override
  void dispose() {
    videoProgress.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.6,
            child: Container(
              width: double.infinity,
              height: 70,
              color: Colors.black,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<Duration>(
                  stream: videoProgress.stream,
                  builder: (context, snapshot) {
                    return Stack(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                Colors.red,
                                Colors.orange,
                                Colors.yellow,
                                Colors.green,
                                Colors.blue,
                                Colors.purple,
                              ])),
                          width: snapshot.data?.inSeconds.toDouble(),
                          height: 15,
                        ),
                        GestureDetector(
                          onHorizontalDragUpdate: (DragUpdateDetails details) {
                            seekToRelativePosition(details.globalPosition);
                          },
                          child: Container(
                              color: Colors.transparent,
                              height: 15,
                              width: double.infinity),
                        ),
                      ],
                    );
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LeftSection(controller: widget.controller),
                  StreamBuilder<Duration>(
                    stream: videoProgress.stream,
                    builder: (context, snapshot) {
                      return Text(
                          '${formatDuration(snapshot.data ?? const Duration())} / ${formatDuration(widget.controller.videoPlayerController?.value.duration ?? const Duration())}');
                    },
                  ),
                  RightSection(
                    controller: widget.controller,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void seekToRelativePosition(Offset globalPosition) async {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject != null) {
      final box = renderObject as RenderBox;
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      if (relative > 0) {
        final Duration position =
            widget.controller.videoPlayerController!.value.duration! * relative;
        lastSeek = position;
        await widget.controller.videoPlayerController!.seekTo(position);
      }
    }
  }
}
