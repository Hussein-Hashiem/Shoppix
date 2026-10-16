import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';

void main() {
  group('NoParams', () {
    test('two instances should be equal', () {
      expect(NoParams(), NoParams());
    });

    test('props should be empty', () {
      expect(NoParams().props, isEmpty);
    });
  });

  group('UseCase contract', () {
    test('can be invoked via call() syntax', () async {
      final useCase = _FakeUseCase();

      final result = await useCase(NoParams());

      expect(result, const Right<Failure, int>(1));
    });
  });
}

class _FakeUseCase extends UseCase<int, NoParams> {
  @override
  Future<Either<Failure, int>> call(NoParams params) async => const Right(1);
}
