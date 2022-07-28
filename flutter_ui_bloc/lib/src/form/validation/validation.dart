import 'dart:core';
import 'dart:core' as core;

import 'package:cross_file/cross_file.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_ui_bloc/src/form/validation/validation_base.dart';
import 'package:flutter_ui_bloc/src/form/validation/validation_errors.dart';
import 'package:pure_extensions/pure_extensions.dart';

abstract class Validation<T> {
  const Validation();

  /// If validation is not necessary
  static const Validation<dynamic> none = ValidationNone();

  /// It combines the validators into a single validation
  ///
  /// All validators must be valid
  const factory Validation.every(List<Validator<T>> validators) = CompositeValidation.every;

  /// It combines the validators into a single validation
  ///
  /// A validator just needs to be valid
  const factory Validation.any(List<Validator<T>> validators) = CompositeValidation.any;

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

///  It allows you to convert a field from null to non-null
class RequiredValidation<T> extends ValidationBase<T?> {
  final List<Validator<T>> validators;

  const RequiredValidation({
    String? errorCode,
    this.validators = const [],
  }) : super(errorCode);

  @override
  Object? call(T? value) {
    if (value == null) {
      return RequiredValidationError(
        validation: this,
        code: errorCode,
      );
    }
    return CompositeValidation.validateEvery(validators, value);
  }

  @override
  String toString() {
    return 'RequiredValidation{validators: $validators}';
  }
}

/// It allows you to convert a field from an `x` type to a` y` type.
/// * [stringToInt]
/// * [stringToDouble]
/// * [stringToRational]
/// * [doubleToInt]
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
      return CompositeValidation.validateEvery(validators, converter(value));
    } catch (_) {
      return InvalidValidationError(validation: this, code: errorCode);
    }
  }

  @override
  String toString() {
    return 'ValidationTransformer{converter: $converter, errorCode: $errorCode, validate: $validators}';
  }
}

/// It allows you to compare two values
class EqualityValidation<T extends Object> extends ValidationBase<T> {
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
      return EqualityValidationError<T>(
        validation: this,
        code: errorCode,
        equals: equals!,
      );
    } else if (identical != null && core.identical(identical, value)) {
      return EqualityValidationError<T>(
        validation: this,
        code: errorCode,
        identical: identical!,
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'EqualityValidation{equals: $equals, identical: $identical}';
  }
}

/// It allows to validate a text field such as the length or if it is match with a regexp
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
    if (minLength != null && value.length < minLength!) {
      return TextValidationError(
        validation: this,
        code: errorCode,
        minLength: minLength,
      );
    } else if (maxLength != null && value.length > maxLength!) {
      return TextValidationError(
        validation: this,
        code: errorCode,
        maxLength: maxLength,
      );
    } else if (match != null && !match!.hasMatch(value)) {
      return TextValidationError(
        validation: this,
        code: errorCode,
        match: match?.pattern,
      );
    } else if (notMatch != null && notMatch!.hasMatch(value)) {
      return TextValidationError(
        validation: this,
        code: errorCode,
        notMatch: notMatch?.pattern,
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'TextValidation{minLength: $minLength, maxLength: $maxLength, match: $match, notMatch: $notMatch}';
  }
}

/// It allows you to validate a field of type [Comparable]
/// but you can usually use it to validate fields of type:
/// * [num]
/// * [int]
/// * [double]
/// * [Rational]
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
      return NumberValidationError<T>(
        validation: this,
        code: errorCode,
        greaterThan: greaterThan!,
      );
    } else if (lessThan != null && lessThan!.compareTo(value) <= 0) {
      return NumberValidationError<T>(
        validation: this,
        code: errorCode,
        lessThan: lessThan!,
      );
    } else if (greaterOrEqualThan != null && greaterOrEqualThan!.compareTo(value) > 0) {
      return NumberValidationError<T>(
        validation: this,
        code: errorCode,
        greaterOrEqualThan: greaterOrEqualThan!,
      );
    } else if (lessOrEqualThan != null && lessOrEqualThan!.compareTo(value) < 0) {
      return NumberValidationError<T>(
        validation: this,
        code: errorCode,
        lessOrEqualThan: lessOrEqualThan!,
      );
    }
    return null;
  }

  @override
  String toString() {
    return '$runtimeType{greaterThan: $greaterThan, lessThan: $lessThan, greaterOrEqualThan: $greaterOrEqualThan, lessOrEqualThan: $lessOrEqualThan}';
  }
}

class DateTimeValidation extends ValidationBase<DateTime> {
  final DateTime? before;
  final DateTime? after;

  const DateTimeValidation({
    String? errorCode,
    this.before,
    this.after,
  }) : super(errorCode);

  @override
  Object? call(DateTime value) {
    if (before != null && !value.isBefore(before!)) {
      return DateTimeValidationError(
        validation: this,
        code: errorCode,
        before: before!,
      );
    } else if (after != null && !value.isAfter(after!)) {
      return DateTimeValidationError(
        validation: this,
        code: errorCode,
        after: after!,
      );
    }
    return null;
  }
}

/// It allows you to validate a list of options
/// by checking the minimum length and if any particular options have been selected
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
      return OptionsValidationError(
        validation: this,
        code: errorCode,
        maxLength: maxLength,
      );
    } else if (whereIn != null && whereIn!.any((v) => !value.contains(v))) {
      return OptionsValidationError(
        validation: this,
        code: errorCode,
        whereIn: whereIn,
      );
    } else if (whereNotIn != null && whereNotIn!.any((v) => value.contains(v))) {
      return OptionsValidationError(
        validation: this,
        code: errorCode,
        whereNotIn: whereNotIn,
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'OptionsValidation{minLength: $minLength, maxLength: $maxLength, whereIn: $whereIn, whereNotIn: $whereNotIn}';
  }
}

/// It allows you to validate a file by checking its extension
class FileValidation extends ValidationBase<XFile> {
  final List<String>? whereExtensionIn;
  final List<String>? whereExtensionNotIn;

  const FileValidation({
    String? errorCode,
    this.whereExtensionIn,
    this.whereExtensionNotIn,
  }) : super(errorCode);

  @override
  Object? call(XFile value) {
    final name = value.name.toLowerCase();
    if (whereExtensionIn != null &&
        !whereExtensionIn!.map((e) => e.toLowerCase()).any(name.endsWith)) {
      return FileValidationError(
        validation: this,
        code: errorCode,
        whereExtensionIn: whereExtensionIn,
        whereExtensionNotIn: whereExtensionNotIn,
      );
    } else if (whereExtensionNotIn != null &&
        whereExtensionNotIn!.map((e) => e.toLowerCase()).any(name.endsWith)) {
      return FileValidationError(
        validation: this,
        code: errorCode,
        whereExtensionIn: whereExtensionIn,
        whereExtensionNotIn: whereExtensionNotIn,
      );
    }
    return null;
  }
}

class ValidationDelegate<T> extends Validation<T> {
  final Validator<T> Function(T value) validator;

  const ValidationDelegate(this.validator);

  @override
  Object? call(T value) => validator(value).call(value);
}
