import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/features/cart/domain/repo/cart_repo.dart';

class GetCartUsecase implements UseCase<CartEntity,NoParams> {
  final CartRepo  cartRepo;

  GetCartUsecase({required this.cartRepo});

  @override
  Future<Either<Failure, CartEntity>> call(NoParams params) {
    return cartRepo.getCartProducts();
  }
}