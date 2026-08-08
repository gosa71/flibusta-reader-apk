import 'package:equatable/equatable.dart';

abstract class UserContactDataEvent extends Equatable {
  const UserContactDataEvent();
  @override
  List<Object> get props => [];
}

class LoadUserContactDataEvent extends UserContactDataEvent {}
