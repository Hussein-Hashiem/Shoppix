import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';

abstract class CartRepo {
  Future<Either<Failure,CartEntity>> getCartProducts(); 
  Future<Either<Failure,Unit>>addProductToCart(int productId);
  Future<Either<Failure, Unit>> decreaseProductQuantity(int productId );
  Future<Either<Failure,Unit>>deleteProductFromCart(int productId);
}