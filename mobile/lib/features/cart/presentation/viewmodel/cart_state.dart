import 'package:equatable/equatable.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartSuccess extends CartState {
  final CartEntity cart;

  const CartSuccess({required this.cart});

  @override
  List<Object?> get props => [cart];
}

class CartFail extends CartState {
  final String message;

  const CartFail({required this.message});

  @override
  List<Object?> get props => [message];
}
