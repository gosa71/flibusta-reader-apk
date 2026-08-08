import 'package:equatable/equatable.dart';

abstract class TorProxyState extends Equatable {
  const TorProxyState();

  @override
  List<Object> get props => [];
}

class TorProxyInitial extends TorProxyState {}

class TorProxyStarting extends TorProxyState {}

class TorProxyStarted extends TorProxyState {
  final String socksPort;
  TorProxyStarted(this.socksPort);
  @override
  List<Object> get props => [socksPort];
}

class TorProxyStopped extends TorProxyState {}

class TorProxyError extends TorProxyState {
  final String message;
  TorProxyError(this.message);
  @override
  List<Object> get props => [message];
}
