import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {
  String selection = '';

  final movies = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'IronMan',
    'Capitan America',
    'Capitan Marvel',
  ];

  final popularMovies = [
    'Spiderman',
    'Batman',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    //Action on AppBar
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          print('Click Clear');
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading Icon
    return IconButton(
      icon: AnimatedIcon(
        progress: transitionAnimation,
        icon: AnimatedIcons.menu_arrow,
      ),
      onPressed: () {
        print('Click menu');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build Results to show
    return Center(
        child: Container(
      height: 100,
      width: 100,
      color: Colors.blueAccent,
      child: Text(selection),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggested = (query.isEmpty)
        ? popularMovies
        : movies
            .where((v) => v.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    // Builder of suggestions
    return ListView.builder(
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(suggested[i]),
          onTap: () {
            selection = suggested[i];
            showResults(context);
          },
        );
      },
      itemCount: suggested.length,
    );
  }
}
