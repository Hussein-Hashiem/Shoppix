import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/domain/repo/product_repo.dart';

class GetProductsUsecase
    implements UseCase<List<ProductEntity>, AllProductsParams> {
  final ProductRepo productRepo;

  GetProductsUsecase({required this.productRepo});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    AllProductsParams params,
  ) async {
    return await productRepo.getAllProducts(token: params.token);
  }
}

class AllProductsParams extends Equatable {
  String? token;
  AllProductsParams(this.token);
  @override
  List<Object?> get props => [token];
}
