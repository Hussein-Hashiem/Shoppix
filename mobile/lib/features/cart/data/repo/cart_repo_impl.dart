import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/exception_handler.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/cart/data/data_sources/cart_local_data_source.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/features/cart/domain/repo/cart_repo.dart';
import 'package:mobile/features/product/domain/repo/product_repo.dart';

class CartRepoImpl implements CartRepo {
  final CartLocalDataSource cartLocalDataSource;
  final ProductRepo productRepo;

  CartRepoImpl({required this.cartLocalDataSource, required this.productRepo});
  @override
  Future<Either<Failure, Unit>> addProductToCart(int productId) async {
    try {
      final products = await cartLocalDataSource.getCartProducts();
      final index = products.indexWhere((p) => p.productId == productId);
      if (index == -1) {
        products.add(CartModel(productId: productId, productQuantity: 1));
      } else {
        products[index] = CartModel(
          productId: productId,
          productQuantity: products[index].productQuantity + 1,
        );
      }
      await cartLocalDataSource.saveCartProducts(products);
      return right(unit);
    } on CacheException catch (e) {
      final ExceptionHandler handler = ExceptionHandler();
      return left(handler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> decreaseProductQuantity(int productId) async {
    try {
      final products = await cartLocalDataSource.getCartProducts();
      final index = products.indexWhere((p) => p.productId == productId);
      if (index == -1) return right(unit);
      if (products[index].productQuantity == 1) {
        products.removeAt(index);
      } else {
        products[index] = CartModel(
          productId: productId,
          productQuantity: products[index].productQuantity - 1,
        );
      }
      await cartLocalDataSource.saveCartProducts(products);
      return right(unit);
    } on CacheException catch (e) {
      final ExceptionHandler handler = ExceptionHandler();
      return left(handler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProductFromCart(int productId) async{
    try {
      final products = await cartLocalDataSource.getCartProducts();
      final index = products.indexWhere((p) => p.productId == productId);
      if(index==-1)return right(unit);
      products.removeAt(index);
      await cartLocalDataSource.saveCartProducts(products);
      return right(unit);
    }on CacheException catch (e) {
      final ExceptionHandler handler = ExceptionHandler();
      return left(handler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCartProducts() async {
    try {
      final List<CartModel> localProducts = await cartLocalDataSource
          .getCartProducts();
      final cartItems = <CartItemEntity>[];
      for (final saved in localProducts) {
        final result = await productRepo.getProductById(id: saved.productId);
        final failure = result.fold((f) => f, (b) {
          cartItems.add(
            CartItemEntity(product: b, quantity: saved.productQuantity),
          );
          return null;
        });
        if (failure == null) continue;
        if (failure is NotFoundFailure) continue;
        return left(failure);
      }
      return right(CartEntity(items: cartItems));
    } on CacheException catch (e) {
      final ExceptionHandler handler = ExceptionHandler();
      return left(handler.handleException(e));
    }
  }
}
