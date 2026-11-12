import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/auth/domain/entities/login_entity.dart';
import 'package:mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';
import 'package:mocktail/mocktail.dart';

class LoginUsecaseMock extends Mock implements LoginUsecase {}

class SecureTokenStorageMock extends Mock implements SecureTokenStorage {}

void main() {
  group("testing the states coming from login cubit", () {
    late LoginUsecaseMock loginUsecaseMock;
    late SecureTokenStorageMock storageMock;

    setUp(() {
      loginUsecaseMock = LoginUsecaseMock();
      storageMock = SecureTokenStorageMock();

      when(() => storageMock.saveToken(any())).thenAnswer((_) async {});
    });

    blocTest<LoginCubit, LoginStates>(
      "emits [loading, success] when the call is successful",
      build: () {
        when(
          () => loginUsecaseMock(
            LoginParams(email: "alimohamed@gmail.com", password: '1234567Aa@'),
          ),
        ).thenAnswer((_) async => right(LoginEntity(token: '1234')));

        return LoginCubit(loginUsecaseMock, storage: storageMock);
      },
      act: (bloc) =>
          bloc.login(email: "alimohamed@gmail.com", password: '1234567Aa@'),
      expect: () => [LoadingLoginState(), SuccessLoginState()],
      verify: (_) {
        verify(
          () => loginUsecaseMock(
            LoginParams(email: "alimohamed@gmail.com", password: '1234567Aa@'),
          ),
        ).called(1);

        verify(() => storageMock.saveToken('1234')).called(1);
      },
    );

    blocTest<LoginCubit, LoginStates>(
      "emits [loading, fail] when the call is unsuccessful",
      build: () {
        when(
          () => loginUsecaseMock(
            LoginParams(email: "alimohamed@gmail.com", password: '1234567Aa@'),
          ),
        ).thenAnswer((_) async => left(ServerFailure("User Not Found")));

        return LoginCubit(loginUsecaseMock, storage: storageMock);
      },
      act: (bloc) =>
          bloc.login(email: "alimohamed@gmail.com", password: '1234567Aa@'),
      expect: () => [
        LoadingLoginState(),
        FailLoginState(message: "User Not Found"),
      ],
      verify: (_) {
        verify(
          () => loginUsecaseMock(
            LoginParams(email: "alimohamed@gmail.com", password: '1234567Aa@'),
          ),
        ).called(1);

        verifyNever(() => storageMock.saveToken(any()));
      },
    );
  });
}
