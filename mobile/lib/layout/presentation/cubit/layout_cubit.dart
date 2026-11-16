import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutState());

  void changeBottomNavIndex(int index) {
    emit(LayoutState(currentIndex: index));
  }
}
