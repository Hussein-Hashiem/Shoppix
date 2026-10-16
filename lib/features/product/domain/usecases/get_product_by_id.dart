import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/domain/repo/product_repo.dart';

class GetProductByIdUsecase implements UseCase<ProductEntity, ProductParams> {
  final ProductRepo productRepo;
  GetProductByIdUsecase(this.productRepo);
  @override
  Future<Either<Failure, ProductEntity>> call(ProductParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class ProductParams extends Equatable {
  final int id;

  ProductParams({required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
