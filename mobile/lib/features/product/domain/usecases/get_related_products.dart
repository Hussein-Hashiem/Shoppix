import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/domain/repo/product_repo.dart';

class GetRelatedProductsUsecase
    implements UseCase<List<ProductEntity>, RelatedProductsParams> {
  final ProductRepo productRepo;

  GetRelatedProductsUsecase(this.productRepo);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    RelatedProductsParams params,
  ) {
    return productRepo.getRelatedProducts(
      productId: params.productId,
      limit: params.limit,
    );
  }
}

class RelatedProductsParams extends Equatable {
  final int productId;
  final int limit;

  const RelatedProductsParams({required this.productId, this.limit = 2});

  @override
  List<Object?> get props => [productId, limit];
}
