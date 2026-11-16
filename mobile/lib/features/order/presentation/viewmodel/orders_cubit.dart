import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/order/domain/usecases/get_orders_usecase.dart';

import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUsecase getOrdersUsecase;

  OrdersCubit({required this.getOrdersUsecase}) : super(const OrdersLoading());

  Future<void> getOrders() async {
    emit(const OrdersLoading());
    final result = await getOrdersUsecase(NoParams());
    result.fold(
      (failure) => emit(OrdersFailure(message: failure.message)),
      (orders) => emit(OrdersSuccess(orders: orders)),
    );
  }
}
