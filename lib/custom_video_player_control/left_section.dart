import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeftSection extends StatefulWidget {
  final BetterPlayerController controller;
  const LeftSection({required this.controller, Key? key}) : super(key: key);

  @override
  _LeftSectionState createState() => _LeftSectionState();
}

class _LeftSectionState extends State<LeftSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _playPauseController;

  @override
  void initState() {
    super.initState();
    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            if (_playPauseController.isCompleted) {
              _playPauseController.reverse();
              widget.controller.pause();
            } else {
              _playPauseController.forward();
              widget.controller.play();
            }
          },
          child: AnimatedIcon(
            progress: _playPauseController,
            icon: AnimatedIcons.play_pause,
            size: 42,
          ),
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.refresh_bold),
          onPressed: () {
            widget.controller.videoPlayerController?.value;
            if (widget.controller.videoPlayerController != null) {
              int skip = widget.controller.videoPlayerController!.value.position
                      .inMilliseconds -
                  10000;
              if (skip < 0) {
                skip = 0;
              }
              widget.controller.seekTo(Duration(milliseconds: skip));
            }
          },
        ),
        _SetVideoSpeed(
          onChanged: (double value) => widget.controller.setSpeed(value),
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.refresh),
          onPressed: () {
            widget.controller.videoPlayerController?.value;
            if (widget.controller.videoPlayerController != null) {
              final int end = widget.controller.videoPlayerController!.value
                  .duration!.inMilliseconds;
              int skip = widget.controller.videoPlayerController!.value.position
                      .inMilliseconds +
                  10000;
              if (skip > end) {
                skip = end;
              }
              widget.controller.seekTo(Duration(milliseconds: skip));
            }
          },
        ),
        _VolumeIndicator(
          volumeLevelChanged: (double value) {
            widget.controller.setVolume(value);
          },
        ),
      ],
    );
  }
}

class _SetVideoSpeed extends StatefulWidget {
  const _SetVideoSpeed({required this.onChanged, Key? key}) : super(key: key);

  final void Function(double value) onChanged;

  @override
  State<_SetVideoSpeed> createState() => _SetVideoSpeedState();
}

class _SetVideoSpeedState extends State<_SetVideoSpeed> {
  static const List<DropdownMenuItem<String>> items =
      <DropdownMenuItem<String>>[
    DropdownMenuItem(
      child: Text('0.25x'),
      value: '0.25',
      alignment: AlignmentDirectional.center,
    ),
    DropdownMenuItem(
      child: Text('0.5x'),
      value: '0.5',
      alignment: AlignmentDirectional.center,
    ),
    DropdownMenuItem(
      child: Text('0.75x'),
      value: '0.75',
      alignment: AlignmentDirectional.center,
    ),
    DropdownMenuItem(
      child: Text('1x'),
      value: '1',
      alignment: AlignmentDirectional.center,
    ),
    DropdownMenuItem(
      child: Text('1.25x'),
      value: '1.25',
      alignment: AlignmentDirectional.center,
    ),
    DropdownMenuItem(
      child: Text('1.5x'),
      value: '1.5',
      alignment: AlignmentDirectional.center,
    ),
    DropdownMenuItem(
      child: Text('1.75x'),
      value: '1.75',
      alignment: AlignmentDirectional.center,
    ),
    DropdownMenuItem(
      child: Text('2x'),
      value: '2',
      alignment: AlignmentDirectional.center,
    ),
  ];

  String selectedValue = '1';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        alignment: AlignmentDirectional.center,
        value: selectedValue,
        items: items,
        icon: const SizedBox(),
        onChanged: (String? value) {
          if (value != null) {
            widget.onChanged(double.parse(value));
            setState(() {
              selectedValue = value;
            });
          }
        },
      ),
    );
  }
}

class _VolumeIndicator extends StatefulWidget {
  const _VolumeIndicator({
    required this.volumeLevelChanged,
    Key? key,
  }) : super(key: key);

  final void Function(double volumeLevel) volumeLevelChanged;

  @override
  State<_VolumeIndicator> createState() => _VolumeIndicatorState();
}

class _VolumeIndicatorState extends State<_VolumeIndicator> {
  double value = 1;
  double? lastValue;

  bool showSlider = false;

  bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          showSlider = true;
        });
      },
      onExit: (_) {
        setState(() {
          showSlider = false;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                isMuted = !isMuted;
                if (isMuted) {
                  lastValue = value;
                  value = 0;
                } else {
                  value = lastValue ?? 1;
                }
              });
              widget.volumeLevelChanged(value);
            },
            icon: value == 0
                ? const Icon(Icons.volume_off)
                : isMuted
                    ? const Icon(Icons.volume_off)
                    : const Icon(Icons.volume_up),
            iconSize: 28,
          ),
          if (showSlider)
            SizedBox(
              height: 10,
              child: SliderTheme(
                data: const SliderThemeData(trackHeight: 3),
                child: Slider(
                  inactiveColor: Colors.grey,
                  activeColor: Colors.white,
                  thumbColor: Colors.white,
                  value: value,
                  onChanged: (double value) {
                    setState(() {
                      this.value = value;
                      widget.volumeLevelChanged(value);
                    });
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}
