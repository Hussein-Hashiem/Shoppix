import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/cart/domain/repo/cart_repo.dart';

class ClearCartUsecase implements UseCase<Unit, NoParams> {
  final CartRepo cartRepo;

  ClearCartUsecase({required this.cartRepo});

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return cartRepo.clearCart();
  }
}
