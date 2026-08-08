import 'package:bloc/bloc.dart';
import 'package:flibusta/services/local_storage.dart';

class ProxyListBloc extends Cubit<List<String>> {
  ProxyListBloc() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final list = await LocalStorage().getProxyList();
    emit(list ?? []);
  }

  Future<void> addProxy(String proxy) async {
    final list = List<String>.from(state)..add(proxy);
    await LocalStorage().setProxyList(list);
    emit(list);
  }

  Future<void> removeProxy(String proxy) async {
    final list = List<String>.from(state)..remove(proxy);
    await LocalStorage().setProxyList(list);
    emit(list);
  }
}
