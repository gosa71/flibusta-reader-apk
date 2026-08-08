import 'package:json_annotation/json_annotation.dart';
import 'package:flibusta/model/bookCard.dart';

part 'searchResults.g.dart';

@JsonSerializable()
class SearchResults {
  List<BookCard> books;
  int totalCount;

  SearchResults({this.books, this.totalCount});

  factory SearchResults.fromJson(Map<String, dynamic> json) =>
      _$SearchResultsFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultsToJson(this);
}
