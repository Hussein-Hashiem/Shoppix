import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/domain/usecases/get_products_usecase.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_states.dart';
import 'package:mocktail/mocktail.dart';

class GetAllProductsUsecaseMock extends Mock implements GetProductsUsecase {}

class SecureTokenStorageMock extends Mock implements SecureTokenStorage {}

void main() {
  late GetAllProductsUsecaseMock mock;
  late SecureTokenStorage tokenStorage;
  setUp(() {
    mock = GetAllProductsUsecaseMock();
    tokenStorage = SecureTokenStorageMock();
  });

  group("Testing the states of the getallproducts cubit", () {
    final response = [
      ProductEntity(
        id: 1,
        description: "ofsdijfodsi",
        name: "ifdosifjods",
        price: 40,
        stockQuantity: 20,
        imageUrl: "fjodijfosd",
      ),
      ProductEntity(
        id: 2,
        description: "ofsdijfodsi",
        name: "ifdosifjods",
        price: 40,
        stockQuantity: 20,
        imageUrl: "fjodijfosd",
      ),
      ProductEntity(
        id: 3,
        description: "ofsdijfodsi",
        name: "ifdosifjods",
        price: 40,
        stockQuantity: 20,
        imageUrl: "fjodijfosd",
      ),
    ];
    blocTest<GetAllProductsCubit, GetAllProductsStates>(
      "check if the bloc emits [loading, success] when called",
      build: () {
        when(() => mock(AllProductsParams('1234')))
            .thenAnswer((_) async => right(response));
        when(() => tokenStorage.readToken()).thenAnswer((_) async => "1234");
        return GetAllProductsCubit(mock, tokenStorage);
      },
      act: (bloc) => bloc.getAllProducts(),
      expect: () => [
        LoadingGetAllProductState(),
        SuccessGetAllProductState(products: response),
      ],
      verify: (_) => verify(() => mock(AllProductsParams('1234'))).called(1),
    );
    blocTest<GetAllProductsCubit, GetAllProductsStates>(
      "check if the bloc emits [loading, error] when called",
      build: () {
        when(() => mock(AllProductsParams('1234'))).thenAnswer(
          (_) async => left(
            ServerFailure(
              "Your session may have expired. Please sign in again.",
            ),
          ),
        );
        when(() => tokenStorage.readToken()).thenAnswer((_) async => "1234");
        return GetAllProductsCubit(mock, tokenStorage);
      },
      act: (bloc) => bloc.getAllProducts(),
      expect: () => [
        LoadingGetAllProductState(),
        FailGetAllProductState(
          message: "Your session may have expired. Please sign in again.",
        ),
      ],
      verify: (_) => verify(() => mock(AllProductsParams('1234'))).called(1),
    );
  });
}
