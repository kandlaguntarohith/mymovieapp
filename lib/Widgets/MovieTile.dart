import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mymovieapp/model/movie.dart';
import 'package:mymovieapp/style/theme.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;

  const MovieTile({Key key, this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        left: 5,
        right: 5,
      ),
      width: 130,
      child: Column(
        children: <Widget>[
          Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
                image: movie.poster == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(
                          'http://image.tmdb.org/t/p/w200/' + movie.poster,
                        ),
                        fit: BoxFit.cover),
              ),
              child: movie.poster == null
                  ? Center(
                      child: Icon(EvaIcons.moveOutline),
                    )
                  : null),
          SizedBox(height: 10),
          Text(
            movie.title,
            style: TextStyle(
                fontSize: 12,
                color: MyColors.titleColor,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          SizedBox(height: 10),
          RatingBar(
            onRatingUpdate: (value) => print(value),
            allowHalfRating: true,
            direction: Axis.horizontal,
            initialRating: movie.rating / 2,
            itemSize: 8,
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
    );
  }
}
