import 'package:flutter/material.dart';

class BuildErrorDisplayWidget extends StatelessWidget {
  final error;

  const BuildErrorDisplayWidget({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error.toString(),
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
