import 'package:bloc/bloc.dart';
import 'package:flibusta/model/genre.dart';
import 'package:flibusta/services/http_client/http_client.dart';
import 'package:flibusta/utils/html_parsers.dart';

class GenresListBloc extends Cubit<List<Genre>> {
  GenresListBloc() : super([]) {
    load();
  }

  Future<void> load() async {
    try {
      final response = await ProxyHttpClient().getHtml('/g');
      final genres = parseGenresList(response);
      emit(genres);
    } catch (e) {
      emit([]);
    }
  }
}
