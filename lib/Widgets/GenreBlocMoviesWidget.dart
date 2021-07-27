import 'package:flutter/material.dart';
import 'package:mymovieapp/bloc/get_movies_byGenre_bloc.dart';
import 'package:mymovieapp/model/movie_response.dart';
import 'BuildMovieTileList.dart';
import 'ErrorDisplayWidget.dart';
import 'ProgressIndicator.dart';

class GenreBlocMoviesWidget extends StatefulWidget {
  final id;

  const GenreBlocMoviesWidget({Key key, this.id}) : super(key: key);

  @override
  _GenreBlocMoviesWidgetState createState() => _GenreBlocMoviesWidgetState();
}

class _GenreBlocMoviesWidgetState extends State<GenreBlocMoviesWidget> {
  @override
  void initState() {
    moviesByGenreBloc.getMoviesByGenre(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 15),
      // height: 220,
      width: double.infinity,
      child: StreamBuilder<MovieResponse>(
        stream: moviesByGenreBloc.subject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0)
              return BuildErrorDisplayWidget(error: snapshot.data.error);
            return BuildMovieTileList(movies: snapshot.data.movies);
          } else if (snapshot.hasError)
            return BuildErrorDisplayWidget(error: snapshot.error);
          else
            return BuildProgressIndicator();
        },
      ),
    );
  }
}
