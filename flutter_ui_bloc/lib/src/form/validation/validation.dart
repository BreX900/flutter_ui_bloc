import 'dart:core';
import 'dart:core' as core;

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_ui_bloc/src/form/validation/validation_errors.dart';
import 'package:pure_extensions/pure_extensions.dart';

abstract class Validation<T> {
  const Validation();

  static final TextValidation email = TextValidation(
    errorCode: TextValidationError.emailCode,
    match: RegExp(r'^[a-zA-Z0-9_\-+~.]+@[a-zA-Z0-9]+\.+[A-Za-z]+$'),
  );
  static final TextValidation url = TextValidation(
    errorCode: TextValidationError.urlCode,
    match: RegExp(r'^((https?|ftp|smtp):\/\/)?(www.)?[a-z0-9]+\.[a-z]+(\/[a-zA-Z0-9#]+\/?)*$'),
  );

  Object? call(T value);
}

abstract class ValidationBase<T> extends Validation<T> {
  final String? errorCode;

  const ValidationBase(this.errorCode);
}

extension ValidatorList<T> on Iterable<Validator<T>> {
  Object? call(T value) {
    for (final validate in this) {
      final error = validate(value);
      if (error != null) return error;
    }
  }
}

class RequiredValidation<T> extends ValidationBase<T?> {
  final List<Validator<T>> validators;

  RequiredValidation(this.validators, {String? errorCode}) : super(errorCode);

  @override
  Object? call(T? value) {
    if (value == null) {
      return RequiredValidationError(
        validation: this,
        code: errorCode,
      );
    }
    return validators(value);
  }

  @override
  String toString() {
    return 'RequiredValidation{validate: $validators}';
  }
}

class ValidationParser<I, O> extends ValidationBase<I> {
  final O Function(I value) converter;
  final List<Validator<O>> validators;

  const ValidationParser(
    this.converter, {
    String? errorCode,
    this.validators = const [],
  }) : super(errorCode);

  static ValidationParser<String, int> stringToInt({
    String? errorCode = InvalidValidationError.intCode,
    List<Validator<int>> validators = const [],
  }) {
    return ValidationParser(int.parse, errorCode: errorCode, validators: validators);
  }

  static ValidationParser<String, double> stringToDouble({
    String? errorCode = InvalidValidationError.doubleCode,
    List<Validator<double>> validators = const [],
  }) {
    return ValidationParser(double.parse, errorCode: errorCode, validators: validators);
  }

  static ValidationParser<String, Rational> stringToRational({
    String? errorCode = InvalidValidationError.rationalCode,
    List<Validator<Rational>> validators = const [],
  }) {
    return ValidationParser((value) => Rational.parse(value),
        errorCode: errorCode, validators: validators);
  }

  static ValidationParser<double, int> doubleToInt({
    String? errorCode = InvalidValidationError.rationalCode,
    List<Validator<int>> validators = const [],
  }) {
    return ValidationParser((value) => value.toInt(), errorCode: errorCode, validators: validators);
  }

  @override
  Object? call(I value) {
    try {
      return validators(converter(value));
    } catch (_) {
      return InvalidValidationError(validation: this, code: errorCode);
    }
  }

  @override
  String toString() {
    return 'ValidationTransformer{converter: $converter, errorCode: $errorCode, validate: $validators}';
  }
}

class EqualityValidation<T> extends ValidationBase<T> {
  final T? equals;
  final T? identical;

  const EqualityValidation({
    String? errorCode,
    this.equals,
    this.identical,
  }) : super(errorCode);

  @override
  Object? call(T value) {
    if (equals != null && equals == value) {
      return EqualityValidationError(
        validation: this,
        equals: equals,
      );
    } else if (identical != null && core.identical(identical, value)) {
      return EqualityValidationError(
        validation: this,
        identical: identical,
      );
    }
  }

  @override
  String toString() {
    return 'EqualityValidation{equals: $equals, identical: $identical}';
  }
}

class TextValidation extends ValidationBase<String> {
  final int? minLength;
  final int? maxLength;
  final RegExp? match;
  final RegExp? notMatch;

  const TextValidation({
    String? errorCode,
    this.minLength,
    this.maxLength,
    this.match,
    this.notMatch,
  }) : super(errorCode);

  @override
  Object? call(String value) {
    if (minLength != null && minLength! < value.length) {
      return TextValidationError(
        validation: this,
        minLength: minLength,
      );
    } else if (maxLength != null && maxLength! > value.length) {
      return TextValidationError(
        validation: this,
        maxLength: maxLength,
      );
    } else if (match != null && !match!.hasMatch(value)) {
      return TextValidationError(
        validation: this,
        white: match?.pattern,
      );
    } else if (notMatch != null && notMatch!.hasMatch(value)) {
      return TextValidationError(
        validation: this,
        black: notMatch?.pattern,
      );
    }
  }

  @override
  String toString() {
    return 'TextValidation{minLength: $minLength, maxLength: $maxLength, match: $match, notMatch: $notMatch}';
  }
}

class NumberValidation<T extends Comparable<Object>> extends ValidationBase<T> {
  final T? greaterThan;
  final T? lessThan;
  final T? greaterOrEqualThan;
  final T? lessOrEqualThan;

  const NumberValidation({
    String? errorCode,
    this.greaterThan,
    this.lessThan,
    this.greaterOrEqualThan,
    this.lessOrEqualThan,
  })  : assert(greaterThan == null || greaterOrEqualThan == null),
        assert(lessThan == null || lessOrEqualThan == null),
        super(errorCode);

  @override
  Object? call(T value) {
    if (greaterThan != null && greaterThan!.compareTo(value) >= 0) {
      return NumberValidationError(
        validation: this,
        greaterThan: greaterThan,
      );
    } else if (lessThan != null && lessThan!.compareTo(value) <= 0) {
      return NumberValidationError(
        validation: this,
        lessThan: lessThan,
      );
    } else if (greaterOrEqualThan != null && greaterOrEqualThan!.compareTo(value) > 0) {
      return NumberValidationError(
        validation: this,
        greaterOrEqualThan: greaterOrEqualThan,
      );
    } else if (lessOrEqualThan != null && lessOrEqualThan!.compareTo(value) < 0) {
      return NumberValidationError(
        validation: this,
        lessOrEqualThan: lessOrEqualThan,
      );
    }
  }

  @override
  String toString() {
    return 'NumberValidation{greaterThan: $greaterThan, lessThan: $lessThan, greaterOrEqualThan: $greaterOrEqualThan, lessOrEqualThan: $lessOrEqualThan}';
  }
}

class OptionsValidation<T> extends ValidationBase<Iterable<T>> {
  final int? minLength;
  final int? maxLength;
  final List<T>? whereIn;
  final List<T>? whereNotIn;

  const OptionsValidation({
    String? errorCode,
    this.minLength,
    this.maxLength,
    this.whereIn,
    this.whereNotIn,
  }) : super(errorCode);

  @override
  Object? call(Iterable<T> value) {
    if (minLength != null && minLength! < value.length) {
      return OptionsValidationError(
        validation: this,
        minLength: minLength,
      );
    } else if (maxLength != null && maxLength! > value.length) {
      return OptionsValidationError(validation: this, maxLength: maxLength);
    } else if (whereIn != null && whereIn!.any((v) => !value.contains(v))) {
      return OptionsValidationError(validation: this, whereIn: whereIn);
    } else if (whereNotIn != null && whereNotIn!.any((v) => value.contains(v))) {
      return OptionsValidationError(validation: this, whereNotIn: whereNotIn);
    }
  }

  @override
  String toString() {
    return 'OptionsValidation{minLength: $minLength, maxLength: $maxLength, whereIn: $whereIn, whereNotIn: $whereNotIn}';
  }
}
