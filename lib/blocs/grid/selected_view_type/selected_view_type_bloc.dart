import 'package:bloc/bloc.dart';
import 'package:flibusta/model/enums/gridViewType.dart';

class SelectedViewTypeBloc extends Cubit<GridViewType> {
  SelectedViewTypeBloc() : super(GridViewType.newBooks);

  void setViewType(GridViewType type) {
    emit(type);
  }
}
