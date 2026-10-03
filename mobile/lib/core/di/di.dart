import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../utils/constants/endpoints.dart';

final sl = GetIt.instance;

void setup() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );


  sl.registerLazySingleton<Dio>(() => dio);
}
