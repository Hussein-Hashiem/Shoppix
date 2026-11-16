import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/features/order/domain/entities/create_order_item_entity.dart';
import 'package:mobile/features/order/domain/usecases/create_order_usecase.dart';

import 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrderUsecase createOrderUsecase;

  CreateOrderCubit({required this.createOrderUsecase})
    : super(const CreateOrderInitial());

  Future<void> placeOrder(CartEntity cart) async {
    emit(const CreateOrderLoading());

    final items = cart.items
        .map(
          (item) => CreateOrderItemEntity(
            productId: item.product.id,
            quantity: item.quantity,
          ),
        )
        .toList();

    final result = await createOrderUsecase(CreateOrderParams(items: items));

    result.fold(
      (failure) => emit(CreateOrderFailure(message: failure.message)),
      (order) => emit(CreateOrderSuccess(cart: cart, order: order)),
    );
  }

  void reset() => emit(const CreateOrderInitial());
}
