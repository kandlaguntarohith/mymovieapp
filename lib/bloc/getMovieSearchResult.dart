import 'package:flutter/material.dart';
import 'package:mymovieapp/model/movie_response.dart';
import 'package:mymovieapp/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetMovieSearchResults {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMovieSearch(String query) async {
    MovieResponse response = await _repository.searchMovie(query);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final searchMoviesBloc = GetMovieSearchResults();
