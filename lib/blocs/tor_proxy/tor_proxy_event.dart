import 'package:equatable/equatable.dart';

abstract class TorProxyEvent extends Equatable {
  const TorProxyEvent();
  @override
  List<Object> get props => [];
}

class StartTorProxyEvent extends TorProxyEvent {}

class StopTorProxyEvent extends TorProxyEvent {}
