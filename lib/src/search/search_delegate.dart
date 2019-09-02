import 'package:flutter/material.dart';
import 'package:movie_searchbox/src/models/movie_model.dart';
import 'package:movie_searchbox/src/providers/movie_provider.dart';

class DataSearch extends SearchDelegate {
  String selection = '';

  final MovieProvider movieProvider = MovieProvider();

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
        close(context, null);
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
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: movieProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;

          return ListView(
            children: movies.map((movie) {
              movie.uniqueId = '${movie.id}-search';

              return ListTile(
                leading: Hero(
                  tag: movie.uniqueId,
                  child: FadeInImage(
                    image: NetworkImage(movie.getPosterImg()),
                    placeholder: AssetImage('lib/assets/img/no-image.gif'),
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(
                  movie.title,
                  style: Theme.of(context).textTheme.title,
                ),
                subtitle: Text(movie.originalTitle),
                onTap: () {
                  Navigator.pushNamed(context, 'detail', arguments: movie);
                },
              );
            }).toList(),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
