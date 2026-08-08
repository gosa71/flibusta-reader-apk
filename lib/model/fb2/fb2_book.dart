import 'dart:typed_data';

enum Fb2BlockType {
  chapterTitle,
  title,
  subtitle,
  paragraph,
  emptyLine,
  image,
  table,
}

class Fb2Span {
  final String text;
  final String noteId;
  Fb2Span(this.text, {this.noteId});
}

class Fb2Block {
  final String type; // 'p', 'subtitle', 'empty-line' etc for simplicity
  final String text;
  final List<Fb2Span> spans;
  final Uint8List imageBytes;
  final List<List<String>> tableRows;
  double imageWidth;
  double imageHeight;

  Fb2Block({
    this.type,
    this.text,
    this.spans,
    this.imageBytes,
    this.tableRows,
    this.imageWidth,
    this.imageHeight,
  });
}

class Fb2Chapter {
  final String title;
  final List<Fb2Block> blocks;
  Fb2Chapter({this.title, this.blocks});
}

class Fb2Book {
  String title;
  List<String> authors;
  String annotation;
  String sourcePath;
  List<Fb2Chapter> chapters;
  Map<String, String> notes;

  Fb2Book({
    this.title,
    this.authors,
    this.annotation,
    this.sourcePath,
    this.chapters,
    this.notes = const {},
  });

  String get author => authors != null && authors.isNotEmpty ? authors.join(', ') : '';
}

class Fb2ParseException implements Exception {
  final String message;
  Fb2ParseException(this.message);
  @override
  String toString() => message;
}
