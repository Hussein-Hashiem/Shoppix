import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/product/data/data_sources/product_data_source.dart';
import 'package:mobile/features/product/data/models/product_model.dart';
import 'package:mobile/features/product/data/repo/product_repo_impl.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/domain/repo/product_repo.dart';
import 'package:mocktail/mocktail.dart';

class ProductDataSourceMock extends Mock implements ProductDataSource {}

void main() {
  late ProductRepo productRepoImpl;
  late ProductDataSourceMock productDataSourceMock;

  setUp(() {
    productDataSourceMock = ProductDataSourceMock();
    productRepoImpl = ProductRepoImpl(productDataSource: productDataSourceMock);
  });

  group("testing the outputs of the getAllProducts method", () {
    test(
      "check if the method returns list of productEntities on success",
      () async {
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
        final response = [
          ProductModel(
            id: 1,
            description: "ofsdijfodsi",
            name: "ifdosifjods",
            price: 40.0,
            stockQuantity: 20,
            imageUrl: "fjodijfosd",
          ),
          ProductModel(
            id: 2,
            description: "ofsdijfodsi",
            name: "ifdosifjods",
            price: 40.0,
            stockQuantity: 20,
            imageUrl: "fjodijfosd",
          ),
          ProductModel(
            id: 3,
            description: "ofsdijfodsi",
            name: "ifdosifjods",
            price: 40.0,
            stockQuantity: 20,
            imageUrl: "fjodijfosd",
          ),
        ];

        when(() => productDataSourceMock.getAllProducts(token: '1234'))
            .thenAnswer((_) async => response);

        final Either<Failure, List<ProductEntity>> result =
            await productRepoImpl.getAllProducts(token: "1234");

        expect(result.isRight(), true);
        expect(result.getOrElse(() => []), expected);

        verify(() => productDataSourceMock.getAllProducts(token: '1234'))
            .called(1);
      },
    );
    test("check if the method returns Server Failure", () async {
      final expected = ServerFailure(
        "Your session may have expired. Please sign in again.",
      );

      when(() => productDataSourceMock.getAllProducts(token: '1234')).thenThrow(
        ServerException(message: "Your session has expired", statusCode: 401),
      );

      expect(
        await productRepoImpl.getAllProducts(token: "1234"),
        left(expected),
      );

      verify(() => productDataSourceMock.getAllProducts(token: '1234'))
          .called(1);
    });
  });
}
