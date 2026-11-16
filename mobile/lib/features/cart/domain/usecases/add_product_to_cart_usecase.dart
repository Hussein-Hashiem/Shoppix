import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/cart/domain/repo/cart_repo.dart';

class AddProductToCartUsecase implements UseCase<Unit, AddProductParams> {
  final CartRepo cartRepo;

  AddProductToCartUsecase({required this.cartRepo});
  @override
  Future<Either<Failure, Unit>> call(AddProductParams params) {
    return cartRepo.addProductToCart(
      params.productId,
      quantity: params.quantity,
    );
  }
}

class AddProductParams extends Equatable {
  final int productId;
  final int quantity;

  const AddProductParams({required this.productId, this.quantity = 1});
  @override
  List<Object?> get props => [productId, quantity];
}
