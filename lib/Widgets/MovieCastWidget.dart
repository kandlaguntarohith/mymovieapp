import 'package:flutter/material.dart';
import 'package:mymovieapp/Widgets/CastTile.dart';
import 'package:mymovieapp/bloc/get_casts_bloc.dart';
import 'package:mymovieapp/model/cast.dart';
import 'package:mymovieapp/model/cast_response.dart';

import 'ErrorDisplayWidget.dart';
import 'ProgressIndicator.dart';

class MovieCastWidget extends StatefulWidget {
  final id;

  const MovieCastWidget({Key key, this.id}) : super(key: key);
  @override
  _MovieCastWidgetState createState() => _MovieCastWidgetState();
}

class _MovieCastWidgetState extends State<MovieCastWidget> {
  @override
  void initState() {
    castsBloc.getCasts(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    castsBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      child: StreamBuilder<CastResponse>(
        stream: castsBloc.subject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) if (snapshot.data.error != null &&
              snapshot.data.error.length > 0)
            return BuildErrorDisplayWidget(error: snapshot.data.error);
          else
            return CastListWidget(casts: snapshot.data.casts);
          else if (snapshot.hasError)
            return BuildErrorDisplayWidget(error: snapshot.error);

          return BuildProgressIndicator();
        },
      ),
    );
  }
}

class CastListWidget extends StatelessWidget {
  final List<Cast> casts;

  const CastListWidget({Key key, this.casts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: casts.length,
      itemBuilder: (context, index) => CastTile(castDetail: casts[index]),
    );
  }
}
