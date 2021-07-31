import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils/input_formatters.dart';

abstract class TextFieldType {
  TextFieldType();

  factory TextFieldType.number({
    bool isDecimal,
    bool isSigned,
  }) = _TextFieldNumberType;

  factory TextFieldType.email() = _TextFieldEmailType;

  factory TextFieldType.password() = _TextFieldPasswordType;

  factory TextFieldType.geoPoint() = _TextFieldGeoPointType;

  List<TextInputFormatter>? get inputFormatters => null;

  TextInputType? get keyboardType => null;
}

class _TextFieldNumberType extends TextFieldType {
  final bool isDecimal;
  final bool isSigned;

  _TextFieldNumberType({this.isDecimal = true, this.isSigned = true});

  @override
  List<TextInputFormatter> get inputFormatters {
    if (isDecimal) {
      return [
        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
        DecimalTextInputFormatter(),
      ];
    }
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      IntegerTextInputFormatter(),
    ];
  }

  @override
  TextInputType get keyboardType {
    return TextInputType.numberWithOptions(
      signed: isSigned,
      decimal: isDecimal,
    );
  }
}

class _TextFieldEmailType extends TextFieldType {
  @override
  TextInputType get keyboardType => TextInputType.emailAddress;
}

class _TextFieldPasswordType extends TextFieldType {}

class _TextFieldGeoPointType extends _TextFieldNumberType {}

class TypedTextFieldBlocBuilder extends StatelessWidget {
  final TextFieldBloc<dynamic> textFieldBloc;
  final TextFieldType type;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final InputDecoration decoration;

  const TypedTextFieldBlocBuilder({
    Key? key,
    required this.textFieldBloc,
    required this.type,
    this.focusNode,
    this.nextFocusNode,
    this.decoration = const InputDecoration(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldBlocBuilder(
      textFieldBloc: textFieldBloc,
      inputFormatters: type.inputFormatters,
      keyboardType: type.keyboardType,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      decoration: decoration,
    );
  }
}
