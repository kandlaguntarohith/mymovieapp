import 'package:flutter/material.dart';
import 'package:mymovieapp/Widgets/BuildMovieTileList.dart';
import 'package:mymovieapp/bloc/get_movies_bloc.dart';
import 'package:mymovieapp/model/movie_response.dart';

import 'ErrorDisplayWidget.dart';
import 'ProgressIndicator.dart';

class TopRatedMovies extends StatefulWidget {
  @override
  _TopRatedMoviesState createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
  @override
  void initState() {
    moviesBloc.getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Top Rated Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 300,
          padding: EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          child: StreamBuilder<MovieResponse>(
            stream: moviesBloc.subject.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0)
                  return BuildErrorDisplayWidget(error: snapshot.data.error);
                return BuildMovieTileList(movies: snapshot.data.movies);
              } else if (snapshot.hasError)
                return BuildErrorDisplayWidget(error: snapshot.error);
              else
                return BuildProgressIndicator();
            },
          ),
        ),
      ],
    );
  }
}
