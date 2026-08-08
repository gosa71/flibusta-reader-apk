import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flibusta/services/local_storage.dart';

class BookFormatsBloc extends Cubit<List<String>> {
  BookFormatsBloc() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final formats = await LocalStorage().getBookFormats();
    emit(formats ?? ['fb2', 'epub', 'mobi', 'pdf', 'txt']);
  }

  Future<void> setFormats(List<String> formats) async {
    await LocalStorage().setBookFormats(formats);
    emit(formats);
  }
}
