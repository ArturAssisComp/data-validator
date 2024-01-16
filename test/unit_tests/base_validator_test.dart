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
      status: UnitValidationStatusCode.notDefined,
      finished: false,
    );
    registerValidationMethod(
      () {
        if (target.length > N) {
          return result.copyWith(
            status: UnitValidationStatusCode.failed,
            finished: true,
            description: 'The word "$target" has length ${target.length} which '
                'is greater than $N',
          );
        }
        if (target.length < N) {
          return result.copyWith(
            status: UnitValidationStatusCode.failed,
            finished: true,
            description: 'The word "$target" has length ${target.length} which '
                'is less than $N',
          );
        }
        return result.copyWith(
          status: UnitValidationStatusCode.success,
          finished: true,
          description: 'The word "$target" has length ${target.length} which '
              'is equal to $N',
        );
      },
    );
  }

  void startsWithUpperCase() {
    const nodeName = 'startsWithUpperCase';
    const result = UnitValidationStatus(
      nodeName: nodeName,
      status: UnitValidationStatusCode.notDefined,
      finished: false,
    );
    registerValidationMethod(
      () {
        if (target[0].toLowerCase() != target[0]) {
          return result.copyWith(
            status: UnitValidationStatusCode.failed,
            finished: true,
            description: 'The word "$target" does not start with upper case',
          );
        }
        return result.copyWith(
          status: UnitValidationStatusCode.success,
          finished: true,
          description: 'The word "$target" starts with upper case',
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
            status: UnitValidationStatusCode.failed,
            description: 'The word "test" has length 4 which is greater than 3',
          ),
        ),
      );
    });
    group('validate', () {});
    group('registerValidationMethod', () {
      test('throw failure: add new step to finished validation pipeline', () {
        final finishedValidationStatus = ValidationStatus(validationName: 'n1');
        final newValidator = SimpleValidator(
          target: 'str',
          validationStatus: finishedValidationStatus,
        )..hasLengthN(2);
        finishedValidationStatus.finish();
        expect(
          newValidator.startsWithUpperCase,
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
