import 'dart:convert';

import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils/_json_converters.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils/validation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pure_extensions/pure_extensions.dart';

part 'validation_errors.g.dart';

abstract class ValidationError {
  @JsonKey(ignore: true)
  final Validation? validation;

  static final _toJson = {
    InvalidValidationError: _$InvalidValidationErrorToJson,
    RequiredValidationError: _$RequiredValidationErrorToJson,
    StringValidationError: _$StringValidationErrorToJson,
    RationalValidationError: _$RationalValidationErrorToJson,
  };
  static final _fromJson = {
    '$InvalidValidationError': _$InvalidValidationErrorFromJson,
    '$RequiredValidationError': _$RequiredValidationErrorFromJson,
    '$StringValidationError': _$StringValidationErrorFromJson,
    '$RationalValidationError': _$RationalValidationErrorFromJson,
  };

  const ValidationError(this.validation);

  static Map<String, dynamic> toMap(ValidationError error) {
    return {
      'type': '${error.runtimeType}',
      ..._toJson[error.runtimeType]!(error as dynamic),
    };
  }

  static ValidationError fromMap(Map<String, dynamic> map) {
    return _fromJson[map['type']]!(map as dynamic);
  }

  static ValidationError fromJson(String error) => fromMap(jsonDecode(error));

  static String toJson(ValidationError error) => jsonEncode(toMap(error));

  static String? builder(BuildContext context, String? error, FieldBloc fieldBloc) {
    if (error == null) return null;
    final e = fromJson(error);
    if (e is InvalidValidationError) {
      return 'Invalid Field';
    } else if (e is RationalValidationError) {
      if (e.greaterThan != null) {
        return 'It must be greater than ${e.greaterThan}';
      } else if (e.lessThan != null) {
        return 'It must be less than ${e.lessThan}';
      } else if (e.greaterOrEqualThan != null) {
        return 'It must be greater or equal than ${e.greaterOrEqualThan}';
      } else if (e.lessOrEqualThan != null) {
        return 'It must be less or equal than ${e.lessOrEqualThan}';
      }
      // else if (e.whereIn != null) {
      //   return 'It must be equal a ${e.whereIn}';
      // } else if (e.whereNotIn != null) {
      //   return 'It must be not equal a ${e.whereNotIn}';
      // }
    } else if (e is StringValidationError) {
      if (e.white != null) {
        return 'Field not match with ${e.white}';
      } else if (e.black != null) {
        return 'Field must not match with ${e.black}';
      }
    }
    return null;
  }
}

@JsonSerializable()
class InvalidValidationError extends ValidationError {
  final String? code;

  const InvalidValidationError({Validation? validation, this.code}) : super(validation);
}

@JsonSerializable()
class RequiredValidationError extends ValidationError {
  const RequiredValidationError({Validation? validation}) : super(validation);
}

@JsonSerializable()
class EqualityValidationError extends ValidationError {
  final Object? equals;
  final Object? identical;

  const EqualityValidationError({
    Validation? validation,
    this.equals,
    this.identical,
  }) : super(validation);
}

@JsonSerializable()
class IterableValidationError extends ValidationError {
  final int? minLength;
  final int? maxLength;
  final List<Object?>? whereIn;
  final List<Object?>? whereNotIn;

  const IterableValidationError({
    Validation? validation,
    this.minLength,
    this.maxLength,
    this.whereIn,
    this.whereNotIn,
  }) : super(validation);
}

@JsonSerializable()
class StringValidationError extends ValidationError {
  final int? minLength;
  final int? maxLength;
  final String? white;
  final String? black;

  const StringValidationError({
    Validation? validation,
    this.minLength,
    this.maxLength,
    this.white,
    this.black,
  }) : super(validation);
}

@JsonSerializable()
class NumberValidationError extends ValidationError {
  final num? greaterThan;
  final num? lessThan;
  final num? greaterOrEqualThan;
  final num? lessOrEqualThan;

  const NumberValidationError({
    Validation? validation,
    this.greaterThan,
    this.lessThan,
    this.greaterOrEqualThan,
    this.lessOrEqualThan,
  }) : super(validation);
}

@JsonSerializable()
@RationalJsonConverter()
@NullRationalJsonConverter()
class RationalValidationError extends ValidationError {
  final Rational? greaterThan;
  final Rational? lessThan;
  final Rational? greaterOrEqualThan;
  final Rational? lessOrEqualThan;

  const RationalValidationError({
    Validation? validation,
    this.greaterThan,
    this.lessThan,
    this.greaterOrEqualThan,
    this.lessOrEqualThan,
  }) : super(validation);
}
