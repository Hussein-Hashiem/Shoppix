import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/exception_handler.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/product/data/data_sources/product_data_source.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/domain/repo/product_repo.dart';

class ProductRepoImpl implements ProductRepo {
  final ProductDataSource productDataSource;

  new({required this.productDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    String? token,
  }) async {
    try {
      final List<ProductEntity> response = await productDataSource
          .getAllProducts(token: token);
      return right(
        response
            .map(
              (product) => ProductEntity(
                id: product.id,
                description: product.description,
                name: product.name,
                price: product.price,
                stockQuantity: product.stockQuantity,
                imageUrl: product.imageUrl,
              ),
            )
            .toList(),
      );
    } on ServerException catch (e) {
      final ExceptionHandler handler = ExceptionHandler();
      return left(handler.handleException(e));
    } on NetworkException catch (e) {
      final ExceptionHandler handler = ExceptionHandler();
      return left(handler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById({required int id}) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }
}
