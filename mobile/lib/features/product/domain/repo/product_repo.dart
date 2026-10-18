import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';

abstract class ProductRepo {
  Future<Either<Failure, ProductEntity>> getProductById({required int id});
  Future<Either<Failure, List<ProductEntity>>> getAllProducts({String? token});
}
