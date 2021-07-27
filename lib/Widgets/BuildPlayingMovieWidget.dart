import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mymovieapp/model/movie.dart';
import 'package:page_indicator/page_indicator.dart';

import 'ErrorDisplayWidget.dart';
import 'PageViewMovieCoverTile.dart';

class BuildPlayingMoviesWidget extends StatelessWidget {
  final List<Movie> movies;

  const BuildPlayingMoviesWidget({Key key, this.movies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (movies.length == 0)
      return BuildErrorDisplayWidget(error: 'No Titles Available');
    return PageIndicatorContainer(
      indicatorColor: Colors.grey[700],
      indicatorSelectorColor: Colors.amber,
      indicatorSpace: 8,
      align: IndicatorAlign.bottom,
      padding: EdgeInsets.only(bottom: 15),
      shape: IndicatorShape.circle(size: 8),
      pageView: PageView.builder(
        itemBuilder: (context, index) =>
            PageViewMovieCoverTile(movie: movies[index]),
        itemCount: min(5, movies.length),
      ),
      length: min(5, movies.length),
    );
  }
}
