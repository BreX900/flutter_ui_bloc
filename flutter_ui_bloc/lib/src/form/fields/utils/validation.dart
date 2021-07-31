import 'dart:core';
import 'dart:core' as core;

import 'package:flutter_ui_bloc/src/form/fields/utils/validation_errors.dart';
import 'package:pure_extensions/pure_extensions.dart';

abstract class Validation<T> {
  static final StringValidation email = StringValidation(
    white: RegExp(r'^[a-zA-Z0-9_\-+~.]+@[a-zA-Z0-9]+\.+[A-Za-z]+$'),
  );
  static final StringValidation url = StringValidation(
    white: RegExp(r'^((https?|ftp|smtp):\/\/)?(www.)?[a-z0-9]+\.[a-z]+(\/[a-zA-Z0-9#]+\/?)*$'),
  );

  const Validation();

  ValidationError? call(T value);
}

extension ListValidations<T> on Iterable<Validation<T>> {
  ValidationError? call(T value) {
    for (final validate in this) {
      final error = validate(value);
      if (error != null) return error;
    }
  }
}

class StringValidationWrap<T> {
  final Validation<T> validate;

  const StringValidationWrap(this.validate);

  String? call(T value) {
    final error = validate(value);
    if (error == null) return null;
    return ValidationError.toJson(error);
  }
}

class RequiredValidation<T> extends Validation<T?> {
  final List<Validation<T>> validate;

  RequiredValidation(this.validate);

  @override
  ValidationError? call(T? value) {
    if (value == null) return RequiredValidationError(validation: this);
    return validate(value);
  }
}

class ValidationTransformer<I, O> extends Validation<I> {
  final O Function(I value) converter;
  final String? errorCode;
  final List<Validation<O>> validate;

  const ValidationTransformer(this.converter, {this.errorCode, this.validate = const []});

  static ValidationTransformer<String, int> int$(
      {String? errorCode, List<Validation<int>> validate = const []}) {
    return ValidationTransformer(int.parse, errorCode: errorCode, validate: validate);
  }

  static ValidationTransformer<String, double> double$(
      {String? errorCode, List<Validation<double>> validate = const []}) {
    return ValidationTransformer(double.parse, errorCode: errorCode, validate: validate);
  }

  static ValidationTransformer<String, Rational> rational(
      {String? errorCode, List<Validation<Rational>> validate = const []}) {
    return ValidationTransformer((value) => Rational.parse(value),
        errorCode: errorCode, validate: validate);
  }

  @override
  ValidationError? call(I value) {
    try {
      return validate(converter(value));
    } catch (_) {
      return InvalidValidationError(validation: this, code: errorCode);
    }
  }
}

class EqualityValidation<T> extends Validation<T> {
  final T? equals;
  final T? identical;

  const EqualityValidation({
    this.equals,
    this.identical,
  });

  @override
  ValidationError? call(T value) {
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
}

class IterableValidation<T> extends Validation<Iterable<T>> {
  final int? minLength;
  final int? maxLength;
  final List<Validation<T>>? whereIn;
  final List<T>? whereNotIn;

  const IterableValidation({
    this.minLength,
    this.maxLength,
    this.whereIn,
    this.whereNotIn,
  });

  @override
  ValidationError? call(Iterable<T> value) {
    if (minLength != null && minLength! < value.length) {
      return IterableValidationError(
        validation: this,
        minLength: minLength,
      );
    } else if (maxLength != null && maxLength! > value.length) {
      return IterableValidationError(validation: this, maxLength: maxLength);
    } else if (whereIn != null && whereIn!.any((v) => !value.contains(v))) {
      return IterableValidationError(validation: this, whereIn: whereIn);
    } else if (whereNotIn != null && whereNotIn!.any((v) => value.contains(v))) {
      return IterableValidationError(validation: this, whereNotIn: whereNotIn);
    }
  }
}

class StringValidation extends Validation<String> {
  final int? minLength;
  final int? maxLength;
  final RegExp? white;
  final RegExp? black;

  const StringValidation({
    this.minLength,
    this.maxLength,
    this.white,
    this.black,
  });

  @override
  ValidationError? call(String value) {
    if (minLength != null && minLength! < value.length) {
      return StringValidationError(
        validation: this,
        minLength: minLength,
      );
    } else if (maxLength != null && maxLength! > value.length) {
      return StringValidationError(
        validation: this,
        maxLength: maxLength,
      );
    } else if (white != null && !white!.hasMatch(value)) {
      return StringValidationError(
        validation: this,
        white: white?.pattern,
      );
    } else if (black != null && black!.hasMatch(value)) {
      return StringValidationError(
        validation: this,
        black: black?.pattern,
      );
    }
  }
}

class NumberValidation<T extends num> extends Validation<T> {
  final T? greaterThan;
  final T? lessThan;
  final T? greaterOrEqualThan;
  final T? lessOrEqualThan;

  const NumberValidation({
    this.greaterThan,
    this.lessThan,
    this.greaterOrEqualThan,
    this.lessOrEqualThan,
  })  : assert(greaterThan == null || greaterOrEqualThan == null),
        assert(lessThan == null || lessOrEqualThan == null);

  @override
  ValidationError? call(T value) {
    if (greaterThan != null && greaterThan! >= value) {
      return NumberValidationError(
        validation: this,
        greaterThan: greaterThan,
      );
    } else if (lessThan != null && lessThan! <= value) {
      return NumberValidationError(
        validation: this,
        lessThan: lessThan,
      );
    } else if (greaterOrEqualThan != null && greaterOrEqualThan! > value) {
      return NumberValidationError(
        validation: this,
        greaterOrEqualThan: greaterOrEqualThan,
      );
    } else if (lessOrEqualThan != null && lessOrEqualThan! < value) {
      return NumberValidationError(
        validation: this,
        lessOrEqualThan: lessOrEqualThan,
      );
    }
  }
}

class RationalValidation extends Validation<Rational> {
  final Rational? greaterThan;
  final Rational? lessThan;
  final Rational? greaterOrEqualThan;
  final Rational? lessOrEqualThan;

  const RationalValidation({
    this.greaterThan,
    this.lessThan,
    this.greaterOrEqualThan,
    this.lessOrEqualThan,
  })  : assert(greaterThan == null || greaterOrEqualThan == null),
        assert(lessThan == null || lessOrEqualThan == null);

  @override
  ValidationError? call(Rational value) {
    if (greaterThan != null && greaterThan! >= value) {
      return RationalValidationError(
        validation: this,
        greaterThan: greaterThan,
      );
    } else if (lessThan != null && lessThan! <= value) {
      return RationalValidationError(
        validation: this,
        lessThan: lessThan,
      );
    } else if (greaterOrEqualThan != null && greaterOrEqualThan! > value) {
      return RationalValidationError(
        validation: this,
        greaterOrEqualThan: greaterOrEqualThan,
      );
    } else if (lessOrEqualThan != null && lessOrEqualThan! < value) {
      return RationalValidationError(
        validation: this,
        lessOrEqualThan: lessOrEqualThan,
      );
    }
  }
}
