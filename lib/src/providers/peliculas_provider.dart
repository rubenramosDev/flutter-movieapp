import 'package:peliculas/src/models/pelicula_model.dart';

import 'dart:async';
import 'package:peliculas/src/secrets/keys.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = keys.movieDatabase;
  String _url = 'api.themoviedb.org';
  String _lenguaje = 'en-EN';

  int _topRatedPage = 0;
  bool _bandera = false;

  List<Pelicula> _listaTopRated = new List();

  //Si no se coloca broadcast este controller solo podria tener un listener
  final _topRatedStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get topRatedSkin =>
      _topRatedStreamController.sink.add;

  Stream<List<Pelicula>> get topRatedStream => _topRatedStreamController.stream;

  void disposeStreams() {
    _topRatedStreamController?.close();
  }

  Future<List<Pelicula>> getPopular() async {
    final url = Uri.https(
      _url,
      '3/movie/popular',
      {'api_key': _apiKey, 'language': _lenguaje},
    );

    return await httpRequest(url);
  }

  Future<List<Pelicula>> getTopRated() async {
    if (_bandera) return [];

    _bandera = true;

    _topRatedPage++;

    final url = Uri.https(
      _url,
      '3/movie/top_rated',
      {
        'api_key': _apiKey,
        'language': _lenguaje,
        'page': _topRatedPage.toString(),
      },
    );
    final response = await httpRequest(url);
    _listaTopRated.addAll(response);
    topRatedSkin(_listaTopRated);

    _bandera = false;
    return response;
  }

  Future<List<Pelicula>> httpRequest(Uri url) async {
    final response = await http.get(url);
    final dataDecoded = json.decode(response.body);
    final peliculas = new Peliculas.fromJsonList(dataDecoded['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> buscarPeliculas(String query) async {
    final url = Uri.https(
      _url,
      '3/search/movie',
      {
         'api_key': _apiKey,
        'language': _lenguaje,
           'query': query,
      },
    );

    return await httpRequest(url);
  }
}
