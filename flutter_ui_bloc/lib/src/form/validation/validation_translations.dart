import 'package:flutter_ui_bloc/src/form/validation/translate.dart';
import 'package:flutter_ui_bloc/src/form/validation/validation_errors.dart';

typedef Formatter<T> = String Function(T value);

class ValidationFormats {
  final ValidationFormats? _formats;
  final Formatter<DateTime>? _dateTimeFormatter;

  const ValidationFormats({
    ValidationFormats? formats,
    Formatter<DateTime>? dateTimeFormatter,
  })  : _formats = formats,
        _dateTimeFormatter = dateTimeFormatter;

  String format(Object value) {
    if (value is DateTime) {
      return formatDateTime(value);
    }
    return '$value';
  }

  String formatDateTime(DateTime value) =>
      _dateTimeFormatter?.call(value) ?? _formats?.formatDateTime(value) ?? '$value';

  ValidationFormats copyWith({
    Formatter<DateTime>? dateTimeFormatter,
  }) {
    return ValidationFormats(
      formats: this,
      dateTimeFormatter: dateTimeFormatter,
    );
  }
}

abstract class ValidationTranslations {
  static const List<ValidationTranslations> values = [
    ValidationEnTranslations(),
    ValidationItTranslations(),
  ];

  final ValidationFormats formats;

  Set<String> get languageCodes;

  const ValidationTranslations({
    this.formats = const ValidationFormats(),
  });

  String greaterThanComparable(Object value);

  String lessThanComparable(Object value);

  String greaterOrEqualThanComparable(Object value);

  String lessOrEqualThanComparable(Object value);

  String beforeDateTime(Object value);

  String afterDateTime(Object value);

  ValidationTranslations copyWith({ValidationFormats? formats});

  String translate(ValidationError error) {
    return translateValidationError(error, this);
  }
}

class ValidationEnTranslations extends ValidationTranslations {
  @override
  Set<String> get languageCodes => const {'en'};

  const ValidationEnTranslations({
    ValidationFormats formats = const ValidationFormats(),
  }) : super(formats: formats);

  @override
  String greaterThanComparable(Object value) {
    return 'It must be greater than ${formats.format(value)}.';
  }

  @override
  String lessThanComparable(Object value) {
    return 'It must be less than ${formats.format(value)}.';
  }

  @override
  String greaterOrEqualThanComparable(Object value) {
    return 'It must be greater or equal than ${formats.format(value)}.';
  }

  @override
  String lessOrEqualThanComparable(Object value) {
    return 'It must be less or equal than ${formats.format(value)}.';
  }

  @override
  String beforeDateTime(Object value) {
    return 'It must be before ${formats.format(value)}.';
  }

  @override
  String afterDateTime(Object value) {
    return 'It must be after ${formats.format(value)}.';
  }

  @override
  ValidationTranslations copyWith({ValidationFormats? formats}) {
    return ValidationEnTranslations(
      formats: formats ?? this.formats,
    );
  }
}

class ValidationItTranslations extends ValidationEnTranslations {
  @override
  Set<String> get languageCodes => const {'it'};

  const ValidationItTranslations({
    ValidationFormats formats = const ValidationFormats(),
  }) : super(formats: formats);

  @override
  ValidationTranslations copyWith({ValidationFormats? formats}) {
    return ValidationItTranslations(
      formats: formats ?? this.formats,
    );
  }
}
