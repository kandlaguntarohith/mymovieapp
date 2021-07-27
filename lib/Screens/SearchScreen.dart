import 'dart:math';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mymovieapp/Screens/MovieDetailScreen.dart';
import 'package:mymovieapp/Widgets/ErrorDisplayWidget.dart';
import 'package:mymovieapp/Widgets/InfoColumn.dart';
import 'package:mymovieapp/Widgets/ProgressIndicator.dart';
import 'package:mymovieapp/bloc/getMovieSearchResult.dart';
import 'package:mymovieapp/model/movie.dart';
import 'package:mymovieapp/model/movie_response.dart';
import 'package:mymovieapp/style/theme.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var controller = TextEditingController();
  bool loadFlag;
  @override
  void initState() {
    loadFlag = false;
    controller.addListener(() {
      searchMoviesBloc.drainStream();
      if (controller.text.trim().length > 0) {
        loadFlag = true;
        searchMoviesBloc.getMovieSearch(controller.text.trim());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    searchMoviesBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey[900].withOpacity(0.3),
              height: 65,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                    height: double.infinity,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.amber,
                            width: 1,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<MovieResponse>(
                stream: searchMoviesBloc.subject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.error != null &&
                        snapshot.data.error.length > 0)
                      return BuildErrorDisplayWidget(
                          error: snapshot.data.error);
                    return BuildSearchMovieList(movies: snapshot.data.movies);
                  } else if (snapshot.hasError)
                    return BuildErrorDisplayWidget(error: snapshot.error);
                  else
                    return loadFlag ? BuildProgressIndicator() : Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildSearchMovieList extends StatelessWidget {
  final List<Movie> movies;

  const BuildSearchMovieList({Key key, this.movies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movies[index]),
            ),
          ),
          child: SearchResultMovieTile(
            movie: movies[index],
            key: Key(movies[index].id.toString()),
          ),
        ),
        itemCount: movies.length,
      ),
      // child: SingleChildScrollView(
      //   child: Column(
      //     children: movies
      //         .map((movie) => SearchResultMovieTile(movie: movie))
      //         .toList(),
      //   ),
      // ),
    );
  }
}

class SearchResultMovieTile extends StatelessWidget {
  final Movie movie;

  const SearchResultMovieTile({Key key, this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: 130,
              decoration: BoxDecoration(
                image: movie.poster != null
                    ? DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/original/" +
                                movie.poster),
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  width: 180,
                  child: Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  movie.releaseDate == null
                      ? 'Release Date'
                      : movie.releaseDate,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                InfoColumn(
                  id: movie.id,
                  key: Key(movie.title),
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Text(
                      movie.rating.toString(),
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    RatingBar(
                      onRatingUpdate: (value) => print(value),
                      allowHalfRating: true,
                      direction: Axis.horizontal,
                      initialRating: movie.rating / 2,
                      itemSize: 10,
                      itemCount: 5,
                      maxRating: 5,
                      itemPadding: EdgeInsets.all(3),
                      minRating: 1,
                      itemBuilder: (context, index) => Icon(
                        EvaIcons.star,
                        color: MyColors.secondColor,
                      ),
                      glowColor: MyColors.secondColor,
                      glow: true,
                      unratedColor: MyColors.titleColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
