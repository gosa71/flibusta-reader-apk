// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searchResults.dart';

// ***************************************************************************
// JsonSerializableGenerator
// ***************************************************************************

SearchResults _$SearchResultsFromJson(Map<String, dynamic> json) {
  return SearchResults(
    books: (json['books'] as List)
        ?.map((e) => e == null ? null : BookCard.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$SearchResultsToJson(SearchResults instance) =>
    <String, dynamic>{
      'books': instance.books,
      'totalCount': instance.totalCount,
    };
