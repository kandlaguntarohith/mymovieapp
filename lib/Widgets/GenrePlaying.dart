import 'package:mymovieapp/bloc/get_genres_bloc.dart';
import 'package:mymovieapp/model/genre_response.dart';
import 'package:flutter/material.dart';
import 'BuildGenreTabWidget.dart';
import 'ErrorDisplayWidget.dart';
import 'ProgressIndicator.dart';

class GenreList extends StatefulWidget {
  @override
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  @override
  void initState() {
    genresBloc.getGenres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      child: StreamBuilder<GenreResponse>(
        stream: genresBloc.subject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0)
              return BuildErrorDisplayWidget(error: snapshot.data.error);
            return BuildGenreTabWidget(genres: snapshot.data.genres);
          } else if (snapshot.hasError)
            return BuildErrorDisplayWidget(error: snapshot.error);
          else
            return BuildProgressIndicator();
        },
      ),
    );
  }
}
