import 'package:flutter/material.dart';

class BuildProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.amber),
      ),
    );
  }
}
