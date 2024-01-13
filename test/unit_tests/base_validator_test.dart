import 'package:data_validator/data_validator.dart';
import 'package:test/test.dart';

final class SimpleValidator extends BaseValidator<String> {
  SimpleValidator({required super.target, required super.validationStatus});
}

void main() {
  group('SimpleValidator (that extends from BaseValidator)', () {
    test('instantiate', () {
      final validationStatus = ValidationStatus(
        validationName: 'some validation',
      );
      SimpleValidator(
        target: 'some string to be validated',
        validationStatus: validationStatus,
      );
    });
  });
}
