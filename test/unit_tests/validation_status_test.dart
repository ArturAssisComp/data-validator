import 'package:data_validator/data_validator.dart';
import 'package:test/test.dart';

void main() {
  const validationStatusName = 'n1';
  group('ValidationStatus', () {
    test('initialization', () {
      final validationStatus = ValidationStatus(
        validationName: validationStatusName,
      );
      final expectedUnitValidationStatus = UnitValidationStatus(
        nodeName: validationStatusName,
        status: UnitValidationStatusCode.notDefined,
        finished: false,
        description: UnitValidationStatusCode.notDefined.defaultDescription,
      );
      expect(validationStatus.detailedStatus, isEmpty);
      expect(validationStatus.finished, isFalse);
      expect(validationStatus.runtimeType, ValidationStatus);
      expect(
        validationStatus.status,
        equals(expectedUnitValidationStatus),
      );
    });
    group('finish method and finished', () {
      test('finish twice', () {
        final validationStatus = ValidationStatus(validationName: 'n1');
        expect(validationStatus.finished, isFalse);
        validationStatus.finish();
        expect(validationStatus.finished, isTrue);
        validationStatus.finish();
        expect(validationStatus.finished, isTrue);
      });
    });
    group('addResult', () {
      test(
          'throw failure - try adding new validation to an empty finished '
          'validation status', () {
        final v = ValidationStatus(validationName: 'name1')..finish();
        const u = UnitValidationStatus(
          nodeName: 'v1',
          status: UnitValidationStatusCode.success,
        );
        expect(
          () => v.addResult(u),
          throwsA(
            isA<ValidationFailure>().having(
              (e) => e.failureCode,
              'contains the right type of failure code',
              equals(
                ValidationFailureCode.addingStateToFinishedValidationPipeline,
              ),
            ),
          ),
        );
      });
      test(
          'throw failure - try adding new validation to a non-empty finished '
          'validation status', () {
        const newState = UnitValidationStatus(
          nodeName: 'n1',
          status: UnitValidationStatusCode.success,
        );
        final v = ValidationStatus(validationName: 'name1')
          ..addResult(newState)
          ..finish();
        const u = UnitValidationStatus(
          nodeName: 'v1',
          status: UnitValidationStatusCode.success,
        );
        expect(
          () => v.addResult(u),
          throwsA(
            isA<ValidationFailure>().having(
              (e) => e.failureCode,
              'contains the right type of failure code',
              equals(
                ValidationFailureCode.addingStateToFinishedValidationPipeline,
              ),
            ),
          ),
        );
      });
      group('add valid states', () {
        late ValidationStatus validationStatus;
        const validationName = 'validation process';
        const finishedSuccessState = UnitValidationStatus(
          nodeName: 's1',
          status: UnitValidationStatusCode.success,
          description: 'successful operation',
        );
        const finishedSuccessState2 = UnitValidationStatus(
          nodeName: 's2',
          status: UnitValidationStatusCode.success,
          description: 'successful operation 2',
        );
        const finishedWarningState = UnitValidationStatus(
          nodeName: 'w1',
          status: UnitValidationStatusCode.warning,
          description: 'warning operation',
        );
        const finishedWarningState2 = UnitValidationStatus(
          nodeName: 'w2',
          status: UnitValidationStatusCode.warning,
          description: 'warning operation 2',
        );
        const finishedFailedState = UnitValidationStatus(
          nodeName: 'f1',
          status: UnitValidationStatusCode.failed,
          description: 'failed operation',
        );
        const finishedFailedState2 = UnitValidationStatus(
          nodeName: 'f2',
          status: UnitValidationStatusCode.failed,
          description: 'failed operation 2',
        );
        setUp(
          () => validationStatus =
              ValidationStatus(validationName: validationName),
        );
        final testInputList = [
          (
            testName: 'add two failed states to empty pipeline',
            mainState: finishedFailedState,
            secondaryState: finishedFailedState2,
            // The state that will be prevalent in the final result
            prevalentState: finishedFailedState,
          ),
          (
            testName: 'add two warning states to empty pipeline',
            mainState: finishedWarningState,
            secondaryState: finishedWarningState2,
            // The state that will be prevalent in the final result
            prevalentState: finishedWarningState,
          ),
          (
            testName: 'add two success states to empty pipeline',
            mainState: finishedSuccessState,
            secondaryState: finishedSuccessState2,
            // The state that will be prevalent in the final result
            prevalentState: finishedSuccessState2,
          ),
        ];
        for (final testInput in testInputList) {
          test(
            testInput.testName,
            () {
              // mainState
              validationStatus.addResult(testInput.mainState);
              expect(validationStatus.detailedStatus.length, equals(1));
              expect(
                validationStatus.detailedStatus[0],
                equals(testInput.mainState),
              );
              expect(
                identical(
                  validationStatus.detailedStatus[0],
                  testInput.mainState,
                ),
                isFalse,
              );
              expect(
                validationStatus.status,
                equals(
                  UnitValidationStatus(
                    nodeName: validationName,
                    status: testInput.mainState.status,
                    finished: false,
                    description: testInput.mainState.description,
                  ),
                ),
              );
              // mainState -> secondaryState
              validationStatus.addResult(testInput.secondaryState);
              expect(validationStatus.detailedStatus.length, equals(2));
              expect(
                validationStatus.detailedStatus[1],
                equals(testInput.secondaryState),
              );
              expect(
                identical(
                  validationStatus.detailedStatus[1],
                  testInput.secondaryState,
                ),
                isFalse,
              );
              expect(
                validationStatus.status,
                equals(
                  UnitValidationStatus(
                    nodeName: validationName,
                    status: testInput.prevalentState.status,
                    finished: false,
                    description: testInput.prevalentState.description,
                  ),
                ),
              );
            },
          );
        }
        group('multiple valid transitions', () {
          test('s -> w -> s -> f -> w', () {
            // Check the empty state
            expect(validationStatus.detailedStatus.isEmpty, isTrue);
            expect(
              validationStatus.status,
              equals(
                UnitValidationStatus(
                  nodeName: validationName,
                  status: UnitValidationStatusCode.notDefined,
                  finished: false,
                  description:
                      UnitValidationStatusCode.notDefined.defaultDescription,
                ),
              ),
            );
            // s
            validationStatus.addResult(finishedSuccessState);
            expect(validationStatus.detailedStatus.length, equals(1));
            expect(
              validationStatus.detailedStatus[0],
              equals(finishedSuccessState),
            );
            expect(
              identical(
                validationStatus.detailedStatus[0],
                finishedSuccessState,
              ),
              isFalse,
            );
            expect(
              validationStatus.status,
              equals(
                UnitValidationStatus(
                  nodeName: validationName,
                  status: UnitValidationStatusCode.success,
                  finished: false,
                  description: finishedSuccessState.description,
                ),
              ),
            );
            // s -> w
            validationStatus.addResult(finishedWarningState);
            expect(validationStatus.detailedStatus.length, equals(2));
            expect(
              validationStatus.detailedStatus[1],
              equals(finishedWarningState),
            );
            expect(
              identical(
                validationStatus.detailedStatus[1],
                finishedWarningState,
              ),
              isFalse,
            );
            expect(
              validationStatus.status,
              equals(
                UnitValidationStatus(
                  nodeName: validationName,
                  status: UnitValidationStatusCode.warning,
                  finished: false,
                  description: finishedWarningState.description,
                ),
              ),
            );
            // s -> w -> s
            validationStatus.addResult(finishedSuccessState2);
            expect(validationStatus.detailedStatus.length, equals(3));
            expect(
              validationStatus.detailedStatus[2],
              equals(finishedSuccessState2),
            );
            expect(
              identical(
                validationStatus.detailedStatus[2],
                finishedSuccessState2,
              ),
              isFalse,
            );
            expect(
              validationStatus.status,
              equals(
                UnitValidationStatus(
                  nodeName: validationName,
                  status: UnitValidationStatusCode.warning,
                  finished: false,
                  description: finishedWarningState.description,
                ),
              ),
            );
            // s -> w -> s -> f
            validationStatus.addResult(finishedFailedState);
            expect(validationStatus.detailedStatus.length, equals(4));
            expect(
              validationStatus.detailedStatus[3],
              equals(finishedFailedState),
            );
            expect(
              identical(
                validationStatus.detailedStatus[3],
                finishedFailedState,
              ),
              isFalse,
            );
            expect(
              validationStatus.status,
              equals(
                UnitValidationStatus(
                  nodeName: validationName,
                  status: UnitValidationStatusCode.failed,
                  finished: false,
                  description: finishedFailedState.description,
                ),
              ),
            );
            // s -> w -> s -> f -> w
            validationStatus.addResult(finishedWarningState2);
            expect(validationStatus.detailedStatus.length, equals(5));
            expect(
              validationStatus.detailedStatus[4],
              equals(finishedWarningState2),
            );
            expect(
              identical(
                validationStatus.detailedStatus[4],
                finishedWarningState2,
              ),
              isFalse,
            );
            expect(
              validationStatus.status,
              equals(
                UnitValidationStatus(
                  nodeName: validationName,
                  status: UnitValidationStatusCode.failed,
                  finished: false,
                  description: finishedFailedState.description,
                ),
              ),
            );
          });
          test('s -> f -> s', () {
            // s
            validationStatus.addResult(finishedSuccessState);
            expect(validationStatus.detailedStatus.length, equals(1));
            expect(
              validationStatus.detailedStatus[0],
              equals(finishedSuccessState),
            );
            expect(
              identical(
                validationStatus.detailedStatus[0],
                finishedSuccessState,
              ),
              isFalse,
            );
            expect(
              validationStatus.status,
              equals(
                UnitValidationStatus(
                  nodeName: validationName,
                  status: UnitValidationStatusCode.success,
                  finished: false,
                  description: finishedSuccessState.description,
                ),
              ),
            );
            // s -> f
            validationStatus.addResult(finishedFailedState);
            expect(validationStatus.detailedStatus.length, equals(2));
            expect(
              validationStatus.detailedStatus[1],
              equals(finishedFailedState),
            );
            expect(
              identical(
                validationStatus.detailedStatus[1],
                finishedFailedState,
              ),
              isFalse,
            );
            expect(
              validationStatus.status,
              equals(
                UnitValidationStatus(
                  nodeName: validationName,
                  status: UnitValidationStatusCode.failed,
                  finished: false,
                  description: finishedFailedState.description,
                ),
              ),
            );
            // s -> f -> s
            validationStatus.addResult(finishedSuccessState2);
            expect(validationStatus.detailedStatus.length, equals(3));
            expect(
              validationStatus.detailedStatus[2],
              equals(finishedSuccessState2),
            );
            expect(
              identical(
                validationStatus.detailedStatus[2],
                finishedSuccessState2,
              ),
              isFalse,
            );
            expect(
              validationStatus.status,
              equals(
                UnitValidationStatus(
                  nodeName: validationName,
                  status: UnitValidationStatusCode.failed,
                  finished: false,
                  description: finishedFailedState.description,
                ),
              ),
            );
          });
        });
      });
      group('invalid state for unit validation status', () {
        const uvs1 = UnitValidationStatus(
          nodeName: 'n1',
          status: UnitValidationStatusCode.success,
        );
        late ValidationStatus validationStatus;
        setUp(() {
          validationStatus = ValidationStatus(validationName: 'name1')
            ..addResult(uvs1);
        });
        test(
            'throw failure - try adding new validation with status notDefined '
            'to the validation satus', () {
          const notDefinedStatus = UnitValidationStatus(
            nodeName: 'v1',
            status: UnitValidationStatusCode.notDefined,
          );
          expect(
            () => validationStatus.addResult(notDefinedStatus),
            throwsA(
              isA<ValidationFailure>().having(
                (e) => e.failureCode,
                'contains the right type of failure code',
                equals(
                  ValidationFailureCode
                      .addingNotDefinedStateToValidationPipeline,
                ),
              ),
            ),
          );
        });
        test(
            'throw failure - try adding not finished warning or success '
            'to the validation satus', () {
          const successStatus = UnitValidationStatus(
            nodeName: 'v1',
            status: UnitValidationStatusCode.success,
            finished: false,
          );
          const warningStatus = UnitValidationStatus(
            nodeName: 'v1',
            status: UnitValidationStatusCode.success,
            finished: false,
          );
          expect(
            () => validationStatus.addResult(successStatus),
            throwsA(
              isA<ValidationFailure>().having(
                (e) => e.failureCode,
                'contains the right type of failure code',
                equals(
                  ValidationFailureCode
                      .addingNotDefinedStateToValidationPipeline,
                ),
              ),
            ),
          );
          expect(
            () => validationStatus.addResult(warningStatus),
            throwsA(
              isA<ValidationFailure>().having(
                (e) => e.failureCode,
                'contains the right type of failure code',
                equals(
                  ValidationFailureCode
                      .addingNotDefinedStateToValidationPipeline,
                ),
              ),
            ),
          );
        });
      });
    });
    group('hashCode', () {
      test('diffetent hash codes for different validation name', () {
        final s1 = ValidationStatus(
          validationName: 'v1',
        );
        final s2 = ValidationStatus(
          validationName: 'v2',
        );
        expect(s1.hashCode, isNot(equals(s2.hashCode)));
      });
      test('same hash codes for equal node and status', () {
        final s1 = ValidationStatus(
          validationName: 'v1',
        );
        final s2 = ValidationStatus(
          validationName: 'v1',
        );
        expect(s1.hashCode, equals(s2.hashCode));
      });
    });
    group('Operator ==', () {
      test('identical', () {
        final v = ValidationStatus(validationName: 'test');
        expect(v, equals(v));
      });

      test('different validation names', () {
        final v1 = ValidationStatus(validationName: 'test1');
        final v2 = ValidationStatus(validationName: 'test2');
        expect(v1, isNot(equals(v2)));
      });

      test('different detailed status lists', () {
        final v1 = ValidationStatus(validationName: 'test');
        final v2 = ValidationStatus(validationName: 'test');
        v1.addResult(
          const UnitValidationStatus(
            nodeName: 'Node1',
            status: UnitValidationStatusCode.success,
          ),
        );
        v2.addResult(
          const UnitValidationStatus(
            nodeName: 'Node2',
            status: UnitValidationStatusCode.failed,
          ),
        );
        expect(v1, isNot(equals(v2)));
      });

      test('one empty and one non-empty detailed status', () {
        final v1 = ValidationStatus(validationName: 'test');
        final v2 = ValidationStatus(validationName: 'test')
          ..addResult(
            const UnitValidationStatus(
              nodeName: 'Node',
              status: UnitValidationStatusCode.success,
            ),
          );
        expect(v1, isNot(equals(v2)));
      });

      test('equal objects with different instances', () {
        final v1 = ValidationStatus(validationName: 'test');
        final v2 = ValidationStatus(validationName: 'test');
        v1.addResult(
          const UnitValidationStatus(
            nodeName: 'Node',
            status: UnitValidationStatusCode.success,
          ),
        );
        v2.addResult(
          const UnitValidationStatus(
            nodeName: 'Node',
            status: UnitValidationStatusCode.success,
          ),
        );
        expect(v1, equals(v2));
      });

      test('same detailed status in different order', () {
        final v1 = ValidationStatus(validationName: 'test');
        final v2 = ValidationStatus(validationName: 'test');
        v1
          ..addResult(
            const UnitValidationStatus(
              nodeName: 'Node1',
              status: UnitValidationStatusCode.success,
            ),
          )
          ..addResult(
            const UnitValidationStatus(
              nodeName: 'Node2',
              status: UnitValidationStatusCode.failed,
            ),
          );
        v2
          ..addResult(
            const UnitValidationStatus(
              nodeName: 'Node2',
              status: UnitValidationStatusCode.failed,
            ),
          )
          ..addResult(
            const UnitValidationStatus(
              nodeName: 'Node1',
              status: UnitValidationStatusCode.success,
            ),
          );
        expect(v1, isNot(equals(v2)));
      });

      test('different object types', () {
        final v = ValidationStatus(validationName: 'test');
        const nonValidationStatusObject = 'some string';
        expect(v, isNot(equals(nonValidationStatusObject)));
      });
    });
  });
}
