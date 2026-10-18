import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_states.dart';
import 'package:mocktail/mocktail.dart';

class RegisterUsecaseMock extends Mock implements RegisterUsecase {}

void main() {
  group("testing the states coming from register cubit", () {
    late RegisterUsecaseMock registerUsecaseMock;
    setUp(() {
      registerUsecaseMock = RegisterUsecaseMock();
    });

    blocTest<RegisterCubit, RegisterState>(
      "emits [loading, success] when the call is successful",
      build: () {
        when(
          () => registerUsecaseMock(
            RegisterParams(
              email: "alimohamed@gmail.com",
              password: '1234567Aa@',
              name: "ali",
            ),
          ),
        ).thenAnswer((_) async => right(unit));
        return RegisterCubit(registerUsecaseMock);
      },
      act: (bloc) => bloc.register(
        email: "alimohamed@gmail.com",
        password: '1234567Aa@',
        name: 'ali',
      ),
      expect: () => [LoadingRegisterState(), SuccessRegisterState()],
      verify: (_) => verify(
        () => registerUsecaseMock(
          RegisterParams(
            email: "alimohamed@gmail.com",
            password: '1234567Aa@',
            name: "ali",
          ),
        ),
      ).called(1),
    );
    blocTest<RegisterCubit, RegisterState>(
      "emits [loading, fail] when the call is unsuccessful",
      build: () {
        when(
          () => registerUsecaseMock(
            RegisterParams(
              email: "alimohamed@gmail.com",
              password: '1234567Aa@',
              name: "ali",
            ),
          ),
        ).thenAnswer((_) async => left(ServerFailure("User Not Found")));
        return RegisterCubit(registerUsecaseMock);
      },
      act: (bloc) => bloc.register(
        email: "alimohamed@gmail.com",
        password: '1234567Aa@',
        name: 'ali',
      ),
      expect: () => [
        LoadingRegisterState(),
        FailRegisterState(message: "User Not Found"),
      ],
      verify: (_) => verify(
        () => registerUsecaseMock(
          RegisterParams(
            email: "alimohamed@gmail.com",
            password: '1234567Aa@',
            name: "ali",
          ),
        ),
      ).called(1),
    );
  });
}
