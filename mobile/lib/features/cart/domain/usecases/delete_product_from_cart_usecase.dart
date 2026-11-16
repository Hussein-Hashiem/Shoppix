import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/cart/domain/repo/cart_repo.dart';

class DeleteProductFromCartUsecase implements UseCase<Unit,DeleteProductParams> {
  final CartRepo cartRepo;

  DeleteProductFromCartUsecase({required this.cartRepo});

  @override
  Future<Either<Failure, Unit>> call(DeleteProductParams params) {
    return cartRepo.deleteProductFromCart(params.id);
  }
}

class DeleteProductParams extends Equatable{
  final int id;

  const DeleteProductParams({required this.id});

  @override
  List<Object?> get props => [id];
}