import 'package:equatable/equatable.dart';
import 'package:flibusta/model/userContactData.dart';

abstract class UserContactDataState extends Equatable {
  const UserContactDataState();
  @override
  List<Object> get props => [];
}

class UserContactDataInitial extends UserContactDataState {}

class UserContactDataLoading extends UserContactDataState {}

class UserContactDataLoaded extends UserContactDataState {
  final UserContactData data;
  UserContactDataLoaded(this.data);
  @override
  List<Object> get props => [data];
}

class UserContactDataError extends UserContactDataState {
  final String message;
  UserContactDataError(this.message);
  @override
  List<Object> get props => [message];
}
