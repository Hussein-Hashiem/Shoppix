import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';
import 'package:mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class AuthRepoMock extends Mock implements AuthRepo {}

void main() {
  group('testing register usecase', () {
    late RegisterUsecase registerUsecase;
    late AuthRepoMock repoMock;
    late RegisterParams params;
    setUp(() {
      repoMock = AuthRepoMock();
      registerUsecase = RegisterUsecase(repoMock);
      params = RegisterParams(
        email: 'alimohamed12@gmail.com',
        name: '',
        password: 'aA@1234567',
      );
    });
    test("check if call method returns map on success", () async {
      when(
        () => repoMock.register(
          name: params.name,
          email: params.email,
          password: params.password,
        ),
      ).thenAnswer((_) async => right(unit));

      final result = await registerUsecase(params);

      expect(result, right(unit));
      verify(
        () => repoMock.register(
          name: params.name,
          email: params.email,
          password: params.password,
        ),
      ).called(1);
    });

    test(
      "check if call method returns server failure with invalid email",
      () async {
        when(
          () => repoMock.register(
            name: params.name,
            email: params.email,
            password: params.password,
          ),
        ).thenAnswer(
          (_) async =>
              left(ServerFailure("'Email' is not a valid email address.")),
        );

        final result = await registerUsecase(params);

        expect(
          result,
          left(ServerFailure("'Email' is not a valid email address.")),
        );
        verify(
          () => repoMock.register(
            name: params.name,
            email: params.email,
            password: params.password,
          ),
        ).called(1);
      },
    );
    test(
      "check if call method returns server failure with empty name",
      () async {
        when(
          () => repoMock.register(
            name: params.name,
            email: params.email,
            password: params.password,
          ),
        ).thenAnswer(
          (_) async => left(ServerFailure("'Name' must not be empty.")),
        );

        final result = await registerUsecase(params);

        expect(result, left(ServerFailure("'Name' must not be empty.")));
        verify(
          () => repoMock.register(
            name: params.name,
            email: params.email,
            password: params.password,
          ),
        ).called(1);
      },
    );
    test("check if call method returns server failure with invalid password format", () async {
      when(
        () => repoMock.register(
          name: params.name,
          email: params.email,
          password: params.password,
        ),
      ).thenAnswer(
        (_) async => left(
          ServerFailure(
            "Passwords must have at least one non alphanumeric character.",
          ),
        ),
      );

      final result = await registerUsecase(params);

      expect(
        result,
        left(
          ServerFailure(
            "Passwords must have at least one non alphanumeric character.",
          ),
        ),
      );
      verify(
        () => repoMock.register(
          name: params.name,
          email: params.email,
          password: params.password,
        ),
      ).called(1);
    });
  });
}
