import 'package:flibusta/ds_controls/ui/show_modal_bottom_sheet.dart';
import 'package:flibusta/model/fb2/fb2_book.dart';
import 'package:flutter/material.dart';

Future<int> showReaderTocMBS(
  BuildContext context, {
  @required List<Fb2Chapter> chapters,
  @required int currentChapterIndex,
}) {
  return showDsModalBottomSheet<int>(
    context: context,
    title: 'Содержание',
    builder: (context) {
      return ListView.separated(
        shrinkWrap: true,
        addSemanticIndexes: false,
        itemCount: chapters.length,
        separatorBuilder: (context, index) => Divider(indent: 16, height: 1),
        itemBuilder: (context, index) {
          var isCurrent = index == currentChapterIndex;

          return ListTile(
            title: Text(
              chapters[index].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            trailing: isCurrent ? Icon(Icons.menu_book, size: 18) : null,
            onTap: () => Navigator.pop(context, index),
          );
        },
      );
    },
  );
}
