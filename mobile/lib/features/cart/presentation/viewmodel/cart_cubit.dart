import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:mobile/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:mobile/features/cart/domain/usecases/add_product_to_cart_usecase.dart';
import 'package:mobile/features/cart/domain/usecases/decrease_product_quantity_usecase.dart';
import 'package:mobile/features/cart/domain/usecases/delete_product_from_cart_usecase.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUsecase getCartUsecase;
  final AddProductToCartUsecase addProductToCartUsecase;
  final DecreaseProductQuantityUsecase decreaseProductQuantityUsecase;
  final DeleteProductFromCartUsecase deleteProductFromCartUsecase;
  final ClearCartUsecase clearCartUsecase;

  CartCubit({
    required this.getCartUsecase,
    required this.addProductToCartUsecase,
    required this.decreaseProductQuantityUsecase,
    required this.deleteProductFromCartUsecase,
    required this.clearCartUsecase,
  }) : super(const CartLoading());

  Future<void> getCartProducts() async {
    emit(const CartLoading());

    final result = await getCartUsecase(NoParams());

    result.fold(
      (failure) => emit(CartFail(message: failure.message)),
      (cart) => emit(CartSuccess(cart: cart)),
    );
  }

  Future<void> addProductToCart(int productId, {int quantity = 1}) async {
    final result = await addProductToCartUsecase(
      AddProductParams(productId: productId, quantity: quantity),
    );

    await result.fold(
      (failure) async {
        emit(CartFail(message: failure.message));
      },
      (_) async {
        await getCartProducts();
      },
    );
  }

  Future<void> decreaseProductQuantity(int productId) async {
    final result = await decreaseProductQuantityUsecase(
      DecreaseProductParams(id: productId),
    );

    await result.fold(
      (failure) async {
        emit(CartFail(message: failure.message));
      },
      (_) async {
        await getCartProducts();
      },
    );
  }

  Future<void> deleteProductFromCart(int productId) async {
    final result = await deleteProductFromCartUsecase(
      DeleteProductParams(id: productId),
    );

    await result.fold(
      (failure) async {
        emit(CartFail(message: failure.message));
      },
      (_) async {
        await getCartProducts();
      },
    );
  }

  Future<String?> clearCart() async {
    final result = await clearCartUsecase(NoParams());
    return result.fold(
      (failure) {
        emit(CartFail(message: failure.message));
        return failure.message;
      },
      (_) {
        emit(const CartSuccess(cart: CartEntity(items: [])));
        return null;
      },
    );
  }
}
