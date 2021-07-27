import 'package:flutter/material.dart';
import 'package:mymovieapp/Screens/SearchScreen.dart';
import 'package:mymovieapp/Widgets/GenrePlaying.dart';
import 'package:mymovieapp/Widgets/NowPlaying.dart';
import 'package:mymovieapp/Widgets/TopRatedMovies.dart';
import 'package:mymovieapp/Widgets/TrendingPersons.dart';
import 'package:mymovieapp/style/theme.dart' as themeData;

class MyHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.MyColors.mainColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: themeData.MyColors.mainColor,
        title: Text(
          'Movie App',
          style: TextStyle(
            color: themeData.MyColors.titleColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: themeData.MyColors.titleColor,
          ),
          onPressed: null,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: themeData.MyColors.titleColor,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SearchScreen(),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            NowPlayingWidget(),
            SizedBox(height: 20),
            GenreList(),
            SizedBox(height: 20),
            TrendingPersons(),
            TopRatedMovies(),
          ],
        ),
      ),
    );
  }
}
