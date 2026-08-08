import 'package:flutter/material.dart';

class AuthorPage extends StatelessWidget {
  static const routeName = '/AuthorPage';
  final dynamic authorId;

  const AuthorPage({Key key, this.authorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Автор')),
      body: Center(child: Text('Author: $authorId')),
    );
  }
}
