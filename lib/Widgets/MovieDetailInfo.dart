import 'package:flutter/material.dart';
import 'package:mymovieapp/Widgets/ErrorDisplayWidget.dart';
import 'package:mymovieapp/Widgets/ProgressIndicator.dart';
import 'package:mymovieapp/bloc/get_movie_detail_bloc.dart';
import 'package:mymovieapp/model/movie_detail.dart';
import 'package:mymovieapp/model/movie_detail_response.dart';
import 'package:mymovieapp/style/theme.dart';

class MovieDetailInfo extends StatefulWidget {
  final id;

  const MovieDetailInfo({Key key, this.id}) : super(key: key);

  @override
  _MovieDetailInfoState createState() => _MovieDetailInfoState();
}

class _MovieDetailInfoState extends State<MovieDetailInfo> {
  @override
  void initState() {
    movieDetailBloc.getMovieDetail(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    movieDetailBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
      stream: movieDetailBloc.subject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0)
            return BuildErrorDisplayWidget(error: snapshot.data.error);
          return BuildMovieInfoWidget(movieDetail: snapshot.data.movieDetail);
        } else if (snapshot.hasError)
          return BuildErrorDisplayWidget(error: snapshot.data.error);
        return BuildProgressIndicator();
      },
    );
  }
}

class BuildMovieInfoWidget extends StatefulWidget {
  final MovieDetail movieDetail;

  const BuildMovieInfoWidget({Key key, this.movieDetail}) : super(key: key);
  @override
  _BuildMovieInfoWidgetState createState() =>
      _BuildMovieInfoWidgetState(movieDetail: movieDetail);
}

class _BuildMovieInfoWidgetState extends State<BuildMovieInfoWidget> {
  final MovieDetail movieDetail;

  _BuildMovieInfoWidgetState({@required this.movieDetail});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'BUDGET',
                  style: TextStyle(
                    color: MyColors.secondColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '\$' + movieDetail.budget.toString(),
                  style: TextStyle(
                    color: MyColors.titleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'DURATION',
                  style: TextStyle(
                    color: MyColors.secondColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  movieDetail.runtime.toString() + ' min',
                  style: TextStyle(
                    color: MyColors.titleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'RELEASE DATE',
                  style: TextStyle(
                    color: MyColors.secondColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  movieDetail.releaseDate,
                  style: TextStyle(
                    color: MyColors.titleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'GENRE',
            style: TextStyle(
              color: MyColors.secondColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 28,
          width: double.infinity,
          child: ListView.builder(
            itemCount: movieDetail.genres.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) =>
                GenreTile(genreName: movieDetail.genres[index].name),
          ),
        ),
      ],
    );
  }
}

class GenreTile extends StatelessWidget {
  final String genreName;

  const GenreTile({Key key, this.genreName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Text(
          genreName,
          style: TextStyle(
            color: MyColors.titleColor,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
