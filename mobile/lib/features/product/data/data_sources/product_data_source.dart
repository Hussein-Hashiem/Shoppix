import 'package:dio/dio.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/utils/constants/endpoints.dart';
import 'package:mobile/features/product/data/models/product_model.dart';

class ProductDataSource {
  final ApiClient apiClient;

  ProductDataSource({required this.apiClient});

  Future<List<ProductModel>> getAllProducts({String? token}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.baseUrl + ApiEndpoints.allProducts,
        token: token,
      );
      final products = response.data;
      return (products as List)
          .map(
            (product) => ProductModel.fromJson(product as Map<String, dynamic>),
          )
          .toList();
    } on ServerException catch (_) {
      rethrow;
    } on NetworkException catch (_) {
      rethrow;
    }
  }
}
