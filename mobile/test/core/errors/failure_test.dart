import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';

void main() {
  test('props should contain message', () {
    expect(const ServerFailure('x').props, ['x']);
  });

  test('failures with same type and message are equal', () {
    expect(const ServerFailure('x'), const ServerFailure('x'));
  });

  test('failures with same message but different type are not equal', () {
    expect(const ServerFailure('x'), isNot(const NetworkFailure('x')));
    expect(const CacheFailure('x'), isNot(const ServerFailure('x')));
  });

  test('failures with different messages are not equal', () {
    expect(const ServerFailure('a'), isNot(const ServerFailure('b')));
  });
}
