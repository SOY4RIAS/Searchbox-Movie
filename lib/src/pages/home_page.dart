import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_scale_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:movie_searchbox/src/models/movie_model.dart';
import 'package:movie_searchbox/src/providers/movie_provider.dart';
import 'package:movie_searchbox/src/search/search_delegate.dart';
import 'package:movie_searchbox/src/widgets/card_swiper_widget.dart';
import 'package:movie_searchbox/src/widgets/list_horizontal_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieProvider movieProvider = MovieProvider();

  @override
  Widget build(BuildContext context) {
    movieProvider.getPopular();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        leading: Icon(Icons.movie_filter),
        title: Text('SearchBox'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(), query: '');
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildCardSwiper(),
                _footer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSwiper() {
    return FutureBuilder(
      future: movieProvider.getOnStage(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            layoutOption: 'STACK',
            items: snapshot.data,
          );
        } else {
          return Center(
              child: Loading(
            indicator: BallScaleIndicator(),
            size: 100,
          ));
        }
      },
    );
  }

  _footer(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 15),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Populares',
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: StreamBuilder(
                stream: movieProvider.popularStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Movie>> snapshot) {
                  if (snapshot.hasData) {
                    return ListHorizontal(
                      nextPage: movieProvider.getPopular,
                      items: snapshot.data,
                    );
                  } else {
                    return Center(
                        child: Container(
                      child: Center(
                          child: Loading(
                              indicator: BallSpinFadeLoaderIndicator(),
                              size: 50)),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
