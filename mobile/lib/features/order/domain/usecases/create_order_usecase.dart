// usecases/create_order_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/order/domain/entities/create_order_item_entity.dart';
import 'package:mobile/features/order/domain/entities/order_entity.dart';
import 'package:mobile/features/order/domain/repo/order_repo.dart';

class CreateOrderParams extends Equatable {
  final List<CreateOrderItemEntity> items;
  const CreateOrderParams({required this.items});

  @override
  List<Object?> get props => [items];
}

class CreateOrderUsecase implements UseCase<OrderEntity, CreateOrderParams> {
  final OrderRepo repo;
  CreateOrderUsecase(this.repo);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) {
    return repo.createOrder(params.items);
  }
}
