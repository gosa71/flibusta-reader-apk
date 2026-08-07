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
      return StatefulBuilder(
        builder: (context, setState) {
          if (bookmarks.isEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Text(
                'Пока нет закладок. Добавить можно кнопкой с флажком в читалке.',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            addSemanticIndexes: false,
            itemCount: bookmarks.length,
            separatorBuilder: (context, index) => Divider(indent: 16, height: 1),
            itemBuilder: (context, index) {
              var bookmark = bookmarks[index];
              return ListTile(
                leading: Icon(Icons.bookmark),
                title: Text(
                  bookmark.label.isNotEmpty ? bookmark.label : 'Закладка',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, size: 20),
                  onPressed: () {
                    onDelete(bookmark);
                    setState(() => bookmarks.removeAt(index));
                  },
                ),
                onTap: () => Navigator.pop(context, bookmark),
              );
            },
          );
        },
      );
    },
  );
}
