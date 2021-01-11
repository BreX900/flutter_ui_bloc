import 'package:flutter/widgets.dart';

typedef FieldValuePicker<T> = Future<T> Function(BuildContext context, T value);

typedef FieldValueBuilder<T> = Widget Function(BuildContext context, T value);