import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_searchbox/src/models/actor_model.dart';

import 'package:movie_searchbox/src/models/movie_model.dart';

class MovieProvider {
  String _apiKey = '475493d521cdb37cd2032dcd6653a629';
  String _url = 'api.themoviedb.org';
  String _lang = 'es-ES';

  int _popularPage = 0;
  bool _loadingPopular = false;

  List<Movie> _popular = [];

  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;

  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController.close();
  }

  Future<List<Movie>> getOnStage() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _lang,
    });

    return await _getResultsMovie(url);
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _lang,
      'query': query,
    });

    return await _getResultsMovie(url);
  }

  Future<List<Movie>> getPopular() async {
    final url = Uri.https(_url, '3/movie/popular',
        {'api_key': _apiKey, 'language': _lang, 'page': '$_popularPage'});

    if (_loadingPopular) return [];

    _loadingPopular = true;

    _popularPage++;

    final results = await _getResultsMovie(url);

    _loadingPopular = false;

    _popular.addAll(results);

    popularSink(_popular);

    return results;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits',
        {'api_key': _apiKey, 'language': _lang});

    final results = await _getResultsActors(url);

    return results;
  }

  Future<List<Actor>> _getResultsActors(Uri url) async {
    final res = await http.get(url);
    final decodedData = json.decode(res.body);

    final Cast cast = Cast.fromJsonList(decodedData['cast']);
    return cast.actors;
  }

  Future<List<Movie>> _getResultsMovie(Uri url) async {
    final res = await http.get(url);
    final decodedData = json.decode(res.body);

    final Movies movies = Movies.fromJsonList(decodedData['results']);
    return movies.items;
  }
}
