import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/utils/constants/endpoints.dart';
import 'package:mobile/features/product/data/data_sources/product_data_source.dart';
import 'package:mobile/features/product/data/models/product_model.dart';
import 'package:mocktail/mocktail.dart';

class ApiClientMock extends Mock implements ApiClient {}

void main() {
  late ProductDataSource productDataSource;
  late ApiClientMock apiClientMock;
  setUp(() {
    apiClientMock = ApiClientMock();
    productDataSource = ProductDataSource(apiClient: apiClientMock);
  });

  group("testing the outputs of getAllProducts method", () {
    test(
      "check if the method returns List of ProductModels on success",
      () async {
        final expected = [
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

        final response = [
          {
            'id': 1,
            'description': "ofsdijfodsi",
            'name': 'ifdosifjods',
            "price": 40.0,
            'stockQuantity': 20,
            'imageUrl': "fjodijfosd",
          },
          {
            'id': 2,
            'description': "ofsdijfodsi",
            'name': 'ifdosifjods',
            "price": 40.0,
            'stockQuantity': 20,
            'imageUrl': "fjodijfosd",
          },
          {
            'id': 3,
            'description': "ofsdijfodsi",
            'name': 'ifdosifjods',
            "price": 40.0,
            'stockQuantity': 20,
            'imageUrl': "fjodijfosd",
          },
        ];
        when(
          () => apiClientMock.get(
            ApiEndpoints.baseUrl + ApiEndpoints.allProducts,
            token: "1234567",
          ),
        ).thenAnswer((_) async => response);

        final result = await productDataSource.getAllProducts(token: "1234567");

        expect(result, expected);

        verify(
          () => apiClientMock.get(
            ApiEndpoints.baseUrl + ApiEndpoints.allProducts,
            token: "1234567",
          ),
        ).called(1);
      },
    );
    test("check if the method throws ServerException on fail", () async {
      final expected = ServerException(message: "Your session has expired");

      when(
        () => apiClientMock.get(
          ApiEndpoints.baseUrl + ApiEndpoints.allProducts,
          token: "1234567",
        ),
      ).thenThrow(expected);

      expect(
        productDataSource.getAllProducts(token: "1234567"),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'test',
            "Your session has expired",
          ),
        ),
      );

      verify(
        () => apiClientMock.get(
          ApiEndpoints.baseUrl + ApiEndpoints.allProducts,
          token: "1234567",
        ),
      ).called(1);
    });
    test("check if the method throws NetworkException on fail", () async {
      final expected = NetworkException(message: "There is no connection");

      when(
        () => apiClientMock.get(
          ApiEndpoints.baseUrl + ApiEndpoints.allProducts,
          token: "1234567",
        ),
      ).thenThrow(expected);

      expect(
        productDataSource.getAllProducts(token: "1234567"),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'test',
            "There is no connection",
          ),
        ),
      );

      verify(
        () => apiClientMock.get(
          ApiEndpoints.baseUrl + ApiEndpoints.allProducts,
          token: "1234567",
        ),
      ).called(1);
    });
  });
}
