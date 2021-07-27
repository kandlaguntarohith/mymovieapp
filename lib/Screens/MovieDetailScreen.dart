import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mymovieapp/Screens/VideoPlayerScreen.dart';
import 'package:mymovieapp/Widgets/BuildMovieTileList.dart';
import 'package:mymovieapp/Widgets/ErrorDisplayWidget.dart';
import 'package:mymovieapp/Widgets/MovieCastWidget.dart';
import 'package:mymovieapp/Widgets/MovieDetailInfo.dart';
import 'package:mymovieapp/Widgets/ProgressIndicator.dart';
import 'package:mymovieapp/bloc/get_movie_similar_bloc.dart';
import 'package:mymovieapp/bloc/get_movie_videos_bloc.dart';
import 'package:mymovieapp/model/movie.dart';
import 'package:mymovieapp/model/movie_response.dart';
import 'package:mymovieapp/model/video.dart';
import 'package:mymovieapp/model/video_response.dart';
import 'package:mymovieapp/style/theme.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({Key key, this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    movieVideosBloc.getMovieVideos(widget.movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideosBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Builder(
        builder: (context) {
          return SliverFab(
            expandedHeight: 200,
            floatingPosition: FloatingPosition(right: 30),
            floatingWidget: StreamBuilder<VideoResponse>(
              stream: movieVideosBloc.subject.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0)
                    return BuildErrorDisplayWidget(error: snapshot.data.error);
                  else
                    return BuildVideoWidget(videos: snapshot.data.videos);
                } else if (snapshot.hasError)
                  return BuildErrorDisplayWidget(error: snapshot.error);

                return BuildProgressIndicator();
              },
            ),
            slivers: [
              SliverAppBar(
                backgroundColor: MyColors.mainColor,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.movie.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    children: <Widget>[
                      if (widget.movie.backPoster != null)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/" +
                                      widget.movie.backPoster),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          top: 30,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              widget.movie.rating.toString(),
                              style: TextStyle(
                                color: MyColors.titleColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 20),
                            RatingBar(
                              onRatingUpdate: null,
                              allowHalfRating: true,
                              itemCount: 5,
                              initialRating: widget.movie.rating / 2,
                              unratedColor: Colors.grey,
                              itemSize: 15,
                              itemPadding: EdgeInsets.symmetric(horizontal: 5),
                              minRating: 1,
                              direction: Axis.horizontal,
                              itemBuilder: (context, index) => Icon(
                                EvaIcons.star,
                                color: MyColors.secondColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          top: 30,
                        ),
                        child: Text(
                          'OVERVIEW',
                          style: TextStyle(
                            color: MyColors.secondColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          widget.movie.overview,
                          style: TextStyle(
                            color: MyColors.titleColor,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: MovieDetailInfo(id: widget.movie.id),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          'CAST',
                          style: TextStyle(
                            color: MyColors.secondColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      MovieCastWidget(id: widget.movie.id),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          'SIMILAR MOVIES',
                          style: TextStyle(
                            color: MyColors.secondColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: BuildSimilarMovies(id: widget.movie.id),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BuildSimilarMovies extends StatefulWidget {
  final id;

  const BuildSimilarMovies({Key key, this.id}) : super(key: key);
  @override
  _BuildSimilarMoviesState createState() => _BuildSimilarMoviesState();
}

class _BuildSimilarMoviesState extends State<BuildSimilarMovies> {
  @override
  void initState() {
    similarMoviesBloc.getSimilarMovies(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    similarMoviesBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: StreamBuilder<MovieResponse>(
        stream: similarMoviesBloc.subject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) if (snapshot.data.error != null &&
              snapshot.data.error.length > 0)
            return BuildErrorDisplayWidget(error: snapshot.data.error);
          else
            return BuildMovieTileList(movies: snapshot.data.movies);
          else if (snapshot.hasError)
            return BuildErrorDisplayWidget(error: snapshot.error);

          return BuildProgressIndicator();
        },
      ),
    );
  }
}

class BuildVideoWidget extends StatelessWidget {
  final List<Video> videos;

  const BuildVideoWidget({Key key, this.videos}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: videos.length != 0
          ? () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    controller: YoutubePlayerController(
                      initialVideoId: videos[0].key,
                      flags: YoutubePlayerFlags(
                        autoPlay: true,
                      ),
                    ),
                  ),
                ),
              )
          : null,
      backgroundColor: MyColors.secondColor,
      child: Icon(Icons.play_arrow),
    );
  }
}
