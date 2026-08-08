import 'package:flutter/material.dart';

class GenrePage extends StatelessWidget {
  static const routeName = '/GenrePage';
  final dynamic genre;

  const GenrePage({Key key, this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Жанр')),
      body: Center(child: Text('Genre: $genre')),
    );
  }
}
