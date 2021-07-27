import 'package:flutter/material.dart';
import 'package:mymovieapp/Screens/MovieDetailScreen.dart';
import 'package:mymovieapp/model/movie.dart';

import 'MovieTile.dart';

class BuildMovieTileList extends StatelessWidget {
  final List<Movie> movies;

  const BuildMovieTileList({Key key, this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return movies.length == 0
        ? Center(
            child: Text(
              'No Movies Available',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailScreen(movie: movies[index]),
                      ),
                    ),
                child: MovieTile(movie: movies[index])),
            itemCount: movies.length,
          );
  }
}
