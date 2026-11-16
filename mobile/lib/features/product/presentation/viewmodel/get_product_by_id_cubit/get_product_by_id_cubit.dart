import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/product/domain/usecases/get_product_by_id.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_product_by_id_cubit/get_product_by_id_states.dart';

class GetProductByIdCubit extends Cubit<GetProductByIdStates> {
  GetProductByIdCubit(this.usecase)
    : super(InitialGetProductByIdStates());
  final GetProductByIdUsecase usecase;

  void getProductById(int id) async {
    emit(LoadingGetProductByIdStates());
    final response = await usecase(ProductParams(id: id));

    response.fold(
      (fail) => emit(FailGetProductByIdStates(message: fail.message)),
      (success) => emit(SuccessGetProductByIdStates(products: success)),
    );
  }
}
