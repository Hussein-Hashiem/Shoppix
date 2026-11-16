import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/exception_handler.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/order/data/data_sources/order_remote_data_source.dart';
import 'package:mobile/features/order/data/models/create_order_item_model.dart';
import 'package:mobile/features/order/domain/entities/create_order_item_entity.dart';
import 'package:mobile/features/order/domain/entities/order_entity.dart';
import 'package:mobile/features/order/domain/repo/order_repo.dart';

class OrderRepoImpl implements OrderRepo {
  final OrderRemoteDataSource remoteDataSource;
  final SecureTokenStorage tokenStorage;

  OrderRepoImpl({required this.remoteDataSource, required this.tokenStorage});

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
    List<CreateOrderItemEntity> items,
  ) async {
    final token = await tokenStorage.readToken();
    if (token == null) {
      return  left(
        ServerFailure('You need to sign in to place an order.'),
      );
    }

    try {
      final models = items
          .map(
            (e) => CreateOrderItemModel(
              productId: e.productId,
              quantity: e.quantity,
            ),
          )
          .toList();
      final order = await remoteDataSource.createOrder(models, token: token);
      return right(order);
    } on Exception catch (e) {
      return left(ExceptionHandler().handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders() async {
    final token = await tokenStorage.readToken();
    if (token == null) {
      return  left(
        ServerFailure('You need to sign in to view your orders.'),
      );
    }

    try {
      final orders = await remoteDataSource.getMyOrders(token: token);
      return right(orders);
    } on Exception catch (e) {
      return left(ExceptionHandler().handleException(e));
    }
  }
}
