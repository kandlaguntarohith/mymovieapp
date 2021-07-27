import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mymovieapp/bloc/get_casts_bloc.dart';
import 'package:mymovieapp/model/cast_response.dart';

import 'ErrorDisplayWidget.dart';
import 'ProgressIndicator.dart';

class InfoColumn extends StatefulWidget {
  final id;

  const InfoColumn({Key key, this.id}) : super(key: key);
  @override
  _InfoColumnState createState() => _InfoColumnState();
}

class _InfoColumnState extends State<InfoColumn> {
  CastsBloc castsBloc = CastsBloc();
  @override
  void initState() {
    castsBloc.getCasts(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    castsBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CastResponse>(
      stream: castsBloc.subject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0)
            return BuildErrorDisplayWidget(error: snapshot.data.error);
          print(widget.id.toString());
          snapshot.data.casts.forEach((element) => print(element.name));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                height: 70,
                width: 180,
                // child: Text(widget.id.toString(),style: TextStyle(color: Colors.white),),
                child: ListView.builder(
                  primary: false,
                  itemBuilder: (context, index) => Text(
                    snapshot.data.casts[index].name,
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  itemCount: snapshot.data.casts.length == null
                      ? 0
                      : min(5, snapshot.data.casts.length),
                  // itemCount: 1,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError)
          return BuildErrorDisplayWidget(error: snapshot.error);
        else
          return Container();
      },
    );
  }
}
