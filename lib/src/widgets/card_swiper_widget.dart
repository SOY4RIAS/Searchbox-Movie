import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_searchbox/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  /**
   *  * Allowed Values: 
   *    * 'STACK'
   *    * 'TINDER'
   *    * 'DEFAULT'
   */
  String layoutOption;

  final List<Movie> items;

  double height, itemHeight, itemWidth;

  final Map<String, dynamic> _layoutOpts = {
    'STACK': SwiperLayout.STACK,
    'TINDER': SwiperLayout.TINDER,
    'DEFAULT': SwiperLayout.DEFAULT
  };

  CardSwiper({
    @required this.items,
    this.height = 300,
    this.itemWidth = 200,
    this.itemHeight = double.infinity,
    this.layoutOption,
  });

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;

    return Container(
        child: new Swiper(
      layout: _layoutOpts[layoutOption],
      itemHeight: _screenSize.height * 0.5,
      itemWidth: _screenSize.width * 0.7,
      itemBuilder: (BuildContext context, int index) {
        items[index].uniqueId = '${items[index].id}-card';
        return Hero(
          tag: items[index].uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'detail',
                      arguments: items[index]);
                },
                child: FadeInImage(
                  placeholder: AssetImage('lib/assets/img/loading.gif'),
                  image: NetworkImage(items[index].getPosterImg()),
                  fit: BoxFit.cover,
                  fadeInCurve: Curves.slowMiddle,
                  fadeOutCurve: Curves.slowMiddle,
                ),
              ),
            ),
          ),
        );
      },
      itemCount: items.length,
    ));
  }
}
