import 'package:flutter/material.dart';
import 'package:mymovieapp/bloc/get_movies_byGenre_bloc.dart';
import 'package:mymovieapp/model/genre.dart';
import 'package:mymovieapp/style/theme.dart';

import 'ErrorDisplayWidget.dart';
import 'GenreBlocMoviesWidget.dart';

class BuildGenreTabWidget extends StatefulWidget {
  final List<Genre> genres;

  const BuildGenreTabWidget({Key key, this.genres}) : super(key: key);

  @override
  _BuildGenreTabWidgetState createState() => _BuildGenreTabWidgetState();
}

class _BuildGenreTabWidgetState extends State<BuildGenreTabWidget>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(
      vsync: this,
      length: widget.genres.length,
    );
    tabController.addListener(() {
      if (tabController.indexIsChanging) moviesByGenreBloc.drainStream();
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.genres.length == 0)
      return BuildErrorDisplayWidget(error: 'No Genres Available');
    return DefaultTabController(
      length: widget.genres.length,
      child: Scaffold(
        backgroundColor: MyColors.mainColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: MyColors.mainColor,
            elevation: 0,
            bottom: TabBar(
              tabs: widget.genres
                  .map(
                    (genreItem) => Container(
                      padding: EdgeInsets.only(
                        bottom: 15,
                        top: 5,
                      ),
                      child: Text(
                        genreItem.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              indicatorWeight: 3.0,
              unselectedLabelColor: MyColors.titleColor,
              labelColor: Colors.white,
              indicatorColor: MyColors.secondColor,
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: widget.genres
              .map(
                (e) => GenreBlocMoviesWidget(
                  id: e.id,
                ),
              )
              .toList(),
          controller: tabController,
        ),
      ),
    );
  }
}
