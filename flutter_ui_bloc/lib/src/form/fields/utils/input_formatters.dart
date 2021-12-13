import 'package:flutter/services.dart';

class DefaultInputFormatters {
  List<TextInputFormatter> number({bool isDecimal = true, bool isSigned = true}) {
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

  List<TextInputFormatter> email() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9@+._-~]$')),
    ];
  }
}

abstract class StringTextInputFormatter extends TextInputFormatter {
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

class IntegerTextInputFormatter extends StringTextInputFormatter {
  @override
  String substringManipulation(String value) {
    if (value.startsWith('0')) return value.substring(1);
    return value;
  }
}

class DecimalTextInputFormatter extends IntegerTextInputFormatter {
  @override
  String substringManipulation(String value) {
    value = value.replaceAll(',', '.');

    if (value.startsWith(RegExp(r'[.,]'))) return value.substring(1);
    final matches = RegExp(r'([,.])').allMatches(value);

    if (matches.length > 1) return value.substring(0, value.length - matches.length + 1);

    return super.substringManipulation(value);
  }
}
