import 'package:equatable/equatable.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/features/order/domain/entities/order_entity.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();
  @override
  List<Object?> get props => [];
}

class CreateOrderInitial extends CreateOrderState {
  const CreateOrderInitial();
}

class CreateOrderLoading extends CreateOrderState {
  const CreateOrderLoading();
}

class CreateOrderSuccess extends CreateOrderState {
  final CartEntity cart;
  final OrderEntity order;
  const CreateOrderSuccess({required this.cart, required this.order});

  @override
  List<Object?> get props => [cart, order];
}

class CreateOrderFailure extends CreateOrderState {
  final String message;
  const CreateOrderFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
