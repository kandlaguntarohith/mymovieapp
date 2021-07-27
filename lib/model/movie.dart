import 'package:mymovieapp/model/cast_response.dart';

class Movie {
  final int id;
  final double popularity;
  final String title;
  final String backPoster;
  final String poster;
  final String overview;
  final double rating;
  final String releaseDate;
  Future<CastResponse> castNames;

  Movie(this.id, this.popularity, this.title, this.backPoster, this.poster,
      this.overview, this.rating, this.releaseDate, this.castNames);

  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        popularity = json["popularity"],
        title = json["title"],
        backPoster = json["backdrop_path"],
        poster = json["poster_path"],
        overview = json["overview"],
        rating = json["vote_average"].toDouble(),
        releaseDate = json["release_date"];
}
