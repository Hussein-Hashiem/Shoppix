import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';

void main() {
  group('UseCase', () {
    test('NoParams instances compare equally', () {
      expect(NoParams(), NoParams());
    });

    test('returns an Either result from the implementation', () async {
      final useCase = _SuccessfulUseCase();

      expect(await useCase(NoParams()), const Right<Failure, String>('done'));
    });
  });
}

class _SuccessfulUseCase extends UseCase<String, NoParams> {
  @override
  Future<Either<Failure, String>> call(NoParams params) async =>
      const Right('done');
}
