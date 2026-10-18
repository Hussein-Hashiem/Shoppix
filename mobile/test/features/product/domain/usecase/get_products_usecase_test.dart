import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/domain/repo/product_repo.dart';
import 'package:mobile/features/product/domain/usecases/get_product_by_id.dart';
import 'package:mobile/features/product/domain/usecases/get_products_usecase.dart';
import 'package:mocktail/mocktail.dart';

class ProductRepoMock extends Mock implements ProductRepo {}

void main() {
  late ProductRepoMock productRepoMock;
  late GetProductsUsecase getProductsUsecase;
  setUp(() {
    productRepoMock = ProductRepoMock();
    getProductsUsecase = GetProductsUsecase(productRepo: productRepoMock);
  });
  group("testing the methods of the class", () {
    test("check if the method returns the entities successfully", () async {
      final expected = [
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
      when(() => productRepoMock.getAllProducts(token: "1234"))
          .thenAnswer((_) async => right(expected));

      final result = await getProductsUsecase(AllProductsParams("1234"));

      expect(result, right(expected));

      verify(() => productRepoMock.getAllProducts(token: '1234')).called(1);
    });
    test("check if the method returns ServerFailure", () async {
      final expected = ServerFailure("Your session has expired");
      when(() => productRepoMock.getAllProducts(token: "12345"))
          .thenAnswer((_) async => left(expected));

      final result = await getProductsUsecase(AllProductsParams("1234"));

      expect(result, left(expected));

      verify(() => productRepoMock.getAllProducts(token: "1234")).called(1);
    });
  });
}
