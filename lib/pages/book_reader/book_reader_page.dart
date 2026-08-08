import 'package:flibusta/model/fb2/fb2_book.dart';
import 'package:flibusta/pages/book_reader/components/reader_bookmarks_sheet.dart';
import 'package:flibusta/pages/book_reader/components/reader_search_sheet.dart';
import 'package:flibusta/pages/book_reader/components/reader_settings_sheet.dart';
import 'package:flibusta/pages/book_reader/components/reader_toc_sheet.dart';
import 'package:flibusta/pages/book_reader/reader_theme.dart';
import 'package:flibusta/services/local_storage.dart';
import 'package:flibusta/utils/fb2_parser.dart';
import 'package:flibusta/utils/native_methods.dart';
import 'package:flutter/material.dart';

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
  Future<Fb2Book> _bookFuture;

  double _fontSize = 18;
  int _themeIndex = 0;
  double _brightness = 1.0;
  double _margin = 24;
  bool _showSystemUI = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _bookFuture = Fb2Parser.parseFromFile(widget.filePath);
  }

  Future<void> _loadSettings() async {
    final storage = LocalStorage();
    _fontSize = await storage.getReaderFontSize() ?? 18.0;
    _themeIndex = await storage.getReaderThemeIndex() ?? 0;
    _brightness = await storage.getReaderBrightness() ?? 1.0;
    _margin = await storage.getReaderMargin() ?? 24.0;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final readerTheme = kReaderThemes[_themeIndex % kReaderThemes.length];

    return FutureBuilder<Fb2Book>(
      future: _bookFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: readerTheme.backgroundColor,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Ошибка')),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Не удалось открыть книгу:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final book = snapshot.data;
        final chapters = book.chapters ?? [];

        return Scaffold(
          backgroundColor: readerTheme.backgroundColor,
          appBar: _showSystemUI
              ? AppBar(
                  backgroundColor: readerTheme.appBarColor,
                  title: Text(
                    widget.bookTitle ?? book.title ?? 'Читалка',
                    style: TextStyle(color: readerTheme.textColor, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  iconTheme: IconThemeData(color: readerTheme.textColor),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.list),
                      onPressed: () {
                        try {
                          showReaderTocSheet(context, book, (_) {});
                        } catch (_) {}
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () async {
                        await showReaderSettingsMBS(
                          context,
                          fontSize: _fontSize,
                          themeIndex: _themeIndex,
                          brightness: _brightness,
                          margin: _margin,
                          onChanged: (fs, ti, br, m) {
                            setState(() {
                              _fontSize = fs;
                              _themeIndex = ti;
                              _brightness = br;
                              _margin = m;
                            });
                            final s = LocalStorage();
                            s.setReaderFontSize(fs);
                            s.setReaderThemeIndex(ti);
                            s.setReaderBrightness(br);
                            s.setReaderMargin(m);
                          },
                        );
                      },
                    ),
                  ],
                )
              : null,
          body: GestureDetector(
            onTap: () {
              setState(() => _showSystemUI = !_showSystemUI);
              try {
                NativeMethods.setSystemUIVisible(_showSystemUI);
              } catch (_) {}
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: _margin, vertical: 16),
              itemCount: chapters.length,
              itemBuilder: (context, chapterIndex) {
                final chapter = chapters[chapterIndex];
                final blocks = chapter.blocks ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chapter.title != null && chapter.title.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12, top: 8),
                        child: Text(
                          chapter.title,
                          style: TextStyle(
                            color: readerTheme.textColor,
                            fontSize: _fontSize + 4,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ...blocks.map((block) {
                      final text = block.text ?? '';
                      if (text.isEmpty && block.type == 'empty-line') {
                        return SizedBox(height: _fontSize);
                      }
                      if (text.isEmpty) return SizedBox.shrink();
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          text,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: readerTheme.textColor,
                            fontSize: _fontSize,
                            height: 1.5,
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
