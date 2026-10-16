import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/domain/entities/login_entity.dart';
import 'package:mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';
import 'package:mocktail/mocktail.dart';

class LoginUsecaseMock extends Mock implements LoginUsecase {}

void main() {
  group("testing the states coming from login cubit", () {
    late LoginUsecaseMock loginUsecaseMock;
    setUp(() {
      loginUsecaseMock = LoginUsecaseMock();
    });

    blocTest<LoginCubit, LoginStates>(
      "emits [loading, success] when the call is successful",
      build: () {
        when(
          () => loginUsecaseMock(
            LoginParams(email: "alimohamed@gmail.com", password: '1234567Aa@'),
          ),
        ).thenAnswer((_) async => right(LoginEntity(token: '1234')));
        return LoginCubit(loginUsecaseMock);
      },
      act: (bloc) =>
          bloc.login(email: "alimohamed@gmail.com", password: '1234567Aa@'),
      expect: () => [LoadingLoginState(), SuccessLoginState()],
      verify: (_) => verify(
        () => loginUsecaseMock(
          LoginParams(email: "alimohamed@gmail.com", password: '1234567Aa@'),
        ),
      ).called(1),
    );
    blocTest<LoginCubit, LoginStates>(
      "emits [loading, fail] when the call is unsuccessful",
      build: () {
        when(
          () => loginUsecaseMock(
            LoginParams(email: "alimohamed@gmail.com", password: '1234567Aa@'),
          ),
        ).thenAnswer((_) async => left(ServerFailure("User Not Found")));
        return LoginCubit(loginUsecaseMock);
      },
      act: (bloc) =>
          bloc.login(email: "alimohamed@gmail.com", password: '1234567Aa@'),
      expect: () => [
        LoadingLoginState(),
        FailLoginState(message: "User Not Found"),
      ],
      verify: (_) => verify(
        () => loginUsecaseMock(
          LoginParams(email: "alimohamed@gmail.com", password: '1234567Aa@'),
        ),
      ).called(1),
    );
  });
}
