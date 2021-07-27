import 'package:flutter/material.dart';
import 'package:mymovieapp/bloc/get_persons_bloc.dart';
import 'package:mymovieapp/model/person_response.dart';
import 'package:mymovieapp/style/theme.dart';

import 'BuildPersonList.dart';
import 'ErrorDisplayWidget.dart';
import 'ProgressIndicator.dart';

class TrendingPersons extends StatefulWidget {
  @override
  _TrendingPersonsState createState() => _TrendingPersonsState();
}

class _TrendingPersonsState extends State<TrendingPersons> {
  @override
  void initState() {
    personsBloc.getPersons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Trending Person',
              style: TextStyle(
                color: MyColors.titleColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 150,
            width: double.infinity,
            child: StreamBuilder<PersonResponse>(
              stream: personsBloc.subject.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0)
                    return BuildErrorDisplayWidget(error: snapshot.data.error);
                  return BuildPersonsList(persons: snapshot.data.persons);
                } else if (snapshot.hasError)
                  return BuildErrorDisplayWidget(error: snapshot.error);
                else
                  return BuildProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
