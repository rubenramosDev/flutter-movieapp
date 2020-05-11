import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class SwipeFooterWidget extends StatelessWidget {
  final List<Pelicula> items;
  final Function siguientePagina;

  SwipeFooterWidget({@required this.items, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.26,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * .3,
      child: PageView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          return _crearTarjetaIndividual(context, items[i]);
        },
        pageSnapping: false,
        controller: _pageController,
      ),
    );
  }

  Widget _crearTarjetaIndividual(BuildContext context,
   Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-footer';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 2.0),
      child: Column(
        children: <Widget>[
          Hero(
            /*El tag debe ser un 'ancla' que va a indicar hacia
            donde va la animacion, es una llame unique */
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 8.0),
              Text(
                pelicula.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
              Text(
                pelicula.voteAverage.toString(),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: tarjeta,
    );
  }

/* Antes se estaba usando este widget pero se sustituo por _crearTarjetaIndividual 
para mejorar las peticiones y el renderizado (Paginacion)
  List<Widget> _tarjetas(BuildContext context) {
    return items.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 2.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 8.0),
                Text(
                  pelicula.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  pelicula.voteAverage.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            )
          ],
        ),
      );
    }).toList();
  }*/
}
