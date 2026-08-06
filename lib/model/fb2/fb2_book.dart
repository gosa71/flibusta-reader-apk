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

/// Кусок текста параграфа. Если [noteId] не null — это кликабельная
/// ссылка на сноску из <body name="notes">.
class Fb2Span {
  final String text;
  final String noteId;

  Fb2Span(this.text, {this.noteId});
}

class Fb2Block {
  final Fb2BlockType type;
  final String text;
  final List<Fb2Span> spans;
  final Uint8List imageBytes;
  final List<List<String>> tableRows;

  /// Ширина/высота картинки в пикселях — заполняется асинхронно после
  /// декодирования, нужно для точной постраничной разбивки.
  double imageWidth;
  double imageHeight;

  Fb2Block(
    this.type,
    this.text, {
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
  final String title;
  final String author;
  final List<Fb2Chapter> chapters;

  /// id сноски (из <section id="..."> внутри <body name="notes">) -> текст.
  final Map<String, String> notes;

  Fb2Book({this.title, this.author, this.chapters, this.notes = const {}});
}

class Fb2ParseException implements Exception {
  final String message;

  Fb2ParseException(this.message);

  @override
  String toString() => message;
}
