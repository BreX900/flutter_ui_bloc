// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvalidValidationError _$InvalidValidationErrorFromJson(
        Map<String, dynamic> json) =>
    InvalidValidationError(
      code: json['code'] as String?,
    );

Map<String, dynamic> _$InvalidValidationErrorToJson(
        InvalidValidationError instance) =>
    <String, dynamic>{
      'code': instance.code,
    };

RequiredValidationError _$RequiredValidationErrorFromJson(
        Map<String, dynamic> json) =>
    RequiredValidationError();

Map<String, dynamic> _$RequiredValidationErrorToJson(
        RequiredValidationError instance) =>
    <String, dynamic>{};

EqualityValidationError _$EqualityValidationErrorFromJson(
        Map<String, dynamic> json) =>
    EqualityValidationError(
      equals: json['equals'],
      identical: json['identical'],
    );

Map<String, dynamic> _$EqualityValidationErrorToJson(
        EqualityValidationError instance) =>
    <String, dynamic>{
      'equals': instance.equals,
      'identical': instance.identical,
    };

IterableValidationError _$IterableValidationErrorFromJson(
        Map<String, dynamic> json) =>
    IterableValidationError(
      minLength: json['minLength'] as int?,
      maxLength: json['maxLength'] as int?,
      whereIn: json['whereIn'] as List<dynamic>?,
      whereNotIn: json['whereNotIn'] as List<dynamic>?,
    );

Map<String, dynamic> _$IterableValidationErrorToJson(
        IterableValidationError instance) =>
    <String, dynamic>{
      'minLength': instance.minLength,
      'maxLength': instance.maxLength,
      'whereIn': instance.whereIn,
      'whereNotIn': instance.whereNotIn,
    };

StringValidationError _$StringValidationErrorFromJson(
        Map<String, dynamic> json) =>
    StringValidationError(
      minLength: json['minLength'] as int?,
      maxLength: json['maxLength'] as int?,
      white: json['white'] as String?,
      black: json['black'] as String?,
    );

Map<String, dynamic> _$StringValidationErrorToJson(
        StringValidationError instance) =>
    <String, dynamic>{
      'minLength': instance.minLength,
      'maxLength': instance.maxLength,
      'white': instance.white,
      'black': instance.black,
    };

NumberValidationError _$NumberValidationErrorFromJson(
        Map<String, dynamic> json) =>
    NumberValidationError(
      greaterThan: json['greaterThan'] as num?,
      lessThan: json['lessThan'] as num?,
      greaterOrEqualThan: json['greaterOrEqualThan'] as num?,
      lessOrEqualThan: json['lessOrEqualThan'] as num?,
    );

Map<String, dynamic> _$NumberValidationErrorToJson(
        NumberValidationError instance) =>
    <String, dynamic>{
      'greaterThan': instance.greaterThan,
      'lessThan': instance.lessThan,
      'greaterOrEqualThan': instance.greaterOrEqualThan,
      'lessOrEqualThan': instance.lessOrEqualThan,
    };

RationalValidationError _$RationalValidationErrorFromJson(
        Map<String, dynamic> json) =>
    RationalValidationError(
      greaterThan: const NullRationalJsonConverter()
          .fromJson(json['greaterThan'] as String?),
      lessThan: const NullRationalJsonConverter()
          .fromJson(json['lessThan'] as String?),
      greaterOrEqualThan: const NullRationalJsonConverter()
          .fromJson(json['greaterOrEqualThan'] as String?),
      lessOrEqualThan: const NullRationalJsonConverter()
          .fromJson(json['lessOrEqualThan'] as String?),
    );

Map<String, dynamic> _$RationalValidationErrorToJson(
        RationalValidationError instance) =>
    <String, dynamic>{
      'greaterThan':
          const NullRationalJsonConverter().toJson(instance.greaterThan),
      'lessThan': const NullRationalJsonConverter().toJson(instance.lessThan),
      'greaterOrEqualThan':
          const NullRationalJsonConverter().toJson(instance.greaterOrEqualThan),
      'lessOrEqualThan':
          const NullRationalJsonConverter().toJson(instance.lessOrEqualThan),
    };
