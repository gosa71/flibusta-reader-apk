import 'package:bloc/bloc.dart';
import 'package:flibusta/blocs/tor_proxy/tor_proxy_event.dart';
import 'package:flibusta/blocs/tor_proxy/tor_proxy_state.dart';
import 'package:utopic_tor_onion_proxy/utopic_tor_onion_proxy.dart';

class TorProxyBloc extends Bloc<TorProxyEvent, TorProxyState> {
  TorProxyBloc() : super(TorProxyInitial());

  @override
  Stream<TorProxyState> mapEventToState(TorProxyEvent event) async* {
    if (event is StartTorProxyEvent) {
      yield TorProxyStarting();
      try {
        final port = await UtopicTorOnionProxy.startTor();
        yield TorProxyStarted(port.toString());
      } catch (e) {
        yield TorProxyError(e.toString());
      }
    } else if (event is StopTorProxyEvent) {
      await UtopicTorOnionProxy.stopTor();
      yield TorProxyStopped();
    }
  }
}
