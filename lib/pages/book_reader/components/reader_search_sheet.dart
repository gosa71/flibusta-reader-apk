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
  var lowerQuery = query.trim().toLowerCase();
  var results = <ReaderSearchResult>[];

  for (var chapterIndex = 0; chapterIndex < chapters.length; chapterIndex++) {
    var blocks = chapters[chapterIndex].blocks;
    for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
      var block = blocks[blockIndex];
      var text = block.text;
      if (text == null) continue;
      var lowerText = text.toLowerCase();
      var matchIndex = lowerText.indexOf(lowerQuery);
      if (matchIndex == -1) continue;

      var start = (matchIndex - 40).clamp(0, text.length);
      var end = (matchIndex + lowerQuery.length + 60).clamp(0, text.length);
      var snippet = (start > 0 ? '…' : '') +
          text.substring(start, end) +
          (end < text.length ? '…' : '');

      // +1: в разбивке на страницы главы 0-й блок — синтетический
      // заголовок главы, поэтому реальные блоки смещены на 1.
      results.add(ReaderSearchResult(
        chapterIndex: chapterIndex,
        blockIndex: blockIndex + 1,
        snippet: snippet,
      ));

      if (results.length >= 200) return results;
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
    title: 'Поиск по книге',
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          var results = <ReaderSearchResult>[];
          var searching = false;

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Что ищем?',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searching = true;
                      results = searchInBook(chapters, value);
                    });
                  },
                ),
                SizedBox(height: 8),
                if (searching && results.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('Ничего не найдено', style: TextStyle(color: Colors.black54)),
                  ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    addSemanticIndexes: false,
                    itemCount: results.length,
                    separatorBuilder: (context, index) => Divider(indent: 16, height: 1),
                    itemBuilder: (context, index) {
                      var result = results[index];
                      return ListTile(
                        title: Text(
                          result.snippet,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => Navigator.of(context).pop(result),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
