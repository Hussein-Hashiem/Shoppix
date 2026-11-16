import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/order/domain/entities/create_order_item_entity.dart';
import 'package:mobile/features/order/domain/entities/order_entity.dart';

abstract class OrderRepo {
  Future<Either<Failure, OrderEntity>> createOrder(
    List<CreateOrderItemEntity> items,
  );
  Future<Either<Failure, List<OrderEntity>>> getMyOrders();
}
