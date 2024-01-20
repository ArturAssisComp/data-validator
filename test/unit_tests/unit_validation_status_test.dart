import 'package:data_validator/data_validator.dart';
import 'package:test/test.dart';

void main() {
  const nodeName = 'node1';
  group('UnitValidationStatus', () {
    group('toString', () {
      test('name: n1 with success and description', () {
        const s1 = UnitValidationStatus(
          nodeName: 'n1',
          statusCode: UnitValidationStatusCode.success,
          description: 'hello world.',
        );
        expect(s1.toString(), '(n1: success [finished], "hello world.")');
      });
      test('name: n1 with success', () {
        const s1 = UnitValidationStatus(
          nodeName: 'n1',
          statusCode: UnitValidationStatusCode.success,
        );
        expect(s1.toString(), '(n1: success [finished])');
      });
      test("name: '' with failure", () {
        const s1 = UnitValidationStatus(
          nodeName: '',
          statusCode: UnitValidationStatusCode.failed,
        );
        expect(s1.toString(), '(: failed [finished])');
      });
    });
    group('hashCode', () {
      test('diffetent hash codes for different node name', () {
        const s1 = UnitValidationStatus(
          nodeName: 'n1',
          statusCode: UnitValidationStatusCode.success,
        );
        const s2 = UnitValidationStatus(
          nodeName: 'N1',
          statusCode: UnitValidationStatusCode.success,
        );
        expect(s1.hashCode, isNot(equals(s2.hashCode)));
      });
      test('same hash codes for equal node and status', () {
        const s1 = UnitValidationStatus(
          nodeName: 'n1',
          statusCode: UnitValidationStatusCode.success,
        );
        const s2 = UnitValidationStatus(
          nodeName: 'n1',
          statusCode: UnitValidationStatusCode.success,
        );
        expect(s1.hashCode, equals(s2.hashCode));
      });
    });
    group('== operator', () {
      const nodeName = 'TestNode';
      test('identical', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.notDefined,
        );
        expect(v1, equals(v1));
      });

      test('equal', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.success,
        );
        const expected = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.success,
        );
        expect(v1, equals(expected));
      });

      test('not equal - different nodeName', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.success,
        );
        const different = UnitValidationStatus(
          nodeName: 'DifferentNode',
          statusCode: UnitValidationStatusCode.success,
        );
        expect(v1, isNot(equals(different)));
      });

      test('not equal - different status', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.success,
        );
        const different = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.failed,
        );
        expect(v1, isNot(equals(different)));
      });

      test('not equal - different finished', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.success,
        );
        const different = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.failed,
          finished: false,
        );
        expect(v1, isNot(equals(different)));
      });

      test('not equal - both different', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.success,
        );
        const different = UnitValidationStatus(
          nodeName: 'DifferentNode',
          statusCode: UnitValidationStatusCode.failed,
        );
        expect(v1, isNot(equals(different)));
      });

      test('not equal - different type', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.success,
        );
        const different = 'NotAValidationStatus';
        expect(v1, isNot(equals(different)));
      });
    });

    group('copyWith', () {
      test('identical copy', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.notDefined,
        );
        expect(v1.copyWith(), v1);
      });
      test('different copy', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.notDefined,
        );
        const expected = UnitValidationStatus(
          nodeName: nodeName,
          statusCode: UnitValidationStatusCode.success,
        );
        expect(v1.copyWith(statusCode: UnitValidationStatusCode.success), expected);
      });
    });
  });
}
