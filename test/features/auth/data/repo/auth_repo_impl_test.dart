import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/data/data_source/server_datasource.dart';
import 'package:mobile/features/auth/data/models/login_model.dart';
import 'package:mobile/features/auth/data/models/register_model.dart';
import 'package:mobile/features/auth/data/repo/auth_repo_impl.dart';
import 'package:mobile/features/auth/domain/entities/login_entity.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';
import 'package:mocktail/mocktail.dart';

class ServerDataSourceMock extends Mock implements ServerDatasource {}

void main() {
  late ServerDataSourceMock serverDataSourceMock;
  late AuthRepo authRepo;

  setUp(() {
    serverDataSourceMock = ServerDataSourceMock();
    authRepo = AuthRepoImpl(serverDatasource: serverDataSourceMock);
  });
  group("testing the outputs of the register method", () {
    test("check if the method returns unit when successful", () async {
      when(
        () => serverDataSourceMock.register(
          email: 'alimohamed@gmail.com',
          name: 'ali',
          password: '1234562A',
        ),
      ).thenAnswer(
        (_) async => RegisterModel(
          email: 'alimohamed@gmail.com',
          name: 'ali',
          userId: 'jfosidjfosdifji',
        ),
      );

      final result = await authRepo.register(
        name: 'ali',
        email: 'alimohamed@gmail.com',
        password: '1234562A',
      );

      expect(result, right(unit));
      verify(
        () => serverDataSourceMock.register(
          email: 'alimohamed@gmail.com',
          name: 'ali',
          password: '1234562A',
        ),
      ).called(1);
    });
    test("check if the method returns ServerException when it fails", () async {
      final ServerFailure expectedFailure = ServerFailure(
        'The requested information could not be found.',
      );
      when(
        () => serverDataSourceMock.register(
          email: 'alimohamed@gmail.com',
          name: 'ali',
          password: '1234562A',
        ),
      ).thenThrow(ServerException(message: 'Not Found', statusCode: 404));

      final result = await authRepo.register(
        name: 'ali',
        email: 'alimohamed@gmail.com',
        password: '1234562A',
      );

      expect(result, left(expectedFailure));
      verify(
        () => serverDataSourceMock.register(
          email: 'alimohamed@gmail.com',
          name: 'ali',
          password: '1234562A',
        ),
      ).called(1);
    });
  });
  group("testing the outputs of the register method", () {
    test("check if the method returns unit when successful", () async {
      final response = LoginModel(
        token: '1234',
        name: 'ali',
        email: 'jfodisjfod',
        refreshToken: "1234",
        expiresIn: 1800,
      );
      final expected = LoginEntity(token: '1234');
      when(
        () => serverDataSourceMock.login(
          email: 'alimohamed@gmail.com',
          password: '1234562A',
        ),
      ).thenAnswer((_) async => response);

      final result = await authRepo.login(
        email: 'alimohamed@gmail.com',
        password: '1234562A',
      );

      expect(result, right(expected));
      verify(
        () => serverDataSourceMock.login(
          email: 'alimohamed@gmail.com',
          password: '1234562A',
        ),
      ).called(1);
    });
    test("check if the method returns ServerFailure when it fails", () async {
      final ServerFailure expectedFailure = ServerFailure(
        'The requested information could not be found.',
      );
      when(
        () => serverDataSourceMock.login(
          email: 'alimohamed@gmail.com',
          password: '1234562A',
        ),
      ).thenThrow(ServerException(message: 'Not Found', statusCode: 404));

      final result = await authRepo.login(
        email: 'alimohamed@gmail.com',
        password: '1234562A',
      );

      expect(result, left(expectedFailure));
      verify(
        () => serverDataSourceMock.login(
          email: 'alimohamed@gmail.com',
          password: '1234562A',
        ),
      ).called(1);
    });
  });
}
