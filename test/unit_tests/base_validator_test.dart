import 'package:data_validator/data_validator.dart';
import 'package:test/test.dart';

final class SimpleValidator extends BaseValidator<String> {
  SimpleValidator({required super.target, required super.validationStatus});

  // Validation Methods

  /// Check if the [target] word has exactly [N] characters.
  void hasLengthN(int N) {
    final nodeName = 'hasLength$N';
    final result = UnitValidationStatus(
      nodeName: nodeName,
      statusCode: UnitValidationStatusCode.notDefined,
      finished: false,
    );
    registerValidationMethod(
      () {
        if (target.length > N) {
          return result.copyWith(
            statusCode: UnitValidationStatusCode.failed,
            finished: true,
            description: 'The word "$target" has length ${target.length} which '
                'is greater than $N.',
          );
        }
        if (target.length < N) {
          return result.copyWith(
            statusCode: UnitValidationStatusCode.failed,
            finished: true,
            description: 'The word "$target" has length ${target.length} which '
                'is less than $N.',
          );
        }
        return result.copyWith(
          statusCode: UnitValidationStatusCode.success,
          finished: true,
          description: 'The word "$target" has length ${target.length} which '
              'is equal to $N.',
        );
      },
    );
  }

  void startsWithUpperCase() {
    const nodeName = 'startsWithUpperCase';
    const result = UnitValidationStatus(
      nodeName: nodeName,
      statusCode: UnitValidationStatusCode.notDefined,
      finished: false,
    );
    registerValidationMethod(
      () {
        if (target[0].toUpperCase() != target[0]) {
          return result.copyWith(
            statusCode: UnitValidationStatusCode.failed,
            finished: true,
            description: 'The word "$target" does not start with upper case.',
          );
        }
        return result.copyWith(
          statusCode: UnitValidationStatusCode.success,
          finished: true,
          description: 'The word "$target" starts with upper case.',
        );
      },
    );
  }
}

void main() {
  late ValidationStatus validationStatus;
  late SimpleValidator simpleValidator;
  const validationName = 'Validate string';
  group('SimpleValidator (that extends from BaseValidator)', () {
    setUp(() {
      validationStatus = ValidationStatus(
        validationName: validationName,
      );
      simpleValidator = SimpleValidator(
        target: 'test',
        validationStatus: validationStatus,
      );
    });
    test('build validation', () {
      simpleValidator
        ..hasLengthN(3)
        ..startsWithUpperCase()
        ..validate();
      expect(
        validationStatus.status,
        equals(
          const UnitValidationStatus(
            nodeName: validationName,
            finished: false,
            statusCode: UnitValidationStatusCode.failed,
            description: 'The word "test" has length 4 which is greater than '
                '3.',
          ),
        ),
      );
    });
    group('validate', () {
      test('throw failure: trying to validate a finished validation pipeline',
          () {
        simpleValidator.hasLengthN(3);
        validationStatus.finish();
        expect(
          simpleValidator.validate,
          throwsA(
            isA<ValidationFailure>().having(
              (e) => e.failureCode,
              'have the same failure code',
              equals(
                ValidationFailureCode
                    .executingValidationStepsOnFinishedPipeline,
              ),
            ),
          ),
        );
      });
      test('validate two steps', () {
        const target = 'Abcd';
        const validationName = 'Check length 3 and starts with upper case';
        final validationSts = ValidationStatus(
          validationName: validationName,
        );
        final strValidator = SimpleValidator(
          target: target,
          validationStatus: validationSts,
        )..hasLengthN(3);

        SimpleValidator(
          target: target,
          validationStatus: validationSts,
        )
          ..startsWithUpperCase()
          ..validate();
        expect(
          validationSts.status,
          equals(
            const UnitValidationStatus(
              nodeName: validationName,
              statusCode: UnitValidationStatusCode.success,
              finished: false,
              description: 'The word "Abcd" starts with upper case.',
            ),
          ),
        );
        strValidator.validate();
        validationSts.finish();
        expect(
          validationSts.status,
          equals(
            const UnitValidationStatus(
              nodeName: validationName,
              statusCode: UnitValidationStatusCode.failed,
              description: 'The word "Abcd" has length 4 which is greater than '
                  '3.',
            ),
          ),
        );
      });
    });
    group('registerValidationMethod', () {
      test('throw failure: add new step to finished validation pipeline', () {
        simpleValidator.hasLengthN(2);
        validationStatus.finish();
        expect(
          simpleValidator.startsWithUpperCase,
          throwsA(
            isA<ValidationFailure>().having(
              (e) => e.failureCode,
              'have the same failure code',
              equals(
                ValidationFailureCode
                    .addingNewValidationStepToFinishedValidationPipeline,
              ),
            ),
          ),
        );
      });
      test('Add two steps to the pipeline', () {
        expect(simpleValidator.remainingValidationMethodsCount(), equals(0));
        simpleValidator.hasLengthN(2);
        expect(simpleValidator.remainingValidationMethodsCount(), equals(1));
        simpleValidator.startsWithUpperCase();
        expect(simpleValidator.remainingValidationMethodsCount(), equals(2));
      });
    });
  });
}
