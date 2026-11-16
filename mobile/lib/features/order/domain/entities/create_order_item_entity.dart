import 'package:equatable/equatable.dart';

class CreateOrderItemEntity extends Equatable {
  final int productId;
  final int quantity;

  const CreateOrderItemEntity({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}
