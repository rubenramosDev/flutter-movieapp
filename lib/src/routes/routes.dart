import 'package:flutter/material.dart';

import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle.dart';

class _Routes {
  Map<String, WidgetBuilder> routesGenerator() {
    return <String, WidgetBuilder>{
      '/': (BuildContext context) => HomePage(),
      'detalle': (BuildContext context) => PeliculaDetalle(),
    };
  }
}

final routesGenerator = new _Routes();
