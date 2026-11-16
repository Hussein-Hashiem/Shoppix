import 'package:mobile/features/order/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({super.id, super.orderDate, super.totalPrice, super.status});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int?,
      orderDate: json['orderDate'] == null
          ? null
          : DateTime.parse(json['orderDate'] as String),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      status: json['status'] as String?,
    );
  }
}
