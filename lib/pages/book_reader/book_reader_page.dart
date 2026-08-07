import 'package:flutter/material.dart';
import 'package:flibusta/model/fb2/fb2_book.dart';

class BookReaderPageArguments {
  final String filePath;
  final String bookTitle;
  BookReaderPageArguments({@required this.filePath, this.bookTitle});
}

class BookReaderPage extends StatefulWidget {
  static const routeName = '/BookReaderPage';
  final String filePath;
  final String bookTitle;
  const BookReaderPage({Key key, this.filePath, this.bookTitle}) : super(key: key);
  @override
  _BookReaderPageState createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bookTitle ?? 'Читалка')),
      body: Center(child: Text('FB2 Reader loading... ${widget.filePath}')),
    );
  }
}
