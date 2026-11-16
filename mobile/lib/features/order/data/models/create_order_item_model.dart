import 'package:mobile/features/order/domain/entities/create_order_item_entity.dart';

class CreateOrderItemModel extends CreateOrderItemEntity {
  const CreateOrderItemModel({
    required super.productId,
    required super.quantity,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
  };
}
