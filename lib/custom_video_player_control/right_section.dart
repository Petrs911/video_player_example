import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RightSection extends StatefulWidget {
  const RightSection({required this.controller, Key? key}) : super(key: key);

  final BetterPlayerController controller;

  @override
  State<RightSection> createState() => _RightSectionState();
}

class _RightSectionState extends State<RightSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const _MyIcon('assets/svg_icons/take_notes.svg'),
        const _MyIcon('assets/svg_icons/notes.svg'),
        _SetSubtitles(
          'assets/svg_icons/closed_caption.svg',
          controller: widget.controller,
        ),
        _SetAudioTrack(
          'assets/svg_icons/settings.svg',
          controller: widget.controller,
        ),
        _ClickableIcon('assets/svg_icons/full_screen.svg', onTap: () {
          widget.controller.toggleFullScreen();
        }),
      ],
    );
  }
}

class _MyIcon extends StatelessWidget {
  const _MyIcon(this.assetPath, {Key? key}) : super(key: key);

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SvgPicture.asset(
        assetPath,
        height: 20,
        width: 20,
      ),
    );
  }
}

class _ClickableIcon extends StatelessWidget {
  const _ClickableIcon(
    this.assetPath, {
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String assetPath;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SvgPicture.asset(
          assetPath,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}

class _SetSubtitles extends StatefulWidget {
  const _SetSubtitles(this.assetPath, {required this.controller, Key? key})
      : super(key: key);

  final BetterPlayerController controller;
  final String assetPath;

  @override
  State<_SetSubtitles> createState() => _SetSubtitlesState();
}

class _SetSubtitlesState extends State<_SetSubtitles> {
  late OverlayEntry _overlayEntry;

  bool isOverlayCreated = false;

  void _createOverlayEntry(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: offset.dy - 180,
        left: offset.dx - 60,
        child: Material(
          child: Column(
            children: [
              ...widget.controller.betterPlayerSubtitlesSourceList
                  .map((BetterPlayerSubtitlesSource source) => _Subtitle(
                      source: source,
                      onTap: () {
                        widget.controller.setupSubtitleSource(source);
                        _overlayEntry.remove();
                        isOverlayCreated = false;
                      }))
                  .toList(),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isOverlayCreated) {
          _overlayEntry.remove();
        } else {
          _createOverlayEntry(context);
        }
        isOverlayCreated = !isOverlayCreated;
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SvgPicture.asset(
          widget.assetPath,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.onTap, required this.source, Key? key})
      : super(key: key);

  final BetterPlayerSubtitlesSource source;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Text(source.name ?? ''),
      ),
    );
  }
}

class _SetAudioTrack extends StatefulWidget {
  const _SetAudioTrack(this.assetPath, {required this.controller, Key? key})
      : super(key: key);

  final BetterPlayerController controller;
  final String assetPath;

  @override
  State<_SetAudioTrack> createState() => _SetAudioTrackState();
}

class _SetAudioTrackState extends State<_SetAudioTrack> {
  late OverlayEntry _overlayEntry;

  bool isOverlayCreated = false;

  void _createOverlayEntry(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    // final List<BetterPlayerAsmsAudioTrack>? asmsTracks =
    //     widget.controller.betterPlayerAsmsAudioTracks;
    // final List<Widget> children = [];
    // final BetterPlayerAsmsAudioTrack? selectedAsmsAudioTrack =
    //     widget.controller.betterPlayerAsmsAudioTrack;
    // if (asmsTracks != null) {
    //   for (var index = 0; index < asmsTracks.length; index++) {
    //     final bool isSelected = selectedAsmsAudioTrack != null &&
    //         selectedAsmsAudioTrack == asmsTracks[index];
    //   }
    // }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: offset.dy - 150,
        left: offset.dx - 30,
        child: Material(
          child: Column(
            children: [
              if (widget.controller.betterPlayerAsmsAudioTracks != null)
                ...widget.controller.betterPlayerAsmsAudioTracks!
                    .map((BetterPlayerAsmsAudioTrack track) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              child: Text(track.language ?? ''),
                              onTap: () {
                                widget.controller.setAudioTrack(track);
                                _overlayEntry.remove();
                                isOverlayCreated = false;
                              }),
                        ))
                    .toList(),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isOverlayCreated) {
          _overlayEntry.remove();
        } else {
          _createOverlayEntry(context);
        }
        isOverlayCreated = !isOverlayCreated;
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SvgPicture.asset(
          widget.assetPath,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
