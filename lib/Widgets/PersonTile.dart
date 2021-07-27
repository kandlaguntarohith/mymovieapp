import 'package:flutter/material.dart';
import 'package:mymovieapp/model/person.dart';
import 'package:mymovieapp/style/theme.dart';

class PersonTile extends StatelessWidget {
  final Person person;

  const PersonTile({Key key, this.person}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          children: <Widget>[
            person.profileImg == null
                ? CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[900],
                  )
                : CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[900],
                    backgroundImage: NetworkImage(
                      'https://image.tmdb.org/t/p/original/' +
                          person.profileImg,
                    ),
                  ),
            SizedBox(height: 10),
            Text(
              person.name,
              style: TextStyle(
                color: MyColors.titleColor,
                fontSize: 10,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text(
              person.known,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
