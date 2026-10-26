import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/cart/domain/repo/cart_repo.dart';

class DecreaseProductQuantityUsecase
    implements UseCase<Unit, DecreaseProductParams> {
  final CartRepo cartRepo;

  DecreaseProductQuantityUsecase({required this.cartRepo});

  @override
  Future<Either<Failure, Unit>> call(DecreaseProductParams params) {
    return cartRepo.decreaseProductQuantity(params.id);
  }
}

class DecreaseProductParams extends Equatable {
  final int id;

  const DecreaseProductParams({required this.id});

  @override
  List<Object?> get props => [id];
}
