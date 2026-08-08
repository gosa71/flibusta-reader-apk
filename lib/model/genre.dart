import 'package:flibusta/model/grid_data/grid_data.dart';

class Genre extends GridData {
  final String name;
  final String code;

  Genre({
    int id,
    this.name,
    this.code,
  }) {
    this.id = id;
  }

  @override
  String get tileSubtitle => this.code;

  @override
  String get tileTitle => this.name;
}
