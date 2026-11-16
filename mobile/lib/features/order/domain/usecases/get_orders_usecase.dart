import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/order/domain/entities/order_entity.dart';
import 'package:mobile/features/order/domain/repo/order_repo.dart';

class GetOrdersUsecase implements UseCase<List<OrderEntity>, NoParams> {
  final OrderRepo repo;
  GetOrdersUsecase(this.repo);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) {
    return repo.getMyOrders();
  }
}
