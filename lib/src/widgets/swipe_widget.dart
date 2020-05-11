import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class SwipeWidget extends StatelessWidget {
  final List<Pelicula> items;
  SwipeWidget({@required this.items});

  @override
  Widget build(BuildContext context) {
    /*Dimensiones del dispositivo. Mediaquery...*/

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemHeight: _screenSize.height * .50, //El 50% del dispositivo
        itemWidth: _screenSize.width * .60, //El 70% del dispositivo
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {
          /*Se implementa un nuevo ID, dado que la animacion de
          que en la animacion de hero no pueden existir
          dos widgets con el mismo ID, si no, causa un error. */
          items[index].uniqueId = '${items[index].id}-tajerta';

          return Hero(
            tag: items[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'detalle',
                      arguments: items[index]);
                },
                child: FadeInImage(
                  image: NetworkImage(items[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: items.length,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}
