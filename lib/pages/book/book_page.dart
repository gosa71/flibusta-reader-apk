import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  static const routeName = '/BookPage';
  final dynamic bookCard;
  final dynamic bookId;

  const BookPage({Key key, this.bookCard, this.bookId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Книга')),
      body: Center(child: Text('Book Page ${bookId ?? bookCard}')),
    );
  }
}
