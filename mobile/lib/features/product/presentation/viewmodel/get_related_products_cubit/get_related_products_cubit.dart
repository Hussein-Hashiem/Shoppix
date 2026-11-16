import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/product/domain/usecases/get_related_products.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_related_products_cubit/get_related_products_states.dart';

class GetRelatedProductsCubit extends Cubit<GetRelatedProductsStates> {
  GetRelatedProductsCubit(this.usecase)
    : super(InitialGetRelatedProductsState());

  final GetRelatedProductsUsecase usecase;

  Future<void> getRelatedProducts(int productId, {int limit = 2}) async {
    emit(LoadingGetRelatedProductsState());
    final result = await usecase(
      RelatedProductsParams(productId: productId, limit: limit),
    );
    result.fold(
      (failure) => emit(FailGetRelatedProductsState(message: failure.message)),
      (products) => emit(SuccessGetRelatedProductsState(products: products)),
    );
  }
}
