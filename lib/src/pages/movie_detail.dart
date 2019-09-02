import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_searchbox/src/models/actor_model.dart';
import 'package:movie_searchbox/src/models/movie_model.dart';
import 'package:movie_searchbox/src/providers/movie_provider.dart';

class MovieDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: <Widget>[
            _builAppbar(movie, context),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 10,
                ),
                _poster(movie, context),
                _description(movie),
                _description(movie),
                _casting(movie),
              ]),
            )
          ],
        ));
  }

  _builAppbar(Movie movie, BuildContext context) {
    return SliverAppBar(
      elevation: 2.0,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              shadows: [Shadow(color: Colors.black, offset: Offset(0.5, 1))]),
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
        background: FadeInImage(
          image: NetworkImage(movie.getCoverImg()),
          placeholder: AssetImage('lib/assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _poster(Movie movie, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(blurRadius: 60.0, color: Colors.black38)
                ]),
                child: Image(
                  image: NetworkImage(movie.getPosterImg()),
                  height: 150,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.title,
                ),
                Text(
                  movie.originalTitle,
                  style: Theme.of(context).textTheme.body1,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(
                      movie.voteAverage.toString(),
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text(
          movie.overview,
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.justify,
        ));
  }

  Widget _casting(Movie movie) {
    final MovieProvider movieProvider = MovieProvider();

    return FutureBuilder(
        future: movieProvider.getCast('${movie.id}'),
        builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
          if (snapshot.hasData) {
            return _buildActorsPageView(snapshot.data);
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _buildActorsPageView(List<Actor> list) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int i) {
          return _actorContainer(list[i]);
        },
      ),
    );
  }

  Widget _actorContainer(Actor actor) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getPhoto()),
              placeholder: AssetImage('lib/assets/img/no-image.jpg'),
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            actor.name,
          )
        ],
      ),
    );
  }
}
