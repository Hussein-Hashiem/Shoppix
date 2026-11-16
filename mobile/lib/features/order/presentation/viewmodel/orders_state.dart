// orders_state.dart
import 'package:equatable/equatable.dart';
import 'package:mobile/features/order/domain/entities/order_entity.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersSuccess extends OrdersState {
  final List<OrderEntity> orders;
  const OrdersSuccess({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrdersFailure extends OrdersState {
  final String message;
  const OrdersFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
