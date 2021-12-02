import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';
import 'package:flutter_ui_bloc/src/form/validation/validation.dart';

abstract class ValidationError {
  final Validation? validation;
  final String? code;

  const ValidationError(this.validation, this.code);

  static String? builder(BuildContext context, Object? e, FieldBloc fieldBloc) {
    if (e == null) return null;
    if (e is InvalidValidationError) {
      switch (e.code) {
        case InvalidValidationError.intCode:
          return 'Invalid integer value.';
        case InvalidValidationError.doubleCode:
        case InvalidValidationError.rationalCode:
          return 'Invalid decimal value.';
      }
      return 'Invalid field.';
    } else if (e is EqualityValidationError) {
      return 'The field must be equal to ${e.equals ?? e.identical}.';
    } else if (e is RequiredValidationError) {
      return 'This field is required.';
    } else if (e is TextValidationError) {
      switch (e.code) {
        case TextValidationError.urlCode:
          return 'Invalid url.';
        case TextValidationError.emailCode:
          return 'Invalid email.';
      }
      if (e.minLength != null) {
        return 'The text must be at least ${e.minLength} characters long.';
      } else if (e.maxLength != null) {
        return 'The text must be up to ${e.maxLength} characters long.';
      } else if (e.white != null) {
        return 'Field not match with ${e.white}.';
      } else if (e.black != null) {
        return 'Field must not match with ${e.black}.';
      }
    } else if (e is NumberValidationError) {
      if (e.greaterThan != null) {
        return 'It must be greater than ${e.greaterThan}.';
      } else if (e.lessThan != null) {
        return 'It must be less than ${e.lessThan}.';
      } else if (e.greaterOrEqualThan != null) {
        return 'It must be greater or equal than ${e.greaterOrEqualThan}.';
      } else if (e.lessOrEqualThan != null) {
        return 'It must be less or equal than ${e.lessOrEqualThan}.';
      }
    } else if (e is OptionsValidationError) {
      if (e.minLength != null) {
        return 'You can choose at least ${e.minLength} options.';
      } else if (e.maxLength != null) {
        return 'You can choose up to ${e.maxLength} options.';
      } else if (e.whereIn != null) {
        return 'It must contain these values (${e.whereIn!.join(', ')}).';
      } else if (e.whereNotIn != null) {
        return 'It must not contains these values (${e.whereNotIn!.join(', ')}).';
      }
    }
    return null;
  }
}

class InvalidValidationError extends ValidationError {
  const InvalidValidationError({Validation? validation, String? code})
      : super(validation, code);

  static const String intCode = 'Invalid int.';
  static const String doubleCode = 'Invalid double.';
  static const String rationalCode = 'Invalid Rational.';

  @override
  String toString() {
    return 'InvalidValidationError{code: $code}';
  }
}

class RequiredValidationError extends ValidationError {
  const RequiredValidationError({Validation? validation, String? code})
      : super(validation, code);

  @override
  String toString() {
    return 'RequiredValidationError{}';
  }
}

class EqualityValidationError extends ValidationError {
  final Object? equals;
  final Object? identical;

  const EqualityValidationError({
    Validation? validation,
    String? code,
    this.equals,
    this.identical,
  }) : super(validation, code);

  @override
  String toString() {
    return 'EqualityValidationError{equals:$equals,identical:$identical}';
  }
}

class TextValidationError extends ValidationError {
  final int? minLength;
  final int? maxLength;
  final String? white;
  final String? black;

  static const String emailCode = 'Invalid email.';
  static const String urlCode = 'Invalid url.';

  const TextValidationError({
    Validation? validation,
    String? code,
    this.minLength,
    this.maxLength,
    this.white,
    this.black,
  }) : super(validation, code);
}

class NumberValidationError extends ValidationError {
  final Comparable<Object>? greaterThan;
  final Comparable<Object>? lessThan;
  final Comparable<Object>? greaterOrEqualThan;
  final Comparable<Object>? lessOrEqualThan;

  const NumberValidationError({
    Validation? validation,
    String? code,
    this.greaterThan,
    this.lessThan,
    this.greaterOrEqualThan,
    this.lessOrEqualThan,
  }) : super(validation, code);

  @override
  String toString() =>
      'NumberValidationError{greaterThan:$greaterThan,lessThan:$lessThan,greaterOrEqualThan:$greaterOrEqualThan,lessOrEqualThan:$lessOrEqualThan}';
}

class OptionsValidationError extends ValidationError {
  final int? length;
  final int? minLength;
  final int? maxLength;
  final List<Object?>? whereIn;
  final List<Object?>? whereNotIn;

  const OptionsValidationError({
    Validation? validation,
    String? code,
    this.length,
    this.minLength,
    this.maxLength,
    this.whereIn,
    this.whereNotIn,
  }) : super(validation, code);

  @override
  String toString() =>
      'OptionsValidationError{length:$length,minLength:$minLength,maxLength:$maxLength,whereIn:$whereIn,whereNotIn:$whereNotIn}';
}
