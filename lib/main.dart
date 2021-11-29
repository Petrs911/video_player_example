import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_video_player_control/custom_video_player_controls.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example player"),
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer.network(
          "https://bitmovin-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
          betterPlayerConfiguration: BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              playerTheme: BetterPlayerTheme.custom,
              customControlsBuilder: (
                BetterPlayerController controller,
                Function(bool) onPlayerVisibilityChanged,
              ) {
                return CustomVideoPlayerControls(controller: controller);
              },
              progressBarBufferedColor: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
