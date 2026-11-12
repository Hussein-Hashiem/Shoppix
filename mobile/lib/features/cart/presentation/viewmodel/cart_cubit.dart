import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
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

  CartCubit({
    required this.getCartUsecase,
    required this.addProductToCartUsecase,
    required this.decreaseProductQuantityUsecase,
    required this.deleteProductFromCartUsecase,
  }) : super(const CartLoading());

  Future<void> getCartProducts() async {
    emit(const CartLoading());

    final result = await getCartUsecase(NoParams());

    result.fold(
      (failure) => emit(CartFail(message: failure.message)),
      (cart) => emit(CartSuccess(cart: cart)),
    );
  }

  Future<void> addProductToCart(int productId) async {
    final result = await addProductToCartUsecase(
      AddProductParams(productId: productId),
    );

     result.fold(
      (failure)  {
        emit(CartFail(message: failure.message));
      },
      (_) {
        final current = state;
        if (current is! CartSuccess)return; 
        final updated = current.cart.items
            .map((t) => t.product.id == productId ? CartItemEntity(product: t.product, quantity: t.quantity+1) : t)
            .toList(); 
        emit(CartSuccess(cart: CartEntity(items: updated)));
      },
    );
  }

  Future<void> decreaseProductQuantity(int productId) async {
    final result = await decreaseProductQuantityUsecase(
      DecreaseProductParams(id: productId),
    );

     result.fold(
      (failure)  {
        emit(CartFail(message: failure.message));
      },
      (_)  {
        final current= state;
        if (current is! CartSuccess) return;
        final updatedItems = current.cart.items
            .map(
              (r) => r.product.id == productId ? CartItemEntity(product: r.product, quantity: r.quantity - 1) : r,
            ) 
            .where((r) => r.quantity > 0)
            .toList();
            emit(CartSuccess(cart: CartEntity(items: updatedItems)));
      }
    );
  }

  Future<void> deleteProductFromCart(int productId) async {
    final result = await deleteProductFromCartUsecase(
      DeleteProductParams(id: productId),
    );

     result.fold(
      (failure)  {
        emit(CartFail(message: failure.message));
      },
      (_)  {
        final current = state;
        if (current is! CartSuccess) return;
        final kept = current.cart.items
            .where((r) => r.product.id != productId)
            .toList();
        emit(CartSuccess(cart: CartEntity(items: kept)));
      },
    );
  }
}
