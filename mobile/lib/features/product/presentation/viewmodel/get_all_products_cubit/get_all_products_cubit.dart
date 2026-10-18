import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/product/domain/usecases/get_products_usecase.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_states.dart';

class GetAllProductsCubit extends Cubit<GetAllProductsStates> {
  GetAllProductsCubit(this.usecase, this.secureTokenStorage)
    : super(InitialGetAllProductState());
  final GetProductsUsecase usecase;
  final SecureTokenStorage secureTokenStorage;

  void getAllProducts() async {
    emit(LoadingGetAllProductState());
    final token = await secureTokenStorage.readToken();
    final response = await usecase(AllProductsParams(token));

    response.fold(
      (fail) => emit(FailGetAllProductState(message: fail.message)),
      (success) => emit(SuccessGetAllProductState(products: success)),
    );
  }
}
