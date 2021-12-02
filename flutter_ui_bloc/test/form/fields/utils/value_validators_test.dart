import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_bloc/src/form/validation/validation.dart';
import 'package:pure_extensions/pure_extensions.dart';

void main() {
  group('Test ValidationTransformers', () {
    group('Rational', () {
      test('"ciao"->🔴', () {
        expect(
          ValidationTransformer.rational().call('ciao'),
          isNotNull,
        );
      });
      test('"1"->🟢', () {
        expect(
          ValidationTransformer.rational().call('1'),
          isNull,
        );
      });
      test('"1."->🟢', () {
        expect(
          ValidationTransformer.rational().call('1.'),
          isNull,
        );
      });
      test('"1"->🟢', () {
        expect(
          ValidationTransformer.rational().call('1.1'),
          isNull,
        );
      });
    });
  });

  group('Test ValueValidation', () {
    group('Test RationalValidation', () {
      test('"1"{greaterThan: 0}->🟢', () {
        expect(
          NumberValidation(greaterThan: Rational.zero).call(Rational.one),
          isNull,
        );
      });
      test('"1"{greaterThan: 1}->🔴', () {
        expect(
          NumberValidation(greaterThan: Rational.one).call(Rational.one),
          isNotNull,
        );
      });
      test('"0"{lessThan: 1}->🟢', () {
        expect(
          NumberValidation(lessThan: Rational.one).call(Rational.zero),
          isNull,
        );
      });
      test('"0"{lessThan: 0}->🔴', () {
        expect(
          NumberValidation(lessThan: Rational.zero).call(Rational.zero),
          isNotNull,
        );
      });
    });

    group('Test StringValidation', () {
      test('"ciao"{white: hola}->🔴', () {
        expect(
          TextValidation(match: RegExp('hola')).call('ciao'),
          isNotNull,
        );
      });
      test('"ciao"{white: ciao}->🟢', () {
        expect(
          TextValidation(match: RegExp('ciao')).call('ciao'),
          isNull,
        );
      });
      test('"ciao"{black: ciao}->🔴', () {
        expect(
          TextValidation(notMatch: RegExp('ciao')).call('ciao'),
          isNotNull,
        );
      });
      test('"ciao"{black: hola}->🟢', () {
        expect(
          TextValidation(notMatch: RegExp('hola')).call('ciao'),
          isNull,
        );
      });
    });
  });
}
