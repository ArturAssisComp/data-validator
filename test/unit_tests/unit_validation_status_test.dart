import 'package:data_validator/data_validator.dart';
import 'package:test/test.dart';

void main() {
  const nodeName = 'node1';
  group('UnitValidationStatus', () {
    group('toString', () {
      test('name: n1 with success', () {
        const s1 = UnitValidationStatus(
          nodeName: 'n1',
          status: UnitValidationStatusCode.success,
        );
        expect(s1.toString(), 'n1: success');
      });
      test("name: '' with failure", () {
        const s1 = UnitValidationStatus(
          nodeName: '',
          status: UnitValidationStatusCode.failed,
        );
        expect(s1.toString(), ': failed');
      });
    });
    group('== operator', () {
      const nodeName = 'TestNode';
      test('identical', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.notDefined,
        );
        expect(v1, equals(v1));
      });

      test('equal', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.success,
        );
        const expected = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.success,
        );
        expect(v1, equals(expected));
      });

      test('not equal - different nodeName', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.success,
        );
        const different = UnitValidationStatus(
          nodeName: 'DifferentNode',
          status: UnitValidationStatusCode.success,
        );
        expect(v1, isNot(equals(different)));
      });

      test('not equal - different status', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.success,
        );
        const different = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.failed,
        );
        expect(v1, isNot(equals(different)));
      });

      test('not equal - both different', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.success,
        );
        const different = UnitValidationStatus(
          nodeName: 'DifferentNode',
          status: UnitValidationStatusCode.failed,
        );
        expect(v1, isNot(equals(different)));
      });

      test('not equal - different type', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.success,
        );
        const different = 'NotAValidationStatus';
        expect(v1, isNot(equals(different)));
      });
    });

    group('copyOf', () {
      test('identical copy', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.notDefined,
        );
        expect(v1.copyOf(), v1);
      });
      test('different copy', () {
        const v1 = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.notDefined,
        );
        const expected = UnitValidationStatus(
          nodeName: nodeName,
          status: UnitValidationStatusCode.success,
        );
        expect(v1.copyOf(status: UnitValidationStatusCode.success), expected);
      });
    });
  });
}
