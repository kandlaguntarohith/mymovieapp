import 'package:flutter/material.dart';
import 'package:mymovieapp/model/person.dart';

import 'PersonTile.dart';

class BuildPersonsList extends StatelessWidget {
  final List<Person> persons;

  const BuildPersonsList({Key key, this.persons}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => PersonTile(
        person: persons[index],
        key: Key(persons[index].id.toString()),
      ),
      itemCount: persons.length,
    );
  }
}
