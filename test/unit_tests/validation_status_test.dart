import 'package:data_validator/data_validator.dart';
import 'package:test/test.dart';

void main() {
  group('ValidationStatus', () {
    group('addResult', () {
      // add tests here to complete the implementation of addResult. eAch result
      // added should update the current general state.
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
