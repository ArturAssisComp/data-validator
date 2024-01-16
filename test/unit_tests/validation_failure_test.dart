import 'package:data_validator/data_validator.dart';
import 'package:test/test.dart';

void main() {
  group('ValidationFailure', () {
    group('toString', () {
      test('default code', () {
        expect(
          const ValidationFailure().toString(),
          equals('ValidationFailure: ${ValidationFailureCode.unknown.message}'),
        );
      });
      test('add state to finished pipeline code', () {
        expect(
          const ValidationFailure(
            failureCode:
                ValidationFailureCode.addingStateToFinishedValidationPipeline,
          ).toString(),
          equals(
            'ValidationFailure: ${ValidationFailureCode.addingStateToFinishedValidationPipeline.message}', // ignore: lines_longer_than_80_chars
          ),
        );
      });
    });
  });
}
