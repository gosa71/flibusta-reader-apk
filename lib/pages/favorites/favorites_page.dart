import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  static const routeName = '/FavoritesPage';
  final dynamic favoritesType;

  const FavoritesPage({Key key, this.favoritesType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Избранное')),
      body: Center(child: Text('Favorites')),
    );
  }
}
