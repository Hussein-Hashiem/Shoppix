import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/domain/entities/login_entity.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';
import 'package:mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class AuthRepoMock extends Mock implements AuthRepo {}

void main() {
  group("testing login usecase", () {
    late LoginUsecase loginUsecase;
    late AuthRepoMock repoMock;
    late LoginParams params;
    setUp(() {
      repoMock = AuthRepoMock();
      loginUsecase = LoginUsecase(repoMock);
      params = LoginParams(email: 'alimohamed12@gmail', password: 'aA@1234567');
    });
    test("check if call method returns map on success", () async {
      when(() => repoMock.login(email: params.email, password: params.password))
          .thenAnswer((_) async => right(LoginEntity(token: '1234')));

      final result = await loginUsecase(params);

      expect(result, right(LoginEntity(token: '1234')));
      verify(
        () => repoMock.login(email: params.email, password: params.password),
      ).called(1);
    });

    test(
      "check if call method returns server failure with invalid email",
      () async {
        when(
          () => repoMock.login(email: params.email, password: params.password),
        ).thenAnswer(
          (_) async =>
              left(ServerFailure("'Email' is not a valid email address.")),
        );

        final result = await loginUsecase(params);

        expect(
          result,
          left(ServerFailure("'Email' is not a valid email address.")),
        );
        verify(
          () => repoMock.login(email: params.email, password: params.password),
        ).called(1);
      },
    );

    test("check if call method returns server failure with invalid password format", () async {
      when(() => repoMock.login(email: params.email, password: params.password))
          .thenAnswer(
            (_) async => left(
              ServerFailure(
                "Passwords must have at least one non alphanumeric character.",
              ),
            ),
          );

      final result = await loginUsecase(params);

      expect(
        result,
        left(
          ServerFailure(
            "Passwords must have at least one non alphanumeric character.",
          ),
        ),
      );
      verify(
        () => repoMock.login(email: params.email, password: params.password),
      ).called(1);
    });
  });
}
