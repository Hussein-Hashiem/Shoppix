import 'package:dio/dio.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/utils/constants/endpoints.dart';
import 'package:mobile/features/auth/data/models/login_model.dart';
import 'package:mobile/features/auth/data/models/register_model.dart';

class ServerDatasource {
  final ApiClient apiClient;
  final Map<String, dynamic> query = {'Content-Type': 'application/json'};
  ServerDatasource({required this.apiClient});

  Future<RegisterModel> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      // data to be sent to the backend
      final Map<String, dynamic> data = {
        'email': email,
        'name': name,
        'password': password,
      };
      // query parameters

      // response of the api call
      final Response response = await apiClient.post(
        ApiEndpoints.baseUrl + ApiEndpoints.register,
        data: data,
        queryParams: query,
      );
      // we return the model from the data source
      return RegisterModel.fromJson(response.data);
    } on ServerException catch (e) {
      rethrow;
    }
  }

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {'email': email, 'password': password};
      final Response response = await apiClient.post(
        ApiEndpoints.baseUrl + ApiEndpoints.login,
        data: data,
        queryParams: query,
      );
      return LoginModel.fromJson(response.data);
    } on ServerException catch (e) {
      rethrow;
    }
  }
}
