import 'package:flutter/material.dart';
import 'package:movie_searchbox/src/pages/home_page.dart';
import 'package:movie_searchbox/src/pages/movie_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SearchBox',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detail': (BuildContext context) => MovieDetailPage()
      },
      theme: ThemeData(
          backgroundColor: Colors.black,
          primaryColor: Colors.black,
          primaryColorBrightness: Brightness.dark,
          textTheme: TextTheme(
              title: TextStyle(color: Colors.grey),
              body1: TextStyle(color: Colors.grey),
              body2: TextStyle(color: Colors.grey),
              caption: TextStyle(color: Colors.grey),
              subhead: TextStyle(
                color: Colors.grey,
                fontSize: 30,
              )),
          primarySwatch: Colors.red),
    );
  }
}
