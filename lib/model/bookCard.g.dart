// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookCard.dart';

// ***************************************************************************
// JsonSerializableGenerator
// ***************************************************************************

BookCard _$BookCardFromJson(Map<String, dynamic> json) {
  return BookCard(
    id: json['id'] as int,
    title: json['title'] as String,
    authors: json['authors'] as String,
    sequenceTitle: json['sequenceTitle'] as String,
    sequenceNumber: json['sequenceNumber'] as int,
    genres: json['genres'] as String,
    size: json['size'] as String,
    addedDate: json['addedDate'] as String,
    downloadFormats: json['downloadFormats'] as String,
    score: json['score'] as int,
    filePath: json['filePath'] as String,
  );
}

Map<String, dynamic> _$BookCardToJson(BookCard instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors,
      'sequenceTitle': instance.sequenceTitle,
      'sequenceNumber': instance.sequenceNumber,
      'genres': instance.genres,
      'size': instance.size,
      'addedDate': instance.addedDate,
      'downloadFormats': instance.downloadFormats,
      'score': instance.score,
      'filePath': instance.filePath,
    };
