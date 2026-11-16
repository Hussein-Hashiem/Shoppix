import 'package:equatable/equatable.dart';
import 'package:mobile/core/utils/constants/constant_values.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';

class CartEntity extends Equatable {
  final List<CartItemEntity> items;

  const CartEntity({required this.items, });
  //operations
  double get subtotal => items.fold(0, (sum, l) => sum + l.cartItemTotal);
  double get salesTax => ConstantValues.taxValue * subtotal;
  double get total => subtotal + salesTax;

  @override
  List<Object?> get props => [items];
}

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({required this.product, required this.quantity});
  //operations
  double get cartItemTotal => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}
