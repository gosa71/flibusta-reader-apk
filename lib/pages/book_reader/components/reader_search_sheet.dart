import 'package:flibusta/ds_controls/ui/show_modal_bottom_sheet.dart';
import 'package:flibusta/model/fb2/fb2_book.dart';
import 'package:flutter/material.dart';

class ReaderSearchResult {
  final int chapterIndex;
  final int blockIndex;
  final String snippet;

  ReaderSearchResult({this.chapterIndex, this.blockIndex, this.snippet});
}

List<ReaderSearchResult> searchInBook(List<Fb2Chapter> chapters, String query) {
  if (query == null || query.trim().length < 2) return [];
  final lowerQuery = query.trim().toLowerCase();
  final results = <ReaderSearchResult>[];

  for (var chapterIndex = 0; chapterIndex < chapters.length; chapterIndex++) {
    final blocks = chapters[chapterIndex].blocks ?? [];
    for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
      final text = blocks[blockIndex].text;
      if (text == null) continue;
      final lowerText = text.toLowerCase();
      final matchIndex = lowerText.indexOf(lowerQuery);
      if (matchIndex == -1) continue;

      final start = (matchIndex - 40).clamp(0, text.length);
      final end = (matchIndex + lowerQuery.length + 60).clamp(0, text.length);
      final snippet = (start > 0 ? '…' : '') +
          text.substring(start, end) +
          (end < text.length ? '…' : '');

      results.add(ReaderSearchResult(
        chapterIndex: chapterIndex,
        blockIndex: blockIndex,
        snippet: snippet,
      ));
      if (results.length >= 50) return results;
    }
  }
  return results;
}

Future<ReaderSearchResult> showReaderSearchMBS(
  BuildContext context, {
  @required List<Fb2Chapter> chapters,
}) {
  return showDsModalBottomSheet<ReaderSearchResult>(
    context: context,
    title: 'Поиск',
    builder: (context) {
      return _SearchBody(chapters: chapters);
    },
  );
}

class _SearchBody extends StatefulWidget {
  final List<Fb2Chapter> chapters;
  const _SearchBody({this.chapters});

  @override
  __SearchBodyState createState() => __SearchBodyState();
}

class __SearchBodyState extends State<_SearchBody> {
  final _controller = TextEditingController();
  List<ReaderSearchResult> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String q) {
    setState(() {
      _results = searchInBook(widget.chapters, q);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Введите текст…',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _search,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, i) {
              final r = _results[i];
              return ListTile(
                title: Text(r.snippet ?? '', maxLines: 3),
                onTap: () => Navigator.pop(context, r),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Alias used by BookReaderPage
Future<void> showReaderSearchSheet(BuildContext context, Fb2Book book) async {
  await showReaderSearchMBS(context, chapters: book.chapters ?? []);
}
