import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/api_client_impl.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/auth/data/data_source/server_datasource.dart';
import 'package:mobile/features/auth/data/repo/auth_repo_impl.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';
import 'package:mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_cubit.dart';

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
  sl.registerLazySingleton<ApiClient>(() => ApiClientImpl(sl()));
  sl.registerLazySingleton<ServerDatasource>(
    () => ServerDatasource(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(serverDatasource: sl()),
  );
  sl.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(sl()));
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));
  sl.registerSingleton<LoginCubit>(LoginCubit(sl()));
  sl.registerSingleton<RegisterCubit>(RegisterCubit(sl()));
}
