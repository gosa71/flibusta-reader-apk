import 'package:flutter/gestures.dart';
import 'package:flibusta/model/fb2/fb2_book.dart';
import 'package:flibusta/pages/book_reader/components/reader_bookmarks_sheet.dart';
import 'package:flibusta/pages/book_reader/components/reader_search_sheet.dart';
import 'package:flibusta/pages/book_reader/components/reader_settings_sheet.dart';
import 'package:flibusta/pages/book_reader/components/reader_toc_sheet.dart';
import 'package:flibusta/pages/book_reader/reader_paginator.dart';
import 'package:flibusta/pages/book_reader/reader_theme.dart';
import 'package:flibusta/services/local_storage.dart';
import 'package:flibusta/utils/fb2_parser.dart';
import 'package:flibusta/utils/native_methods.dart';
import 'package:flutter/material.dart';

const double _kTopPadding = 12;
const double _kBottomPadding = 12;
const double _kFooterHeight = 44;

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
  Fb2Book _book;

  List<ReaderPage> _pages;
  PageController _pageController;
  int _currentPageIndex = 0;
  bool _paginating = false;
  Size _lastPaginatedSize;
  ReaderTypography _lastPaginatedTypography;

  double _fontSize = 18;
  int _themeIndex = 0;
  double _brightness = 1.0;
  double _margin = 24;
  bool _showSystemUI = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _bookFuture = Fb2Parser.parseFromFile(widget.filePath).then((book) {
      _book = book;
      return book;
    });
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
    _pageController?.dispose();
    super.dispose();
  }

  void _paginate(Size size, ReaderTypography typography) {
    if (_book == null || _paginating) return;
    if (_lastPaginatedSize == size && _lastPaginatedTypography == typography) return;
    _paginating = true;
    _lastPaginatedSize = size;
    _lastPaginatedTypography = typography;

    final pages = ReaderPaginator.paginate(
      book: _book,
      size: size,
      typography: typography,
      margin: _margin,
    );
    if (mounted) {
      setState(() {
        _pages = pages;
        _paginating = false;
        if (_pageController == null) {
          _pageController = PageController(initialPage: _currentPageIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Fb2Book>(
      future: _bookFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Ошибка')),
            body: Center(child: Text('Не удалось открыть книгу: ${snapshot.error}')),
          );
        }
        final book = snapshot.data;
        final readerTheme = kReaderThemes[_themeIndex % kReaderThemes.length];
        final typography = ReaderTypography(
          fontSize: _fontSize,
          fontFamily: 'PTSerif',
          lineHeight: 1.5,
        );

        return Scaffold(
          backgroundColor: readerTheme.backgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(
                  constraints.maxWidth,
                  constraints.maxHeight - (_showSystemUI ? _kFooterHeight : 0),
                );
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _paginate(size, typography);
                });

                if (_pages == null || _paginating) {
                  return Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _showSystemUI = !_showSystemUI);
                          try {
                            NativeMethods.setSystemUIVisible(_showSystemUI);
                          } catch (_) {}
                        },
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pages.length,
                          onPageChanged: (i) => setState(() => _currentPageIndex = i),
                          itemBuilder: (context, index) {
                            final page = _pages[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: _margin,
                                vertical: _kTopPadding,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: page.spans ?? [],
                                  style: TextStyle(
                                    color: readerTheme.textColor,
                                    fontSize: typography.fontSize,
                                    fontFamily: typography.fontFamily,
                                    height: typography.lineHeight,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (_showSystemUI)
                      Container(
                        height: _kFooterHeight,
                        color: readerTheme.backgroundColor.withOpacity(0.95),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.list, color: readerTheme.textColor),
                              onPressed: () {
                                try {
                                  showReaderTocSheet(context, book, (ch) {});
                                } catch (_) {}
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.bookmark_border, color: readerTheme.textColor),
                              onPressed: () {
                                try {
                                  showReaderBookmarksSheet(context);
                                } catch (_) {}
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.search, color: readerTheme.textColor),
                              onPressed: () {
                                try {
                                  showReaderSearchSheet(context, book);
                                } catch (_) {}
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.settings, color: readerTheme.textColor),
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
                            Text(
                              '${_currentPageIndex + 1} / ${_pages.length}',
                              style: TextStyle(
                                color: readerTheme.textColor,
                                fontSize: _fontSize - 2,
                              ),
                            ),
                          ],
                        ),
                      ),
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
