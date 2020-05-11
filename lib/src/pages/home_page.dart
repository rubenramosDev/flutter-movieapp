import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/swipe_footer_widget.dart';
import 'package:peliculas/src/widgets/swipe_widget.dart';

class HomePage extends StatelessWidget {
  final peliculas = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculas.getTopRated();

    return Scaffold(
      appBar: AppBar(
        title: Text('Popular movies'),
        backgroundColor: Colors.indigo,
        elevation: 5.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _swiper(),
            _footerSwiper(context),
          ],
        ),
      ),
    );
  }

  Widget _swiper() {
    return FutureBuilder(
      future: peliculas.getPopular(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return SwipeWidget(
            items: snapshot.data,
          );
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _footerSwiper(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: Text('Top rated',
                  style: Theme.of(context).textTheme.subtitle1)),
          StreamBuilder(
            stream: peliculas.topRatedStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SwipeFooterWidget(
                  items: snapshot.data,
                  siguientePagina: peliculas.getTopRated,
                );
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
