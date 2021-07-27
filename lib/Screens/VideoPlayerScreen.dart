import 'package:flutter/material.dart';
import 'package:mymovieapp/style/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final YoutubePlayerController controller;

  const VideoPlayerScreen({Key key, this.controller}) : super(key: key);
  @override
  _VideoPlayerScreenState createState() =>
      _VideoPlayerScreenState(controller: controller);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final YoutubePlayerController controller;

  _VideoPlayerScreenState({this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: YoutubePlayer(controller: controller),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              iconSize: 30,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
