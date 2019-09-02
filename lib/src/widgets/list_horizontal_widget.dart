import 'package:flutter/material.dart';
import 'package:movie_searchbox/src/models/movie_model.dart';

class ListHorizontal extends StatelessWidget {
  final List<Movie> items;
  final Function nextPage;

  ListHorizontal({@required this.items, @required this.nextPage});

  final _pageController = PageController(initialPage: 1, viewportFraction: 0.4);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      final currentPixel = _pageController.position.pixels;
      final maxPixel = _pageController.position.maxScrollExtent - 200;

      if (currentPixel >= maxPixel) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int i) =>
            _card(_screenSize, context, items[i]),
      ),
    );
  }

  Widget _card(Size screenSize, BuildContext context, Movie item) {
    item.uniqueId = '${item.id}-poster';

    final Container card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: item.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(blurRadius: 60.0, color: Colors.black38)
                ]),
                child: FadeInImage(
                  image: NetworkImage(item.getPosterImg()),
                  placeholder: AssetImage('lib/assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: screenSize.height * 0.25,
                  width: 160,
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            padding: EdgeInsets.only(top: 5),
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: item);
      },
      child: card,
    );
  }
}
