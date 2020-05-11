import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/secrets/keys.dart';
import 'package:http/http.dart' as http;

class ActoresProvider {
  String _apiKey = keys.movieDatabase;
  String _url = 'api.themoviedb.org';
  String _lenguaje = 'en-EN';

  Future<List<Actor>> getCast(String peliculaId) async {
    final url = Uri.https(
      _url,
      '3/movie/$peliculaId/credits',
      {'api_key': _apiKey, 'language': _lenguaje},
    );

    final response = await http.get(url);
    final decodeData = json.decode(response.body);

    final cast = new Cast.fromJsonList(decodeData['cast']);
    return cast.actores;
  }
}
