import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/api_client_impl.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/auth/data/data_source/server_datasource.dart';
import 'package:mobile/features/auth/data/repo/auth_repo_impl.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';
import 'package:mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_cubit.dart';
import 'package:mobile/features/product/data/data_sources/product_data_source.dart';
import 'package:mobile/features/product/data/repo/product_repo_impl.dart';
import 'package:mobile/features/product/domain/repo/product_repo.dart';
import 'package:mobile/features/product/domain/usecases/get_products_usecase.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_cubit.dart';

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
  // dio and api client
  sl.registerLazySingleton<Dio>(() => dio);
  sl.registerLazySingleton<ApiClient>(() => ApiClientImpl(sl()));

  // data sources
  sl.registerLazySingleton<ServerDatasource>(
    () => ServerDatasource(apiClient: sl()),
  );
  sl.registerLazySingleton<ProductDataSource>(
    () => ProductDataSource(apiClient: sl()),
  );

  // repos
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(serverDatasource: sl()),
  );
  sl.registerLazySingleton<ProductRepo>(
    () => ProductRepoImpl(productDataSource: sl()),
  );

  // usecases
  sl.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(sl()));
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));
  sl.registerLazySingleton<GetProductsUsecase>(
    () => GetProductsUsecase(productRepo: sl()),
  );

  // flutter secure storage
  sl.registerSingleton<FlutterSecureStorage>(
    FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );

  // token secure storage
  sl.registerLazySingleton<SecureTokenStorage>(() => SecureTokenStorage(sl()));

  // cubits
  sl.registerSingleton<LoginCubit>(LoginCubit(sl()));
  sl.registerSingleton<RegisterCubit>(RegisterCubit(sl()));
  sl.registerSingleton<GetAllProductsCubit>(GetAllProductsCubit(sl(), sl()));
}
