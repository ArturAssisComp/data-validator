import 'package:data_validator/data_validator.dart';
import 'package:test/test.dart';

void main() {
  group('UnitValidationStatus', () {
    group('copyOf', () {
      test('identical copy', () {
        const v1 = UnitValidationStatus(
          nodeName: 'v1',
          status: UnitValidationStatusCode.notDefined,
        );
        expect(v1.copyOf(), v1);
      });
      test('different copy', () {
        const v1 = UnitValidationStatus(
          nodeName: 'v1',
          status: UnitValidationStatusCode.notDefined,
        );
        const expected = UnitValidationStatus(
          nodeName: 'v1',
          status: UnitValidationStatusCode.success,
        );
        expect(v1.copyOf(status: UnitValidationStatusCode.success), expected);
      });
    });
  });
}
