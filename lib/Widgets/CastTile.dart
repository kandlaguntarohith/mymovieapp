import 'package:flutter/material.dart';
import 'package:mymovieapp/model/cast.dart';
import 'package:mymovieapp/style/theme.dart';

class CastTile extends StatelessWidget {
  final Cast castDetail;
  const CastTile({Key key, this.castDetail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 10,
        left: 10,
      ),
      child: Column(
        children: <Widget>[
          castDetail.img == null
              ? CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[900],
                )
              : CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[900],
                  backgroundImage: NetworkImage(
                    'https://image.tmdb.org/t/p/original/' + castDetail.img,
                  ),
                ),
          SizedBox(height: 10),
          Text(
            castDetail.name,
            style: TextStyle(
              color: MyColors.titleColor,
              fontSize: 10,
            ),
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
          SizedBox(height: 10),
          Text(
            castDetail.character.replaceAll('/', '\n'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 8,
            ),
            maxLines: 3,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }
}
