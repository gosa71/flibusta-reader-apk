import 'package:json_annotation/json_annotation.dart';
import 'package:flibusta/model/grid_data/grid_data.dart';

part 'bookCard.g.dart';

@JsonSerializable()
class BookCard extends GridData {
  @JsonKey(name: 'id')
  int id;
  String title;
  String authors;
  String sequenceTitle;
  int sequenceNumber;
  String genres;
  String size;
  String addedDate;
  String downloadFormats;
  int score;
  String filePath;

  BookCard({
    this.id,
    this.title,
    this.authors,
    this.sequenceTitle,
    this.sequenceNumber,
    this.genres,
    this.size,
    this.addedDate,
    this.downloadFormats,
    this.score,
    this.filePath,
  });

  factory BookCard.fromJson(Map<String, dynamic> json) =>
      _$BookCardFromJson(json);
  Map<String, dynamic> toJson() => _$BookCardToJson(this);

  @override
  String get tileTitle => title ?? '';

  @override
  String get tileSubtitle => authors ?? '';
}
