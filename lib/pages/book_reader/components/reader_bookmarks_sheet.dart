import 'package:flibusta/ds_controls/ui/show_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ReaderBookmark {
  final int chapterIndex;
  final int blockIndex;
  final String label;

  ReaderBookmark({this.chapterIndex, this.blockIndex, this.label});
}

Future<ReaderBookmark> showReaderBookmarksMBS(
  BuildContext context, {
  @required List<ReaderBookmark> bookmarks,
  @required void Function(ReaderBookmark) onDelete,
}) {
  return showDsModalBottomSheet<ReaderBookmark>(
    context: context,
    title: 'Закладки',
    builder: (context) {
      if (bookmarks == null || bookmarks.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('Нет закладок')),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          final b = bookmarks[index];
          return ListTile(
            title: Text(b.label ?? 'Закладка ${index + 1}'),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () => onDelete(b),
            ),
            onTap: () => Navigator.pop(context, b),
          );
        },
      );
    },
  );
}

/// Alias used by BookReaderPage
Future<void> showReaderBookmarksSheet(BuildContext context) async {
  await showReaderBookmarksMBS(
    context,
    bookmarks: [],
    onDelete: (_) {},
  );
}
