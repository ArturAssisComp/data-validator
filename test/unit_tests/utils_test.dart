import 'package:data_validator/src/utils.dart';
import 'package:test/test.dart';

class A {}

void main() {
  group('listEquality', () {
    test('identical', () {
      const l1 = <int>[1, 2, 3];
      expect(listEquality(l1, l1), isTrue);
    });
    test('const [] equals to const []', () {
      const l1 = <num>[];
      const l2 = <num>[];
      expect(listEquality(l1, l2), isTrue);
    });
    test('<A>[] equals to <A>[]', () {
      final l1 = <A>[];
      final l2 = <A>[];
      expect(listEquality(l1, l2), isTrue);
    });
    test('<A>[] equals to <int>[]', () {
      final l1 = <A>[];
      final l2 = <int>[];
      expect(listEquality(l1, l2), isFalse);
    });
    test('[1, 2, 3] equals [1, 2, 3]', () {
      expect(listEquality(<int>[1, 2, 3], <int>[1, 2, 3]), isTrue);
    });
    test('[1, 2] not equals [1, 2, 3]', () {
      expect(listEquality(<int>[1, 2], <int>[1, 2, 3]), isFalse);
    });
    test('<int>[1, 2] not equals <num>[1, 2, 3]', () {
      expect(listEquality(<int>[1, 2], <num>[1, 2, 3]), isFalse);
    });
    test('<int>[1, 2, 3] not equals <num>[1, 20, 3]', () {
      expect(listEquality<int>(<int>[1, 2, 3], <int>[1, 20, 3]), isFalse);
    });
    test('Different Types', () {
      expect(listEquality([1, '2', 3], [1, 2, 3]), isFalse);
    });

    test('Mixed Element Order', () {
      expect(listEquality([1, 2, 3], [3, 2, 1]), isFalse);
    });

    test('With Null Elements', () {
      expect(listEquality([1, null, 3], [1, null, 3]), isTrue);
    });

    test('Different Lengths', () {
      expect(listEquality([1, 2, 3, 4], [1, 2, 3]), isFalse);
    });

    test('Empty vs Non-Empty Lists', () {
      expect(listEquality([], [1]), isFalse);
    });

    test('Lists with Duplicate Elements', () {
      expect(listEquality([1, 1, 2], [1, 2, 2]), isFalse);
    });

    test('Different Typed Lists with Same Values', () {
      expect(listEquality([1, 2, 3], <num>[1, 2, 3]), isFalse);
    });
  });
}
