import 'package:bloc/bloc.dart';
import 'package:flibusta/services/local_storage.dart';

class BookLanguagesBloc extends Cubit<List<String>> {
  BookLanguagesBloc() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final langs = await LocalStorage().getBookLanguages();
    emit(langs ?? ['ru', 'en']);
  }

  Future<void> setLanguages(List<String> langs) async {
    await LocalStorage().setBookLanguages(langs);
    emit(langs);
  }
}
