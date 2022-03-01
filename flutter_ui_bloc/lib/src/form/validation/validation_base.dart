import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_ui_bloc/src/form/validation/validation.dart';

abstract class ValidationBase<T> extends Validation<T> {
  /// Use a custom error string to differentiate between errors
  final String? errorCode;

  const ValidationBase(this.errorCode);
}

class CompositeValidation<T> extends Validation<T> {
  final List<Validator<T>> validators;
  final bool _isEvery;

  const CompositeValidation.every(this.validators) : _isEvery = true;

  const CompositeValidation.any(this.validators) : _isEvery = false;

  static Object? validateEvery<T>(List<Validator<T>> validators, T value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  static Object? validateAny<T>(List<Validator<T>> validators, T value) {
    Object? firstError;
    for (final validator in validators) {
      final error = validator(value);
      if (error == null) {
        return null;
      } else {
        firstError ??= error;
      }
    }
    return firstError;
  }

  @override
  Object? call(T value) => (_isEvery ? validateEvery : validateAny)(validators, value);
}

class ValidationNone<T> extends Validation<T> {
  const ValidationNone();

  @override
  Object? call(T value) => null;
}
