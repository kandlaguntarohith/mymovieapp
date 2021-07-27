import 'package:flutter/material.dart';
import 'package:mymovieapp/bloc/get_now_playing_bloc.dart';

import 'package:mymovieapp/model/movie_response.dart';

import 'BuildPlayingMovieWidget.dart';
import 'ErrorDisplayWidget.dart';
import 'ProgressIndicator.dart';

class NowPlayingWidget extends StatefulWidget {
  @override
  _NowPlayingWidgetState createState() => _NowPlayingWidgetState();
}

class _NowPlayingWidgetState extends State<NowPlayingWidget> {
  PageController pageController;

  @override
  void initState() {
    nowPlayingMoviesBloc.getMovies();
    pageController = PageController(viewportFraction: 1, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      child: StreamBuilder<MovieResponse>(
        stream: nowPlayingMoviesBloc.subject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0)
              return BuildErrorDisplayWidget(error: snapshot.data.error);
            return BuildPlayingMoviesWidget(movies: snapshot.data.movies);
          } else if (snapshot.hasError)
            return BuildErrorDisplayWidget(error: snapshot.error);
          else
            return BuildProgressIndicator();
        },
      ),
    );
  }
}
