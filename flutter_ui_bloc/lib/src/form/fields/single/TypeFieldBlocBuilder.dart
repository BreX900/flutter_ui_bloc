import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

abstract class TextFieldType {
  TextFieldType();

  factory TextFieldType.number({
    bool? isDecimal,
    bool? isSigned,
  }) = _TextFieldNumberType;

  factory TextFieldType.email() = _TextFieldEmailType;

  factory TextFieldType.password() = _TextFieldPasswordType;

  factory TextFieldType.geoPoint() = _TextFieldGeoPointType;

  List<TextInputFormatter>? get inputFormatters => null;

  TextInputType? get keyboardType => null;
}

class _TextFieldNumberType extends TextFieldType {
  final bool? isDecimal;
  final bool? isSigned;

  _TextFieldNumberType({this.isDecimal = true, this.isSigned = true});

  List<TextInputFormatter> get inputFormatters {
    if (!isDecimal!) {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        _IntegerTextInputFormatter(),
      ];
    }
    return [
      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
      _DecimalTextInputFormatter(),
    ];
  }

  @override
  TextInputType get keyboardType => TextInputType.numberWithOptions(
        signed: isSigned,
        decimal: isDecimal,
      );
}

class _TextFieldEmailType extends TextFieldType {
  @override
  TextInputType get keyboardType => TextInputType.emailAddress;
}

class _TextFieldPasswordType extends TextFieldType {}

class _TextFieldGeoPointType extends _TextFieldNumberType {}

class TypedTextFieldBlocBuilder extends StatelessWidget {
  final TextFieldBloc textFieldBloc;
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
      textFieldBloc: textFieldBloc as TextFieldBloc<Object>,
      inputFormatters: type.inputFormatters!,
      keyboardType: type.keyboardType!,
      focusNode: focusNode!,
      nextFocusNode: nextFocusNode!,
      decoration: decoration,
    );
  }
}

abstract class _StringTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final value = newValue;
    final selection = value.selection;

    final text = substringManipulation(newValue.text);

    return TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: selection.baseOffset > text.length ? text.length : selection.baseOffset,
        extentOffset: selection.extentOffset > text.length ? text.length : selection.extentOffset,
      ),
      composing: TextRange.empty,
    );
  }

  String substringManipulation(String value);
}

class _IntegerTextInputFormatter extends _StringTextInputFormatter {
  @override
  String substringManipulation(String value) {
    if (value.startsWith('0')) return value.substring(1);
    return value;
  }
}

class _DecimalTextInputFormatter extends _IntegerTextInputFormatter {
  @override
  String substringManipulation(String value) {
    value = value.replaceAll(',', '.');

    if (value.startsWith(RegExp(r'[.,]'))) return value.substring(1);
    final matches = RegExp(r'([,.])').allMatches(value);

    if (matches.length > 1) return value.substring(0, value.length - matches.length + 1);

    return super.substringManipulation(value);
  }
}
