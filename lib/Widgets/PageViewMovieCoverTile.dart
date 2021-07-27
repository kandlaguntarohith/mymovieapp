import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mymovieapp/Screens/VideoPlayerScreen.dart';
import 'package:mymovieapp/Widgets/ErrorDisplayWidget.dart';
import 'package:mymovieapp/Widgets/ProgressIndicator.dart';
import 'package:mymovieapp/bloc/get_movie_videos_bloc.dart';
import 'package:mymovieapp/model/movie.dart';
import 'package:mymovieapp/model/video.dart';
import 'package:mymovieapp/model/video_response.dart';
import 'package:mymovieapp/style/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PageViewMovieCoverTile extends StatefulWidget {
  final Movie movie;

  const PageViewMovieCoverTile({Key key, this.movie}) : super(key: key);

  @override
  _PageViewMovieCoverTileState createState() => _PageViewMovieCoverTileState();
}

class _PageViewMovieCoverTileState extends State<PageViewMovieCoverTile> {
  var videosBloc;
  @override
  void initState() {
    super.initState();
    videosBloc = MovieVideosBloc();
    videosBloc.getMovieVideos(widget.movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    videosBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.pink,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.network(
              'https://image.tmdb.org/t/p/original/' + widget.movie.backPoster,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.mainColor.withOpacity(1.0),
                  MyColors.mainColor.withOpacity(0.0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [
                  0.05,
                  0.9,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.movie.title,
                style: TextStyle(
                    color: MyColors.titleColor,
                    fontWeight: FontWeight.w300,
                    height: 1.5,
                    fontSize: 15),
              ),
            ),
          ),
          Positioned(
            top: -20,
            bottom: 0,
            left: 0,
            right: 0,
            child: StreamBuilder<VideoResponse>(
              stream: videosBloc.subject.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0)
                    return BuildErrorDisplayWidget(
                        error: snapshot.data.error.toString());
                  return PlayWidget(videos: snapshot.data.videos);
                } else if (snapshot.hasError)
                  BuildErrorDisplayWidget(
                      error: snapshot.data.error.toString());
                return BuildProgressIndicator();
              },
            ),
          )
        ],
      ),
    );
  }
}

class PlayWidget extends StatelessWidget {
  final List<Video> videos;
  PlayWidget({
    Key key,
    this.videos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(
            controller: YoutubePlayerController(initialVideoId: videos[0].key),
          ),
        ),
      ),
      child: Icon(
        FontAwesomeIcons.playCircle,
        size: 40,
        color: Colors.amber,
      ),
    );
  }
}
