import 'package:bloc/bloc.dart';
import 'package:flibusta/blocs/user_contact_data/user_contact_data_event.dart';
import 'package:flibusta/blocs/user_contact_data/user_contact_data_repository.dart';
import 'package:flibusta/blocs/user_contact_data/user_contact_data_state.dart';

class UserContactDataBloc extends Bloc<UserContactDataEvent, UserContactDataState> {
  final UserContactDataRepository repository;
  UserContactDataBloc(this.repository) : super(UserContactDataInitial());

  @override
  Stream<UserContactDataState> mapEventToState(UserContactDataEvent event) async* {
    if (event is LoadUserContactDataEvent) {
      yield UserContactDataLoading();
      try {
        final data = await repository.getUserContactData();
        yield UserContactDataLoaded(data);
      } catch (e) {
        yield UserContactDataError(e.toString());
      }
    }
  }
}
